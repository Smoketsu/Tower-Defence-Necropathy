## The Sun's Course: Act V's act rule (GDD §7.3 "Day, dusk and night";
## Necropathy's SunCourse, docs/act5/PROPOSAL.md). The sun crosses during the
## map, by wave: day until the map's dusk wave, dusk until its night wave, then
## night (RULE "phases"). Numbers in Acts.data("shogunate")["RULE"].
##   visibility — can_target(): by day towers see all they reach; at dusk only
##                `dusk_sight` of their range, at night none (`night_sight`),
##                except inside the light of a lit stone lantern (`light_radius`).
##   lanterns   — map key "lanterns" (Array of map px): stone lanterns beside the
##                road, lit when dusk falls. Ninja and kunoichi douse them
##                (douse_near()); a doused lantern rekindles by itself after
##                `relight_time` s, or at once for `relight_cost` souls with a
##                tap (relight(), SunLayer's input; SoulEconomy pays).
##   ambush     — map key "ambush" (Array of [road id, px along it]): from dusk
##                the ninja trait asks ambush_point() where to appear (round
##                robin); [] by day.
##   the sky override — set_override(phase) / set_override(-1): a boss that moves
##                the sun (Amaterasu) forces day (0) or night (2); the one entry.
## The look (SunLayer, drawing only, nothing headless): a small darkness texture
## (one texel per `cell` px, alpha 0 inside a lit pool) stretched over the map
## UNDER the units (the floor goes dark, units stay readable), the lantern
## sprites, their warm additive glows and the pools' real edges; the HUD sun dial
## (SunDial: sun / setting sun / moon, lanterns lit). Rebuilt only when the
## phase or a lantern changes.
extends MapRule

## Wave (1-based) dusk / night falls on this map (INF-like 999 = never).
var dusk_wave: int = 999
## See dusk_wave.
var night_wave: int = 999
## Phase from the waves: 0 day, 1 dusk, 2 night.
var base_phase: int = 0
## The sky override (-1 = none, else a phase).
var override: int = -1
## The phase in force now (0 day, 1 dusk, 2 night).
var phase: int = 0
## Highest phase reached this run (summary).
var reached: int = 0
## Stone lanterns: {pos: Vector2 map px, lit: bool, out_until: game s it rekindles}.
var lanterns: Array[Dictionary] = []
## Index of the next ambush point (round robin).
var _ambush_i: int = 0
## Counters for the summary.
var counts: Dictionary = {"hidden": 0, "doused": 0, "rekindled": 0, "relit": 0, "ambushes": 0, "overrides": 0}
## The drawing layer (null headless).
var layer: Node2D = null
## The HUD sun dial (null headless).
var dial: Control = null


## The RULE numbers.
static func r() -> Dictionary:
	return Acts.data("shogunate")["RULE"]


func setup() -> void:
	var ph: Dictionary = r()["phases"].get(game.map_id, {})  # This map's dusk / night waves.
	dusk_wave = int(ph.get("dusk", 999))
	night_wave = int(ph.get("night", 999))
	for p: Vector2 in game.map.get("lanterns", []):
		lanterns.append({"pos": p, "lit": false, "out_until": 0.0})
	if DisplayServer.get_name() == "headless":
		return
	layer = (load("res://scripts/maps/rules/shogunate/sun_layer.gd") as GDScript).new() as Node2D
	layer.set("rule", self)
	game.world.add_child(layer)
	dial = (load("res://scripts/maps/rules/shogunate/sun_dial.gd") as GDScript).new() as Control
	dial.set("rule", self)
	game.hud.root.add_child(dial)


func on_wave_start(n: int) -> void:
	base_phase = 2 if n >= night_wave else (1 if n >= dusk_wave else 0)
	_apply()


## Forces the sky to phase `p` (0 day, 1 dusk, 2 night) or hands it back to the clock (-1).
func set_override(p: int) -> void:
	override = p
	if p >= 0:
		counts["overrides"] = int(counts["overrides"]) + 1
	_apply()


## Puts the phase in force; lights every lantern when the light first fails.
func _apply() -> void:
	var p := override if override >= 0 else base_phase  # The phase now.
	if p == phase:
		return
	var old := phase  # Before.
	phase = p
	reached = maxi(reached, p)
	if old == 0:
		for l: Dictionary in lanterns:
			l["lit"] = true
	if override < 0:
		game.banner(["The sun stands high", "Dusk falls: the lanterns are lit, ninja leave the shadows",
			"Night: your towers see only in the lanterns' light"][p])
	if p == 2:
		Sfx.play("nightfall")
	_changed()


## True when map px `pos` is lit: by day everywhere, else inside a lit lantern's pool.
func in_light(pos: Vector2) -> bool:
	if phase == 0:
		return true
	var rr := float(r()["light_radius"])  # Pool radius (px).
	for l: Dictionary in lanterns:
		if bool(l["lit"]) and pos.distance_squared_to(l["pos"]) <= rr * rr:
			return true
	return false


func can_target(t: Tower, e: TdEnemy) -> bool:
	if phase == 0:
		return true
	var sight := float(t.stats["range"]) * float(r()["dusk_sight" if phase == 1 else "night_sight"])  # Px seen without light.
	if t.position.distance_squared_to(e.position) <= sight * sight or in_light(e.position):
		return true
	counts["hidden"] = int(counts["hidden"]) + 1
	return false


## Douses the first lit lantern within `radius` px of `pos`; returns how many (0 or 1).
func douse_near(pos: Vector2, radius: float) -> int:
	if phase == 0:
		return 0
	var n := 0  # Doused now.
	for l: Dictionary in lanterns:
		if n == 0 and bool(l["lit"]) and pos.distance_squared_to(l["pos"]) <= radius * radius:
			l["lit"] = false
			l["out_until"] = game.time + float(r()["relight_time"])
			n += 1
			game.fx.spawn("spore_cloud", l["pos"], 70.0, 0.6, Color(0.5, 0.5, 0.6, 0.8))
	if n > 0:
		counts["doused"] = int(counts["doused"]) + n
		_changed()
	return n


## Relights doused lantern `i` at once for RULE relight_cost souls; false when lit or unaffordable.
func relight(i: int) -> bool:
	if i < 0 or i >= lanterns.size() or bool(lanterns[i]["lit"]) or phase == 0:
		return false
	if not game.economy.spend(int(r()["relight_cost"])):
		game.sound("denied")
		return false
	_light(i)
	counts["relit"] = int(counts["relit"]) + 1
	return true


## Lights lantern `i` (its look and sound).
func _light(i: int) -> void:
	lanterns[i]["lit"] = true
	game.fx.spawn("level_up", lanterns[i]["pos"], 60.0, 0.5, Color(1.0, 0.8, 0.4))
	Sfx.play("lantern_lit")
	_changed()


func step(_dt: float) -> void:
	for i in lanterns.size():
		if not bool(lanterns[i]["lit"]) and phase > 0 and game.time >= float(lanterns[i]["out_until"]):
			counts["rekindled"] = int(counts["rekindled"]) + 1
			_light(i)


## The autotest bot's tap policy (TdAutotest calls it each tick): relights a
## doused lantern when it has RULE bot_reserve souls to spare.
func autotest_tap() -> void:
	if phase == 0 or game.economy.souls < int(r()["bot_reserve"]):
		return
	for i in lanterns.size():
		if not bool(lanterns[i]["lit"]):
			relight(i)
			return


## [road id, px along it] where the next ambushing ninja appears; [] by day or without points.
func ambush_point() -> Array:
	var pts: Array = game.map.get("ambush", [])  # The map's ambush points.
	if phase == 0 or pts.is_empty():
		return []
	var p: Array = pts[_ambush_i % pts.size()]
	_ambush_i += 1
	counts["ambushes"] = int(counts["ambushes"]) + 1
	return p


## Lanterns lit now.
func lit_count() -> int:
	var n := 0  # Lit so far.
	for l: Dictionary in lanterns:
		n += 1 if bool(l["lit"]) else 0
	return n


## Redraws the look after a change (drawing only).
func _changed() -> void:
	if layer != null:
		layer.call("rebuild")
	if dial != null:
		dial.queue_redraw()


func summary() -> String:
	var keys := counts.keys()  # Sorted for a stable line.
	keys.sort()
	var parts: Array[String] = ["phase:%d" % reached, "dusk_wave:%d" % dusk_wave, "night_wave:%d" % night_wave, "lanterns:%d/%d" % [lit_count(), lanterns.size()]]
	for k: Variant in keys:
		parts.append("%s:%d" % [k, int(counts[k])])
	return ",".join(parts)
