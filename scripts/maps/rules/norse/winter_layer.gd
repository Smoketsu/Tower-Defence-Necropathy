## WinterLayer: the look of the Long Winter (rules/norse/long_winter.gd), a node
## under game.world drawn UNDER the units (z -2): each brazier (the lit or
## doused 8-frame loop, a doused one tinted cold), the warmth's real edge round
## a lit brazier, a rime ring under every chilled tower, Sigrun's Holmgang
## square round her duel post, and frost bands creeping in from the map's
## edges as the cold rises (norse/frost_creep tiled along each edge: edge
## bands, never a full-screen overlay). Its child Glow draws the braziers' warm
## glows additively (dropped on Reduced effects). It also takes taps on a
## doused brazier (relight for souls). Drawing only: it never writes run state
## except through rule.relight().
extends Node2D

## Additive glow child: draws back through its WinterLayer.
class Glow:
	extends Node2D
	## The layer drawing through it.
	var owner_layer: Node2D = null

	func _draw() -> void:
		owner_layer.call("draw_glows", self)

## The act rule (a long_winter.gd instance).
var rule: MapRule = null
## The additive glow child.
var _glow: Glow = null
## Last brazier animation frame drawn (redraw only when it changes).
var _frame: int = -1


func _ready() -> void:
	z_index = -2  # Over the floor, roads and spots; under the units.
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED  # The frost band tiles along each edge.
	_glow = Glow.new()
	_glow.owner_layer = self
	_glow.z_index = 1
	_glow.material = TdVfx.additive()
	add_child(_glow)


func _process(_delta: float) -> void:
	var f := int(rule.game.time * float(Acts.data("norse")["RULE"]["anim_fps"])) % 8  # Brazier loop frame.
	if f != _frame:
		_frame = f
		queue_redraw()
		_glow.queue_redraw()


func _draw() -> void:
	var rr: Dictionary = Acts.data("norse")["RULE"]
	var lv := int(rule.get("level"))  # Cold level.
	var ring := TdArt.texture("range_ring")  # Real edges.
	if lv > 0 and ring != null:
		var rd := float(rr["rime_d"])  # Rime ring size (px).
		for t: Tower in rule.game.towers:
			if t.vars.has("k_cold"):
				draw_texture_rect(ring, Rect2(t.position - Vector2(rd, rd) * 0.5, Vector2(rd, rd)), false, rr["rime"])
	var wr := float(rr["warm_radius"])  # Warmth radius (px).
	for b: Dictionary in rule.get("braziers"):
		var p: Vector2 = b["pos"]
		var lit := bool(b["lit"])  # Burning now.
		if lit and lv > 0 and ring != null:
			draw_texture_rect(ring, Rect2(p - Vector2(wr, wr), Vector2(wr, wr) * 2.0), false, rr["warm_ring"])
		var key := "norse/brazier_lit_anim" if lit else "norse/brazier_doused_anim"  # Its loop.
		if not SpriteBank.draw_flat_frame(self, key, 8, maxi(_frame, 0), p, 0.0, Color.WHITE if lit else rr["doused_tint"]):
			SpriteBank.draw(self, "norse/brazier_lit" if lit else "norse/brazier_doused", p, false)
	var dt: Tower = rule.get("duel_tower")
	if dt != null and is_instance_valid(dt):
		_draw_duel(dt.position)
	var fp := float(rr["frost_px"][mini(lv, (rr["frost_px"] as Array).size() - 1)])  # Frost band depth (px).
	var tex := SpriteBank.texture("norse/frost_creep")
	if fp > 0.0 and tex != null:
		var sz := MapView.SIZE
		var tint: Color = rr["frost_tint"]
		var w := float(tex.get_width()) * fp / float(tex.get_height())  # Tile width at that depth (px).
		for edge: Array in [[Vector2.ZERO, 0.0, sz.x], [Vector2(sz.x, sz.y), PI, sz.x], [Vector2(0, sz.y), -PI * 0.5, sz.y], [Vector2(sz.x, 0), PI * 0.5, sz.y]]:
			draw_set_transform(edge[0], float(edge[1]))
			draw_texture_rect_region(tex, Rect2(0, 0, float(edge[2]), fp), Rect2(0, 0, float(edge[2]) / w * float(tex.get_width()), float(tex.get_height())), tint)
		draw_set_transform(Vector2.ZERO, 0.0)


## The Holmgang's hazel square round the duel post at `c` (four rods of the shared disc, textures only).
func _draw_duel(c: Vector2) -> void:
	var lk: Dictionary = Acts.data("norse")["LOOK"]
	var h := float(lk["duel_half"])  # Half side (px).
	var w := float(lk["duel_rod"])  # Rod thickness (px).
	var tint: Color = lk["duel_tint"]
	var disc := SpriteBank.disc()
	for r: Rect2 in [Rect2(c.x - h, c.y - h, h * 2.0, w), Rect2(c.x - h, c.y + h - w, h * 2.0, w), Rect2(c.x - h, c.y - h, w, h * 2.0), Rect2(c.x + h - w, c.y - h, w, h * 2.0)]:
		draw_texture_rect(disc, r, false, tint)
	for k in 4:
		var corner := c + Vector2(h if k % 2 == 1 else -h, h if k >= 2 else -h)  # Corner rod.
		SpriteBank.draw_disc(self, corner, w * 1.4, tint)


## Glow child callback: a warm additive glow on each lit brazier (not on Reduced effects).
func draw_glows(ci: CanvasItem) -> void:
	if TdVfx.reduced():
		return
	var rr: Dictionary = Acts.data("norse")["RULE"]
	var g := float(rr["glow_r"])  # Glow radius (px).
	var flick := 1.0 + 0.06 * sin(float(_frame) * 1.7)  # A small flicker with the loop.
	for b: Dictionary in rule.get("braziers"):
		if bool(b["lit"]):
			ci.draw_texture_rect(TdVfx._soft(), Rect2(Vector2(b["pos"]) - Vector2(g, g + 10.0) * flick, Vector2(g, g) * 2.0 * flick), false, rr["glow"])


## A tap on a doused brazier relights it (souls); other taps pass on to the map.
func _unhandled_input(event: InputEvent) -> void:
	var mb := event as InputEventMouseButton  # Touch arrives as emulated clicks.
	if mb == null or not mb.pressed or mb.button_index != MOUSE_BUTTON_LEFT or rule.game.armed >= 0:
		return
	var p: Vector2 = rule.game.world.get_global_transform_with_canvas().affine_inverse() * mb.position  # Map px.
	var br: Array = rule.get("braziers")
	for i in br.size():
		if not bool(br[i]["lit"]) and p.distance_to(br[i]["pos"]) <= float(Acts.data("norse")["RULE"]["tap_radius"]):
			rule.call("relight", i)
			get_viewport().set_input_as_handled()
			return
