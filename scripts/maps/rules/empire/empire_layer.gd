## EmpireLayer: the look of the Lock-On (rules/empire/line_of_fire.gd), a node
## under game.world drawn over the units (z 4, additive): for every live paint a
## red line from the shooter to the painted tower that thickens and pulses
## faster as the shot nears, and a closing reticle (telegraphs/target) on the
## tower. Textures only, two rects per paint. Drawing only: it never writes run
## state. Numbers in the act data's LOOK (lock_*).
extends Node2D

## The act rule (a line_of_fire.gd instance).
var rule: MapRule = null


func _ready() -> void:
	z_index = 4  # Over the units, under the hostile shots (5).
	material = TdVfx.additive()


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var lk: Dictionary = Acts.data("empire")["LOOK"]
	var g: TdGame = rule.game
	var streak := TdArt.texture("vfx_streak")  # Line mask.
	var tg := SpriteBank.texture("telegraphs/target")  # Reticle.
	var lt := float(Acts.data("empire")["RULE"]["lock_time"])  # Paint length (s).
	for l: Dictionary in rule.get("locks"):
		var e: TdEnemy = l["e"]
		var t: Tower = l["t"]
		if not (is_instance_valid(t) and e.alive):
			continue
		var p := clampf((g.time - float(l["born"])) / lt, 0.0, 1.0)  # 0..1 to the shot.
		var pulse := 0.6 + 0.4 * sin(g.time * TAU * lerpf(2.0, 7.0, p))  # Faster as it nears.
		var from := e.position + Vector2(0, -14)  # The shooter's muzzle.
		var tint: Color = lk["lock_tint"]
		if streak != null:
			TdVfx.draw_streak(self, streak, t.position, (t.position - from).angle(), from.distance_to(t.position),
					lerpf(float(lk["lock_w0"]), float(lk["lock_w1"]), p), Color(tint, tint.a * pulse))
		if tg != null:
			var rr := float(lk["reticle"]) * (1.6 - 0.6 * p)  # Closing in (px).
			draw_texture_rect(tg, Rect2(t.position - Vector2(rr, rr), Vector2(rr, rr) * 2.0), false, Color(tint, 0.4 + 0.5 * pulse))
