## SpotAudit: checks where a map's grave plots and road posts stand (DECISIONS S1):
## how much real road the shortest-range plot tower reaches from each plot (dead /
## weak), whether a built tower would stand on the road or a post (too close), on
## another spot, the gate or an entrance (crowded), under the HUD or off the map
## (covered), on an obstacle or an act object (on a prop), and whether each post is
## on its road, apart from the others and away from the road's ends. Pure geometry
## on the map data (Road objects, TowerData ranges, SpotAuditData thresholds); no
## state. Used by MapLoader.validate() (any flag fails the map) and printed in full by
## tools/spot_audit.tscn. Off-road trails (herds that leave the map, costing nothing)
## and sky lanes are not counted as road: their px are reported apart (trail_px).
class_name SpotAudit
extends RefCounted


## Level 1 range (px) and class id of the shortest-range tower a plot can hold.
static func shortest_tower() -> Array:
	var best := ""  # Class id.
	for id: String in TowerData.TOWERS:
		var row: Dictionary = TowerData.TOWERS[id]
		if String(row["spot"]) == "plot" and (best == "" or float(row["range"]) < float(TowerData.TOWERS[best]["range"])):
			best = id
	return [float(TowerData.TOWERS[best]["range"]), best]


## Range (px) of tower class `id` at `level` (1-5), before synergies.
static func range_of(id: String, level: int) -> float:
	return float(TowerData.TOWERS[id]["range"]) * float(TowerData.LEVELS[id][level - 1].get("range", 1.0))


## Px of segment a-b inside the circle (c, r).
static func chord(a: Vector2, b: Vector2, c: Vector2, r: float) -> float:
	var d := b - a  # Segment vector.
	var f := a - c  # Start relative to the centre.
	var qa := d.dot(d)
	if qa <= 0.0:
		return 0.0
	var qb := 2.0 * f.dot(d)
	var qc := f.dot(f) - r * r
	var disc := qb * qb - 4.0 * qa * qc  # Discriminant of |a + t d - c| = r.
	if disc <= 0.0:
		return 0.0
	var s := sqrt(disc)
	var t0 := clampf((-qb - s) / (2.0 * qa), 0.0, 1.0)  # Entry fraction.
	var t1 := clampf((-qb + s) / (2.0 * qa), 0.0, 1.0)  # Exit fraction.
	return (t1 - t0) * sqrt(qa)


## Px of road `rd` inside the circle (c, r).
static func road_in(rd: Road, c: Vector2, r: float) -> float:
	var n := 0.0  # Px so far.
	for i in rd.points.size() - 1:
		n += chord(rd.points[i], rd.points[i + 1], c, r)
	return n


## True for a road enemies walk and towers defend (not an off-road trail or sky lane).
static func real(rd: Road) -> bool:
	return not rd.off_road and not rd.sky


## Points every SpotAuditData.SAMPLE_STEP px along every real road.
static func samples(roads: Dictionary) -> Array[Vector2]:
	var out: Array[Vector2] = []  # Road samples (map px).
	for rd: Road in roads.values():
		if not real(rd):
			continue
		var d := 0.0  # Distance along it.
		while d <= rd.length:
			out.append(rd.point_at(d))
			d += SpotAuditData.SAMPLE_STEP
	return out


## The footprint of a plot at `p`: its art square (+-SpotAuditData.FOOT_HALF).
static func footprint(p: Vector2) -> Rect2:
	return Rect2(p - Vector2.ONE * SpotAuditData.FOOT_HALF, Vector2.ONE * SpotAuditData.FOOT_HALF * 2.0)


## The snapped position, road id and distance of every post (as MapLoader.build_spots()).
static func snapped_posts(map: Dictionary, roads: Dictionary) -> Array[Dictionary]:
	var out: Array[Dictionary] = []  # {pos, road, dist, authored}.
	for p: Vector2 in map["posts"]:
		var best: Road = null  # Nearest real road.
		for rd: Road in roads.values():
			if rd.off_road:
				continue
			if best == null or rd.distance_to(p) < best.distance_to(p):
				best = rd
		var d := best.project(p)  # Distance along it.
		out.append({"pos": best.point_at(d), "road": best, "dist": d, "authored": p})
	return out


## The desktop spell bar's rect as TdHud._place_spell_bar() picks it: the bottom slot
## (centre, left, right) covering the fewest road samples x MENU_ROAD_COST + spots.
static func spell_bar(map: Dictionary, roads: Dictionary) -> Rect2:
	var vp := MapView.SIZE
	var sz := SpotAuditData.SPELL_BAR
	var m := TdUiData.SPELL_BAR_MARGIN
	var pts: Array[Vector2] = []  # Road samples as the HUD takes them (every road).
	for rd: Road in roads.values():
		var d := 0.0
		while d <= rd.length:
			pts.append(rd.point_at(d))
			d += TdUiData.MENU_ROAD_STEP
	var spots: Array = (map["plots"] as Array) + (map["posts"] as Array)  # Spot points (posts unsnapped: near enough).
	var best := Rect2()  # Chosen slot (returned without the clearance).
	var best_n := 1 << 30  # Its cost.
	for c: Vector2 in [Vector2((vp.x - sz.x) * 0.5, vp.y - sz.y - m), Vector2(m, vp.y - sz.y - m), Vector2(vp.x - sz.x - m, vp.y - sz.y - m)]:
		var r := Rect2(c, sz).grow(TdUiData.SPELL_BAR_CLEAR)  # With its clearance.
		var n := 0  # Its cost.
		for q: Vector2 in pts:
			if r.has_point(q):
				n += TdUiData.MENU_ROAD_COST
		for q: Vector2 in spots:
			if r.has_point(q):
				n += 1
		if n < best_n:
			best_n = n
			best = Rect2(c, sz)
	return best


## Rects (map px) the interface covers on this map: the top bar, the spell bar, the
## act's HUD widget corner and bottom band.
static func covers(map: Dictionary, roads: Dictionary) -> Array[Rect2]:
	var vp := MapView.SIZE
	var out: Array[Rect2] = [Rect2(0.0, 0.0, vp.x, TdUiData.TOP_BAR_H), spell_bar(map, roads)]
	var act := String(map.get("act", Acts.act_of_map(String(map["id"]))))  # Act id.
	var w := SpotAuditData.WIDGET_BOX
	match String(SpotAuditData.WIDGET_CORNER.get(act, "")):
		"tl":
			out.append(Rect2(0.0, TdUiData.TOP_BAR_H, w.x, w.y))
		"tr":
			out.append(Rect2(vp.x - w.x, TdUiData.TOP_BAR_H, w.x, w.y))
		"bl":
			out.append(Rect2(0.0, vp.y - w.y, w.x, w.y))
	var band := float(SpotAuditData.BOTTOM_BAND.get(act, 0.0))  # Px of the act's bottom band.
	if band > 0.0:
		out.append(Rect2(0.0, vp.y - band, vp.x, band))
	return out


## Point-like act objects of the map (MAP_POINTS keys, portals, the act data's jars,
## cannons, kegs and structures for this map).
static func act_points(map: Dictionary) -> Array[Vector2]:
	var out: Array[Vector2] = []  # Object points (map px).
	for k: String in SpotAuditData.MAP_POINTS:
		for p: Vector2 in map.get(k, []):
			out.append(p)
	for row: Dictionary in map.get("portals", []):
		out.append(Vector2(row["at"]))
	var id := String(map["id"])
	var data := Acts.data(String(map.get("act", Acts.act_of_map(id))))  # Its act data constants.
	for p: Vector2 in (data.get("JARS", {}) as Dictionary).get(id, []):
		out.append(p)
	for row: Dictionary in (data.get("BROADSIDES", {}) as Dictionary).get(id, []):
		out.append(Vector2(row["pos"]))
		out.append(Vector2(row["keg"]))
	for row: Array in (data.get("STRUCTURES", {}) as Dictionary).get(id, []):
		out.append(Vector2(row[1]))
	return out


## Obstacle art rects (as MapView draws them), shrunk by OBSTACLE_SHRINK.
static func obstacle_rects(map: Dictionary) -> Array[Rect2]:
	var out: Array[Rect2] = []  # Rects (map px).
	for o: Array in map.get("obstacles", []):
		var tex := MapView.grid_texture(String(o[0]))  # Its art.
		if tex == null:
			continue
		var sz := tex.get_size()
		var r := Rect2(Vector2(o[1]) - Vector2(sz.x * 0.5, sz.y * 0.8), sz)  # Drawn rect.
		out.append(r.grow_individual(-sz.x * SpotAuditData.OBSTACLE_SHRINK, -sz.y * SpotAuditData.OBSTACLE_SHRINK,
			-sz.x * SpotAuditData.OBSTACLE_SHRINK, -sz.y * SpotAuditData.OBSTACLE_SHRINK))
	return out


## Distance (px) from rect `r` to point `p` (0 inside).
static func rect_dist(r: Rect2, p: Vector2) -> float:
	return p.distance_to(Vector2(clampf(p.x, r.position.x, r.end.x), clampf(p.y, r.position.y, r.end.y)))


## One row per plot: {i, pos, road_d (px to the nearest real road centre line),
## short_px / short_s (shortest-range tower, level 1: road px and fodder s in range),
## short5_px (level 5), typ_px / typ_s (SpotAuditData.TYPICAL_TOWER level 1),
## trail_px (off-road trail px in the typical range), flags (Array of "dead",
## "weak", "too_close", "crowded", "covered", "prop")}.
static func plots(map: Dictionary, roads: Dictionary) -> Array[Dictionary]:
	var ctx := context(map, roads)
	var out: Array[Dictionary] = []
	var all: Array = map["plots"]
	for i in all.size():
		out.append(plot_row(map, roads, ctx, i, all[i], all))
	return out


## What plot_row() needs once per map: {r1, r5, rt (ranges, px), smp (road samples),
## posts (snapped_posts()), cov (covers()), pts (act_points()), obs (obstacle_rects()),
## entries (where entrance roads come on screen)}.
static func context(map: Dictionary, roads: Dictionary) -> Dictionary:
	var sh := shortest_tower()
	var vp := MapView.SIZE
	var entries: Array[Vector2] = []  # Where entrance roads come on screen.
	for rd: Road in roads.values():
		if rd.entrance and real(rd):
			var d := 0.0
			while d < rd.length and not Rect2(Vector2.ZERO, vp).has_point(rd.point_at(d)):
				d += SpotAuditData.SAMPLE_STEP
			entries.append(rd.point_at(d))
	return {"r1": float(sh[0]), "r5": range_of(String(sh[1]), 5), "rt": range_of(SpotAuditData.TYPICAL_TOWER, 1),
		"smp": samples(roads), "posts": snapped_posts(map, roads), "cov": covers(map, roads), "pts": act_points(map),
		"obs": obstacle_rects(map), "entries": entries}


## The audit row of plot `i` standing at `p` among the plots `all` (see plots()).
static func plot_row(map: Dictionary, roads: Dictionary, ctx: Dictionary, i: int, p: Vector2, all: Array) -> Dictionary:
	var vp := MapView.SIZE
	var row := {"i": i, "pos": p, "road_d": INF, "short_px": 0.0, "short5_px": 0.0, "typ_px": 0.0, "trail_px": 0.0}
	var flags: Array[String] = []
	for rd: Road in roads.values():
		if rd.sky:
			continue
		if rd.off_road:
			row["trail_px"] = float(row["trail_px"]) + road_in(rd, p, ctx["rt"])
			continue
		row["road_d"] = minf(float(row["road_d"]), rd.distance_to(p))
		row["short_px"] = float(row["short_px"]) + road_in(rd, p, ctx["r1"])
		row["short5_px"] = float(row["short5_px"]) + road_in(rd, p, ctx["r5"])
		row["typ_px"] = float(row["typ_px"]) + road_in(rd, p, ctx["rt"])
	row["short_s"] = float(row["short_px"]) / SpotAuditData.FODDER_SPEED
	row["typ_s"] = float(row["typ_px"]) / SpotAuditData.FODDER_SPEED
	if float(row["short_px"]) <= 0.0:
		flags.append("dead")
	elif float(row["short_px"]) < SpotAuditData.WEAK_PX:
		flags.append("weak")
	var fp := footprint(p)  # The plot art.
	var close := false  # Footprint on the road or a post.
	for q: Vector2 in ctx["smp"]:
		if rect_dist(fp, q) < TdArtData.ROAD_WIDTH * 0.5 + SpotAuditData.ROAD_MARGIN:
			close = true
			break
	for po: Dictionary in ctx["posts"]:
		close = close or p.distance_to(po["pos"]) < SpotAuditData.POST_CLEAR
	if close:
		flags.append("too_close")
	var crowd := p.distance_to(map["gate"]) < SpotAuditData.GATE_CLEAR  # On a spot, the gate or an entrance.
	for j in all.size():
		crowd = crowd or (j != i and p.distance_to(all[j]) < SpotAuditData.PLOT_CLEAR)
	for e: Vector2 in ctx["entries"]:
		crowd = crowd or p.distance_to(e) < SpotAuditData.ENTRANCE_CLEAR
	if crowd:
		flags.append("crowded")
	var hid := not Rect2(Vector2.ZERO, vp).encloses(fp)  # Off the map, or under the interface.
	for c: Rect2 in ctx["cov"]:
		hid = hid or c.intersects(fp)
	if hid:
		flags.append("covered")
	var on := false  # On an obstacle or act object.
	for o: Rect2 in ctx["obs"]:
		on = on or o.intersects(fp)
	for q: Vector2 in ctx["pts"]:
		on = on or p.distance_to(q) < SpotAuditData.POINT_CLEAR
	for k: String in SpotAuditData.MAP_AREAS:
		var a: Array = map.get(k, [])
		if a.size() == 2 and a[0] is Vector2:
			a = [a]  # A single [centre, radius] area (the watering hole).
		for ar: Array in a:
			on = on or p.distance_to(ar[0]) < float(ar[1]) + SpotAuditData.FOOT_HALF
	if on:
		flags.append("prop")
	row["flags"] = flags
	return row


## One row per post: {i, pos (snapped), road, flags ("off_road": authored far from its
## road, "overlap": too near another post on its road, "dead_end": at a road's start
## (an entrance), inside the gate or off screen)}.
static func posts(map: Dictionary, roads: Dictionary) -> Array[Dictionary]:
	var sp := snapped_posts(map, roads)
	var out: Array[Dictionary] = []
	for i in sp.size():
		var a: Dictionary = sp[i]
		var rd: Road = a["road"]
		var flags: Array[String] = []
		if Vector2(a["authored"]).distance_to(a["pos"]) > SpotAuditData.POST_SNAP:
			flags.append("off_road")
		for j in sp.size():
			if j != i and sp[j]["road"] == rd and absf(float(sp[j]["dist"]) - float(a["dist"])) < SpotAuditData.POST_GAP:
				flags.append("overlap")
				break
		var end := SpotAuditData.POST_END
		var at_start := rd.entrance and float(a["dist"]) < end  # At an entrance.
		var at_gate := rd.next_id == "" and float(a["dist"]) > rd.length - SpotAuditData.POST_GATE  # Inside the gate.
		if at_start or at_gate or not Rect2(Vector2.ZERO, MapView.SIZE).grow(-end).has_point(a["pos"]):
			flags.append("dead_end")
		out.append({"i": i, "pos": a["pos"], "road": rd.id, "flags": flags})
	return out


## One error line per flagged spot of `map` (empty = every spot passes).
static func problems(map: Dictionary, roads: Dictionary) -> Array[String]:
	var out: Array[String] = []
	for r: Dictionary in plots(map, roads):
		if not (r["flags"] as Array).is_empty():
			out.append("plot:%d %s %s road_d=%.0f short_px=%.0f" % [r["i"], r["pos"], ",".join(r["flags"]), r["road_d"], r["short_px"]])
	for r: Dictionary in posts(map, roads):
		if not (r["flags"] as Array).is_empty():
			out.append("post:%d %s %s" % [r["i"], r["pos"], ",".join(r["flags"])])
	return out
