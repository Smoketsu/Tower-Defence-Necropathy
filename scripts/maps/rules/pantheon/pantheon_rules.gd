## The Olympian Republic's act rule (Act VIII, GDD §7.3; Necropathy's
## PantheonRules, docs/act4/PROPOSAL.md). Numbers in Acts.data("pantheon")
## ["RULE"], looks in ["LOOK"] (read through r() / look()). Three shared rules:
##   PHALANX — the shield fronts: the facing test lives in the phalanx trait
##     (scripts/enemies/traits/pantheon/phalanx.gd), asked once per hit from
##     TdCombat.damage_enemy(); this rule DRAWS every shield (PantheonLayer)
##     and reports its counters.
##   WRATH OF THE GODS — from the map's `from_wave`, every `every` s the god of
##     the map strikes: Poseidon's WAVE (a row of circles along a stretch of
##     road), Zeus' LIGHTNING (bolts on towers and foes alike) or Hades'
##     FISSURES (a line of circles across the road). Each circle is a
##     telegraphed strike through the hostile path (game.hostile.shell: towers
##     inside disabled, blocker bodies damaged) AND, landing, it hurts every
##     foe inside (TdCombat.damage_enemy, source "wrath", x `boss_mult` on
##     bosses / minibosses). Both armies. Read on the HUD by the WrathMeter.
##   GLORY — Heroes grow with every blocker body they fell (the hero trait).
## Also the act's two boss hooks: can_target() hides an enemy while its
## vars "cloak_until" lies ahead (Hades' Helm of Darkness), and
## on_body_fallen() raises a fallen blocker as a shade while an enemy with vars
## "claiming" lives (Hades' Reclaiming, game.spawn_from_body()).
class_name PantheonActRules
extends MapRule

## This map's wrath row (RULE "wrath"[map id]; {} = no wrath).
var wrath: Dictionary = {}
## Wave number (1-based) now.
var wave: int = 0
## Game s of the next wrath strike (INF until its first wave).
var next_wrath: float = INF
## Pending landings: [map px, radius px, land game s, first circle of its strike].
var pending: Array = []
## Counters for the summary.
var counts: Dictionary = {"strikes": 0, "circles": 0, "enemy_hits": 0, "enemy_damage": 0.0, "towers_hit": 0, "bodies_hit": 0, "claims": 0, "hidden": 0}
## True once the first strike was announced.
var _announced: bool = false
## The drawing layer (shields, glory; null headless).
var layer: Node2D = null
## The HUD cue (null headless).
var meter: Control = null


## The RULE numbers.
static func r() -> Dictionary:
	return Acts.data("pantheon")["RULE"]


## The act's looks (drawing only).
static func look() -> Dictionary:
	return Acts.data("pantheon")["LOOK"]


func setup() -> void:
	wrath = (r()["wrath"] as Dictionary).get(game.map_id, {})
	if DisplayServer.get_name() == "headless":
		return
	layer = (load("res://scripts/maps/rules/pantheon/pantheon_layer.gd") as GDScript).new() as Node2D
	layer.set("game", game)
	game.world.add_child(layer)
	if not wrath.is_empty():
		meter = (load("res://scripts/maps/rules/pantheon/wrath_meter.gd") as GDScript).new() as Control
		meter.set("rule", self)
		game.hud.root.add_child(meter)


func on_wave_start(n: int) -> void:
	wave = n
	if not wrath.is_empty() and n >= int(wrath["from_wave"]) and next_wrath == INF:
		next_wrath = game.time + float(wrath["first"])


func step(_dt: float) -> void:
	for i in range(pending.size() - 1, -1, -1):
		var p: Array = pending[i]
		if game.time >= float(p[2]):
			pending.remove_at(i)
			_land(p)
	if game.time >= next_wrath:
		next_wrath += float(wrath["every"])
		_strike()


## Seconds to the next strike (INF before the first wave of wrath).
func time_left() -> float:
	return next_wrath - game.time


## One strike of the map's god: its circles telegraphed now, landing after `delay`.
func _strike() -> void:
	var pts: Array[Vector2] = []  # Circle centres.
	var n := int(wrath["count"])  # Circles.
	var gap := float(wrath["gap"])  # Px between circles.
	match String(wrath["kind"]):
		"wave", "fissure":
			var rs: Array[Road] = []  # Roads it may strike (no off-road trails).
			for rd: Road in game.roads.values():
				if not rd.off_road:
					rs.append(rd)
			var rd: Road = rs[game.rng.randi() % rs.size()]
			var d := game.rng.randf_range(float(wrath["road_from"]), float(wrath["road_to"])) * rd.length  # Where on it.
			var dir := rd.dir_at(d)  # Road direction there.
			for i in n:
				var k := float(i) - float(n - 1) * 0.5  # Offset index.
				if String(wrath["kind"]) == "wave":
					pts.append(rd.point_at(clampf(d + k * gap, 0.0, rd.length)))  # Along the road.
				else:
					pts.append(rd.point_at(d) + Vector2(dir.y, -dir.x) * k * gap)  # Across it.
		"lightning":
			var cands: Array[Vector2] = []  # Towers and foes alike.
			for t: Tower in game.towers:
				cands.append(t.position)
			for e: TdEnemy in game.enemies:
				if not bool(e.row.get("structure", false)):
					cands.append(e.position)
			if cands.is_empty():
				return
			for i in n:
				pts.append(cands[game.rng.randi() % cands.size()])
	counts["strikes"] = int(counts["strikes"]) + 1
	var land := game.time + float(wrath["delay"])  # When they land.
	for i in pts.size():
		game.hostile.shell(pts[i], float(wrath["radius"]), float(wrath["delay"]), float(wrath["disable"]), String(wrath["cause"]), float(wrath["body_damage"]))
		pending.append([pts[i], float(wrath["radius"]), land, i == 0])
		counts["circles"] = int(counts["circles"]) + 1
	if not _announced:
		_announced = true
		game.banner(String(wrath["banner"]))


## Circle `p` lands: every foe inside is struck (the towers and bodies are the
## hostile shell's own landing); its look and, once per strike, its sound.
func _land(p: Array) -> void:
	var at: Vector2 = p[0]
	var rad := float(p[1])  # Radius (px).
	for e: TdEnemy in game.foes_near(at, rad):
		var big: bool = e.row["rank"] == "boss" or e.row["rank"] == "miniboss"  # Gods spare the great.
		var dealt := TdCombat.damage_enemy(game, e, float(wrath["enemy_damage"]) * (float(wrath["boss_mult"]) if big else 1.0), {"source": "wrath", "origin": at})
		counts["enemy_hits"] = int(counts["enemy_hits"]) + 1
		counts["enemy_damage"] = float(counts["enemy_damage"]) + dealt
	for t: Tower in game.towers:
		if t.position.distance_squared_to(at) <= rad * rad:
			counts["towers_hit"] = int(counts["towers_hit"]) + 1
	counts["bodies_hit"] = int(counts["bodies_hit"]) + game.bodies_near(at, rad).size()
	if bool(p[3]):
		Sfx.play(String(wrath["sound"]))
	if game.vfx.on:
		var lk: Dictionary = look()
		var kind := String(wrath["kind"])  # Its look.
		game.vfx.add(TdVfx.Kind.ANIM, at + Vector2(0, -float(lk["bolt_lift"]) if kind == "lightning" else 0.0), rad * float(lk["wrath_anim_mult"]),
				0.5, lk["wrath_tint"][kind], String(lk["wrath_anim"][kind]))


func can_target(_t: Tower, e: TdEnemy) -> bool:
	if game.time < float(e.vars.get("cloak_until", 0.0)):
		counts["hidden"] = int(counts["hidden"]) + 1
		return false
	return true


func on_body_fallen(b: BlockBody, _by: TdEnemy) -> void:
	if b.temporary:
		return
	for e: TdEnemy in game.enemies:
		if bool(e.vars.get("claiming", false)):
			game.spawn_from_body(String(e.row["args"]["claim_kind"]), b)
			counts["claims"] = int(counts["claims"]) + 1
			return


func summary() -> String:
	var ev: Dictionary = game.stats.get("events", {})  # Trait counters.
	var parts: Array[String] = ["wrath:%s" % String(wrath.get("kind", "none"))]
	for k: String in ["strikes", "circles", "enemy_hits", "towers_hit", "bodies_hit", "claims", "hidden"]:
		parts.append("%s:%d" % [k, int(counts[k])])
	parts.append("enemy_dmg:%d" % int(counts["enemy_damage"]))
	for k: String in ["phalanx_front", "phalanx_flank", "phalanx_back", "phalanx_roof", "phalanx_saved", "glory"]:
		parts.append("%s:%d" % [k.trim_prefix("phalanx_"), int(ev.get(k, 0.0))])
	return ",".join(parts)
