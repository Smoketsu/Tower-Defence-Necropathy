## MapMood: the battlefield dressing of one map (TdMoodData; DECISIONS V9-V12):
## props placed at hashed free points (lanterns, campfires, banners, candles),
## their flickering additive glows and flames, the Graveyard's drifting ground
## fog and the Sanctum's stained-glass light pools, all under the units. Also
## builds the screen vignette (vignette()). Purely visual and off headless;
## placement is a pure function of the map (no RNG). Reduced effects keeps the
## props but drops the glows, flames, fog, pools and animation.
class_name MapMood
extends Node2D

## The run (its clock drives the flicker; paused with the game).
var game: TdGame = null
## Placed props: [prop row (Dictionary), map px (Vector2), phase (float)].
var _props: Array = []
## Stained-glass pool centres (map px).
var _pools: Array[Vector2] = []
## Its mood row (TdMoodData.MOODS; empty = none).
var _mood: Dictionary = {}
## Animated layer (flames, banners, fog; normal blend) and additive glow layer.
var _anim: UnitLayer = null
## See _anim.
var _glow: UnitLayer = null


func _ready() -> void:
	z_index = -9
	if DisplayServer.get_name() == "headless":
		set_process(false)
		return
	_mood = Acts.mood_for(game.map)
	_place()
	_anim = UnitLayer.new()
	_anim.draw_fn = _draw_anim
	add_child(_anim)
	_glow = UnitLayer.new()
	_glow.show_behind_parent = true  # Behind the lanterns, not washing them out.
	_glow.material = TdVfx.additive()
	_glow.draw_fn = _draw_glow
	add_child(_glow)


## A screen vignette (a CanvasLayer under the HUD): four soft dark bands
## along the screen edges (linear gradient textures, no shader; only the edges
## are filled, cheaper than a full-screen quad on fill-limited phones), the
## corners darker where two meet. Hidden on Reduced effects (MapMood._process).
static func vignette() -> CanvasLayer:
	var layer := CanvasLayer.new()  # Between the map (0) and the HUD (5).
	layer.layer = 1
	layer.name = "Vignette"
	var g := Gradient.new()  # Dark edge -> clear.
	g.offsets = PackedFloat32Array([0.0, 1.0])
	g.colors = PackedColorArray([Color(0, 0, 0, TdMoodData.VIGNETTE_ALPHA), Color(0, 0, 0, 0)])
	var f := TdMoodData.VIGNETTE_BAND  # Band depth (fraction of the screen).
	# [anchor rect (left, top, right, bottom), gradient from, gradient to] per edge.
	for e: Array in [[Rect2(0, 0, f, 1), Vector2(0, 0), Vector2(1, 0)], [Rect2(1.0 - f, 0, 1, 1), Vector2(1, 0), Vector2(0, 0)],
			[Rect2(0, 0, 1, f), Vector2(0, 0), Vector2(0, 1)], [Rect2(0, 1.0 - f, 1, 1), Vector2(0, 1), Vector2(0, 0)]]:
		var tex := GradientTexture2D.new()  # Linear across the band.
		tex.gradient = g
		tex.fill_from = e[1]
		tex.fill_to = e[2]
		tex.width = 64
		tex.height = 64
		var r := TextureRect.new()  # One band, clicks pass through.
		r.texture = tex
		r.stretch_mode = TextureRect.STRETCH_SCALE
		r.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var a: Rect2 = e[0]
		r.anchor_left = a.position.x
		r.anchor_top = a.position.y
		r.anchor_right = a.size.x
		r.anchor_bottom = a.size.y
		layer.add_child(r)
	return layer


## Places every prop and pool at hashed points clear of roads, spots,
## obstacles and each other (a pure function of the try index).
func _place() -> void:
	var taken: Array[Vector2] = []  # Points used so far.
	var want: Array = []  # One entry per prop to place: its row.
	for row: Dictionary in _mood.get("props", []):
		for i in int(row["count"]):
			want.append(row)
	for i in int(_mood.get("pools", 0)):
		want.append({})
	var k := 0  # Next prop to place.
	for i in TdMoodData.PLACE_TRIES:
		if k >= want.size():
			break
		var h := hash(Vector2i(i, 104729))  # Pure hash of the try.
		var p := Vector2(TdMoodData.MARGIN_X + float(h % 1200), TdMoodData.MARGIN_TOP + float((h / 1200) % 610))  # Candidate (px).
		if p.x > MapView.SIZE.x - TdMoodData.MARGIN_X or p.y > MapView.SIZE.y - TdMoodData.MARGIN_BOTTOM or not _clear(p, taken):
			continue
		taken.append(p)
		if (want[k] as Dictionary).is_empty():
			_pools.append(p)
		else:
			_props.append([want[k], p, float(h % 628) * 0.01])
		k += 1


## True when map px `p` is clear of roads, spots, obstacles and `taken` points.
func _clear(p: Vector2, taken: Array[Vector2]) -> bool:
	for r: Road in game.roads.values():
		if r.distance_to(p) < TdMoodData.CLEAR_ROAD:
			return false
	for s: Spot in game.spots:
		if s.position.distance_to(p) < TdMoodData.CLEAR_SPOT:
			return false
	for o: Array in game.map["obstacles"]:
		if Vector2(o[1]).distance_to(p) < TdMoodData.CLEAR_OBSTACLE:
			return false
	if Vector2(game.map["gate"]).distance_to(p) < 100.0:
		return false
	for q: Vector2 in taken:
		if q.distance_to(p) < TdMoodData.CLEAR_PROP:
			return false
	return true


func _process(_delta: float) -> void:
	var vig := game.get_node_or_null("Vignette") as CanvasLayer  # The screen vignette.
	if vig != null:
		vig.visible = not TdVfx.reduced()
	if TdVfx.reduced():
		if _anim.visible:
			_anim.visible = false
			_glow.visible = false
			queue_redraw()
		return
	if not _anim.visible:
		_anim.visible = true
		_glow.visible = true
		queue_redraw()
	_anim.queue_redraw()
	_glow.queue_redraw()


## Static props (drawn once, redrawn only when the effects level changes):
## everything that does not move.
func _draw() -> void:
	SpriteBank.apply_sharp(self)
	for pr: Array in _props:
		var row: Dictionary = pr[0]
		if float(row["sway"]) > 0.0 or (int(row["frames"]) > 1 and not TdVfx.reduced()):
			continue  # Drawn by the animated layer.
		_draw_prop(self, row, pr[1], 0, 1.0)


## One prop `row` at `p`, frame `fr`, horizontal scale `sx` (banner sway).
func _draw_prop(ci: CanvasItem, row: Dictionary, p: Vector2, fr: int, sx: float) -> void:
	var sc := float(row["scale"])  # Drawn scale.
	var tex := SpriteBank.texture(String(row["sprite"])) if row.has("sprite") else null  # A Necropathy sprite.
	if row.has("sprite"):
		if tex != null:
			var sz := tex.get_size() * sc * Vector2(sx, 1.0)  # Drawn size, swaying (px).
			ci.draw_texture_rect(tex, Rect2((p - Vector2(sz.x * 0.5, sz.y * 0.9)).round(), sz), false)
		return
	tex = TdArt.texture(String(row["art"]))  # Its art.
	if tex == null:
		return
	var n := int(row["frames"])  # Frames in the strip.
	var fw := tex.get_size().x / float(n)  # Frame width (texels).
	var size := Vector2(fw, tex.get_size().y) * sc  # Drawn size (px).
	var r := Rect2((p - Vector2(size.x * 0.5, size.y * 0.85)).round(), size)  # Feet near p.
	ci.draw_texture_rect_region(tex, r, Rect2(fw * float(fr % n), 0.0, fw, tex.get_size().y))


## Animated layer: campfire frames, swaying banners, candle flames, the fog.
func _draw_anim(ci: CanvasItem) -> void:
	SpriteBank.apply_sharp(ci)
	var t := game.time  # Game clock (s).
	for pr: Array in _props:
		var row: Dictionary = pr[0]
		var ph := float(pr[2])  # Its phase.
		if float(row["sway"]) > 0.0:
			_draw_prop(ci, row, pr[1], 0, 1.0 + float(row["sway"]) * sin(t * TAU / TdMoodData.SWAY_PERIOD + ph))
		elif int(row["frames"]) > 1:
			_draw_prop(ci, row, pr[1], int(t * TdMoodData.FIRE_FPS + ph * 3.0), 1.0)
		if String(row["flame"]) != "":
			var ft := TdArt.texture(String(row["flame"]))  # Flame art.
			if ft != null:
				var fl := 1.0 + 0.25 * sin(t * TdMoodData.FLICKER_HZ * 1.7 + ph)  # Flame height flicker.
				var sz := ft.get_size() * float(row["scale"]) * Vector2(1.0, fl)  # Drawn size (px).
				var o: Vector2 = pr[1] + Vector2(row["flame_at"]) * float(row["scale"]) * 0.5
				ci.draw_texture_rect(ft, Rect2((o - Vector2(sz.x * 0.5, sz.y)).round(), sz), false)
	var soft := TdVfx._soft()  # Soft disc: each fog bank is a few wide, flat puffs.
	for i in int(_mood.get("fog", 0)) * TdMoodData.FOG_PUFFS:
		var row := i / TdMoodData.FOG_PUFFS  # Its fog bank.
		var y := 150.0 + float(row) * (MapView.SIZE.y - 200.0) / maxf(float(int(_mood["fog"]) - 1), 1.0) + float(i % 3) * 14.0  # Its row (px).
		var w := TdMoodData.FOG_W * (0.7 + 0.15 * float(i % 4))  # Puff width (px).
		var x := pingpong(t * TdMoodData.FOG_SPEED * (1.0 + 0.25 * float(row % 2)) + float(i) * 211.0, MapView.SIZE.x - w)  # Drifting to and fro, inside the map.
		ci.draw_texture_rect(soft, Rect2(Vector2(x, y - TdMoodData.FOG_H * 0.5), Vector2(w, TdMoodData.FOG_H)), false, TdMoodData.FOG_TINT)


## Additive layer: the props' flickering glows and the stained-glass pools.
func _draw_glow(ci: CanvasItem) -> void:
	var t := game.time  # Game clock (s).
	var soft := TdVfx._soft()  # Soft disc.
	for pr: Array in _props:
		var row: Dictionary = pr[0]
		var r := float(row["glow_r"])  # Glow radius (px).
		if r <= 0.0:
			continue
		var ph := float(pr[2])  # Its phase.
		var fl := 1.0 + float(row["flicker"]) * (sin(t * TdMoodData.FLICKER_HZ + ph) + 0.6 * sin(t * TdMoodData.FLICKER_HZ * 2.3 + ph * 2.0)) * 0.6  # Flicker.
		var c: Color = row["glow"]
		var o: Vector2 = pr[1] + Vector2(row["glow_at"])
		r *= fl
		ci.draw_texture_rect(soft, Rect2(o - Vector2(r, r * 0.8), Vector2(r * 2.0, r * 1.6)), false, Color(c, c.a * fl))
	var glass := TdArt.texture("mood_glass")  # Light pool.
	if glass != null:
		for i in _pools.size():
			var a := TdMoodData.POOL_ALPHA * (1.0 + TdMoodData.POOL_PULSE * sin(t * TAU / TdMoodData.POOL_PERIOD + float(i)))  # Pulsing.
			var sz := glass.get_size() * TdMoodData.POOL_SCALE  # Drawn size (px).
			ci.draw_texture_rect(glass, Rect2(_pools[i] - sz * 0.5, sz), false, Color(1, 1, 1, a))
