## Unlocks: the one place that decides whether a later tower, spell or
## ultimate is open (DECISIONS K1). A row opts in with an `unlock` key (a
## spec; absent or {} = open from the start):
##   {"map": id}               — that map's boss has been beaten (any difficulty);
##   {"map": id, "skulls": n}  — that map cleared with at least n skulls on some difficulty.
## TowerData, SpellData.SPELLS and SpellData.ULTIMATES rows use it (characters
## keep their CharacterData "unlock_after"). Opened ids are also recorded in the
## save (Meta `unlocks` section, refresh()) so an unlock is never taken back.
## The autotest sees everything open (UI only: game.build() never asks).
## Only the menus (spot menu, map hints, pre-map pick, Codex) ask; a run never does.
class_name Unlocks
extends RefCounted

## Save categories, each -> its rows' table: "towers" TowerData.TOWERS,
## "spells" SpellData.SPELLS, "ultimates" SpellData.ULTIMATES.
const CATEGORIES: Array[String] = ["towers", "spells", "ultimates"]


## The rows of category `cat` (id -> row).
static func _table(cat: String) -> Dictionary:
	match cat:
		"towers": return TowerData.TOWERS
		"spells": return SpellData.SPELLS
		"ultimates": return SpellData.ULTIMATES
	return {}


## True when spec `spec` is met by the save's records now.
static func met(spec: Dictionary) -> bool:
	if spec.is_empty():
		return true
	var map := String(spec.get("map", ""))  # Map whose clear opens it.
	if map != "" and not MapRegistry.MAPS.has(map):
		return true  # A map not built yet never locks anything.
	var need := int(spec.get("skulls", 0))  # Skulls asked (0 = a clear).
	if need <= 0:
		return Meta.cleared(map)
	for d: String in DifficultyData.ORDER:
		if Meta.skulls(map, d) >= need:
			return true
	return false


## True when id `id` of category `cat` is open (rule met or recorded; always under the autotest).
static func is_open(cat: String, id: String) -> bool:
	if GameState.autotest or GameState.unlock_all:
		return true
	var row: Dictionary = _table(cat).get(id, {})
	return met(row.get("unlock", {})) or (Meta.data.get("unlocks", {}).get(cat, []) as Array).has(id)


## Shorthands for the menus.
static func tower_open(id: String) -> bool:
	return is_open("towers", id)


## See tower_open().
static func spell_open(id: String) -> bool:
	return is_open("spells", id)


## See tower_open().
static func ultimate_open(id: String) -> bool:
	return is_open("ultimates", id)


## The player-facing line for spec `spec` ("" when open from the start).
static func line(spec: Dictionary) -> String:
	if spec.is_empty() or not MapRegistry.MAPS.has(String(spec.get("map", ""))):
		return ""
	var name := String(MapRegistry.get_map(String(spec["map"]))["name"])  # Map name.
	if int(spec.get("skulls", 0)) > 0:
		return "%d skulls on %s" % [int(spec["skulls"]), name]
	return "Beat the boss of %s" % name


## Records every newly met unlock in the save's `unlocks` section (the save
## migration and Meta.record_run() call it); returns the names newly opened.
static func refresh() -> Array[String]:
	var out: Array[String] = []  # Names opened now.
	if not Meta.data.has("unlocks"):
		Meta.data["unlocks"] = {}
	for cat: String in CATEGORIES:
		if not Meta.data["unlocks"].has(cat):
			Meta.data["unlocks"][cat] = []
		var rec: Array = Meta.data["unlocks"][cat]
		var table := _table(cat)  # Its rows.
		for id: String in table:
			var spec: Dictionary = table[id].get("unlock", {})
			if not spec.is_empty() and not rec.has(id) and met(spec):
				rec.append(id)
				out.append(String(table[id]["name"]))
	return out
