## The Stampedes: Act XIV's act rule (GDD §7.3 "herds cross the map off-road and
## trample plots in their path"; Necropathy's Herds, docs/titans/). Numbers in
## Acts.data("primeval")["RULE"]; map geometry in the map's keys.
##   herds     — every wave group on a herd TRAIL (map key "herd_trails": trail
##               road id -> its reversed road id; both off-road, exit) is one herd
##               (keyed wave:trail). `lead` s before its first beast comes the
##               trail is MARKED (a dust line, running arrows, a pulsing ring
##               under each plot in its path) and the HUD cue counts down. The
##               beasts trample (traits/primeval/herd.gd: towers they pass are
##               disabled, blocker bodies on the trail knocked down).
##   turning   — a herd runs away from what hurts it (owner rule): once the
##               damage dealt to it reaches `turn_share` of its spawned HP, every
##               beast of it turns and runs back along the reversed road (no more
##               trampling); beasts of it still to come turn on arrival. Bosses
##               start herds of their own through launch().
##   tar       — the Fern Basin (map key "tar": [[centre, radius], ...]): every
##               ground walker in a seep is slowed (`tar_slow`), except the
##               swimmers (row args "sprite_sunk": the Bog Croc), which sink out
##               of sight there (vars "hidden_until", the one hidden test).
##   hole      — the Great Plain (map key "hole": [centre, radius]): herd beasts
##               wade in and drink (`hole_slow`); a herd hurt enough to turn while
##               one of its beasts drinks THERE does not turn: it BOLTS forward
##               (`bolt_haste`) and never turns (hit herds before the water).
##   meteors   — the Last Day (map key "meteors": true): a meteorite on a
##               telegraphed circle every `every` s (RULE "meteor"), on a tower
##               half the time (seeded) and on the road ahead of the leading foe
##               otherwise; it disables towers, strikes bodies AND foes inside.
##               Gravejaw's Last Day speeds them (meteor_mult).
## The look: PrimevalLayer (pools, marked trails, meteor circles; drawing only)
## and PrimevalCue (the HUD cue, top-left), both null headless.
extends MapRule

## Trail road id -> reversed road id (map key "herd_trails").
var trails: Dictionary = {}
## Trail road id -> plot spot ids in its path (within RULE mark_r).
var marked_plots: Dictionary = {}
## Herds: key "wave:trail" -> {hp: spawned HP, hurt: damage taken, turned: bool, bolted: bool}.
var herds: Dictionary = {}
## Warnings: [trail id, game s it shows from, game s the herd arrives, game s it ends].
var warnings: Array = []
## Boss-launched beasts to come: [game s, kind, trail id, herd key].
var pending: Array = []
## Tar seeps [[Vector2 centre, float radius], ...] and the watering hole [centre, radius] or [].
var tar: Array = []
## See tar.
var hole: Array = []
## Meteors falling: [Vector2 centre, game s it lands, game s it was called].
var meteors: Array = []
## Game s of the next meteor (INF = none on this map).
var next_meteor: float = INF
## Herd key of a boss-launched beast being spawned now ("" = a wave's herd).
var _spawning: String = ""
## Multiplier on the meteor interval (Gravejaw's Last Day sets it below 1).
var meteor_mult: float = 1.0
## Wave now (1-based).
var wave: int = 0
## Game s of the next tar / hole application.
var next_tick: float = 0.0
## Counters for the summary.
var counts: Dictionary = {"herds": 0, "turned": 0, "bolted": 0, "beasts": 0, "beasts_turned": 0, "tar_slowed": 0, "sunk": 0,
	"drinking": 0, "meteors": 0, "meteor_towers": 0, "meteor_bodies": 0, "meteor_foes": 0, "boss_herds": 0}
## The drawing layer and the HUD cue (null headless).
var layer: Node2D = null
## See layer.
var cue: Control = null


## The RULE numbers.
static func r() -> Dictionary:
	return Acts.data("primeval")["RULE"]


## The Stampedes of this run, or null on another act's map (kinds ask).
static func of(game: TdGame) -> MapRule:
	return game.act_rule if game.act_rule != null and game.act_rule.has_method("herd_hurt") else null


func setup() -> void:
	trails = game.map.get("herd_trails", {})
	tar = game.map.get("tar", [])
	hole = game.map.get("hole", [])
	if bool(game.map.get("meteors", false)):
		next_meteor = float(r()["meteor"]["first"])
	for tid: String in trails:
		var rd: Road = game.roads[tid]
		var ids: Array[String] = []  # Plots in its path.
		for s: Spot in game.spots:
			if s.kind == "plot" and rd.distance_to(s.position) <= float(r()["mark_r"]):
				ids.append(s.spot_id())
		marked_plots[tid] = ids
	if DisplayServer.get_name() == "headless":
		return
	layer = (load("res://scripts/maps/rules/primeval/primeval_layer.gd") as GDScript).new() as Node2D
	layer.set("rule", self)
	game.world.add_child(layer)
	cue = (load("res://scripts/maps/rules/primeval/primeval_cue.gd") as GDScript).new() as Control
	cue.set("rule", self)
	game.hud.root.add_child(cue)


func on_wave_start(n: int) -> void:
	wave = n
	var w: Dictionary = game.waves.waves[n - 1]
	for g: Dictionary in w["groups"]:
		var tid := String(g.get("road", ""))
		if not trails.has(tid):
			continue
		var at := game.time + float(g.get("delay", 0.0))  # The first beast comes.
		var span := float(g.get("spacing", TdRulesData.DEFAULT_SPACING)) * float(maxi(int(g["count"]) - 1, 0))  # Px of the column in s.
		warnings.append([tid, at - float(r()["lead"]), at, at + span + 2.0])
		Sfx.play("stampede_warn")


## Starts a herd of `groups` ([[kind, count], ...]) on the trail nearest `near`
## (a boss's): marked now, the beasts come `lead` s later, `gap` s apart.
func launch(groups: Array, near: Vector2, gap: float) -> void:
	if trails.is_empty():
		return
	var tid := ""  # The trail nearest `near`.
	for t: String in trails:
		if tid == "" or (game.roads[t] as Road).distance_to(near) < (game.roads[tid] as Road).distance_to(near):
			tid = t
	var at := game.time + float(r()["lead"])
	var key := "boss%d:%s" % [counts["boss_herds"], tid]
	var k := 0  # Beasts queued.
	for g: Array in groups:
		for i in int(g[1]):
			pending.append([at + gap * float(k), String(g[0]), tid, key])
			k += 1
	warnings.append([tid, game.time, at, at + gap * float(k) + 2.0])
	counts["boss_herds"] = int(counts["boss_herds"]) + 1
	game.banner("A stampede! The herd runs down its trail")


func on_spawn(e: TdEnemy) -> void:
	var tid := e.follower.road.id
	if not trails.has(tid) or e.vars.has("herd"):
		return
	_join(e, _spawning if _spawning != "" else "%d:%s" % [e.wave, tid])


## Makes `e` a beast of herd `key` (a new herd on its first beast); turns it at
## once if its herd already turned.
func _join(e: TdEnemy, key: String) -> void:
	if not herds.has(key):
		herds[key] = {"hp": 0.0, "hurt": 0.0, "turned": false, "bolted": false}
		counts["herds"] = int(counts["herds"]) + 1
	var h: Dictionary = herds[key]
	h["hp"] = float(h["hp"]) + e.max_hp
	e.vars["herd"] = key
	counts["beasts"] = int(counts["beasts"]) + 1
	if bool(h["turned"]):
		_turn_beast(e)
	elif bool(h["bolted"]):
		TdCombat.haste_enemy(game, e, float(r()["bolt_haste"]), 60.0)


## A beast of a herd took `amount` damage (its trait calls this): the herd turns
## back once hurt enough, or bolts forward if the beast was drinking.
func herd_hurt(e: TdEnemy, amount: float) -> void:
	var h: Dictionary = herds.get(String(e.vars.get("herd", "")), {})
	if h.is_empty() or bool(h["turned"]) or bool(h["bolted"]) or bool(e.vars.get("turned", false)):
		return
	h["hurt"] = float(h["hurt"]) + amount
	if float(h["hurt"]) < float(h["hp"]) * float(r()["turn_share"]):
		return
	if in_hole(e.position):
		h["bolted"] = true
		counts["bolted"] = int(counts["bolted"]) + 1
		for o: TdEnemy in _beasts(String(e.vars["herd"])):
			TdCombat.haste_enemy(game, o, float(r()["bolt_haste"]), 60.0)
		game.banner("The herd bolts from the watering hole!")
		EnemyTrait.note(game, "herds_bolted")
		return
	h["turned"] = true
	counts["turned"] = int(counts["turned"]) + 1
	for o: TdEnemy in _beasts(String(e.vars["herd"])):
		_turn_beast(o)
	game.banner("The herd turns back from your fire!")


## Living beasts of herd `key`.
func _beasts(key: String) -> Array[TdEnemy]:
	var out: Array[TdEnemy] = []
	for o: TdEnemy in game.enemies:
		if String(o.vars.get("herd", "")) == key:
			out.append(o)
	return out


## Turns beast `e`: it runs back along its trail's reversed road (an exit too).
func _turn_beast(e: TdEnemy) -> void:
	var tid := e.follower.road.id
	if not trails.has(tid) or bool(e.vars.get("turned", false)):
		return
	var back: Road = game.roads[String(trails[tid])]
	e.follower.setup(game.roads, back, maxf(back.length - e.follower.dist, 0.0), -e.follower.lane)
	e.last_dist = e.follower.dist
	e.vars["turned"] = true
	counts["beasts_turned"] = int(counts["beasts_turned"]) + 1
	if game.vfx.on:
		game.vfx.add(TdVfx.Kind.ANIM, e.position, e.radius * 4.0, 0.4, r()["turn_tint"], "volley_flash")


## True when map px `p` lies in a tar seep.
func in_tar(p: Vector2) -> bool:
	for t: Array in tar:
		if p.distance_to(t[0]) <= float(t[1]):
			return true
	return false


## True when map px `p` lies in the watering hole.
func in_hole(p: Vector2) -> bool:
	return not hole.is_empty() and p.distance_to(hole[0]) <= float(hole[1])


## Seconds until the next marked herd arrives (INF = none marked now), and its trail.
func next_herd() -> Array:
	var best := INF
	var tid := ""
	for w: Array in warnings:
		if game.time >= float(w[1]) and float(w[2]) - game.time < best and game.time <= float(w[3]):
			best = maxf(float(w[2]) - game.time, 0.0)
			tid = String(w[0])
	return [best, tid]


## Trails marked now (drawn).
func marked() -> Array[String]:
	var out: Array[String] = []
	for w: Array in warnings:
		if game.time >= float(w[1]) and game.time <= float(w[3]) and not out.has(String(w[0])):
			out.append(String(w[0]))
	return out


func step(_dt: float) -> void:
	for i in range(warnings.size() - 1, -1, -1):
		if game.time > float(warnings[i][3]):
			warnings.remove_at(i)
	for i in range(pending.size() - 1, -1, -1):
		var p: Array = pending[i]
		if game.time >= float(p[0]):
			pending.remove_at(i)
			_spawning = String(p[3])
			game.waves.spawn_extra(String(p[1]), String(p[2]), 0.0, game.rng.randf_range(-TdRulesData.LANE_SPREAD, TdRulesData.LANE_SPREAD))
			_spawning = ""
	if game.time >= next_tick:
		next_tick = game.time + float(r()["tick"])
		_pools()
	if game.time >= next_meteor:
		_call_meteor()
	for i in range(meteors.size() - 1, -1, -1):
		if game.time >= float(meteors[i][1]):
			_land_meteor(meteors[i][0])
			meteors.remove_at(i)


## The tar and the watering hole (every `tick` s).
func _pools() -> void:
	if tar.is_empty() and hole.is_empty():
		return
	var t := float(r()["tick"]) + 0.05  # Status time (bridges two ticks).
	for e: TdEnemy in game.enemies:
		if bool(e.row["flying"]) or bool(e.row.get("structure", false)):
			continue
		if in_tar(e.position):
			if (e.row["args"] as Dictionary).has("sprite_sunk"):
				e.vars["hidden_until"] = game.time + t
				counts["sunk"] = int(counts["sunk"]) + 1
			else:
				TdCombat.slow_enemy(game, e, float(r()["tar_slow"]), t)
				counts["tar_slowed"] = int(counts["tar_slowed"]) + 1
		if e.vars.has("herd") and in_hole(e.position) and not bool(e.vars.get("turned", false)):
			TdCombat.slow_enemy(game, e, float(r()["hole_slow"]), t)
			counts["drinking"] = int(counts["drinking"]) + 1


## Calls the next meteorite (see the header).
func _call_meteor() -> void:
	var m: Dictionary = r()["meteor"]
	var every := float(m["every_late"] if wave >= int(m["late_wave"]) else m["every"]) * meteor_mult
	next_meteor = game.time + every
	var at := Vector2.INF  # Where it falls.
	if not game.towers.is_empty() and game.rng.randf() < 0.5:
		at = (game.towers[game.rng.randi() % game.towers.size()] as Tower).position
	else:
		var lead: TdEnemy = null  # The foe nearest the gate (not a beast).
		for e: TdEnemy in game.enemies:
			if not e.follower.road.off_road and not bool(e.row.get("structure", false)) and (lead == null or game.progress(e) > game.progress(lead)):
				lead = e
		if lead != null:
			at = lead.follower.road.point_at(minf(lead.follower.dist + 40.0, lead.follower.road.length))
	if at == Vector2.INF:
		return
	meteors.append([at, game.time + float(m["delay"]), game.time])
	Sfx.play("bomb_warn")
	counts["meteors"] = int(counts["meteors"]) + 1


## A meteorite lands at `p`: towers disabled, bodies and foes struck.
func _land_meteor(p: Vector2) -> void:
	var m: Dictionary = r()["meteor"]
	var rad := float(m["radius"])
	for t: Tower in game.towers.duplicate():
		if t.position.distance_to(p) <= rad:
			TdCombat.disable_tower(game, t, float(m["disable"]), "shelled")
			counts["meteor_towers"] = int(counts["meteor_towers"]) + 1
	for b: BlockBody in game.bodies_near(p, rad):
		TdCombat.damage_body(game, b, float(m["body_damage"]))
		counts["meteor_bodies"] = int(counts["meteor_bodies"]) + 1
	for e: TdEnemy in game.foes_near(p, rad):
		if not bool(e.row["flying"]):
			TdCombat.damage_enemy(game, e, float(m["enemy_damage"]), {"source": "meteor", "origin": p})
			counts["meteor_foes"] = int(counts["meteor_foes"]) + 1
	if game.vfx.on:
		var tint: Color = r()["meteor_tint"]
		game.vfx.add(TdVfx.Kind.ANIM, p, rad * 2.2, TdVfxData.IMPACT_TIME * 1.4, Color.WHITE, "corpse_explosion")
		var ring := game.vfx.add(TdVfx.Kind.RING, p, rad, TdVfxData.RING_TIME, tint)
		if ring != null:
			ring.size0 = rad * 0.3
		game.vfx.add(TdVfx.Kind.CRACK, p, 1.0, TdVfxData.CRACK_TIME, Color.WHITE)
		game.vfx.shake(HostileData.SHELL_SHAKE)
		Sfx.play("bomb_land")


func summary() -> String:
	var keys := counts.keys()
	keys.sort()
	var parts: Array[String] = []
	for k: Variant in keys:
		parts.append("%s=%d" % [k, int(counts[k])])
	return " ".join(parts)
