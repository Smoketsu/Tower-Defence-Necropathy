## HostLayer: the look of the Hallowed Light (rules/host/hallowed_light.gd), a
## node under game.world drawn UNDER the units (z -2): the cloud banks'
## shadows (tiles/host_cloud_shadow), the shade round every Crypt Warder /
## Bound Ophan, a white glare under each tower the Light weakens and a cool ring
## under each one shade saves; its child Glow draws the shafts additively (the
## fx/host_shaft band, a brighter centre line, the faint band where a sweeping
## shaft goes next) and the telegraph of a shaft about to burn (a pulsing
## fx/host_shaft_line where it enters and a faint band). Textures only, a few
## rects per frame. While the Voice's Be Not Afraid is coming it also draws
## pulsing gold-white bands on the four map edges (DECISIONS Y9; never a
## full-screen overlay). Drawing only: it never writes run state.
extends Node2D

## Additive glow child: draws back through its HostLayer.
class Glow:
	extends Node2D
	## The layer drawing through it.
	var owner_layer: Node2D = null

	func _draw() -> void:
		owner_layer.call("draw_light", self)

## The act rule (a hallowed_light.gd instance).
var rule: MapRule = null
## The additive glow child.
var _glow: Glow = null
## Cached edge-band gradient (opaque at the edge, clear inward).
var _band_tex: GradientTexture2D = null


func _ready() -> void:
	z_index = -2  # Over the floor, roads and spots; under the units.
	_glow = Glow.new()
	_glow.owner_layer = self
	_glow.z_index = 1
	_glow.material = TdVfx.additive()
	add_child(_glow)


func _process(_delta: float) -> void:
	queue_redraw()
	_glow.queue_redraw()


func _draw() -> void:
	var rr: Dictionary = Acts.data("host")["RULE"]
	var cloud := SpriteBank.texture("tiles/host_cloud_shadow")  # Shadow art (null = the soft disc).
	var soft := TdVfx._soft()  # Soft round mask.
	for c: Array in rule.call("clouds"):
		var rad := float(c[1])  # Px.
		draw_texture_rect(cloud if cloud != null else soft, Rect2(Vector2(c[0]) - Vector2(rad, rad * 0.8), Vector2(rad, rad * 0.8) * 2.0), false, rr["cloud_tint"])
	var st: Dictionary = rr["shade_towers"]
	for t: Tower in rule.game.towers:
		if st.has(t.tower_id):
			var sr := float(st[t.tower_id])  # Shade px.
			draw_texture_rect(cloud if cloud != null else soft, Rect2(t.position - Vector2(sr, sr * 0.8), Vector2(sr, sr * 0.8) * 2.0), false, rr["shade_tint"])
	var lr := float(rr["lit_r"])  # Glare px.
	for t: Tower in rule.get("lit"):
		if is_instance_valid(t):
			draw_texture_rect(soft, Rect2(t.position - Vector2(lr, lr * 0.6), Vector2(lr, lr * 0.6) * 2.0), false, rr["lit_tint"])
	var ring := TdArt.texture("range_ring")  # Saved-by-shade ring.
	for t: Tower in rule.get("saved"):
		if is_instance_valid(t) and ring != null:
			draw_texture_rect(ring, Rect2(t.position - Vector2(lr, lr * 0.6), Vector2(lr, lr * 0.6) * 2.0), false, rr["shaded_tint"])


## Glow child callback: every shaft, burning or telegraphed (additive).
func draw_light(ci: CanvasItem) -> void:
	var rr: Dictionary = Acts.data("host")["RULE"]
	var band := SpriteBank.texture("fx/host_shaft")  # The shaft art (32 x 128, long axis vertical).
	var line := SpriteBank.texture("fx/host_shaft_line")  # The telegraph line art.
	var soft := TdVfx._soft()
	var c := MapView.SIZE * 0.5  # Map centre.
	var ln := MapView.SIZE.length() * 0.5  # Half the band's length (px).
	var g: TdGame = rule.game
	var pulse := 0.6 + 0.4 * sin(g.time * 8.0)  # Telegraph pulse.
	var seg := float(rr["seg_px"])  # Px of one band piece along the shaft.
	var map := Rect2(Vector2.ZERO, MapView.SIZE)  # Pieces outside the map are skipped (no glow past its edge).
	for sh: Dictionary in rule.get("shafts"):
		var n: Vector2 = sh["n"]
		var w := float(rule.call("shaft_width", sh))  # Px.
		var s := float(rule.call("shaft_s", sh))  # Centre line (px along n).
		var burn := bool(rule.call("burning", sh))
		var moving := float(sh["speed"]) > 0.0
		if not burn and moving:
			s = -float(rule.call("half_extent", n)) + w * 0.5  # Telegraph just inside the edge it enters by.
		var along := Vector2(-n.y, n.x)  # The band's long axis.
		var y := -ln
		while y < ln:
			var mid := c + n * s + along * (y + seg * 0.5)  # This piece's centre (map px).
			if map.has_point(mid):
				ci.draw_set_transform(mid, n.angle(), Vector2.ONE)
				var rect := Rect2(Vector2(-w * 0.5, -seg * 0.5), Vector2(w, seg))  # The piece in its own frame.
				var src := Rect2(0.0, fposmod(y, maxf(128.0 - seg, 1.0)), 32.0, minf(seg, 128.0)) if band != null else Rect2()  # Texels of the band art.
				if burn:
					if band != null:
						ci.draw_texture_rect_region(band, rect, src, rr["shaft_tint"])
					else:
						ci.draw_texture_rect(soft, rect, false, rr["shaft_tint"])
					if line != null:
						ci.draw_texture_rect(line, Rect2(Vector2(-3.0, -seg * 0.5), Vector2(6.0, seg)), false, rr["shaft_core"])
					if moving and not TdVfx.reduced():
						ci.draw_texture_rect(soft, Rect2(Vector2(w * 0.5, -seg * 0.5), Vector2(float(rr["path_ahead"]), seg)), false, rr["path_tint"])
				else:
					ci.draw_texture_rect(soft, rect, false, Color(rr["warn_tint"], float(rr["warn_band"]) * pulse))
					var wt: Color = rr["warn_tint"]
					for x: float in [-w * 0.5, w * 0.5]:
						ci.draw_texture_rect(line if line != null else soft, Rect2(Vector2(x - 2.0, -seg * 0.5), Vector2(4.0, seg)), false, Color(wt, wt.a * pulse))
			y += seg
	ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	_draw_fear(ci, g)


## Be Not Afraid's warning: four pulsing edge bands, stronger as it nears.
func _draw_fear(ci: CanvasItem, g: TdGame) -> void:
	var left := 0.0  # Share of the warning still to run (0 = none coming).
	for e: TdEnemy in g.enemies:
		var at := float(e.vars.get("fear_at", 0.0))  # When it lands (the Voice only).
		if e.kind == "host_voice" and at > g.time:
			left = clampf((at - g.time) / float(e.row["args"]["fear_warn"]), 0.0, 1.0)
	if left <= 0.0:
		return
	var lk: Dictionary = Acts.data("host")["LOOK"]
	var c: Color = lk["fear_band"]
	c.a *= (0.6 + 0.4 * (1.0 - left)) * (0.75 + 0.25 * sin(g.time * float(lk["fear_band_pulse"])))
	var sz := MapView.SIZE  # Map size (px).
	var dh := sz.y * float(lk["fear_band_depth"])  # Band depth (px).
	if _band_tex == null:
		var gr := Gradient.new()
		gr.set_color(0, Color.WHITE)
		gr.set_color(1, Color(1, 1, 1, 0))
		_band_tex = GradientTexture2D.new()
		_band_tex.gradient = gr
		_band_tex.fill_from = Vector2(0.5, 0.0)
		_band_tex.fill_to = Vector2(0.5, 1.0)
		_band_tex.width = 8
		_band_tex.height = 64
	ci.draw_texture_rect(_band_tex, Rect2(0, 0, sz.x, dh), false, c)
	ci.draw_set_transform(Vector2(0, sz.y), PI, Vector2(-1, 1))
	ci.draw_texture_rect(_band_tex, Rect2(0, 0, sz.x, dh), false, c)
	ci.draw_set_transform(Vector2.ZERO, -PI * 0.5, Vector2(-1, 1))
	ci.draw_texture_rect(_band_tex, Rect2(0, 0, sz.y, dh), false, c)
	ci.draw_set_transform(Vector2(sz.x, 0), PI * 0.5, Vector2.ONE)
	ci.draw_texture_rect(_band_tex, Rect2(0, 0, sz.y, dh), false, c)
	ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
