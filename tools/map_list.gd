## map_list: prints every registered, non-hidden map with its weak build order,
## one "MAP <id> <weak_order>" line each in campaign order (Acts.map_order()),
## then validates each map (MapLoader.validate()). The ONE map list for CI's
## matrix and tools/run_all_maps.sh.
## Run: godot --headless tools/map_list.tscn   (exit 0, or 1 when a map fails validation)
extends Node


func _ready() -> void:
	var ok := true  # Every map valid.
	for id: String in Acts.map_order():
		if bool(Acts.row(Acts.act_of_map(id)).get("hidden", false)):
			continue
		var m := MapRegistry.get_map(id)  # Its MAP with act defaults.
		ok = MapLoader.validate(m, MapLoader.build_roads(m)) and ok
		print("MAP %s %s" % [id, String(m.get("weak_order", ""))])
	get_tree().quit(0 if ok else 1)
