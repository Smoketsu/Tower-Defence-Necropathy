## MapView: draws the static map once (redrawn only when asked): the
## Necropathy stage floor tile over the whole 1280 x 720 map, floor decals at
## hashed points off the road, the decoration obstacles, the roads (TdArtData
## road_fill tiled in map space + road_edge kerbs, each joint drawn as a short
## rounded bend, rounded()) and the entrance arches.
## The gate and the necromancer are drawn by TdGame's gate layer (they change
## with lives). Purely visual: nothing here collides.
class_name MapView
extends Node2D

## Map size (px); the map is one fixed screen (GDD §7.1).
const SIZE: Vector2 = Vector2(1280, 720)
## Decal attempts per map (each placed by a pure position hash, skipped near roads and spots).
const DECAL_TRIES: int = 90  # TUNING (not in GDD) visual density
## Px decals keep away from road centre lines and spots.
const DECAL_CLEAR: float = 40.0  # TUNING (not in GDD)

## grid_texture() cache: key (+ "#r" when tiled) -> wrapped texture or null.
static var _tex_cache: Dictionary = {}
## The map data.
var map: Dictionary = {}
## Its roads (id -> Road).
var roads: Dictionary = {}


func _ready() -> void:
	z_index = -10


## Raw grid texture for a Necropathy sprite key, wrapped for the sharp shader
## (`repeat` = tiled), or null. Cached: a draw command only holds the texture's
## RID, so the wrapper must outlive the _draw() that used it.
static func grid_texture(key: String, repeat: bool = false) -> Texture2D:
	var ck := key + ("#r" if repeat else "")  # Cache key.
	if _tex_cache.has(ck):
		return _tex_cache[ck]
	var path := SpriteData.ROOT + key + ".png"  # Its PNG.
	var ct: CanvasTexture = null  # The wrapper (null = no art).
	if ResourceLoader.exists(path):
		ct = CanvasTexture.new()
		ct.diffuse_texture = load(path) as Texture2D
		ct.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		ct.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED if repeat else CanvasItem.TEXTURE_REPEAT_DISABLED
	_tex_cache[ck] = ct
	return ct


func _draw() -> void:
	SpriteBank.apply_sharp(self)
	var floor_tex := grid_texture(String(map["floor"]), true)  # The stage floor tile.
	if floor_tex != null:
		draw_texture_rect(floor_tex, Rect2(Vector2.ZERO, SIZE), true)
	else:
		draw_rect(Rect2(Vector2.ZERO, SIZE), Color(0.08, 0.09, 0.1))
	_draw_decals()
	for o: Array in map["obstacles"]:
		var tex := grid_texture(String(o[0]))  # Obstacle art.
		if tex != null:
			var sz := tex.get_size()  # Its size (px).
			draw_texture_rect(tex, Rect2((Vector2(o[1]) - Vector2(sz.x * 0.5, sz.y * 0.8)).round(), sz), false)
	var paths := {}  # Road id -> [drawn path (rounded(), cut), its corner polyline].
	for r: Road in roads.values():
		if not r.sky:  # A sky lane (Act XIII) leaves no trail.
			var bends := rounded(r.points)  # Arcs at the joints.
			paths[r.id] = [cut(bends), bends]
	for r: Road in roads.values():
		if paths.has(r.id):
			# An off-road route is only a trampled trail (its worn shoulder, narrower).
			_draw_shoulder(paths[r.id][0], TdArtData.ROAD_WIDTH * (TdMoodData.OFF_ROAD_TRAIL if r.off_road else 0.5) + TdMoodData.SHOULDER_PX)
	var built: Array[Road] = []  # The paved roads (not off-road, not sky).
	for r: Road in roads.values():
		if paths.has(r.id) and not r.off_road:
			built.append(r)
	for r: Road in built:
		_draw_fill(paths[r.id][0])
	for r: Road in built:
		_draw_wear(r, paths[r.id][0])
	for r: Road in built:
		var others: Array = []  # The corner polylines of the other paved roads.
		for o: Road in built:
			if o != r:
				others.append(paths[o.id][1])
		_draw_kerbs(paths[r.id][0], others)
	for r: Road in roads.values():
		if r.entrance and not r.off_road:
			var p := r.points[0].lerp(r.points[1], clampf(80.0 / maxf(r.points[0].distance_to(r.points[1]), 1.0), 0.0, 1.0))  # Arch just inside the map.
			TdArt.draw(self, "entrance", p + Vector2(0, -24))


## Decals at hashed points (a pure function of the index: same every run).
func _draw_decals() -> void:
	var keys: Array = map["decals"]  # Decal sprite keys.
	if keys.is_empty():
		return
	for i in DECAL_TRIES:
		var h := hash(Vector2i(i, 7919))  # Pure hash of the index.
		var p := Vector2(float(h % 1280), float((h / 1280) % 720))  # Candidate px.
		if _near_road_or_spot(p):
			continue
		var tex := grid_texture(String(keys[(h / 7) % keys.size()]))  # The decal.
		if tex != null:
			draw_texture_rect(tex, Rect2((p - tex.get_size() * 0.5).round(), tex.get_size()), false)


## True when map px `p` is within DECAL_CLEAR (+ the road half width) of a road or a spot.
func _near_road_or_spot(p: Vector2) -> bool:
	for r: Road in roads.values():
		if r.distance_to(p) < DECAL_CLEAR + TdArtData.ROAD_WIDTH * 0.5:
			return true
	for s: Vector2 in map["plots"] + map["posts"]:
		if s.distance_to(p) < DECAL_CLEAR:
			return true
	return false


## Road polyline `pts` as drawn: each joint becomes an arc of TdArtData.ROAD_TURN_RADIUS
## (shrunk so two arcs never share a segment's half; an end segment is all one arc's), in pieces of at most
## ROAD_TURN_STEP_DEG. Pure and static (CityStreets draws its wider streets with a
## larger `radius`, px).
static func rounded(pts: PackedVector2Array, radius: float = TdArtData.ROAD_TURN_RADIUS) -> PackedVector2Array:
	var out := PackedVector2Array([pts[0]])  # The polyline with its bends.
	for i in range(1, pts.size() - 1):
		var c := pts[i]  # The joint.
		var d1 := (c - pts[i - 1]).normalized()  # Direction in.
		var d2 := (pts[i + 1] - c).normalized()  # Direction out.
		var turn := d1.angle_to(d2)  # Signed turn (rad).
		if absf(turn) < 0.01:
			out.append(c)
			continue
		var tn := tan(absf(turn) * 0.5)
		var room_in := pts[i - 1].distance_to(c) * (1.0 if i == 1 else 0.5)  # An end segment has no other bend to share with.
		var room_out := c.distance_to(pts[i + 1]) * (1.0 if i == pts.size() - 2 else 0.5)
		var t := minf(radius * tn, minf(room_in, room_out))  # Tangent length (px).
		var rad := t / tn  # Arc radius (px).
		var perp := d1.rotated(signf(turn) * PI * 0.5)  # Towards the arc centre.
		var centre := c - d1 * t + perp * rad
		var steps := maxi(1, ceili(absf(rad_to_deg(turn)) / TdArtData.ROAD_TURN_STEP_DEG))  # Arc pieces.
		for k in steps + 1:
			out.append(centre - perp.rotated(turn * float(k) / float(steps)) * rad)
	out.append(pts[pts.size() - 1])
	return out


## Polyline `pts` cut into pieces of at most TdArtData.ROAD_PIECE_PX; points closer than
## 0.5 px to the last one are dropped (two bends sharing a short segment meet in one
## point, and a zero-length piece cannot be drawn).
static func cut(pts: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array([pts[0]])  # The cut polyline.
	for i in range(1, pts.size()):
		var a := out[out.size() - 1]  # The last point kept.
		if a.distance_to(pts[i]) < 0.5:
			continue
		var n := ceili(a.distance_to(pts[i]) / TdArtData.ROAD_PIECE_PX)  # Pieces here.
		for k in range(1, n + 1):
			out.append(a.lerp(pts[i], float(k) / float(n)))
	return out


## Polyline `path` moved `dist` px along its left normal (Vector2(d.y, -d.x)), mitred at
## each point so neighbouring pieces share their edges.
static func offset(path: PackedVector2Array, dist: float) -> PackedVector2Array:
	var out := PackedVector2Array()  # One point per path point.
	var last := path.size() - 1
	for i in path.size():
		var d0 := (path[i] - path[maxi(i - 1, 0)]).normalized()  # Piece in.
		var d1 := (path[mini(i + 1, last)] - path[i]).normalized()  # Piece out.
		if i == 0:
			d0 = d1
		if i == last:
			d1 = d0
		var n1 := Vector2(d1.y, -d1.x)  # Normal of the piece out.
		var m := (Vector2(d0.y, -d0.x) + n1).normalized()  # Mitre direction.
		out.append(path[i] + m * dist / maxf(m.dot(n1), 0.5))
	return out


## The road fill along drawn path `path` (TdArtData road_fill mapped in map space, so
## pieces and roads meet seamlessly).
func _draw_fill(path: PackedVector2Array) -> void:
	var fill := TdArt.texture("road_fill", true)  # Seamless 48 px flagstones.
	var hw := TdArtData.ROAD_WIDTH * 0.5  # Half width (px).
	var l := offset(path, hw)  # Left edge.
	var rr := offset(path, -hw)  # Right edge.
	for i in range(path.size() - 1):
		var quad := PackedVector2Array([l[i], l[i + 1], rr[i + 1], rr[i]])  # One piece.
		if fill != null:
			piece(self, quad, _uv(quad, fill), fill)
		else:
			draw_colored_polygon(quad, Color(0.35, 0.33, 0.3))


## Both road_edge kerbs along drawn path `path`, bent round its bends with the strip's
## pattern running on unbroken; a piece lying under another paved road (corner
## polylines `others`: a merge or a crossing) is left out, so the roads open into each other.
func _draw_kerbs(path: PackedVector2Array, others: Array) -> void:
	var edge := TdArt.texture("road_edge", true)  # 48 x 8 kerb strip.
	if edge == null:
		return
	var hw := TdArtData.ROAD_WIDTH * 0.5  # Half width (px).
	var eh := edge.get_size().y  # Kerb thickness (px).
	for side: float in [1.0, -1.0]:
		var mid := side * (hw - eh * 0.5)  # Kerb centre offset (px).
		var c := offset(path, mid)  # Kerb centre line (its length drives u).
		var top := offset(path, mid + eh * 0.5)  # v = 0 edge (as the straight kerbs always were).
		var bot := offset(path, mid - eh * 0.5)  # v = 1 edge.
		var u := 0.0  # Strip tiles so far.
		for i in range(path.size() - 1):
			var u1 := u + c[i].distance_to(c[i + 1]) / edge.get_size().x  # u at the piece end.
			if not _under(c[i].lerp(c[i + 1], 0.5), others, hw - eh):
				piece(self, PackedVector2Array([top[i], top[i + 1], bot[i + 1], bot[i]]),
						PackedVector2Array([Vector2(u, 0), Vector2(u1, 0), Vector2(u1, 1), Vector2(u, 1)]), edge)
			u = u1


## Draws one textured road piece `pts` (uvs `uv`) on `ci` with draw_polygon, first
## dropping a corner within 0.5 px of the previous one: where a bend's inner edge
## shrinks to a point the quad has two near-equal corners, which draw_polygon cannot
## triangulate (draw_primitive was tried instead: on the Web build the city asphalt
## and its lane dashes vanished with it).
static func piece(ci: CanvasItem, pts: PackedVector2Array, uv: PackedVector2Array, tex: Texture2D) -> void:
	var p := PackedVector2Array()  # Kept corners.
	var u := PackedVector2Array()  # Their uvs.
	for i in pts.size():
		if p.is_empty() or (pts[i].distance_to(p[p.size() - 1]) >= 0.5 and (i < pts.size() - 1 or pts[i].distance_to(p[0]) >= 0.5)):
			p.append(pts[i])
			u.append(uv[i])
	if p.size() < 3:
		return
	if not Geometry2D.triangulate_polygon(p).is_empty():
		ci.draw_polygon(p, PackedColorArray([Color.WHITE]), u, tex)
		return
	# A quad folded at a tight bend's inner edge (a bow tie, DECISIONS L1) cannot be
	# triangulated: draw it as its two triangles instead (a degenerate one is dropped).
	for tri: Array in [[0, 1, 2], [0, 2, 3]]:
		if p.size() == 4:
			var tp := PackedVector2Array([p[tri[0]], p[tri[1]], p[tri[2]]])  # One triangle.
			if absf((tp[1] - tp[0]).cross(tp[2] - tp[0])) > 0.5:
				ci.draw_polygon(tp, PackedColorArray([Color.WHITE]), PackedVector2Array([u[tri[0]], u[tri[1]], u[tri[2]]]), tex)


## True when `p` lies within `r` px of any of the polylines `lines`.
static func _under(p: Vector2, lines: Array, r: float) -> bool:
	for pl: PackedVector2Array in lines:
		for i in range(pl.size() - 1):
			if p.distance_to(Geometry2D.get_closest_point_to_segment(p, pl[i], pl[i + 1])) < r:
				return true
	return false


## The worn shoulder: a dark band reaching past the road edges (half width
## `w`) along drawn path `path`, one clean outline (no doubled alpha at the
## bends), drawn under the road (static: this layer is drawn once).
func _draw_shoulder(path: PackedVector2Array, w: float) -> void:
	for poly: PackedVector2Array in Geometry2D.offset_polyline(path, w, Geometry2D.JOIN_ROUND, Geometry2D.END_BUTT):
		draw_colored_polygon(poly, TdMoodData.SHOULDER_TINT)


## Cart ruts along drawn path `path` (round the bends) and loose cobbles at hashed
## pieces of it (static).
func _draw_wear(r: Road, path: PackedVector2Array) -> void:
	for side: float in [1.0, -1.0]:
		draw_polyline(offset(path, side * TdMoodData.RUT_OFFSET), TdMoodData.RUT_TINT, TdMoodData.RUT_W)
	var n := path.size() - 1  # Pieces.
	for k in int(float(n) * TdArtData.ROAD_PIECE_PX * TdMoodData.COBBLE_PER_PX):
		var h := hash(Vector3i(k, 0, r.id.hash()))  # Pure hash.
		var i := h % n  # The piece.
		var d := (path[i + 1] - path[i]).normalized()  # Its direction.
		var p := path[i] + Vector2(d.y, -d.x) * (float((h / 97) % 36) - 18.0)  # On the road.
		draw_rect(Rect2(p.round(), Vector2(TdMoodData.COBBLE_PX, TdMoodData.COBBLE_PX - 1.0)), TdMoodData.COBBLE_TINT)


## Map-space UVs (in tiles of `tex`) for polygon `pts`.
func _uv(pts: PackedVector2Array, tex: Texture2D) -> PackedVector2Array:
	var out := PackedVector2Array()  # One UV per point.
	for p: Vector2 in pts:
		out.append(p / tex.get_size())
	return out
