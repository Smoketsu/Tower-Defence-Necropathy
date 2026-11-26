## Ghost Saucer kit (Act XIII tower, unlocked by the Harvester; Necropathy's
## GhostSaucerBehavior "saucer_lift": a Concord saucer raised in bone-grey
## plates and soul-light). It hovers over its plot and hits flyers.
##   beam  — every `interval` s it picks a target by its mode (t.pick_target())
##           and fires a SHORT BEAM from its hull through it, `beam_len` px
##           long: every foe within `beam_w` px of the beam (t.can_hit()) takes
##           `damage` once (TdCombat.damage_enemy, its own source). The Black
##           Mothership fires `beams` beams fanned `beam_spread` rad apart.
##   lift  — every `lift_every` beams it lifts the nearest fodder foe in range
##           (never an elite, miniboss, boss or structure): frozen in the air
##           `lift_time` s (TdCombat.freeze_enemy, rank multipliers apply),
##           then dropped: `lift_damage` to it and to the foes within
##           `lift_radius` px. The Black Mothership lifts `lifts` foes at once.
##   volley — from level 3 its beams throw the volley (TowerBehavior.volley()).
## A disabled saucer (lifted by the Concord itself!) does nothing: its step is
## not called. Tower.vars: "beams" (count), "lifted" (count), "held"
## ([TdEnemy, generation, game s it drops]), "beam_to" ([map px], drawn only).
extends "res://scripts/towers/projectile.gd"


func step(t: Tower, _dt: float) -> void:
	_drops(t)
	if t.game.time < t.next_fire:
		return
	var target := t.pick_target()  # The beam's aim.
	if target == null:
		return
	var g := t.game  # The run.
	t.next_fire = g.time + float(t.stats["interval"])
	t.shots += 1
	t.face(target.position)
	t.squash_until = g.time + TowerData.FIRE_SQUASH_TIME
	g.sound_fire(t.tower_id)
	var from := t.position + Vector2(0, -24)  # Its hull.
	var n := int(t.stats["beams"])  # Beams this attack.
	var hit: Array[TdEnemy] = []  # Struck this attack (once each).
	for i in n:
		var ang := (target.position - from).angle() + (float(i) - float(n - 1) * 0.5) * float(t.stats["beam_spread"])
		var end := from + Vector2.from_angle(ang) * float(t.stats["beam_len"])
		_beam(t, from, end, hit)
	t.vars["beams"] = int(t.vars.get("beams", 0)) + 1
	g.vfx.muzzle(t, false)
	if int(t.vars["beams"]) % int(t.stats["lift_every"]) == 0:
		_lift(t)
	volley(t, target)


## One beam from `from` to `end`: strikes every foe near it not in `hit`.
func _beam(t: Tower, from: Vector2, end: Vector2, hit: Array[TdEnemy]) -> void:
	var g := t.game
	var w := float(t.stats["beam_w"])  # Px either side.
	var d := end - from
	var len2 := maxf(d.length_squared(), 1.0)
	for e: TdEnemy in g.foes_near(from.lerp(end, 0.5), from.distance_to(end) * 0.5 + w):
		if hit.has(e) or not t.can_hit(e):
			continue
		var u := clampf((e.position - from).dot(d) / len2, 0.0, 1.0)  # Its place along the beam.
		if e.position.distance_to(from + d * u) > w + e.radius:
			continue
		hit.append(e)
		TdCombat.damage_enemy(g, e, float(t.stats["damage"]), {"source": t.tower_id, "tower": t, "origin": from})
		if g.vfx.on:
			g.vfx.add(TdVfx.Kind.ANIM, e.position, float(TdVfxData.SHOTS["ghost_saucer"]["impact_d"]) * TdVfx.loud(t), 0.3, TdVfxData.SHOTS["ghost_saucer"]["tint"], "beam_hit")
	if g.vfx.on:
		var lk: Dictionary = Acts.data("concord")["LOOK"]
		var f := g.vfx.add(TdVfx.Kind.STREAK, end, float(lk["saucer_beam_w"]) * TdVfx.loud(t), float(lk["saucer_beam_time"]), TdVfxData.SHOTS["ghost_saucer"]["tint"])
		if f != null:
			f.ang = d.angle()
			f.size0 = d.length()


## Lifts the nearest fodder foes in range (see the header).
func _lift(t: Tower) -> void:
	var g := t.game
	var held: Array = t.vars.get("held", [])
	var cands: Array[TdEnemy] = []
	for e: TdEnemy in g.foes_near(t.position, float(t.stats["range"])):
		if String(e.row["rank"]) == "fodder" and t.can_hit(e) and g.time >= e.freeze_until:
			cands.append(e)
	cands.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return a.position.distance_squared_to(t.position) < b.position.distance_squared_to(t.position))
	for i in mini(int(t.stats["lifts"]), cands.size()):
		var e := cands[i]
		TdCombat.freeze_enemy(g, e, float(t.stats["lift_time"]))
		held.append([e, e.generation, g.time + float(t.stats["lift_time"])])
		t.vars["lifted"] = int(t.vars.get("lifted", 0)) + 1
		EnemyTrait.note(g, "ghost_saucer_lifts")
		if g.vfx.on:
			var f := g.vfx.add(TdVfx.Kind.STREAK, e.position, 26.0, float(t.stats["lift_time"]), Acts.data("concord")["LOOK"]["tractor_tint"])
			if f != null:
				f.ang = PI * 0.5
				f.size0 = 90.0
	t.vars["held"] = held


## Drops the foes whose lift is over (see the header).
func _drops(t: Tower) -> void:
	var held: Array = t.vars.get("held", [])
	for i in range(held.size() - 1, -1, -1):
		if t.game.time < float(held[i][2]):
			continue
		var e: TdEnemy = held[i][0]
		var gen := int(held[i][1])  # Its generation when lifted.
		held.remove_at(i)
		if not TdEnemy.valid(e, gen):
			continue
		var at := e.position
		for o: TdEnemy in t.game.foes_near(at, float(t.stats["lift_radius"])):
			TdCombat.damage_enemy(t.game, o, float(t.stats["lift_damage"]), {"source": t.tower_id, "tower": t, "origin": at})
		t.game.fx.spawn("golem_slam", at, float(t.stats["lift_radius"]) * 2.0, 0.4, TdVfxData.SHOTS["ghost_saucer"]["tint"])
