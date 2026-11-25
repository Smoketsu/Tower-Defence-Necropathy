## MapView: draws the static map once (redrawn only when asked): the
## Necropathy stage floor tile over the whole 1280 x 720 map, floor decals at
## hashed points off the road, the decoration obstacles, the roads (TdArtData
## road_fill tiled in map space + road_edge kerbs) and the entrance arches.
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
	for r: Road in roads.values():
		_draw_road(r)
	for r: Road in roads.values():
		if r.entrance:
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


## One road: a fill quad per segment and a square at each joint (the fill
## tile is mapped in map space, so pieces meet seamlessly), then the kerbs.
func _draw_road(r: Road) -> void:
	var fill := TdArt.texture("road_fill", true)  # Seamless 48 px flagstones.
	var edge := TdArt.texture("road_edge", true)  # 48 x 8 kerb strip.
	var hw := TdArtData.ROAD_WIDTH * 0.5  # Half width (px).
	for i in range(r.points.size() - 1):
		var a := r.points[i]
		var b := r.points[i + 1]
		var d := (b - a).normalized()  # Segment direction.
		var n := Vector2(d.y, -d.x) * hw  # Half-width normal.
		var quad := PackedVector2Array([a + n, b + n, b - n, a - n])  # Segment fill.
		if fill != null:
			draw_polygon(quad, PackedColorArray([Color.WHITE]), _uv(quad, fill), fill)
		else:
			draw_colored_polygon(quad, Color(0.35, 0.33, 0.3))
	for i in range(1, r.points.size() - 1):
		var c := r.points[i]  # Joint.
		var sq := PackedVector2Array([c + Vector2(-hw, -hw), c + Vector2(hw, -hw), c + Vector2(hw, hw), c + Vector2(-hw, hw)])
		if fill != null:
			draw_polygon(sq, PackedColorArray([Color.WHITE]), _uv(sq, fill), fill)
	if edge == null:
		return
	var eh := edge.get_size().y  # Kerb thickness (px).
	for i in range(r.points.size() - 1):
		var a := r.points[i]
		var b := r.points[i + 1]
		var d := (b - a).normalized()
		var n := Vector2(d.y, -d.x)  # Unit normal.
		var len := a.distance_to(b)  # Segment length.
		for side: float in [1.0, -1.0]:
			var o := n * side * (hw - eh * 0.5)  # Kerb centre offset.
			var k := PackedVector2Array([a + o + n * eh * 0.5, b + o + n * eh * 0.5, b + o - n * eh * 0.5, a + o - n * eh * 0.5])
			var u := len / edge.get_size().x  # Tiles along the kerb.
			draw_polygon(k, PackedColorArray([Color.WHITE]), PackedVector2Array([Vector2(0, 0), Vector2(u, 0), Vector2(u, 1), Vector2(0, 1)]), edge)


## Map-space UVs (in tiles of `tex`) for polygon `pts`.
func _uv(pts: PackedVector2Array, tex: Texture2D) -> PackedVector2Array:
	var out := PackedVector2Array()  # One UV per point.
	for p: Vector2 in pts:
		out.append(p / tex.get_size())
	return out
