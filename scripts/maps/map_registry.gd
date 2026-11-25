## MapRegistry: the one list of playable maps. A map is one data script under
## scripts/maps/ with a `const MAP: Dictionary` (keys documented in
## graveyard_map.gd); add a map by writing that file and one MAPS row here.
## Data only, no logic beyond the lookup.
class_name MapRegistry
extends RefCounted

## Map played when none is chosen (and by the autotest by default).
const DEFAULT_ID: String = "graveyard"
## Map id -> its data script (each defines const MAP). Order = map-select order.
const MAPS: Dictionary = {
	"graveyard": preload("res://scripts/maps/graveyard_map.gd"),
	"crimson_march": preload("res://scripts/maps/crimson_march_map.gd"),
	"sanctum": preload("res://scripts/maps/sanctum_map.gd"),
}


## The MAP dictionary of map `id` (the default map's when `id` is unknown).
static func get_map(id: String) -> Dictionary:
	var script: GDScript = MAPS.get(id, MAPS[DEFAULT_ID])  # The map's data script.
	return script.get_script_constant_map()["MAP"]
