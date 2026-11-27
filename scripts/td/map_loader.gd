## MapLoader: turns a map's data (MapRegistry -> const MAP) into run objects:
## the Road objects, the Spot nodes (posts snapped onto their road) and a
## check of the map rules every map must keep (an entrance road, roads that
## join existing roads, known enemy kinds and roads in the waves, a boss on the
## final wave (GDD §3), rule scripts that exist, and a default and a weak build
## order (MAP "build_order" / "weak_order") whose steps name real spots, and
## spots that pass the spot audit (SpotAudit, DECISIONS S1: no dead or weak plot,
## none on the road, a post, another spot, a prop or under the HUD; posts on their road)).
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
			if r.off_road:
				continue  # Posts stand on real roads only.
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
		boss = boss or String(Acts.kinds()[g["kind"]]["rank"]) == "boss"
	if not boss:
		push_error("Map %s: the final wave has no boss (GDD §3)" % map["id"])
		ok = false
	for w: Dictionary in map["waves"]:
		for g: Dictionary in w["groups"]:
			if not Acts.kinds().has(String(g["kind"])) or (g.has("road") and not roads.has(String(g["road"]))):
				push_error("Map %s: wave group with unknown kind or road: %s" % [map["id"], str(g)])
				ok = false
	for key: String in ["rule", "act_rule"]:
		var rid := String(map.get(key, ""))  # Rule id ("" = none).
		if rid != "" and not ResourceLoader.exists("res://scripts/maps/rules/%s.gd" % rid):
			push_error("Map %s: no script for %s '%s'" % [map["id"], key, rid])
			ok = false
	for key: String in ["build_order", "weak_order"]:
		var oid := String(map.get(key, ""))  # Build order id.
		if not Acts.orders().has(oid):
			push_error("Map %s: %s '%s' is not a build order (BuildOrderData / its act's ORDERS)" % [map["id"], key, oid])
			ok = false
			continue
		for st: Dictionary in Acts.orders()[oid]["steps"]:
			var sp := String(st["spot"]).split(":")  # ["plot"|"post", index].
			if sp.size() != 2 or not map.has(sp[0] + "s") or int(sp[1]) >= (map[sp[0] + "s"] as Array).size():
				push_error("Map %s: build order %s names a missing spot %s" % [map["id"], oid, st["spot"]])
				ok = false
				break
	for line: String in SpotAudit.problems(map, roads):
		push_error("Map %s: bad spot %s (SpotAudit; details: tools/spot_audit.tscn)" % [map["id"], line])
		ok = false
	return ok


## Souls a map can pay on Necromancer with no leaks (the income check, DECISIONS
## X2): {"start", "kills", "no_leak", "total"}; kills = every wave group's count
## x its kind's souls (row "souls", else its rank's EconomyData.KILL_SOULS).
## Units a trait or boss spawns mid-map are not counted. Printed by map_list.
static func income(map: Dictionary) -> Dictionary:
	var kills := 0  # Souls from the scripted waves' kills.
	var bonus := 0  # Souls from the no-leak bonuses.
	var waves: Array = map["waves"]
	for i in waves.size():
		bonus += EconomyData.NO_LEAK_BASE + EconomyData.NO_LEAK_PER_WAVE * (i + 1)
		for g: Dictionary in waves[i]["groups"]:
			var row: Dictionary = Acts.kinds()[g["kind"]]
			kills += int(g["count"]) * int(row.get("souls", EconomyData.KILL_SOULS[row["rank"]]))
	var start := int(map.get("souls", 0)) if int(map.get("souls", 0)) > 0 else EconomyData.START_SOULS  # Start souls.
	return {"start": start, "kills": kills, "no_leak": bonus, "total": start + kills + bonus}
