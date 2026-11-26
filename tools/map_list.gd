## map_list: prints every registered, non-hidden map with its weak build order,
## one "MAP <id> <weak_order>" line each in campaign order (Acts.map_order()),
## then validates each map (MapLoader.validate()) and prints its "INCOME" line
## (MapLoader.income(): the souls it can pay with no leaks). The ONE map list for CI's
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
		var inc := MapLoader.income(m)  # Its souls with no leaks.
		print("INCOME %s start=%d kills=%d no_leak=%d total=%d" % [id, inc["start"], inc["kills"], inc["no_leak"], inc["total"]])
		if Acts.act_of_map(id) != Acts.act_of_map("sanctum") and (int(inc["total"]) < EconomyData.INCOME_MIN or int(inc["total"]) > EconomyData.INCOME_MAX):
			push_error("Map %s: income %d outside %d-%d (EconomyData.INCOME_*)" % [id, inc["total"], EconomyData.INCOME_MIN, EconomyData.INCOME_MAX])
			ok = false
	get_tree().quit(0 if ok else 1)
