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
## Leak curve (balance report, W-rows): lives at the last tick (-1 before the first).
var _lives_seen: int = -1
## Wave number (1-based) of the first life lost (0 = none yet).
var _first_leak_wave: int = 0
## Game times (s) of every permanent blocker body's fall (body_fallen, not Risen).
var _deaths: Array[float] = []
## Game times (s) of every life lost, one entry per life.
var _life_losses: Array[float] = []
## Seconds after a body falls in which lost lives are charged to that fall.
const DEATH_WINDOW: float = 15.0  # TUNING (not in GDD) report only


func _ready() -> void:
	Meta.load_save()  # A fresh save unless --meta-save (never touches user:// otherwise).
	if GameState.autotest_meta == "max":
		MetaModifiers.set_max()
	elif GameState.autotest_meta == "none":
		MetaModifiers.bonuses.clear()
		MetaModifiers.masteries.clear()
	CharacterModifiers.current = GameState.character if CharacterData.CHARACTERS.has(GameState.character) else CharacterData.DEFAULT_ID
	var spells: Array[String] = SpellData.DEFAULT_LOADOUT.duplicate()  # Three spells, then the meta slot.
	for id: String in SpellData.SPELLS:
		if spells.size() < MetaModifiers.spell_slots() and not spells.has(id):
			spells.append(id)
	SpellCaster.ultimate_id = GameState.autotest_ultimate if SpellData.ULTIMATES.has(GameState.autotest_ultimate) else String(SpellData.ULTIMATE["id"])
	game = TdGame.new()
	var map_default := String(MapRegistry.get_map(GameState.map_id if MapRegistry.has(GameState.map_id) else MapRegistry.DEFAULT_ID)["build_order"])  # The map's own order.
	_order_id = GameState.autotest_build if GameState.autotest_build != "" else map_default
	if not Acts.orders().has(_order_id):
		push_error("TdAutotest: unknown build order '%s'" % _order_id)
		_order_id = map_default
	order = Acts.orders()[_order_id]
	if order.has("ultimate") and GameState.autotest_ultimate == "":
		SpellCaster.ultimate_id = String(order["ultimate"])
	if order.has("steps_by_map"):  # One order for every map (gw2-kit kit orders): this map's steps.
		order = order.duplicate()
		order["steps"] = order["steps_by_map"].get(GameState.map_id if MapRegistry.has(GameState.map_id) else MapRegistry.DEFAULT_ID, [])
	if order.has("loadout"):
		spells.assign(order["loadout"])  # The order's own spells (test orders).
		for id: String in SpellData.SPELLS:
			if spells.size() < MetaModifiers.spell_slots() and not spells.has(id):
				spells.append(id)
	game.setup(GameState.map_id, GameState.difficulty, GameState.run_seed, CharacterModifiers.loadout(spells))
	if GameState.meta_save:
		var watch := RunWatch.new()  # Codex and masteries into the real save.
		watch.game = game
		game.add_child(watch)
	if GameState.autotest_swap.contains(":"):
		_swap(GameState.autotest_swap.get_slice(":", 0), GameState.autotest_swap.get_slice(":", 1))
	if order.has("bonus_souls"):
		game.economy.earn(int(order["bonus_souls"]), "test_bonus")
	game.speed = GameState.autotest_speed
	game.ticked.connect(_on_tick)
	game.ended.connect(_on_ended)
	game.body_fallen.connect(func(b: BlockBody, _by: TdEnemy) -> void:
		if not b.temporary:
			_deaths.append(game.time))
	add_child(game)
	_on_tick()
	game.call_wave()


## --swap: the order's first "build" of class `from` builds `to` instead (a copy; the data is untouched).
func _swap(from: String, to: String) -> void:
	if not TowerData.TOWERS.has(to):
		push_error("TdAutotest: unknown tower '%s'" % to)
		return
	order = order.duplicate()
	var st: Array = (order["steps"] as Array).duplicate(true)
	for s: Dictionary in st:
		if String(s["do"]) == "build" and String(s.get("tower", "")) == from:
			s["tower"] = to
			break
	order["steps"] = st
	_order_id += "/swap:" + to


## Every fixed step: build what the order allows, cast spells, watch the clock.
## Leak curve: records lives lost since the last look (each tick and at the end).
func _track_lives() -> void:
	if _lives_seen >= 0 and game.lives < _lives_seen:
		for i in _lives_seen - game.lives:
			_life_losses.append(game.time)
		if _first_leak_wave == 0:
			_first_leak_wave = game.waves.current + 1
	_lives_seen = game.lives


func _on_tick() -> void:
	_track_lives()
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
	return _reachable(EvolutionData.EVOLUTIONS[String(t.row["evolution"])]["recipe"])


## True for a record recipe the bot can wait for ("any": one of its parts is).
func _reachable(rec: Dictionary) -> bool:
	if String(rec["type"]) == "any":
		return (rec["of"] as Array).any(func(r: Dictionary) -> bool: return _reachable(r))
	return String(rec["type"]) in ["kills", "healed", "damage", "elite_kills"]


## Spell policy: Shadow Bolt the enemy nearest the gate; Bone Wall in front of
## the leading enemy once it is within THREAT_DIST of the gate; the ultimate
## as soon as it is full while any enemy is on the road.
func _cast_spells() -> void:
	var lead: TdEnemy = null  # Enemy closest to the gate.
	for e: TdEnemy in game.enemies:
		if bool(e.row.get("structure", false)):
			continue
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
			"corpse_explosion", "plague_cloud", "death_mark", "soul_chains", "heros_fist":
				game.cast_spell(i, lead.position)
			"wither":
				var sp: Spot = null  # The spot nearest the leader (Wither stands on a spot).
				for o: Spot in game.spots:
					if sp == null or o.position.distance_squared_to(lead.position) < sp.position.distance_squared_to(lead.position):
						sp = o
				if sp != null and sp.position.distance_to(lead.position) < float(SpellData.SPELLS["wither"]["radius"]):
					game.cast_spell(i, sp.position)
			"raise_dead":
				if -game.progress(lead) < THREAT_DIST and lead.holder == null:
					game.cast_spell(i, lead.follower.road.point_at(lead.follower.dist + 40.0))
			"hearse_run", "bone_mines":  # Act IV (w2b-city): just ahead of the leader, so it drives / walks into them
	if game.caster.ultimate_ready():
		game.caster.cast_ultimate()


func _on_ended(_won: bool) -> void:
	if GameState.autotest_reckoning and game.won and not game.reckoning:
		game.start_reckoning()
		return
	if GameState.meta_save:
		Meta.record_run(game)
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
	var evo: Array[String] = []  # Evolved towers (evolution ids).
	var syn := {}  # Active synergy id -> towers in it.
	var healed := 0.0  # HP restored by Menders.
	for t: Tower in game.towers:
		if t.evolution != "":
			evo.append(t.evolution)
		for pair: Array in t.synergies:
			syn[pair[0]] = int(syn.get(pair[0], 0)) + 1
		healed += float(t.vars.get("healed", 0.0))
	evo.sort()
	lines.append("evolutions=%d %s synergies=%s" % [evo.size(), ",".join(evo), _sorted(syn)])
	var sd := {}  # Damage by spell (loadout and ultimate).
	for id: String in game.caster.loadout + [game.caster.ultimate.id if game.caster.ultimate != null else String(SpellData.ULTIMATE["id"])]:
		sd[id] = "%dc/%dd" % [int(game.caster.casts.get(id, 0)), roundi(float(game.stats["damage"].get(id, 0.0)))]
	lines.append("spell_casts/damage=%s" % _sorted(sd))
	lines.append("blockers_lost=%d respawned=%d healed=%d risen=%d deep_freezes=%d shatters=%d shrapnel=%d corpses_detonated=%d" % [
		int(game.stats["bodies_lost"]), int(game.stats.get("bodies_respawned", 0)), roundi(healed), int(game.stats.get("risen", 0)),
		int(game.stats.get("deep_freezes", 0)), int(game.stats.get("shatters", 0)), int(game.stats.get("shrapnel", 0)),
		int(game.stats.get("corpses_detonated", 0))])
	lines.append("reckoning=%s reckoning_wave=%d suppressed_tower_s=%.1f" % [str(game.reckoning), game.reckoning_wave, float(game.stats.get("suppressed_s", 0.0))])
	var ev := {}  # Rounded trait / boss event counters.
	for k: String in game.stats.get("events", {}):
		ev[k] = roundi(float(game.stats["events"][k]))
	lines.append("events=%s" % _sorted(ev))
	if game.rule != null:
		lines.append("rule=%s %s" % [String(game.map["rule"]), game.rule.summary()])
	if game.act_rule != null:
		lines.append("act_rule=%s %s" % [String(game.map["act_rule"]), game.act_rule.summary()])
	var hc: Dictionary = game.hostile.counts  # Hostile fire counts (act framework; printed only when used).
	if int(hc["fired"]) > 0 or int(hc["shells"]) > 0 or float(game.stats.get("disabled_s", 0.0)) > 0.0:
		lines.append("hostile=%s disabled_tower_s=%.1f" % [_sorted(hc), float(game.stats.get("disabled_s", 0.0))])
	lines.append("meta=%s character=%s loadout=%s ash=%d bonuses=%s masteries=%d saved=%s" % [GameState.autotest_meta if GameState.autotest_meta != "" else "save" if GameState.meta_save else "none",
		CharacterModifiers.current, ",".join(game.caster.loadout), Meta.ash_for(game), _sorted(MetaModifiers.bonuses), MetaModifiers.masteries.size(), str(GameState.meta_save)])
	if _kit_run():
		_kit_summary(lines)
	_track_lives()
	var charged := 0  # Lives lost within DEATH_WINDOW s after some body fell.
	for t: float in _life_losses:
		for d: float in _deaths:
			if t >= d and t - d <= DEATH_WINDOW:
				charged += 1
				break
	lines.append("leak_curve=first_leak_wave:%d end_wave:%d lives_lost:%d body_deaths:%d lives_after_deaths:%d per_death:%.2f" % [
		_first_leak_wave, game.waves.current + 1, _life_losses.size(), _deaths.size(), charged, float(charged) / maxf(1.0, float(_deaths.size()))])
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


## True when the run uses any gw2-kit content (later towers, spells, ultimates or
## characters): only then are the kit lines printed, so Act I summaries stay byte-identical.
func _kit_run() -> bool:
	for t: Tower in game.towers:
		if TowerData.TOWERS[t.tower_id].has("unlock"):
			return true
	for id: String in game.caster.loadout:
		if SpellData.SPELLS[id].has("unlock"):
			return true
	return GameState.autotest_swap != "" or SpellCaster.ultimate_id != String(SpellData.ULTIMATE["id"]) or CharacterData.ORDER.find(CharacterModifiers.current) >= 4


## The kit summary lines: every class's souls spent per damage (tower strength
## comparison), the later systems' counters and the ultimate.
func _kit_summary(lines: Array[String]) -> void:
	var val := {}  # Class -> [souls spent, damage, kills, towers].
	for t: Tower in game.towers:
		var v: Array = val.get(t.tower_id, [0, 0.0, 0, 0])
		val[t.tower_id] = [int(v[0]) + t.spent, float(v[1]) + t.damage_done, int(v[2]) + t.kills, int(v[3]) + 1]
	var tv := {}  # Class -> "n x spent / damage = damage per soul".
	for id: String in val:
		var v: Array = val[id]
		tv[id] = "%dx%ds/%dd/%dk=%.1f/soul" % [int(v[3]), int(v[0]), roundi(float(v[1])), int(v[2]), float(v[1]) / maxf(float(v[0]), 1.0)]
	lines.append("tower_value=%s" % _sorted(tv))
	var c := {}  # Kit counters.
	for t: Tower in game.towers:
		for k: String in ["warded", "dashes", "swoops", "bites", "ruins", "slams", "fed", "spilled"]:
			if t.vars.has(k):
				c[k] = roundi(float(c.get(k, 0)) + float(t.vars[k]))
	for k: String in ["barrier_absorbed", "rogue_resets", "brand_risen", "chained", "withered", "eclipsed", "risen", "moonfang_bites", "hex_healed", "swarm_bites"]:
		if game.stats.has(k):
			c[k] = roundi(float(game.stats[k]))
	lines.append("kit=%s ultimate=%s" % [_sorted(c), game.caster.ultimate.id if game.caster.ultimate != null else "-"])
