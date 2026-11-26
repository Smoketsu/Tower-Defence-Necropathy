## EyeLayer: the look of Claims (rules/eye/claims.gd), a node under game.world
## drawn UNDER the units (z -2): a drowned-teal disc and ring of each
## claimer's real reach (Chanters, Hierophants, cursed cultists), the spore
## clouds; its child Top draws OVER the units: the Scribe's ink sigil above
## every cursed cultist. Textures only, a few rects per frame. Drawing only:
## it never writes run state. Numbers in the act data's RULE.
extends Node2D

## Child drawn over the units: draws back through its EyeLayer.
class Top:
	extends Node2D
	## The layer drawing through it.
	var owner_layer: Node2D = null

	func _draw() -> void:
		owner_layer.call("draw_top", self)

## The act rule (a claims.gd instance).
var rule: MapRule = null
## The over-the-units child.
var _top: Top = null


func _ready() -> void:
	z_index = -2  # Over the floor, roads and spots; under the units.
	_top = Top.new()
	_top.owner_layer = self
	_top.z_index = 6
	_top.z_as_relative = false
	add_child(_top)


func _process(_delta: float) -> void:
	queue_redraw()
	_top.queue_redraw()


func _draw() -> void:
	var rr: Dictionary = Acts.data("eye")["RULE"]
	var soft := TdVfx._soft()  # Soft round mask.
	var ring := TdArt.texture("range_ring")  # The reach edge.
	var g: TdGame = rule.game
	var pulse := 0.85 + 0.15 * sin(g.time * 3.0)  # A slow breath.
	for e: TdEnemy in g.enemies:
		var reach := float(rule.call("claim_reach", e))  # Px (0 = not a claimer).
		if reach <= 0.0:
			continue
		var rect := Rect2(e.position - Vector2(reach, reach), Vector2(reach, reach) * 2.0)
		draw_texture_rect(soft, rect, false, Color(rr["aura_tint"], (rr["aura_tint"] as Color).a * pulse))
		if ring != null:
			draw_texture_rect(ring, rect, false, rr["aura_ring"])
	for c: Array in rule.get("clouds"):
		var cr := float(c[1])  # Px.
		var left := clampf((float(c[2]) - g.time) / 1.0, 0.0, 1.0)  # Fades in its last second.
		draw_texture_rect(soft, Rect2(Vector2(c[0]) - Vector2(cr, cr), Vector2(cr, cr) * 2.0), false, Color(rr["cloud_tint"], (rr["cloud_tint"] as Color).a * left))
		if not TdVfx.reduced():
			SpriteBank.draw_anim(self, "spore_cloud", c[0], cr * 2.0, fposmod(g.time * 0.5, 1.0), 0.5 * left, rr["cloud_tint"])


## Top child callback: the ink sigil over every cursed cultist.
func draw_top(ci: CanvasItem) -> void:
	var rr: Dictionary = Acts.data("eye")["RULE"]
	var g: TdGame = rule.game
	var px := float(rr["curse_px"])  # Sigil size.
	for e: TdEnemy in g.enemies:
		if g.time < float(e.vars.get("claimer_until", 0.0)):
			var h := SpriteBank.drawn_height(String(e.row["sprite"]))  # Its height (px).
			var p := e.position + Vector2(0, -h * 0.5 - 14.0 - px * 0.5)  # Above its head.
			ci.draw_texture_rect(TdVfx._soft(), Rect2(p - Vector2(px, px), Vector2(px, px) * 2.0), false, Color(rr["curse_tint"], 0.5))
			if not SpriteBank.draw_icon_art(ci, "marginalia", Rect2(p - Vector2(px, px) * 0.5, Vector2(px, px))):
				SpriteBank.draw_disc(ci, p, px * 0.4, rr["curse_tint"])
