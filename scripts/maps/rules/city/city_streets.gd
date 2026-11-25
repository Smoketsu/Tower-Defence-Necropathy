## CityStreets: the Last Line's streets (Act IV look, drawn only). One static
## layer just above MapView (z -9) that repaves every road of the map as a
## city street: Necropathy's asphalt (tiles/city_street, its plain rows)
## over the flagstones, a sidewalk strip with its kerb on both sides
## (tiles/city_sidewalk), a dashed centre line, and the entrance arches again
## on top. Drawn once (never redrawn per frame); never read by the simulation.
## Numbers in the act's RULE (street_extra, sidewalk_px, asphalt_v, dash_tint, dash_len, dash_w).
class_name CityStreets
extends Node2D

## The run.
var game: TdGame = null
## The act's RULE numbers.
var rule: Dictionary = {}


func _ready() -> void:
	z_index = -9


func _draw() -> void:
	SpriteBank.apply_sharp(self)
	var asphalt := MapView.grid_texture("tiles/city_street", true)  # 64 x 192 asphalt.
	var walk := MapView.grid_texture("tiles/city_sidewalk", true)  # 64 x 32, kerb at the bottom.
	var hw := TdArtData.ROAD_WIDTH * 0.5 + float(rule["street_extra"]) * 0.5  # Asphalt half width (px).
	var sw := float(rule["sidewalk_px"])  # Sidewalk width (px).
	var roads: Array = game.roads.values()
	for r: Road in roads:
		if not r.off_road and walk != null:
			_strip(r, walk, hw, hw + sw, true)
	for r: Road in roads:
		if not r.off_road and asphalt != null:
			_strip(r, asphalt, -hw, hw, false)
	for r: Road in roads:
		if r.off_road:
			continue
		_dashes(r)
		if r.entrance:
			var p := r.points[0].lerp(r.points[1], clampf(80.0 / maxf(r.points[0].distance_to(r.points[1]), 1.0), 0.0, 1.0))  # As MapView.
			TdArt.draw(self, "entrance", p + Vector2(0, -24))


## Textured quads along road `r` between offsets `from` and `to` px across it
## (both sides mirrored when `both`), plus a square at each joint. Sidewalks
## map v 0 -> 1 from the outer edge to the kerb; asphalt uses its plain rows.
func _strip(r: Road, tex: Texture2D, from: float, to: float, both: bool) -> void:
	var sz := tex.get_size()  # Tile size (px).
	for side: float in ([1.0, -1.0] if both else [1.0]):
		for i in range(r.points.size() - 1):
			var a := r.points[i]
			var b := r.points[i + 1]
			var d := (b - a).normalized()  # Along.
			var n := Vector2(d.y, -d.x) * side  # Across (this side).
			var ext := d * (to if both else 0.0)  # Sidewalks run on past the corners to close them.
			var q := PackedVector2Array([a - ext + n * from, b + ext + n * from, b + ext + n * to, a - ext + n * to])
			var len := (b - a).length() + ext.length() * 2.0  # Along (px).
			var uv: PackedVector2Array
			if both:
				uv = PackedVector2Array([Vector2(0, 1), Vector2(len / sz.x, 1), Vector2(len / sz.x, 0), Vector2(0, 0)])
			else:
				var v0 := float(rule["asphalt_v"])  # Plain asphalt rows only.
				var v1 := float(rule["asphalt_v"]) + (to - from) / sz.y
				uv = PackedVector2Array([Vector2(0, v0), Vector2(len / sz.x, v0), Vector2(len / sz.x, v1), Vector2(0, v1)])
			draw_polygon(q, PackedColorArray([Color.WHITE]), uv, tex)
	if both:
		return
	for i in range(1, r.points.size() - 1):
		var c := r.points[i]  # Joint: a square of asphalt.
		var sq := PackedVector2Array([c + Vector2(from, from), c + Vector2(to, from), c + Vector2(to, to), c + Vector2(from, to)])
		var v1 := float(rule["asphalt_v"]) + (to - from) / sz.y
		draw_polygon(sq, PackedColorArray([Color.WHITE]), PackedVector2Array([Vector2(0, float(rule["asphalt_v"])), Vector2((to - from) / sz.x, float(rule["asphalt_v"])), Vector2((to - from) / sz.x, v1), Vector2(0, v1)]), tex)


## The dashed centre line of road `r` (skips the corners).
func _dashes(r: Road) -> void:
	var dl := float(rule["dash_len"])  # Dash length (px).
	var tint: Color = rule["dash_tint"]
	for i in range(r.points.size() - 1):
		var a := r.points[i]
		var b := r.points[i + 1]
		var d := (b - a).normalized()
		var len := (b - a).length()
		var s := TdArtData.ROAD_WIDTH  # Clear of the joint.
		while s + dl < len - TdArtData.ROAD_WIDTH:
			draw_line(a + d * s, a + d * (s + dl), tint, float(rule["dash_w"]))
			s += dl * 2.0
