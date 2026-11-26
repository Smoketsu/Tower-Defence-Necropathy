## The Long Winter: Act VI's act rule (GDD §7.3; Necropathy's LongWinter,
## NorseRulesData.LONG_WINTER: "the cold rises with the clock; outside a lit
## brazier's warmth the necromancer's side is slowed; frost giants and seers
## douse braziers, the necromancer relights them"). Numbers in
## Acts.data("norse")["RULE"].
##   cold     — the cold level rises by wave (RULE "cold_waves" for this map:
##              the waves at which levels 1, 2, 3 begin). Every `check_every` s
##              each tower further than `warm_radius` px from every lit brazier
##              attacks at RULE rate_by_level[level] of its speed
##              (TdCombat.chill_tower(), through Tower.recompute()); near a lit
##              brazier it works normally.
##   braziers — map key "braziers" (Array of map px), lit from the start. Frost
##              giants and seers douse them as they pass (douse_near(); one per
##              douser); a doused brazier rekindles by itself after
##              `relight_time` s, or at once for `relight_cost` souls with a tap
##              (relight(); WinterLayer's input; SoulEconomy pays).
##   rune-stones — map key "rune_stones" (Array of map px): the act's
##              structures (kind norse_rune_stone, trait norse/rune_stone) raised
##              beside the road at the start; cleared when only they remain.
##   reach    — can_target(): an enemy whose vars "untargetable" is true (a boss
##              sunk in his barrow, Odin watching) is hidden from every tower.
##   holmgang — set_duel(tower, until) / duel_tower(): Sigrun's duel post, drawn
##              as a hazel square (WinterLayer).
## The look (WinterLayer, drawing only, nothing headless): the brazier sprites
## (lit / doused loops), their warm glows and the warmth's real edge, a rime ring
## under every chilled tower, frost bands creeping in from the screen edges as
## the cold rises (norse/frost_creep, edge bands, no full-screen overlay); the
## HUD cold meter (WinterMeter, bottom-left).
extends MapRule

## Waves (1-based) at which cold levels 1.. begin on this map.
var cold_waves: Array = []
## The cold level now (0 .. rate_by_level.size() - 1).
var level: int = 0
## Braziers: {pos: Vector2 map px, lit: bool, out_until: game s it rekindles}.
var braziers: Array[Dictionary] = []
## Game s of the next warmth check.
var _next_check: float = 0.0
## Sigrun's duel post (null = no duel) and the game s it ends.
var duel_tower: Tower = null
## See duel_tower.
var duel_until: float = 0.0
## Counters for the summary.
var counts: Dictionary = {"doused": 0, "rekindled": 0, "relit": 0, "chilled_s": 0.0, "hidden": 0, "stones": 0}
## The drawing layer (null headless).
var layer: Node2D = null
## The HUD meter (null headless).
var meter: Control = null


## The RULE numbers.
static func r() -> Dictionary:
	return Acts.data("norse")["RULE"]


## The Long Winter of this run, or null on another act's map (kinds call it).
static func of(game: TdGame) -> MapRule:
	return game.act_rule if game.act_rule != null and game.act_rule.has_method("douse_near") and game.act_rule.has_method("warm_at") else null


func setup() -> void:
	cold_waves = r()["cold_waves"].get(game.map_id, [])
	for p: Vector2 in game.map.get("braziers", []):
		braziers.append({"pos": p, "lit": true, "out_until": 0.0})
	for p: Vector2 in game.map.get("rune_stones", []):
		Structures.raise(game, "norse_rune_stone", p)
		counts["stones"] = int(counts["stones"]) + 1
	if DisplayServer.get_name() == "headless":
		return
	layer = (load("res://scripts/maps/rules/norse/winter_layer.gd") as GDScript).new() as Node2D
	layer.set("rule", self)
	game.world.add_child(layer)
	meter = (load("res://scripts/maps/rules/norse/winter_meter.gd") as GDScript).new() as Control
	meter.set("rule", self)
	game.hud.root.add_child(meter)


func on_wave_start(n: int) -> void:
	var lv := 0  # Levels whose wave has come.
	for w: Variant in cold_waves:
		if n >= int(w):
			lv += 1
	lv = mini(lv, (r()["rate_by_level"] as Array).size() - 1)
	if lv == level:
		return
	level = lv
	game.banner(["", "The Long Winter: towers far from a brazier slow in the cold",
		"The cold deepens: keep the braziers lit", "Fimbulwinter: only the fires keep your towers awake"][mini(lv, 3)])
	Sfx.play("horn_call")
	_next_check = 0.0
	_changed()


## True when map px `pos` lies in a lit brazier's warmth.
func warm_at(pos: Vector2) -> bool:
	var rr := float(r()["warm_radius"])  # Warmth radius (px).
	for b: Dictionary in braziers:
		if bool(b["lit"]) and pos.distance_squared_to(b["pos"]) <= rr * rr:
			return true
	return false


## Douses the first lit brazier within `radius` px of `pos`; returns how many (0 or 1).
func douse_near(pos: Vector2, radius: float) -> int:
	for b: Dictionary in braziers:
		if bool(b["lit"]) and pos.distance_squared_to(b["pos"]) <= radius * radius:
			b["lit"] = false
			b["out_until"] = game.time + float(r()["relight_time"])
			counts["doused"] = int(counts["doused"]) + 1
			game.fx.spawn("spore_cloud", b["pos"], 70.0, 0.6, Color(0.7, 0.8, 0.95, 0.8))
			Sfx.play("deep_freeze")
			_next_check = 0.0
			_changed()
			return 1
	return 0


## Relights doused brazier `i` at once for RULE relight_cost souls; false when lit or unaffordable.
func relight(i: int) -> bool:
	if i < 0 or i >= braziers.size() or bool(braziers[i]["lit"]):
		return false
	if not game.economy.spend(int(r()["relight_cost"])):
		game.sound("denied")
		return false
	_light(i)
	counts["relit"] = int(counts["relit"]) + 1
	return true


## Lights brazier `i` (its look and sound).
func _light(i: int) -> void:
	braziers[i]["lit"] = true
	game.fx.spawn("level_up", braziers[i]["pos"], 64.0, 0.5, Color(1.0, 0.7, 0.35))
	Sfx.play("priest_ward")
	_next_check = 0.0
	_changed()


func step(dt: float) -> void:
	for i in braziers.size():
		if not bool(braziers[i]["lit"]) and game.time >= float(braziers[i]["out_until"]):
			counts["rekindled"] = int(counts["rekindled"]) + 1
			_light(i)
	if game.time >= _next_check:
		_next_check = game.time + float(r()["check_every"])
		var cold := float(r()["rate_by_level"][level])  # Rate out of warmth.
		for t: Tower in game.towers:
			TdCombat.chill_tower(game, t, 1.0 if cold >= 1.0 or warm_at(t.position) else cold)
	for t: Tower in game.towers:
		if t.vars.has("k_cold"):
			counts["chilled_s"] = float(counts["chilled_s"]) + dt
	if duel_tower != null and (game.time >= duel_until or not game.towers.has(duel_tower)):
		duel_tower = null
		_changed()
	finish_structures()


func can_target(_t: Tower, e: TdEnemy) -> bool:
	if bool(e.vars.get("untargetable", false)):
		counts["hidden"] = int(counts["hidden"]) + 1
		return false
	return true


## Sigrun's Holmgang: tower `t` is her duel post until game s `until` (drawn).
func set_duel(t: Tower, until: float) -> void:
	duel_tower = t
	duel_until = until
	_changed()


## The autotest bot's tap policy (TdAutotest calls it each tick): relights a
## doused brazier when it has RULE bot_reserve souls to spare.
func autotest_tap() -> void:
	if level == 0 or game.economy.souls < int(r()["bot_reserve"]):
		return
	for i in braziers.size():
		if not bool(braziers[i]["lit"]):
			relight(i)
			return


## Braziers lit now.
func lit_count() -> int:
	var n := 0  # Lit so far.
	for b: Dictionary in braziers:
		n += 1 if bool(b["lit"]) else 0
	return n


## Redraws the look after a change (drawing only).
func _changed() -> void:
	if layer != null:
		layer.queue_redraw()
	if meter != null:
		meter.queue_redraw()


func summary() -> String:
	return "cold:%d braziers:%d/%d doused:%d rekindled:%d relit:%d chilled_tower_s:%d hidden:%d stones:%d" % [level, lit_count(), braziers.size(),
		int(counts["doused"]), int(counts["rekindled"]), int(counts["relit"]), int(counts["chilled_s"]), int(counts["hidden"]), int(counts["stones"])]
