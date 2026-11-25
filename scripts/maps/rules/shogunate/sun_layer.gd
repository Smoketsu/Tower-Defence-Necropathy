## SunLayer: the look of the Sun's Course (rules/shogunate/sun_course.gd), a
## node under game.world drawn UNDER the units (z -2): the darkness texture
## (one texel per RULE `cell` px, alpha 0 inside a lit lantern's pool, RULE
## dusk_dark / night_dark beyond, tinted dusk orange or night indigo; bilinear
## between texels), each stone lantern's sprite (lit / unlit / doused tint) and
## the real edge of its light pool; its child Glow draws the lanterns' warm
## glows additively (dropped on Reduced effects). It also takes taps on a doused
## lantern (relight for souls). Rebuilt only when the rule changes (rebuild()).
## Drawing only: it never writes run state except through rule.relight().
extends Node2D

## Additive glow child: draws back through its SunLayer.
class Glow:
	extends Node2D
	## The layer drawing through it.
	var owner_layer: Node2D = null

	func _draw() -> void:
		owner_layer.call("draw_glows", self)

## The act rule (a sun_course.gd instance).
var rule: MapRule = null
## Darkness image (alpha = darkness) and its texture.
var _img: Image = null
## See _img.
var _tex: ImageTexture = null
## The additive glow child.
var _glow: Glow = null


func _ready() -> void:
	z_index = -2  # Over the floor, roads and spots; under the units.
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var cell := float(Acts.data("shogunate")["RULE"]["cell"])  # Px per texel.
	_img = Image.create(ceili(MapView.SIZE.x / cell), ceili(MapView.SIZE.y / cell), false, Image.FORMAT_RGBA8)
	_tex = ImageTexture.create_from_image(_img)
	_glow = Glow.new()
	_glow.owner_layer = self
	_glow.z_index = 1
	_glow.material = TdVfx.additive()
	add_child(_glow)
	rebuild()


## Recomputes the darkness from the rule's phase and lanterns, then redraws.
func rebuild() -> void:
	if _img == null:
		return
	var rr: Dictionary = Acts.data("shogunate")["RULE"]
	var phase := int(rule.get("phase"))  # 0 day, 1 dusk, 2 night.
	if phase > 0:
		var dark := float(rr["dusk_dark" if phase == 1 else "night_dark"])  # Alpha beyond the pools.
		var tint: Color = rr["dusk_tint" if phase == 1 else "night_tint"]
		var cell := float(rr["cell"])  # Px per texel.
		var rad := float(rr["light_radius"])  # Pool radius (px).
		var soft := rad * float(rr["pool_soft"])  # Px of the rim fade.
		var lit: Array[Vector2] = []  # Lit lantern positions.
		for l: Dictionary in rule.get("lanterns"):
			if bool(l["lit"]):
				lit.append(l["pos"])
		for y in _img.get_height():
			for x in _img.get_width():
				var p := Vector2((float(x) + 0.5) * cell, (float(y) + 0.5) * cell)  # Texel centre (map px).
				var light := 0.0  # 0 dark .. 1 lit.
				for q: Vector2 in lit:
					light = maxf(light, clampf((rad - p.distance_to(q)) / soft, 0.0, 1.0))
				_img.set_pixel(x, y, Color(tint, dark * (1.0 - light)))
		_tex.update(_img)
	queue_redraw()
	_glow.queue_redraw()


func _draw() -> void:
	var rr: Dictionary = Acts.data("shogunate")["RULE"]
	var phase := int(rule.get("phase"))  # 0 day, 1 dusk, 2 night.
	if phase > 0:
		draw_texture_rect(_tex, Rect2(Vector2.ZERO, MapView.SIZE), false)
	var ring := TdArt.texture("range_ring")  # The pools' real edge.
	var rad := float(rr["light_radius"])  # Pool radius (px).
	for l: Dictionary in rule.get("lanterns"):
		var p: Vector2 = l["pos"]
		var lit := bool(l["lit"])  # Burning now.
		if phase > 0 and lit and ring != null:
			draw_texture_rect(ring, Rect2(p - Vector2(rad, rad), Vector2(rad, rad) * 2.0), false, rr["ring"])
		var doused := phase > 0 and not lit  # Put out by a ninja.
		SpriteBank.draw(self, "obstacles/stone_lantern_lit" if lit and phase > 0 else "obstacles/stone_lantern", p, false, rr["doused_tint"] if doused else Color.WHITE)


## Glow child callback: a warm additive glow on each lit lantern (not on Reduced effects).
func draw_glows(ci: CanvasItem) -> void:
	var rr: Dictionary = Acts.data("shogunate")["RULE"]
	if int(rule.get("phase")) == 0 or TdVfx.reduced():
		return
	var g := float(rr["glow_r"])  # Glow radius (px).
	for l: Dictionary in rule.get("lanterns"):
		if bool(l["lit"]):
			ci.draw_texture_rect(TdVfx._soft(), Rect2(Vector2(l["pos"]) + Vector2(-g, -g - 12.0), Vector2(g, g) * 2.0), false, rr["glow"])


## A tap on a doused lantern relights it (souls); other taps pass on to the map.
func _unhandled_input(event: InputEvent) -> void:
	var mb := event as InputEventMouseButton  # Touch arrives as emulated clicks.
	if mb == null or not mb.pressed or mb.button_index != MOUSE_BUTTON_LEFT or rule.game.armed >= 0:
		return
	var p: Vector2 = rule.game.world.get_global_transform_with_canvas().affine_inverse() * mb.position  # Map px.
	var lan: Array = rule.get("lanterns")
	for i in lan.size():
		if not bool(lan[i]["lit"]) and p.distance_to(lan[i]["pos"]) <= float(Acts.data("shogunate")["RULE"]["tap_radius"]):
			rule.call("relight", i)
			get_viewport().set_input_as_handled()
			return
