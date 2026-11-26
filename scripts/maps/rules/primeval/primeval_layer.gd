## PrimevalLayer: the look of the Stampedes and the map twists
## (rules/primeval/stampedes.gd), a node under game.world drawn UNDER the units
## (z -2): the Fern Basin's tar seeps (fx/prim_tar_pool), the Great Plain's
## watering hole (fx/prim_water_pool), a meteor's landing circle
## (markers/primeval_bomb, growing as it nears) and, while a herd is marked,
## its trail: a pulsing dust line (fx/primeval_dust_line), dust fronts running
## down it like arrows (fx/primeval_dust_front) and a pulsing ring under every
## plot in its path. Its child Glow draws the falling meteors additively.
## Textures only, a few rects per frame. Drawing only: never writes run state.
extends Node2D

## Additive glow child: draws back through its layer.
class Glow:
	extends Node2D
	## The layer drawing through it.
	var owner_layer: Node2D = null

	func _draw() -> void:
		owner_layer.call("draw_glow", self)

## The act rule (a stampedes.gd instance).
var rule: MapRule = null
## The additive glow child.
var _glow: Glow = null


func _ready() -> void:
	z_index = -2  # Over the floor, roads and spots; under the units.
	_glow = Glow.new()
	_glow.owner_layer = self
	_glow.z_index = 12
	_glow.material = TdVfx.additive()
	add_child(_glow)


func _process(_delta: float) -> void:
	queue_redraw()
	_glow.queue_redraw()


func _draw() -> void:
	var rr: Dictionary = Acts.data("primeval")["RULE"]
	var g: TdGame = rule.game
	var tar := SpriteBank.texture("fx/prim_tar_pool")  # Pool art (96 px, soft edge).
	for t: Array in rule.get("tar"):
		var rad := float(t[1]) * 1.15  # The art's soft edge reaches past the slowing radius.
		draw_texture_rect(tar if tar != null else TdVfx._soft(), Rect2(Vector2(t[0]) - Vector2(rad, rad), Vector2(rad, rad) * 2.0), false, rr["pool_tar"])
	var hole: Array = rule.get("hole")
	if not hole.is_empty():
		var wt := SpriteBank.texture("fx/prim_water_pool")
		var rad := float(hole[1]) * 1.15
		draw_texture_rect(wt if wt != null else TdVfx._soft(), Rect2(Vector2(hole[0]) - Vector2(rad, rad), Vector2(rad, rad) * 2.0), false, rr["pool_hole"])
	var pulse := 0.6 + 0.4 * sin(g.time * 7.0)  # Warning pulse.
	var bomb := SpriteBank.texture("markers/primeval_bomb")  # Landing ring art (64 px).
	var m: Dictionary = rr["meteor"]
	for mt: Array in rule.get("meteors"):
		var k := clampf((g.time - float(mt[2])) / float(m["delay"]), 0.0, 1.0)  # 0..1 through the fall.
		var rad := float(m["radius"]) * (0.7 + 0.3 * k)
		var c: Color = rr["meteor_tint"]
		draw_texture_rect(TdVfx._soft(), Rect2(Vector2(mt[0]) - Vector2(rad, rad * 0.7), Vector2(rad, rad * 0.7) * 2.0), false, Color(c, 0.25 + 0.25 * k))
		if bomb != null:
			draw_texture_rect(bomb, Rect2(Vector2(mt[0]) - Vector2(rad, rad), Vector2(rad, rad) * 2.0), false, Color(1, 1, 1, 0.5 + 0.5 * pulse))
	var line := SpriteBank.texture("fx/primeval_dust_line")  # 4 x 128, long axis vertical.
	var front := SpriteBank.texture("fx/primeval_dust_front")  # 56 x 128 dust front.
	var ring := TdArt.texture("range_ring")
	var dust: Color = rr["dust_tint"]
	var mp := float(rr["mark_px"])
	for tid: String in rule.call("marked"):
		var rd: Road = g.roads[tid]
		for i in range(rd.points.size() - 1):
			var a: Vector2 = rd.points[i]
			var b: Vector2 = rd.points[i + 1]
			var len := a.distance_to(b)
			draw_set_transform((a + b) * 0.5, (b - a).angle() + PI * 0.5, Vector2.ONE)
			var w := float(rr["dust_w"])
			draw_texture_rect(line if line != null else TdVfx._soft(), Rect2(-w * 0.5, -len * 0.5, w, len), false, Color(dust, dust.a * pulse))
		var step := float(rr["arrow_every"])
		var ap := float(rr["arrow_px"])
		var d := fposmod(g.time * float(rr["arrow_speed"]), step)
		while d < rd.length:
			var p := rd.point_at(d)
			if Rect2(Vector2.ZERO, MapView.SIZE).has_point(p):
				draw_set_transform(p, rd.dir_at(d).angle() + PI * 0.5, Vector2.ONE)
				draw_texture_rect(front if front != null else TdVfx._soft(), Rect2(-ap * 0.5, -ap * 0.4, ap, ap * 0.8), false, Color(1, 1, 1, 0.85))
			d += step
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		for sid: String in rule.get("marked_plots")[tid]:
			var s := g.spot_by_id(sid)
			if s != null and ring != null:
				draw_texture_rect(ring, Rect2(s.position - Vector2(mp, mp * 0.7), Vector2(mp, mp * 0.7) * 2.0), false, Color(rr["mark_tint"], pulse))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


## Glow child callback: each falling meteor, a burning rock streaking down at a slant.
func draw_glow(ci: CanvasItem) -> void:
	var rr: Dictionary = Acts.data("primeval")["RULE"]
	var g: TdGame = rule.game
	var m: Dictionary = rr["meteor"]
	var lift := float(rr["meteor_lift"])
	var px := float(rr["meteor_px"])
	var tint: Color = rr["meteor_tint"]
	for mt: Array in rule.get("meteors"):
		var k := clampf((g.time - float(mt[2])) / float(m["delay"]), 0.0, 1.0)
		var off := Vector2(lift * 0.35, -lift) * (1.0 - k)  # Falls in from the upper right.
		var p: Vector2 = Vector2(mt[0]) + off
		TdVfx.draw_streak(ci, TdVfx._soft(), p, Vector2(-0.35, 1.0).angle(), px * 6.0, px, Color(tint, 0.8 * (1.0 - k * 0.5)))
		ci.draw_texture_rect(TdVfx._soft(), Rect2(p - Vector2(px, px) * 1.6, Vector2(px, px) * 3.2), false, Color(1.0, 0.75, 0.4, 0.95))
