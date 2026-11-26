## Rebirth and the Names: Act VII's act rule (GDD §7.3; Necropathy's Rebirth,
## Sandstorm and TruthScales, DynastyRules). Numbers in
## Acts.data("dynasty")["RULE"], the jars in its JARS.
##   the jars   — Canopic Jars (kind "canopic_jar", structures) stand beside the
##                road from the start (JARS[map]); bosses add more (place_jar()).
##   the Names  — a body whose row has "rebirth" (not already returned, not
##                bound by Linen Bind: vars "no_name") that falls within
##                `jar_radius` px of a standing jar leaves a NAME (kind
##                "dyn_name", a structure: any hit, a splash or Corpse
##                Explosion smashes it) linked to that jar. After `rise_time` s
##                (x the bosses' / Scales' rise multiplier, faster near an
##                "embalms" row) the body RISES where it fell at `return_hp` of
##                its HP, paying no souls again (vars "souls" 0), gold-tinted. A
##                broken jar crumbles every Name it holds at once.
##   the aim    — a tap on a jar (or the bot's autotest_tap()) MARKS it: every
##                tower whose range reaches it shoots only the jar until it
##                breaks (can_target()); tap again to let go. The column or the
##                jars: the player's choice.
##   the storm  — from the map's storm wave a telegraphed sand band crosses the
##                map every `every` s: a tower inside it sees only `sight` of its
##                range (can_target()). force_storm() starts one now (Sekhmet).
##   the Scales — on maps with "scales": every return tips them toward the
##                Dynasty, every smashed Name and broken jar toward the player;
##                past `scale_mark` new spawns are tougher (Dynasty) or weaker
##                (player) and Names rise faster or slower (on_spawn / rise).
## Public calls (kinds and bosses, duck typed through game.act_rule): place_jar(),
## eat_near(), set_rise_mult(), force_storm(), in_storm(), names_alive().
## The look (DynastyLayer, drawing only, nothing headless): the jar-to-Name
## links, the fallen bodies and their rise timers, the marked jar's ring, the
## sand band; the HUD Scales (ScalesBar) on the Hall of Two Truths.
extends MapRule

## Live Names: {e: TdEnemy, gen: int, jar: TdEnemy, jar_gen: int, kind: String,
## road: String, dist: float, lane: float, rise_at: game s, laid: game s}.
var names: Array[Dictionary] = []
## Jars raised: [[TdEnemy, generation], ...].
var jars: Array = []
## The marked jar and its generation (null = none).
var marked: TdEnemy = null
## See marked.
var marked_gen: int = 0
## Rise-time multiplier set by a boss (1 = none; Anubis' Embalmer, Osiris' Weighing).
var rise_mult: float = 1.0
## This map's storm row ({} = no storm).
var storm_cfg: Dictionary = {}
## Game s the next storm starts (INF = not yet).
var next_storm: float = INF
## True while a storm band is out.
var storm_on: bool = false
## Game s the band starts moving (its telegraph before).
var storm_go: float = 0.0
## Band centre x (map px) and its direction (+1 left to right, -1 back).
var storm_x: float = 0.0
## See storm_x.
var storm_dir: float = 1.0
## True on a map with the Scales.
var scales_on: bool = false
## The Scales (negative = the player's side, positive = the Dynasty's).
var scale: float = 0.0
## Counters for the summary.
var counts: Dictionary = {"laid": 0, "returned": 0, "smashed": 0, "crumbled": 0, "eaten": 0, "jars_broken": 0, "marks": 0,
	"storms": 0, "storm_hidden": 0, "scale_min": 0, "scale_max": 0, "empowered": 0}
## The drawing layer and the HUD Scales (null headless).
var layer: Node2D = null
## See layer.
var scales_bar: Control = null


## The RULE numbers.
static func r() -> Dictionary:
	return Acts.data("dynasty")["RULE"]


func setup() -> void:
	storm_cfg = r()["storms"].get(game.map_id, {})
	scales_on = (r()["scales_maps"] as Array).has(game.map_id)
	for p: Vector2 in Acts.data("dynasty")["JARS"].get(game.map_id, []):
		place_jar(p)
	if DisplayServer.get_name() == "headless":
		return
	layer = (load("res://scripts/maps/rules/dynasty/dynasty_layer.gd") as GDScript).new() as Node2D
	layer.set("rule", self)
	game.world.add_child(layer)
	if scales_on:
		scales_bar = (load("res://scripts/maps/rules/dynasty/scales_bar.gd") as GDScript).new() as Control
		scales_bar.set("rule", self)
		game.hud.root.add_child(scales_bar)


## Raises a Canopic Jar beside the road at map px `pos`; returns it.
func place_jar(pos: Vector2) -> TdEnemy:
	var e := Structures.raise(game, "canopic_jar", pos)
	jars.append([e, e.generation])
	return e


## Live jars (prunes the broken).
func live_jars() -> Array:
	jars = jars.filter(func(p: Array) -> bool: return TdEnemy.valid(p[0], int(p[1])))
	return jars


func on_wave_start(n: int) -> void:
	if not storm_cfg.is_empty() and n >= int(storm_cfg["from_wave"]) and next_storm == INF:
		next_storm = game.time + float(r()["storm_first"])


func on_spawn(e: TdEnemy) -> void:
	if not scales_on or e.wave <= 0 or bool(e.row.get("structure", false)) or absf(scale) < float(r()["scale_mark"]):
		return
	TdCombat.empower_enemy(game, e, float(r()["scale_hp_dynasty" if scale > 0.0 else "scale_hp_player"]))
	counts["empowered"] = int(counts["empowered"]) + 1


func on_kill(e: TdEnemy, _tower: Tower) -> void:
	if e.kind == "canopic_jar":
		counts["jars_broken"] = int(counts["jars_broken"]) + 1
		_tip(-float(r()["tip_jar"]))
		game.fx.spawn("bolt_impact", e.position, 90.0, 0.5, LookOf.gold())
		Sfx.play("jar_shatter")
		return
	if not bool(e.row.get("rebirth", false)) or bool(e.vars.get("reborn", false)) or bool(e.vars.get("no_name", false)):
		return
	var jr := float(r()["jar_radius"])  # Reach of a jar's hold (px).
	var best: TdEnemy = null  # The nearest standing jar in reach.
	for p: Array in live_jars():
		var j: TdEnemy = p[0]
		if j.position.distance_squared_to(e.position) <= jr * jr and (best == null or j.position.distance_squared_to(e.position) < best.position.distance_squared_to(e.position)):
			best = j
	if best == null or names.size() >= int(r()["max_names"]):
		return
	var road := e.follower.road.id  # Where it fell.
	var n := game.spawn_at("dyn_name", road, 0, e.follower.dist, e.follower.lane)
	names.append({"e": n, "gen": n.generation, "jar": best, "jar_gen": best.generation, "kind": e.kind,
		"road": road, "dist": e.follower.dist, "lane": e.follower.lane, "rise_at": game.time + _rise_time(), "laid": game.time})
	counts["laid"] = int(counts["laid"]) + 1
	Sfx.play("cartouche_chime")


## Seconds a Name takes to rise now (bosses and the Scales shorten or lengthen it).
func _rise_time() -> float:
	var t := float(r()["rise_time"]) * rise_mult  # Base x the boss's multiplier.
	if scales_on and absf(scale) >= float(r()["scale_mark"]):
		t *= float(r()["scale_rise_dynasty" if scale > 0.0 else "scale_rise_player"])
	return t


## Tips the Scales by `d` (clamped to +-scale_max).
func _tip(d: float) -> void:
	if not scales_on:
		return
	var m := float(r()["scale_max"])  # Its ends.
	scale = clampf(scale + d, -m, m)
	counts["scale_min"] = mini(int(counts["scale_min"]), int(scale))
	counts["scale_max"] = maxi(int(counts["scale_max"]), int(scale))
	if scales_bar != null:
		scales_bar.queue_redraw()
	Sfx.play("scales_tip")


func step(dt: float) -> void:
	_step_storm(dt)
	var er := float(r()["embalm_radius"])  # Reach of an Embalmer's haste (px).
	for i in range(names.size() - 1, -1, -1):
		var nm: Dictionary = names[i]
		var n: TdEnemy = nm["e"]
		if not TdEnemy.valid(n, int(nm["gen"])):
			names.remove_at(i)
			counts["smashed"] = int(counts["smashed"]) + 1
			_tip(-float(r()["tip_smash"]))
			continue
		if not TdEnemy.valid(nm["jar"], int(nm["jar_gen"])):
			names.remove_at(i)
			counts["crumbled"] = int(counts["crumbled"]) + 1
			game.fx.spawn("spore_cloud", n.position, 46.0, 0.5, LookOf.sand())
			game.remove_enemy(n, false)
			continue
		for o: TdEnemy in game.foes_near(n.position, er):
			if bool(o.row.get("embalms", false)):
				nm["rise_at"] = float(nm["rise_at"]) - dt * (float(r()["embalm_speed"]) - 1.0)
				break
		if game.time >= float(nm["rise_at"]):
			names.remove_at(i)
			_rise(nm)
	if marked != null and not TdEnemy.valid(marked, marked_gen):
		marked = null
	finish_structures()


## The body of Name `nm` stands again where it fell.
func _rise(nm: Dictionary) -> void:
	var n: TdEnemy = nm["e"]
	game.remove_enemy(n, false)
	var road: Road = game.roads[nm["road"]]
	var e := game.waves.spawn_extra(String(nm["kind"]), road.id, minf(float(nm["dist"]), road.length - 1.0), float(nm["lane"]))
	e.hp = e.max_hp * float(r()["return_hp"])
	e.vars["reborn"] = true
	e.vars["souls"] = 0  # Its bounty was paid when it first fell.
	e.vars["tint"] = r()["reborn_tint"]
	e.body.queue_redraw()
	counts["returned"] = int(counts["returned"]) + 1
	_tip(float(r()["tip_return"]))
	game.fx.spawn("summon_rise", e.position, 70.0, 0.5, LookOf.gold())
	Sfx.play("rebirth_groan")


## Removes (eats) every Name within `radius` px of `pos` (the Devourer's Whelp,
## Ammit): those bodies never return. Returns how many.
func eat_near(pos: Vector2, radius: float) -> int:
	var eaten := 0  # Names eaten now.
	for i in range(names.size() - 1, -1, -1):
		var n: TdEnemy = names[i]["e"]
		if TdEnemy.valid(n, int(names[i]["gen"])) and n.position.distance_squared_to(pos) <= radius * radius:
			names.remove_at(i)
			game.fx.spawn("spore_cloud", n.position, 50.0, 0.5, Color(0.8, 0.3, 0.25))
			game.remove_enemy(n, false)
			eaten += 1
	counts["eaten"] = int(counts["eaten"]) + eaten
	return eaten


## Sets the bosses' rise multiplier (1 = none).
func set_rise_mult(m: float) -> void:
	rise_mult = m


## Live Names now.
func names_alive() -> int:
	return names.size()


## Marks jar `j` (towers that reach it shoot only it) or lets go when it already is.
func toggle_mark(j: TdEnemy) -> void:
	if marked == j and TdEnemy.valid(marked, marked_gen):
		marked = null
		return
	marked = j
	marked_gen = j.generation
	counts["marks"] = int(counts["marks"]) + 1
	Sfx.play("ui_tick")


## What a tap can mark: the standing Canopic Jars and every enemy whose row
## says "markable" (Sekhmet's wine jars).
func markables() -> Array[TdEnemy]:
	var out: Array[TdEnemy] = []  # Candidates.
	for p: Array in live_jars():
		out.append(p[0])
	for e: TdEnemy in game.enemies:
		if bool(e.row.get("markable", false)):
			out.append(e)
	return out


## The autotest bot's tap policy (TdAutotest calls it each tick): marks a wine
## jar while one stands (dropping a Canopic Jar's mark), else the jar holding the most Names once it holds RULE
## bot_names and no boss or miniboss walks.
func autotest_tap() -> void:
	var held := marked != null and TdEnemy.valid(marked, marked_gen)  # A mark stands.
	if held and bool(marked.row.get("markable", false)):
		return
	for e: TdEnemy in game.enemies:
		if bool(e.row.get("markable", false)):
			marked = null
			toggle_mark(e)
			return
	if held:
		return
	for e: TdEnemy in game.enemies:
		if String(e.row["rank"]) in ["boss", "miniboss"]:
			return
	var best: TdEnemy = null  # The fullest jar.
	var best_n := int(r()["bot_names"]) - 1  # Names it must hold, minus one.
	for p: Array in live_jars():
		var k := 0  # Names it holds.
		for nm: Dictionary in names:
			k += 1 if nm["jar"] == p[0] else 0
		if k > best_n:
			best_n = k
			best = p[0]
	if best != null:
		toggle_mark(best)


func can_target(t: Tower, e: TdEnemy) -> bool:
	if marked != null and TdEnemy.valid(marked, marked_gen):
		var rr := float(t.stats["range"])  # The tower's reach.
		if t.position.distance_squared_to(marked.position) <= rr * rr:
			return e == marked
	if storm_on and game.time >= storm_go and in_storm(t.position):
		var sight := float(t.stats["range"]) * float(r()["storm_sight"])  # Px seen in the sand.
		if t.position.distance_squared_to(e.position) > sight * sight:
			counts["storm_hidden"] = int(counts["storm_hidden"]) + 1
			return false
	return true


# ------------------------------------------------------------------ the Sandstorm

## Starts a storm band now unless one is out (Sekhmet's Red Wind).
func force_storm() -> void:
	if not storm_on:
		_start_storm()


## True when map px `pos` lies in the moving sand band.
func in_storm(pos: Vector2) -> bool:
	return storm_on and game.time >= storm_go and absf(pos.x - storm_x) <= float(r()["storm_width"]) * 0.5


func _start_storm() -> void:
	storm_on = true
	storm_go = game.time + float(r()["storm_warn"])
	var half := float(r()["storm_width"]) * 0.5  # Half the band (px).
	storm_x = -half if storm_dir > 0.0 else MapView.SIZE.x + half
	counts["storms"] = int(counts["storms"]) + 1
	game.banner("A sandstorm sweeps in: towers inside it see half as far")
	Sfx.play("sandstorm")


func _step_storm(dt: float) -> void:
	if not storm_on:
		if game.time >= next_storm:
			_start_storm()
		return
	if game.time < storm_go:
		return
	storm_x += storm_dir * float(r()["storm_speed"]) * dt
	var half := float(r()["storm_width"]) * 0.5  # Half the band (px).
	if storm_x < -half - 1.0 or storm_x > MapView.SIZE.x + half + 1.0:
		storm_on = false
		storm_dir = -storm_dir
		next_storm = game.time + float(storm_cfg.get("every", 40.0))


func summary() -> String:
	var keys := counts.keys()  # Sorted for a stable line.
	keys.sort()
	var parts: Array[String] = ["jars:%d/%d" % [live_jars().size(), jars.size() + int(counts["jars_broken"])], "scale:%d" % int(scale)]
	for k: Variant in keys:
		parts.append("%s:%d" % [k, int(counts[k])])
	return ",".join(parts)


## Looks used by the rule's own effects (drawing only).
class LookOf:
	## The Dynasty's gold.
	static func gold() -> Color:
		return Acts.data("dynasty")["LOOK"]["gold"]

	## Sand.
	static func sand() -> Color:
		return Acts.data("dynasty")["LOOK"]["sand"]
