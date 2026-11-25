## TdAutotest: the headless bot (GDD §10.2). Started by Main under --autotest:
## it builds a TdGame for --map / --difficulty / --seed, runs `--speed` fixed
## steps per physics frame, plays the build order (BuildOrderData; --build, else
## the map's), calls wave 1 at once and lets the rest come by themselves, casts
## spells by a fixed policy, then prints a summary and quits (exit 0 when the
## run completed, 1 on a timeout). Never touches user://. Same seed and
## options -> the same summary, line for line.
class_name TdAutotest
extends Node

## Game seconds after which the run is abandoned (exit 1).
const TIMEOUT: float = 1800.0  # TUNING (not in GDD) about 3x a full map
## Px from the gate within which the bot treats an enemy as a leak threat (spells).
const THREAT_DIST: float = 600.0  # TUNING (not in GDD) bot policy

## The run.
var game: TdGame = null
## The build order played.
var order: Dictionary = {}
## Index of the next build step.
var _step: int = 0
## Build order id played.
var _order_id: String = ""


func _ready() -> void:
	game = TdGame.new()
	game.setup(GameState.map_id, GameState.difficulty, GameState.run_seed)
	_order_id = GameState.autotest_build if GameState.autotest_build != "" else String(game.map["build_order"])
	if not BuildOrderData.ORDERS.has(_order_id):
		push_error("TdAutotest: unknown build order '%s'" % _order_id)
		_order_id = String(game.map["build_order"])
	order = BuildOrderData.ORDERS[_order_id]
	game.speed = GameState.autotest_speed
	game.ticked.connect(_on_tick)
	game.ended.connect(_on_ended)
	add_child(game)
	_on_tick()
	game.call_wave()


## Every fixed step: build what the order allows, cast spells, watch the clock.
func _on_tick() -> void:
	if game.over:
		return
	while _step < (order["steps"] as Array).size() and _try(order["steps"][_step]):
		_step += 1
	if bool(order["spells"]):
		_cast_spells()
	if game.time > TIMEOUT:
		print("TDAUTOTEST TIMEOUT at %.1f s" % game.time)
		_summary("timeout")
		get_tree().quit(1)


## Tries build step `st`; true when done (or impossible, so it is skipped).
func _try(st: Dictionary) -> bool:
	if game.waves.current + 1 < int(st.get("wave", 0)):
		return false
	var s := game.spot_by_id(String(st["spot"]))  # Its spot.
	if s == null:
		push_error("TdAutotest: no spot %s" % st["spot"])
		return true
	match String(st["do"]):
		"build":
			if s.tower != null:
				return true
			return game.build(s, String(st["tower"]))
		"upgrade":
			if s.tower == null or s.tower.level >= 5:
				return true
			return game.upgrade(s)
		"evolve":
			if s.tower == null or s.tower.evolution != "":
				return true
			if not s.tower.can_evolve():
				return s.tower.level >= 5 and not _recipe_reachable(s.tower)
			return game.evolve(s)
		"target":
			game.set_target(s, String(st["mode"]))
			return true
		"sell":
			return game.sell(s)
	return true


## False for recipes the bot cannot wait for (a partner class it never builds).
func _recipe_reachable(t: Tower) -> bool:
	var rec: Dictionary = EvolutionData.EVOLUTIONS[String(t.row["evolution"])]["recipe"]  # The recipe.
	return String(rec["type"]) == "kills"


## Spell policy: Shadow Bolt the enemy nearest the gate; Bone Wall in front of
## the leading enemy once it is within THREAT_DIST of the gate; the ultimate
## as soon as it is full while any enemy is on the road.
func _cast_spells() -> void:
	var lead: TdEnemy = null  # Enemy closest to the gate.
	for e: TdEnemy in game.enemies:
		if lead == null or game.progress(e) > game.progress(lead):
			lead = e
	if lead == null:
		return
	for i in game.caster.loadout.size():
		if not game.caster.is_ready(i):
			continue
		match game.caster.loadout[i]:
			"shadow_bolt":
				game.cast_spell(i, lead.position)
			"bone_wall":
				if -game.progress(lead) < THREAT_DIST and lead.holder == null:
					game.cast_spell(i, lead.follower.road.point_at(lead.follower.dist + 30.0))
	if game.caster.ultimate_ready():
		game.caster.cast_ultimate()


func _on_ended(_won: bool) -> void:
	_summary("won" if game.won else "lost")
	get_tree().quit(0)


## Prints the run summary (sorted keys, fixed formats: diffable across runs).
func _summary(result: String) -> void:
	var lines: Array[String] = []  # Summary lines.
	lines.append("TDAUTOTEST SUMMARY")
	lines.append("map=%s difficulty=%s seed=%d build=%s speed=%d" % [game.map_id, game.difficulty, game.run_seed, _order_id, game.speed])
	lines.append("result=%s skulls=%d time=%.2fs ticks=%d" % [result, game.skulls(), game.time, game.ticks])
	lines.append("waves_cleared=%d/%d reached=%d lives=%d/%d" % [game.waves.cleared_count(), game.waves.total(), game.waves.current + 1, game.lives, game.start_lives])
	lines.append("souls_now=%d earned=%d spent=%d earned_by=%s" % [game.economy.souls, game.economy.total_earned(), game.economy.spent, _sorted(game.economy.earned)])
	lines.append("kills=%s" % _sorted(game.stats["kills"]))
	lines.append("leaks=%s" % _sorted(game.stats["leaks"]))
	var dmg := {}  # Rounded damage by source.
	for k: String in game.stats["damage"]:
		dmg[k] = roundi(float(game.stats["damage"][k]))
	lines.append("damage_by_source=%s" % _sorted(dmg))
	var tw: Array[String] = []  # One entry per tower.
	for t: Tower in game.towers:
		tw.append("%s:%s%s:lv%d:k%d:d%d" % [t.spot.spot_id(), t.tower_id, ("/" + t.evolution) if t.evolution != "" else "", t.level, t.kills, roundi(t.damage_done)])
	lines.append("towers=%s" % ",".join(tw))
	lines.append("build_steps_done=%d/%d chests=%d free_upgrades_left=%d" % [_step, (order["steps"] as Array).size(), int(game.stats["chests"]), game.free_upgrades])
	lines.append("blocker_damage_taken=%d bodies_lost=%d spells=%s" % [roundi(float(game.stats["body_damage"])), int(game.stats["bodies_lost"]), _sorted(game.caster.casts)])
	var wd: Array[String] = []  # Per wave: spawn span / time to clear.
	for i in game.waves.records.size():
		var r: Dictionary = game.waves.records[i]
		if float(r["start"]) < 0.0:
			break
		var spawn := float(r["last_spawn"]) - float(r["start"]) if float(r["last_spawn"]) >= 0.0 else -1.0  # Seconds spawning.
		var clear := float(r["cleared"]) - float(r["start"]) if float(r["cleared"]) >= 0.0 else -1.0  # Seconds to clear.
		wd.append("w%d:%.1f/%.1f%s" % [i + 1, spawn, clear, "L" if bool(r["leaked"]) else ""])
	lines.append("wave_spawn/clear_s=%s" % " ".join(wd))
	lines.append("stuck_enemies=%d alive_at_end=%d" % [int(game.stats["stuck"]), game.enemies.size()])
	for l: String in lines:
		print(l)


## "k:v,k:v" with sorted keys.
func _sorted(d: Dictionary) -> String:
	var keys := d.keys()  # Its keys.
	keys.sort()
	var parts: Array[String] = []  # k:v entries.
	for k: Variant in keys:
		parts.append("%s:%s" % [str(k), str(d[k])])
	return ",".join(parts)
