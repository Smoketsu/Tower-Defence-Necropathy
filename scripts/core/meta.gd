## Meta: the permanent progress file and every record kept between maps
## (GDD §8.2, §8.3): Soul Ash, Ossuary levels, Masteries, map clears, best
## skulls per map and difficulty, best Reckoning wave per map, the Codex
## (what a run has met) and the last pre-map choices. One ConfigFile at
## MetaData.SAVE_PATH, versioned, written through a temp file. Static state;
## load_save() also hands the Ossuary and Masteries to MetaModifiers (the one
## path into a run). Never reads or writes user:// under --autotest unless
## --meta-save (can_write()).
class_name Meta
extends RefCounted

## Codex categories (sections of `data["codex"]`), in Codex tab order.
const CODEX: Array[String] = ["towers", "spells", "enemies", "bosses", "evolutions"]

## The whole save, section -> key -> value (ConfigFile layout):
##   ash {ash: int Soul Ash held, earned: int lifetime}
##   ossuary {upgrade id: owned level 0..max}
##   masteries {class id: true}
##   maps {cleared: Array of map ids, skulls: {"map|difficulty": 1..3}, reckoning: {map: best wave}}
##   codex {category: Array of ids met}
##   prerun {map, difficulty, character, spells: Array, ultimate}
##   unlocks {towers / spells / ultimates: Array of ids opened (Unlocks.refresh(); save version 2)}
static var data: Dictionary = {}
## Last load result (OK, ERR_FILE_NOT_FOUND...; shown nowhere, kept for tests).
static var last_error: Error = OK
## Save version of the file last loaded (0 = none; kept for the migration check).
static var loaded_version: int = 0
## Names of what the last recorded run unlocked (towers, spells, ultimates; the results card lists them).
static var last_unlocks: Array[String] = []


## True when the save may be read and written (never under --autotest unless --meta-save).
static func can_write() -> bool:
	return not GameState.autotest or GameState.meta_save


## A fresh save.
static func _fresh() -> Dictionary:
	var codex := {}  # Empty Codex.
	for c: String in CODEX:
		codex[c] = []
	return {"ash": {"ash": 0, "earned": 0}, "ossuary": {}, "masteries": {},
		"maps": {"cleared": [], "skulls": {}, "reckoning": {}}, "codex": codex, "prerun": {},
		"unlocks": {"towers": [], "spells": [], "ultimates": []}}


## Loads the save (a fresh one when missing or unreadable) and applies it.
static func load_save() -> void:
	data = _fresh()
	if can_write():
		var cfg := ConfigFile.new()
		last_error = cfg.load(MetaData.SAVE_PATH)
		loaded_version = int(cfg.get_value("meta", "save_version", 0)) if last_error == OK else 0
		if last_error == OK and loaded_version >= 1:
			for sec: String in data:
				for key: String in (data[sec] as Dictionary).keys() + (Array(cfg.get_section_keys(sec)) if cfg.has_section(sec) else []):
					if cfg.has_section_key(sec, key):
						data[sec][key] = cfg.get_value(sec, key)
	migrate()
	apply()


## Brings a loaded save up to MetaData.SAVE_VERSION (version 1 -> 2: the
## `unlocks` section is filled from the map records already kept, so an
## existing player keeps everything their clears earned). Safe to run twice.
static func migrate() -> void:
	Unlocks.refresh()


## Writes the save (skipped when can_write() is false). Temp file + rename.
static func save() -> Error:
	if not can_write() or data.is_empty():
		return OK
	var cfg := ConfigFile.new()
	cfg.set_value("meta", "save_version", MetaData.SAVE_VERSION)
	for sec: String in data:
		for key: String in data[sec]:
			cfg.set_value(sec, key, data[sec][key])
	var tmp := MetaData.SAVE_PATH + ".tmp"  # Written first.
	var err := cfg.save(tmp)
	if err != OK:
		return err
	if DirAccess.rename_absolute(tmp, MetaData.SAVE_PATH) != OK:
		DirAccess.remove_absolute(tmp)
		return cfg.save(MetaData.SAVE_PATH)
	return OK


## Hands the owned Ossuary levels and Masteries to MetaModifiers.
static func apply() -> void:
	MetaModifiers.bonuses.clear()
	for id: String in data["ossuary"]:
		if MetaData.UPGRADES.has(id) and int(data["ossuary"][id]) > 0:
			MetaModifiers.bonuses[id] = float(MetaData.UPGRADES[id]["per"]) * float(data["ossuary"][id])
	MetaModifiers.masteries = (data["masteries"] as Dictionary).duplicate()


# ------------------------------------------------------------------ Soul Ash and the Ossuary

## Soul Ash held.
static func ash() -> int:
	return int(data["ash"]["ash"])


## Owned level of Ossuary upgrade `id` (0 = none).
static func level(id: String) -> int:
	return int(data["ossuary"].get(id, 0))


## Ash for the next level of `id` (-1 at max).
static func next_cost(id: String) -> int:
	var costs: Array = MetaData.UPGRADES[id]["costs"]
	return int(costs[level(id)]) if level(id) < costs.size() else -1


## Buys the next level of `id`; true when bought.
static func buy(id: String) -> bool:
	var c := next_cost(id)  # Its price.
	if c < 0 or ash() < c:
		return false
	data["ash"]["ash"] = ash() - c
	data["ossuary"][id] = level(id) + 1
	apply()
	save()
	return true


## Returns every spent Ash and clears the Ossuary (Refund all).
static func refund_all() -> void:
	var back := 0  # Ash returned.
	for id: String in data["ossuary"]:
		var costs: Array = MetaData.UPGRADES.get(id, {"costs": []})["costs"]
		for i in mini(int(data["ossuary"][id]), costs.size()):
			back += int(costs[i])
	data["ash"]["ash"] = ash() + back
	data["ossuary"] = {}
	apply()
	save()


# ------------------------------------------------------------------ maps and records

## Position (0-based) of map `id` in MapRegistry order.
static func map_index(id: String) -> int:
	return MapRegistry.MAPS.keys().find(id)


## True when map `id` is open: the first map, or the map named by its
## "unlock_after" key (default: the previous map) has had its boss beaten.
static func map_open(id: String) -> bool:
	var i := map_index(id)  # Its position.
	if i <= 0:
		return true
	var after := String(MapRegistry.get_map(id).get("unlock_after", MapRegistry.MAPS.keys()[i - 1]))  # Map to clear first.
	return not MapRegistry.MAPS.has(after) or (data["maps"]["cleared"] as Array).has(after)


## True when map `id` has been cleared (its boss beaten) on any difficulty.
static func cleared(id: String) -> bool:
	return (data["maps"]["cleared"] as Array).has(id)


## Best skulls (0..3) on map `id` at difficulty `diff`.
static func skulls(id: String, diff: String) -> int:
	return int(data["maps"]["skulls"].get(id + "|" + diff, 0))


## Best Reckoning wave on map `id` (0 = none).
static func best_reckoning(id: String) -> int:
	return int(data["maps"]["reckoning"].get(id, 0))


## True when character `id` is open (its unlock map cleared, or a map that does not exist yet).
static func character_open(id: String) -> bool:
	var after := String(CharacterData.CHARACTERS[id]["unlock_after"])  # Map whose boss opens it.
	return after == "" or not MapRegistry.MAPS.has(after) or cleared(after)


## Reckoning waves the run reached (0 when the run has no Reckoning; read
## defensively: the maps agent's TdGame may expose `reckoning_wave`).
static func reckoning_of(game: TdGame) -> int:
	var v: Variant = game.get("reckoning_wave")
	return int(v) if v is int or v is float else 0


## Soul Ash a finished run pays (pure; the autotest prints it).
static func ash_for(game: TdGame) -> int:
	var mult := float(DifficultyModifiers.row(game.difficulty)["ash_mult"]) * (1.0 + MetaData.MAP_STEP * float(maxi(map_index(game.map_id), 0)))  # Difficulty x map position.
	var base := MetaData.ASH_PER_WAVE * game.waves.cleared_count()  # A defeat: by waves cleared.
	if game.won or cleared_now(game):
		base = MetaData.CLEAR_BASE + MetaData.ASH_PER_SKULL * maxi(game.skulls(), 1)
	base += MetaData.ASH_PER_RECKONING_WAVE * reckoning_of(game)
	return roundi(float(base) * mult)


## True when the run beat the map (its last wave cleared), even if a
## Reckoning after it later ended in defeat.
static func cleared_now(game: TdGame) -> bool:
	return game.won or game.waves.cleared_count() >= game.waves.total()


## Records a finished run: Soul Ash, clear, skulls, Reckoning wave; saves.
## Returns the Ash paid. Call once per run.
static func record_run(game: TdGame) -> int:
	var paid := ash_for(game)  # Ash earned.
	data["ash"]["ash"] = ash() + paid
	data["ash"]["earned"] = int(data["ash"]["earned"]) + paid
	if cleared_now(game):
		var c: Array = data["maps"]["cleared"]
		if not c.has(game.map_id):
			c.append(game.map_id)
		var key := game.map_id + "|" + game.difficulty  # Skull record key.
		data["maps"]["skulls"][key] = maxi(skulls(game.map_id, game.difficulty), maxi(game.skulls(), 1))
	data["maps"]["reckoning"][game.map_id] = maxi(best_reckoning(game.map_id), reckoning_of(game))
	last_unlocks = Unlocks.refresh()  # Later towers, spells and ultimates this clear opened (gw2-kit).
	apply()  # Masteries opened this run count from the next one.
	save()
	return paid


## Records a Reckoning ending after the clear was already recorded (the
## clear paid with no Reckoning waves): the best wave and the Reckoning's Ash.
## Returns the Ash paid.
static func record_reckoning(game: TdGame) -> int:
	var mult := float(DifficultyModifiers.row(game.difficulty)["ash_mult"]) * (1.0 + MetaData.MAP_STEP * float(maxi(map_index(game.map_id), 0)))  # As in ash_for().
	var paid := roundi(float(MetaData.ASH_PER_RECKONING_WAVE * reckoning_of(game)) * mult)  # Ash for the Reckoning waves.
	data["ash"]["ash"] = ash() + paid
	data["ash"]["earned"] = int(data["ash"]["earned"]) + paid
	data["maps"]["reckoning"][game.map_id] = maxi(best_reckoning(game.map_id), reckoning_of(game))
	save()
	return paid


# ------------------------------------------------------------------ Codex and Masteries

## True when Codex entry `id` of `category` has been met.
static func seen(category: String, id: String) -> bool:
	return (data["codex"].get(category, []) as Array).has(id)


## Marks Codex entry `id` of `category` met (saved with the run's record);
## true when it is new.
static func see(category: String, id: String) -> bool:
	if not data["codex"].has(category):
		data["codex"][category] = []
	var a: Array = data["codex"][category]
	if a.has(id):
		return false
	a.append(id)
	return true


## Opens the Mastery of class `id`; true when it is new.
static func open_mastery(id: String) -> bool:
	if data["masteries"].has(id):
		return false
	data["masteries"][id] = true
	return true


# ------------------------------------------------------------------ pre-map choices

## Remembered pre-map value `key` (`fallback` when none).
static func prerun(key: String, fallback: Variant) -> Variant:
	return data["prerun"].get(key, fallback)


## Remembers pre-map value `key` (saved with the next save()).
static func set_prerun(key: String, value: Variant) -> void:
	data["prerun"][key] = value
