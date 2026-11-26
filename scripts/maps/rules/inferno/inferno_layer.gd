## InfernoLayer: the look of the Portals act rule (rules/inferno/portals.gd),
## a node under game.world drawn UNDER the units (z -2): each marked portal's
## pulsing charm-pink warning ring and its seal radius, each open portal's
## seal radius, each Hell Pit (a closing rim while it telegraphs, then a dark
## burning core) and, on an additive child, the portals' swirling glow and the
## pits' lava glow. Textures only (the shared disc, the soft glow, the range
## ring and the telegraph circle); drawing only, never read by the simulation.
## Colours in the act's RULE.
extends Node2D

## Additive glow child: draws back through its layer.
class Glow:
	extends Node2D
	## The layer drawing through it.
	var owner_layer: Node2D = null

	func _draw() -> void:
		owner_layer.call("draw_glows", self)

## The act rule (a portals.gd instance).
var rule: MapRule = null
## The additive glow child.
var _glow: Glow = null


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
	var rr: Dictionary = Acts.data("inferno")["RULE"]
	var t := rule.game.time  # Game s.
	var ring := TdArt.texture("range_ring")  # Grey ring mask.
	var tg := SpriteBank.texture("telegraphs/target")  # Closing telegraph circle.
	var sr := float(rr["seal_radius"])  # Seal radius (px).
	for p: Dictionary in rule.get("portals"):
		var st := String(p["state"])
		var at: Vector2 = p["at"]
		if ring != null and (st == "marked" or st == "open"):
			draw_texture_rect(ring, Rect2(at - Vector2(sr, sr), Vector2(sr, sr) * 2.0), false, rr["seal_ring"])
		if st == "marked":
			var pulse := 0.75 + 0.25 * sin(t * 5.0)  # Warning pulse.
			var mr := float(rr["mark_r"]) * pulse  # Px.
			if tg != null:
				draw_texture_rect(tg, Rect2(at - Vector2(mr, mr), Vector2(mr, mr) * 2.0), false, rr["mark_tint"])
	for pit: Dictionary in rule.get("pits"):
		var pos: Vector2 = pit["pos"]
		var rad := float(pit["radius"])  # Px.
		if t < float(pit["burn"]):
			var k := (t - float(pit["start"])) / maxf(float(pit["burn"]) - float(pit["start"]), 0.05)  # 0..1 to burning.
			var rc := rad * (1.3 - 0.3 * clampf(k, 0.0, 1.0))  # Closing rim (px).
			if tg != null:
				draw_texture_rect(tg, Rect2(pos - Vector2(rc, rc), Vector2(rc, rc) * 2.0), false, rr["pit_rim"])
			continue
		var fade := clampf((float(pit["until"]) - t) / 0.6, 0.0, 1.0)  # Cools at the end.
		var core: Color = rr["pit_core"]
		draw_texture_rect(SpriteBank.disc(), Rect2(pos - Vector2(rad, rad * 0.6), Vector2(rad, rad * 0.6) * 2.0), false, Color(core, core.a * fade))


## Additive child: portal swirls and pit glows.
func draw_glows(ci: CanvasItem) -> void:
	if TdVfx.reduced():
		return
	var rr: Dictionary = Acts.data("inferno")["RULE"]
	var t := rule.game.time  # Game s.
	var soft := TdVfx._soft()  # Soft round glow.
	for p: Dictionary in rule.get("portals"):
		if String(p["state"]) != "open":
			continue
		var g := float(rr["portal_glow_r"]) * (0.9 + 0.1 * sin(t * 3.0))  # Swirling glow (px).
		ci.draw_texture_rect(soft, Rect2(Vector2(p["at"]) - Vector2(g, g), Vector2(g, g) * 2.0), false, rr["portal_glow"])
	for pit: Dictionary in rule.get("pits"):
		if t < float(pit["burn"]):
			continue
		var rad := float(pit["radius"]) * (1.25 + 0.08 * sin(t * 7.0 + float(pit["burn"])))  # Flickering lava glow (px).
		var fade := clampf((float(pit["until"]) - t) / 0.6, 0.0, 1.0)  # Cools at the end.
		var c: Color = rr["pit_glow"]
		ci.draw_texture_rect(soft, Rect2(Vector2(pit["pos"]) - Vector2(rad, rad * 0.7), Vector2(rad, rad * 0.7) * 2.0), false, Color(c, c.a * fade))
