## MapLoader: turns a map's data (MapRegistry -> const MAP) into run objects:
## the Road objects, the Spot nodes (posts snapped onto their road) and a
## check of the map rules every map must keep (an entrance road, roads that
## join existing roads, a boss on the final wave, GDD §3).
class_name MapLoader
extends RefCounted


## Road id -> Road for `map`.
static func build_roads(map: Dictionary) -> Dictionary:
	var out := {}  # id -> Road.
	for id: String in map["roads"]:
		out[id] = Road.new(id, map["roads"][id])
	return out


## Makes the Spot nodes of `map` under `parent` (plots first, then posts) and
## returns them. Posts snap to the nearest road.
static func build_spots(map: Dictionary, roads: Dictionary, parent: Node) -> Array[Spot]:
	var out: Array[Spot] = []  # Every spot.
	for i in (map["plots"] as Array).size():
		var s := Spot.new()  # A grave plot.
		s.kind = "plot"
		s.index = i
		s.position = map["plots"][i]
		parent.add_child(s)
		out.append(s)
	for i in (map["posts"] as Array).size():
		var p: Vector2 = map["posts"][i]  # Authored post position.
		var best: Road = null  # Nearest road.
		for r: Road in roads.values():
			if best == null or r.distance_to(p) < best.distance_to(p):
				best = r
		var s := Spot.new()  # A road post.
		s.kind = "post"
		s.index = i
		s.road_id = best.id
		s.road_dist = best.project(p)
		s.position = best.point_at(s.road_dist)
		parent.add_child(s)
		out.append(s)
	return out


## push_error()s every broken map rule of `map`; returns true when it is sound.
static func validate(map: Dictionary, roads: Dictionary) -> bool:
	var ok := true  # No rule broken so far.
	var has_entrance := false  # Some road is an entrance.
	for r: Road in roads.values():
		has_entrance = has_entrance or r.entrance
		if r.next_id != "" and not roads.has(r.next_id):
			push_error("Map %s: road %s joins unknown road %s" % [map["id"], r.id, r.next_id])
			ok = false
	if not has_entrance:
		push_error("Map %s: no entrance road" % map["id"])
		ok = false
	var last: Dictionary = (map["waves"] as Array).back()  # The final wave.
	var boss := false  # The final wave holds a boss.
	for g: Dictionary in last["groups"]:
		boss = boss or String(TdEnemyData.KINDS[g["kind"]]["rank"]) == "boss"
	if not boss:
		push_error("Map %s: the final wave has no boss (GDD §3)" % map["id"])
		ok = false
	return ok
