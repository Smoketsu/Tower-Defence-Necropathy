## Acts: lookups over ActData (the one ordered act list) and the per-act data
## files: the campaign map order, a map's act and position in it, the unlock
## chain, and the merged content tables every act adds to without editing a
## shared file — enemy kinds (kinds()), build orders (orders()) and battlefield
## moods (moods()). Act I's tables are TdEnemyData.KINDS, BuildOrderData.ORDERS
## and TdMoodData.MOODS; every other act's come from its data file (ActData
## "data" / DATA_PATH, optional consts KINDS, ORDERS, MOODS). Static and cached;
## no gameplay state.
class_name Acts
extends RefCounted

## Merged tables, built on first use: table name -> {id: row}.
static var _tables: Dictionary = {}
## Enemy kind id -> act id that defines it (built with kinds()).
static var _kind_act: Dictionary = {}
## Act id -> its data file's constant map ({} = no data file).
static var _data: Dictionary = {}


## The ActData row of act `id` ({} when unknown).
static func row(id: String) -> Dictionary:
	for r: Dictionary in ActData.ACTS:
		if String(r["id"]) == id:
			return r
	return {}


## True when act row `r` is shown (hidden acts only with --test-act).
static func shown(r: Dictionary) -> bool:
	return not bool(r.get("hidden", false)) or GameState.test_act


## The act rows shown to the player, in order.
static func visible_acts() -> Array[Dictionary]:
	var out: Array[Dictionary] = []  # Shown rows.
	for r: Dictionary in ActData.ACTS:
		if shown(r):
			out.append(r)
	return out


## Act number label of act `id` ("I".."XV"; "T" for a hidden act).
static func numeral(id: String) -> String:
	var n := 0  # Position among the non-hidden acts.
	for r: Dictionary in ActData.ACTS:
		if bool(r.get("hidden", false)):
			if String(r["id"]) == id:
				return "T"
			continue
		if String(r["id"]) == id:
			return ActData.NUMERALS[n] if n < ActData.NUMERALS.size() else str(n + 1)
		n += 1
	return "?"


## Act id of map `map_id` ("" when no act lists it).
static func act_of_map(map_id: String) -> String:
	for r: Dictionary in ActData.ACTS:
		if (r["maps"] as Array).has(map_id):
			return String(r["id"])
	return ""


## The registered maps of act `id` in play order (maps without a file are left out).
static func maps_of(id: String) -> Array[String]:
	var out: Array[String] = []  # Registered map ids.
	for m: String in row(id).get("maps", []):
		if MapRegistry.has(m):
			out.append(m)
	return out


## Every registered map in campaign order (hidden acts last), then any
## registered map no act lists (MapRegistry.MAPS order).
static func map_order() -> Array[String]:
	var out: Array[String] = []  # Ordered ids.
	for hidden: bool in [false, true]:
		for r: Dictionary in ActData.ACTS:
			if bool(r.get("hidden", false)) == hidden:
				out.append_array(maps_of(String(r["id"])))
	for m: String in MapRegistry.MAPS:
		if not out.has(m):
			out.append(m)
	return out


## Position (0-based) of map `map_id` among its act's maps in ActData (0 when unknown):
## the Soul Ash step (MetaData.MAP_STEP per position, Necropathy's per-act rule).
static func position_in_act(map_id: String) -> int:
	var a := act_of_map(map_id)  # Its act.
	return maxi((row(a)["maps"] as Array).find(map_id), 0) if a != "" else 0


## The map whose boss opens map `map_id`: the previous registered map in the
## campaign order ("" for the first map and for maps of a hidden act, open from the start).
static func prev_map(map_id: String) -> String:
	if bool(row(act_of_map(map_id)).get("hidden", false)):
		return ""
	var order := map_order()  # Campaign order.
	var i := order.find(map_id)  # Its position.
	return order[i - 1] if i > 0 else ""


## The next registered map after `map_id` in the campaign order ("" = none), never into a hidden act.
static func next_map(map_id: String) -> String:
	var order := map_order()  # Campaign order.
	var i := order.find(map_id)  # Its position.
	if i < 0 or i + 1 >= order.size() or bool(row(act_of_map(order[i + 1])).get("hidden", false)):
		return ""
	return order[i + 1]


## The constant map of act `id`'s data file ({} when it has none).
static func data(id: String) -> Dictionary:
	if not _data.has(id):
		var path := String(row(id).get("data", ActData.DATA_PATH % id))  # Its data file.
		_data[id] = (load(path) as GDScript).get_script_constant_map() if id != "" and ResourceLoader.exists(path) else {}
	return _data[id]


## Table `name` (KINDS / ORDERS / MOODS) of every act merged over Act I's `base`
## rows; a duplicate id is an error (the first one wins). Cached.
static func _merged(name: String, base: Dictionary) -> Dictionary:
	if _tables.has(name):
		return _tables[name]
	var out := base.duplicate()  # Act I rows first.
	for r: Dictionary in ActData.ACTS:
		var id := String(r["id"])  # The act.
		var t: Dictionary = data(id).get(name, {})  # Its rows.
		for k: String in t:
			if out.has(k):
				push_error("Acts: %s id '%s' of act %s is already defined" % [name, k, id])
				continue
			out[k] = t[k]
			if name == "KINDS":
				_kind_act[k] = id
	_tables[name] = out
	return out


## Every enemy kind row, id -> row (TdEnemyData.KINDS + each act's KINDS):
## THE lookup for enemy rows (never read TdEnemyData.KINDS directly).
static func kinds() -> Dictionary:
	return _merged("KINDS", TdEnemyData.KINDS)


## Act id that defines enemy kind `kind` (Act I: "covenant").
static func act_of_kind(kind: String) -> String:
	kinds()
	return String(_kind_act.get(kind, ActData.ACTS[0]["id"]))


## Every build order, id -> order (BuildOrderData.ORDERS + each act's ORDERS).
static func orders() -> Dictionary:
	return _merged("ORDERS", BuildOrderData.ORDERS)


## Every mood row, id -> row (TdMoodData.MOODS + each act's MOODS).
static func moods() -> Dictionary:
	return _merged("MOODS", TdMoodData.MOODS)


## The mood row of map `map` (a MAP dictionary): its id's row, else the row its
## "mood" key names (an act default from MapRegistry), else {}.
static func mood_for(map: Dictionary) -> Dictionary:
	var m := moods()  # Every row.
	return m.get(String(map.get("id", "")), m.get(String(map.get("mood", "")), {}))
