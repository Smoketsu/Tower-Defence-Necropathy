## YearLayer: the look of the Turning Year (rules/wild/turning_year.gd), a node
## under game.world drawn UNDER the units (z -2): a frost disc under every tower
## Winter chills, each thicket's sprout growing on its spot (markers/wild_sprout)
## and each grown thicket (obstacles/wild_thicket_m) choking it; its additive
## child Glow draws the season's colour as soft bands on the four map edges
## (never a full-screen overlay) and, on Full effects, a few drifting pieces of
## the season's ambient strip (gold leaves in Autumn, snow in Winter). A tap on
## a grown or sprouting thicket burns it (rule.burn(); souls). Textures only, a
## few rects per frame. Drawing only: it never writes run state except through
## rule.burn().
extends Node2D

## Additive glow child: draws back through its YearLayer.
class Glow:
	extends Node2D
	## The layer drawing through it.
	var owner_layer: Node2D = null

	func _draw() -> void:
		owner_layer.call("draw_glow", self)

## The act rule (a turning_year.gd instance).
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
	var rr: Dictionary = Acts.data("wild")["RULE"]
	var g: TdGame = rule.game
	var soft := TdVfx._soft()  # Soft round mask.
	if int(rule.get("season")) == 3:
		var cr := float(rr["chill_r"])  # Px.
		for t: Tower in g.towers:
			draw_texture_rect(soft, Rect2(t.position - Vector2(cr, cr * 0.6), Vector2(cr, cr * 0.6) * 2.0), false, rr["chill_tint"])
	var sprout := SpriteBank.texture("markers/wild_sprout")
	var thicket := SpriteBank.texture("obstacles/wild_thicket_m")
	for th: Dictionary in rule.get("thickets"):
		var p: Vector2 = (th["spot"] as Spot).position
		var left := float(th["at"]) - g.time  # S until it chokes.
		if left > 0.0:
			var k := 1.0 - clampf(left / float(rr["sprout"]), 0.0, 1.0)  # Growth 0..1.
			var px := float(rr["sprout_px"]) * (0.4 + 0.6 * k)
			var pulse := 0.6 + 0.4 * sin(g.time * 8.0)
			draw_texture_rect(soft, Rect2(p - Vector2(px, px * 0.5), Vector2(px, px)), false, Color(0.5, 1.0, 0.4, 0.35 * pulse))
			if sprout != null:
				draw_texture_rect(sprout, Rect2(p - Vector2(px * 0.5, px * 0.8), Vector2(px, px)), false)
		elif thicket != null:
			var tp := float(rr["thicket_px"])
			draw_texture_rect(thicket, Rect2(p - Vector2(tp * 0.5, tp * 0.75), Vector2(tp, tp)), false)


## Glow child callback: the season's edge bands and ambient drift (additive).
func draw_glow(ci: CanvasItem) -> void:
	var s := int(rule.get("season"))  # Season now.
	if s < 0:
		return
	var rr: Dictionary = Acts.data("wild")["RULE"]
	var g: TdGame = rule.game
	var c: Color = rr["tints"][s]
	c.a *= 0.8 + 0.2 * sin(g.time * 1.5)
	var sz := MapView.SIZE  # Map size (px).
	var dh := sz.y * float(rr["band_depth"])  # Band depth (px).
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
	var amb := String(rr["ambient"][s])  # Ambient strip ("" = none).
	if amb == "" or TdVfx.reduced():
		return
	var n := int(rr["ambient_n"])
	var per := float(rr["ambient_period"])
	for i in n:
		var ph := fposmod(g.time / per + float(i) * 0.37, 1.0)  # Loop phase (game time: drawing only).
		var x := fposmod(float(i) * 233.0 + g.time * 12.0, sz.x)  # Drifts sideways.
		var y := fposmod(float(i) * 151.0 + ph * sz.y, sz.y)  # And down.
		SpriteBank.draw_anim(ci, amb, Vector2(x, y), float(rr["ambient_d"]), ph, 0.6)


## A tap on a thicket burns it (souls); other taps pass on to the map.
func _unhandled_input(event: InputEvent) -> void:
	var mb := event as InputEventMouseButton  # Touch arrives as emulated clicks.
	if mb == null or not mb.pressed or mb.button_index != MOUSE_BUTTON_LEFT or rule.game.armed >= 0:
		return
	var p: Vector2 = rule.game.world.get_global_transform_with_canvas().affine_inverse() * mb.position  # Map px.
	var ths: Array = rule.get("thickets")
	for i in ths.size():
		if p.distance_to((ths[i]["spot"] as Spot).position) <= float(Acts.data("wild")["RULE"]["tap_radius"]):
			rule.call("burn", i)
			get_viewport().set_input_as_handled()
			return
