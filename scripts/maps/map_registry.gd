## MapRegistry: the lookup of playable maps. A map is one data script with a
## `const MAP: Dictionary` (keys documented in graveyard_map.gd). Act I's maps
## are preloaded in MAPS; every later map is found by convention at
## scripts/maps/<id>_map.gd once its act (ActData) lists the id, so adding a
## map needs no edit here. get_map() fills the keys a map leaves out from its
## act's defaults (ActData: floor, mood, music, act rule) and adds "act".
## Lookup only; the campaign order lives in ActData (Acts.map_order()).
class_name MapRegistry
extends RefCounted

## Map played when none is chosen (and by the autotest by default).
const DEFAULT_ID: String = "graveyard"
## Path of a map's data script found by convention ("%s" = map id).
const PATH: String = "res://scripts/maps/%s_map.gd"
## Act I: map id -> its data script (each defines const MAP).
const MAPS: Dictionary = {
	"graveyard": preload("res://scripts/maps/graveyard_map.gd"),
	"crimson_march": preload("res://scripts/maps/crimson_march_map.gd"),
	"sanctum": preload("res://scripts/maps/sanctum_map.gd"),
}

## has() cache: map id -> true when its data script exists.
static var _exists: Dictionary = {}
## get_map() cache: map id -> MAP with its act defaults filled in.
static var _maps: Dictionary = {}


## True when map `id` is registered (Act I, or an act lists it and its file exists).
static func has(id: String) -> bool:
	if MAPS.has(id):
		return true
	if not _exists.has(id):
		_exists[id] = id != "" and Acts.act_of_map(id) != "" and ResourceLoader.exists(PATH % id)
	return _exists[id]


## The MAP dictionary of map `id` with its act's defaults (the default map's when `id` is unknown).
static func get_map(id: String) -> Dictionary:
	if not has(id):
		id = DEFAULT_ID
	if not _maps.has(id):
		var script: GDScript = MAPS[id] if MAPS.has(id) else load(PATH % id)  # The map's data script.
		var m: Dictionary = (script.get_script_constant_map()["MAP"] as Dictionary).duplicate()  # Its MAP.
		var act := Acts.row(Acts.act_of_map(id))  # Its act row ({} = none).
		m["act"] = String(act.get("id", ""))
		for pair: Array in [["floor", "floor"], ["mood", "mood"], ["music", "music"], ["act_rule", "rule"]]:
			if not m.has(pair[0]):
				m[pair[0]] = act.get(pair[1], "")
		if not m.has("road"):  # Road style (TdRoadData): the one reader.
			m["road"] = TdRoadData.style_for(id, String(act.get("road", "")))
		_maps[id] = m
	return _maps[id]
