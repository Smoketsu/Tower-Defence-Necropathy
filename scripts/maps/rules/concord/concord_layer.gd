## ConcordLayer: the look of Abduction (rules/concord/abduction.gd), a node
## under game.world. Under the units (z -2): the faint dashed sky lanes (drawn
## once into its Lanes child, never per frame), the light disc under a
## saucer's target and a burrow mound over every burrowed Concord enemy (vars
## "burrow_until"). Over the units, additively (its Glow child, z 7): each
## saucer's tractor cone growing from it to its target over the windup and the
## bright cone while it lifts, the column over each tower lifted out of the
## fight, and the trophy bomb's ring round Vrask'Tal while it counts down.
## Textures only (streak masks, the soft disc, the mound sprite), a few rects
## per frame. Drawing only: it never writes run state.
extends Node2D

## Additive glow child: draws back through its layer.
class Glow:
	extends Node2D
	## The layer drawing through it.
	var owner_layer: Node2D = null

	func _draw() -> void:
		owner_layer.call("draw_glow", self)

## Static child: the sky lanes, drawn once.
class Lanes:
	extends Node2D
	## The layer drawing through it.
	var owner_layer: Node2D = null

	func _draw() -> void:
		owner_layer.call("draw_lanes", self)

## The act rule (an abduction.gd instance).
var rule: MapRule = null
## The additive glow child.
var _glow: Glow = null


func _ready() -> void:
	z_index = -2  # Over the floor, roads and spots; under the units.
	var lanes := Lanes.new()  # Drawn once.
	lanes.owner_layer = self
	add_child(lanes)
	_glow = Glow.new()
	_glow.owner_layer = self
	_glow.z_index = 9  # Over the units.
	_glow.z_as_relative = false
	_glow.material = TdVfx.additive()
	add_child(_glow)


func _process(_delta: float) -> void:
	queue_redraw()
	_glow.queue_redraw()


## The sky lanes as dashes of the streak mask (once).
func draw_lanes(ci: CanvasItem) -> void:
	var rr: Dictionary = Acts.data("concord")["RULE"]
	var tex := TdArt.texture("vfx_streak")  # Streak mask.
	if tex == null:
		return
	var dash := float(rr["lane_dash"])  # Px.
	for rd: Road in rule.game.roads.values():
		if not rd.sky:
			continue
		var d := 0.0
		while d < rd.length:
			var p := rd.point_at(d + dash)
			ci.draw_set_transform(p, rd.dir_at(d).angle(), Vector2.ONE)
			ci.draw_texture_rect(tex, Rect2(-dash, -float(rr["lane_w"]) * 0.5, dash, float(rr["lane_w"])), false, rr["lane_tint"])
			d += dash * 2.0
		ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw() -> void:
	var rr: Dictionary = Acts.data("concord")["RULE"]
	var soft := TdVfx._soft()  # Soft round mask.
	var g := rule.game
	var mound := SpriteBank.texture("concord/burrow_mound")  # Mound art (null = the soft disc).
	var mpx := float(rr["mound_px"])  # Px.
	for e: TdEnemy in g.enemies:
		if g.time < float(e.vars.get("burrow_until", 0.0)):
			var tex := mound if mound != null else soft
			var sz := tex.get_size() * (mpx / maxf(tex.get_size().x, 1.0)) * (e.radius / 10.0)
			draw_texture_rect(tex, Rect2(e.position - Vector2(sz.x * 0.5, sz.y * 0.7), sz), false)
		var at := float(e.vars.get("beam_at", 0.0))  # Beaming saucer: the light disc on its target.
		if at > 0.0:
			var f := clampf((g.time - float(e.vars["beam_from"])) / maxf(at - float(e.vars["beam_from"]), 0.01), 0.0, 1.0)  # 0..1 of the windup.
			var r := lerpf(14.0, 40.0, f)  # Disc px.
			draw_texture_rect(soft, Rect2(Vector2(e.vars["target_pos"]) - Vector2(r, r * 0.55), Vector2(r, r * 0.55) * 2.0), false, rr["spot_tint"])


## The cones, the lifted columns and the trophy bomb ring (additive).
func draw_glow(ci: CanvasItem) -> void:
	var rr: Dictionary = Acts.data("concord")["RULE"]
	var lk: Dictionary = Acts.data("concord")["LOOK"]
	var tex := TdArt.texture("vfx_streak")  # Streak mask.
	var soft := TdVfx._soft()
	var g := rule.game
	if tex == null:
		return
	for e: TdEnemy in g.enemies:
		var at := float(e.vars.get("beam_at", 0.0))  # Lift time (0 = not beaming).
		var hold := g.time < float(e.vars.get("hold_until", 0.0))  # Lifting now.
		if at <= 0.0 and not hold:
			var bomb := float(e.vars.get("bomb_at", 0.0))  # Vrask'Tal's countdown (0 = none).
			if bomb > g.time:
				var br := float(e.row["args"].get("bomb_radius", 200.0))  # Its real reach (px).
				var ring := TdArt.texture("range_ring")
				var pulse := 0.6 + 0.4 * sin(g.time * 8.0)
				if ring != null:
					ci.draw_texture_rect(ring, Rect2(e.position - Vector2(br, br), Vector2(br, br) * 2.0), false, Color(lk["bomb_tint"], pulse))
			continue
		var top := e.position + Vector2(0, -10)  # The saucer's belly.
		var to: Vector2 = e.vars.get("target_pos", top)
		var f := 1.0 if hold else clampf((g.time - float(e.vars["beam_from"])) / maxf(at - float(e.vars["beam_from"]), 0.01), 0.0, 1.0)
		var w := lerpf(float(rr["cone_w0"]), float(rr["cone_w1"]), f)  # Px.
		var col: Color = rr["cone_hot"] if hold else rr["cone_tint"]
		ci.draw_set_transform(to, (to - top).angle(), Vector2.ONE)
		ci.draw_texture_rect(tex, Rect2(-top.distance_to(to), -w * 0.5, top.distance_to(to), w), false, col)
		ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		ci.draw_texture_rect(soft, Rect2(top - Vector2(18, 10), Vector2(36, 20)), false, col)
	var lw := float(rr["lifted_w"])  # Px.
	for l: Array in rule.get("lifted"):
		var t: Tower = l[0]
		if not is_instance_valid(t):
			continue
		var p := t.position
		var k := 0.75 + 0.25 * sin(g.time * 6.0)
		ci.draw_set_transform(p, -PI * 0.5, Vector2.ONE)
		ci.draw_texture_rect(tex, Rect2(-120.0, -lw * 0.5, 130.0, lw), false, Color(rr["lifted_tint"], float((rr["lifted_tint"] as Color).a) * k))
		ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		ci.draw_texture_rect(soft, Rect2(p - Vector2(lw * 0.6, lw * 0.3), Vector2(lw * 1.2, lw * 0.6)), false, rr["lifted_tint"])

