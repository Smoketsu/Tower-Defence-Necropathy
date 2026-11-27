## spot_audit: the spot audit of every map (SpotAudit, DECISIONS S1): one line per
## flagged plot or post, one summary line per map (plots, posts, the count of each
## flag, the weakest plot's road px), the totals, then "SPOT AUDIT OK" or "SPOT AUDIT
## FAIL". With `-- --json=<path>` it also writes every plot / post row, road polyline
## and covered rect as JSON (the overlay pictures, art_source/spot_audit_overlay.py).
## With `--fix` it prints a "FIX <map> plot:<i> (x,y) -> (x,y) moved=<px> short=<px>" line per
## flagged plot: the nearest place on a SpotAuditData.FIX_STEP grid (within FIX_REACH)
## that passes every test with the shortest-range tower covering FIX_PX of road and the
## same herd-trail marks (Act XIV: in or out of RULE mark_r of each trail), the plots
## taken in index order; "UNFIXED" when none. The map data is edited by hand from them.
## Run: godot --headless tools/spot_audit.tscn [-- --autotest] [--json=/abs/path.json] [--fix]
extends Node

## Flag names in print order (plots, then posts).
const FLAGS: Array[String] = ["dead", "weak", "too_close", "crowded", "covered", "prop", "off_road", "overlap", "dead_end"]


func _ready() -> void:
	var json := ""  # Output path ("" = none).
	var fix := false  # Propose new places for flagged plots.
	for a: String in OS.get_cmdline_user_args():
		if a.begins_with("--json="):
			json = a.substr(7)
		fix = fix or a == "--fix"
	var sh := SpotAudit.shortest_tower()
	print("SPOTS shortest=%s r1=%.0f r5=%.0f typical=%s r=%.0f weak_px=%.0f fodder=%.0f px/s" % [sh[1], sh[0],
		SpotAudit.range_of(String(sh[1]), 5), SpotAuditData.TYPICAL_TOWER, SpotAudit.range_of(SpotAuditData.TYPICAL_TOWER, 1),
		SpotAuditData.WEAK_PX, SpotAuditData.FODDER_SPEED])
	var total := {}  # Flag -> count over every map.
	for f: String in FLAGS:
		total[f] = 0
	var dump := {}  # Map id -> its rows (JSON).
	var maps := 0  # Maps audited.
	var flagged := 0  # Spots with any flag.
	for id: String in Acts.map_order():
		if bool(Acts.row(Acts.act_of_map(id)).get("hidden", false)):
			continue
		maps += 1
		var m := MapRegistry.get_map(id)
		var roads := MapLoader.build_roads(m)
		if fix:
			_fix(id, m, roads)
		var pl := SpotAudit.plots(m, roads)
		var po := SpotAudit.posts(m, roads)
		var cnt := {}  # Flag -> count on this map.
		for f: String in FLAGS:
			cnt[f] = 0
		var worst := INF  # Least shortest-range road px of a plot.
		for r: Dictionary in pl:
			worst = minf(worst, float(r["short_px"]))
			for f: String in r["flags"]:
				cnt[f] += 1
			if not (r["flags"] as Array).is_empty():
				flagged += 1
				print("  %s plot:%d (%d,%d) %s road_d=%.0f short=%.0fpx/%.1fs short5=%.0fpx typ=%.0fpx/%.1fs trail=%.0f" % [id, r["i"],
					r["pos"].x, r["pos"].y, ",".join(r["flags"]), r["road_d"], r["short_px"], r["short_s"], r["short5_px"], r["typ_px"], r["typ_s"], r["trail_px"]])
		for r: Dictionary in po:
			for f: String in r["flags"]:
				cnt[f] += 1
			if not (r["flags"] as Array).is_empty():
				flagged += 1
				print("  %s post:%d (%d,%d) %s road=%s" % [id, r["i"], r["pos"].x, r["pos"].y, ",".join(r["flags"]), r["road"]])
		var parts: Array[String] = []
		for f: String in FLAGS:
			total[f] += cnt[f]
			parts.append("%s=%d" % [f, cnt[f]])
		print("MAPSPOTS %s plots=%d posts=%d %s min_short_px=%.0f" % [id, pl.size(), po.size(), " ".join(parts), worst])
		if json != "":
			var rl := []  # Roads as point lists.
			for rd: Road in roads.values():
				var ps := []
				for q: Vector2 in rd.points:
					ps.append([q.x, q.y])
				rl.append({"id": rd.id, "off_road": rd.off_road, "sky": rd.sky, "points": ps})
			var pj := []
			for r: Dictionary in pl:
				pj.append({"i": r["i"], "x": r["pos"].x, "y": r["pos"].y, "flags": r["flags"], "short_px": r["short_px"], "typ_px": r["typ_px"]})
			var oj := []
			for r: Dictionary in po:
				oj.append({"i": r["i"], "x": r["pos"].x, "y": r["pos"].y, "flags": r["flags"]})
			var cj := []
			for c: Rect2 in SpotAudit.covers(m, roads):
				cj.append([c.position.x, c.position.y, c.size.x, c.size.y])
			var bj := []
			for c: Rect2 in SpotAudit.obstacle_rects(m):
				bj.append([c.position.x, c.position.y, c.size.x, c.size.y])
			var aj := []
			for q: Vector2 in SpotAudit.act_points(m):
				aj.append([q.x, q.y])
			dump[id] = {"name": m["name"], "roads": rl, "plots": pj, "posts": oj, "covers": cj, "obstacles": bj, "points": aj,
				"gate": [m["gate"].x, m["gate"].y]}
	var parts: Array[String] = []
	for f: String in FLAGS:
		parts.append("%s=%d" % [f, total[f]])
	print("SPOTS TOTAL maps=%d flagged_spots=%d %s" % [maps, flagged, " ".join(parts)])
	if json != "":
		var fh := FileAccess.open(json, FileAccess.WRITE)
		fh.store_string(JSON.stringify({"r1": sh[0], "r5": SpotAudit.range_of(String(sh[1]), 5), "rt": SpotAudit.range_of(SpotAuditData.TYPICAL_TOWER, 1), "maps": dump}))
	print("SPOT AUDIT OK" if flagged == 0 else "SPOT AUDIT FAIL")
	get_tree().quit(0 if flagged == 0 else 1)


## Prints the proposed new place of every flagged plot of map `id` (see the header).
func _fix(id: String, m: Dictionary, roads: Dictionary) -> void:
	var ctx := SpotAudit.context(m, roads)
	var all: Array = (m["plots"] as Array).duplicate()  # Plot places, updated as plots move.
	var mark := float((Acts.data(String(m.get("act", ""))).get("RULE", {}) as Dictionary).get("mark_r", 0.0)) if m.has("herd_trails") else 0.0  # Herd-trail mark radius (px).
	var offs: Array[Vector2] = []  # Grid offsets, nearest first.
	var st := SpotAuditData.FIX_STEP
	var n := int(SpotAuditData.FIX_REACH / st)
	for gx in range(-n, n + 1):
		for gy in range(-n, n + 1):
			var o := Vector2(gx, gy) * st
			if o.length() <= SpotAuditData.FIX_REACH and o != Vector2.ZERO:
				offs.append(o)
	offs.sort_custom(func(a: Vector2, b: Vector2) -> bool: return a.length_squared() < b.length_squared())
	for i in all.size():
		var p: Vector2 = all[i]
		if (SpotAudit.plot_row(m, roads, ctx, i, p, all)["flags"] as Array).is_empty():
			continue
		var base := (p / st).round() * st  # Grid origin.
		var found := false
		for o: Vector2 in offs:
			var q := base + o
			if mark > 0.0 and _marks(roads, q, mark) != _marks(roads, p, mark):
				continue
			var r := SpotAudit.plot_row(m, roads, ctx, i, q, all)
			if (r["flags"] as Array).is_empty() and float(r["short_px"]) >= SpotAuditData.FIX_PX:
				print("FIX %s plot:%d (%d,%d) -> (%d,%d) moved=%.0f short=%.0f" % [id, i, p.x, p.y, q.x, q.y, p.distance_to(q), r["short_px"]])
				all[i] = q
				found = true
				break
		if not found:
			print("UNFIXED %s plot:%d (%d,%d)" % [id, i, p.x, p.y])


## Which off-road trails pass within `r` px of `p` (a bit per trail, roads in key order).
func _marks(roads: Dictionary, p: Vector2, r: float) -> int:
	var bits := 0
	var k := 0
	for rd: Road in roads.values():
		if rd.off_road and not rd.sky:
			if rd.distance_to(p) <= r:
				bits |= 1 << k
			k += 1
	return bits
