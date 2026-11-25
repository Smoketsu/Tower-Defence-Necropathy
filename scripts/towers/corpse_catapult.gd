## Corpse Catapult kit (GDD §4.1 "very long range, slow, heavy area hits",
## Bone Barrage): every `interval` s it lobs a boulder (TdProjectiles.fire_at)
## that lands after `arc_time` s on a landing telegraph and splashes
## `splash` px. It aims at the densest pack in range (enemies within `splash`
## of each candidate; the targeting mode breaks ties), leading a walking
## target by its speed; with Killing Field (SynergyData "aim") staggered
## enemies count double. From level 3 its volley is `volley.count` smaller
## boulders on other enemies. Evolved into the Ossuary Engine (EvolutionData
## "ossuary_engine", keys in its "set"): `boulders` boulders a volley spread
## `boulder_spread` px around the aim point, each leaving a burning bone-shard
## field (`field_radius` px, `field_time` s, `field_fraction` of the boulder's
## damage every `field_tick` s).
extends "res://scripts/towers/projectile.gd"


func step(t: Tower, _dt: float) -> void:
	if t.game.time < t.next_fire:
		return
	var target := _aim_target(t)  # Centre of the densest pack, or null.
	if target == null:
		return
	t.next_fire = t.game.time + float(t.stats["interval"])
	t.shots += 1
	t.face(target.position)
	t.squash_until = t.game.time + TowerData.FIRE_SQUASH_TIME
	t.game.sound_fire(t.tower_id)
	var flight := float(t.stats["arc_time"])  # Seconds in the air.
	var aim := lead(target, flight)  # Landing point.
	var n := int(t.stats.get("boulders", 1))  # Boulders this volley.
	for i in n:
		var off := Vector2.ZERO if i == 0 else Vector2(float(t.stats["boulder_spread"]), 0.0).rotated(TAU * float(i) / float(n - 1) + 0.5)  # Spread around the aim.
		t.game.projectiles.fire_at(t, aim + off, flight, float(t.stats["damage"]), String(t.stats["projectile"]), Color.WHITE, false)
	volley(t, target)


## Where walking enemy `e` will be after `time` s (its road ahead; held or
## frozen enemies stay put).
static func lead(e: TdEnemy, time: float) -> Vector2:
	if e.holder != null:
		return e.position
	return e.follower.road.point_at(minf(e.follower.dist + e.current_speed() * time, e.follower.road.length))


## The enemy in range at the centre of the densest pack (see the header), or null.
func _aim_target(t: Tower) -> TdEnemy:
	var aim_status := String(Synergies.value(t, "aim", ""))  # Killing Field: "staggered".
	var mode := t.pick_target()  # The targeting mode's pick (tie-break).
	var best: TdEnemy = null  # Best candidate.
	var best_score := -1.0  # Its pack score.
	for e: TdEnemy in t.game.enemies_near(t.position, float(t.stats["range"])):
		var score := 0.0  # Pack weight around e.
		for o: TdEnemy in t.game.enemies_near(e.position, float(t.stats["splash"])):
			score += 2.0 if aim_status != "" and Synergies.has_status(o, aim_status, t.game) else 1.0
		if e == mode:
			score += 0.5
		if score > best_score:
			best_score = score
			best = e
	return best


func volley(t: Tower, target: TdEnemy) -> void:
	var v: Dictionary = t.stats.get("volley", {})  # The class's volley row.
	if v.is_empty() or t.level < 3 or t.shots % int(v["every"]) != 0:
		return
	var others := t.game.enemies_near(t.position, float(t.stats["range"]))  # Candidates.
	for i in int(v["count"]):
		var e: TdEnemy = others[(i + 1) % others.size()] if others.size() > 1 else target  # Its target.
		t.game.projectiles.fire_at(t, lead(e, float(t.stats["arc_time"])), float(t.stats["arc_time"]),
				float(t.stats["damage"]) * float(v["damage"]), String(v["sprite"]), v["tint"], true, 0.7)
	t.game.fx.spawn("volley_flash", t.position + Vector2(0, -20), 48.0, 0.25, v["tint"])


func impact(t: Tower, shot: TdProjectiles.Shot, _victims: Array[TdEnemy]) -> void:
	t.game.fx.spawn("bolt_impact", shot.pos, shot.splash * 2.0, 0.35, Color(0.95, 0.8, 0.6))
	if shot.is_volley or float(t.stats.get("field_time", 0.0)) <= 0.0:
		return
	t.game.projectiles.add_field(shot.pos, float(t.stats["field_radius"]), float(t.stats["field_time"]), float(t.stats["field_tick"]),
			shot.damage * float(t.stats["field_fraction"]), "ossuary_shards", t, "flame")
