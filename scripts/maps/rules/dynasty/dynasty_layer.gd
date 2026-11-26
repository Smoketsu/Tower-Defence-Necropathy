## DynastyLayer: the look of Rebirth and the Names (rules/dynasty/rebirth.gd),
## a node under game.world drawn UNDER the units (z -2): every Name's fallen
## body (a corpse decal), the gold thread from its jar to it and its rise timer
## (a small bar filling up); a gold glow under every standing jar; the marked jar's pulsing gold ring; the sand band
## of a storm (soft sand textures across the map's height; a faint strip at the
## edge while it gathers). It takes taps on a jar (mark / let go). Textures and
## rects only, redrawn every frame (a handful of items). Drawing only: it never
## writes run state except through rule.toggle_mark(). Numbers in LOOK.
extends Node2D

## The act rule (a rebirth.gd instance).
var rule: MapRule = null
## Cached textures: corpse decal, soft disc, streak mask, range ring.
var _corpse: Texture2D = null
## See _corpse.
var _soft: Texture2D = null
## See _corpse.
var _ring: Texture2D = null


func _ready() -> void:
	z_index = -2  # Over the floor and roads, under the units.
	_corpse = SpriteBank.texture("decals/corpse")
	_soft = TdVfx._soft()
	_ring = TdArt.texture("range_ring")


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var lk: Dictionary = Acts.data("dynasty")["LOOK"]
	var g: TdGame = rule.game
	var gold: Color = lk["gold"]
	for nm: Dictionary in rule.get("names"):
		var n: TdEnemy = nm["e"]
		var j: TdEnemy = nm["jar"]
		if not TdEnemy.valid(n, int(nm["gen"])) or not TdEnemy.valid(j, int(nm["jar_gen"])):
			continue
		var d := n.position - j.position  # Jar -> Name.
		if not TdVfx.reduced():
			TdVfx.draw_streak(self, _soft, n.position, d.angle(), d.length(), float(lk["link_w"]), Color(gold, float(lk["link_a"])))
		if _corpse != null:
			SpriteBank.apply_sharp(self)
			draw_texture(_corpse, (n.position - _corpse.get_size() * 0.5 + Vector2(0, 6)).round(), Color(1, 1, 1, 0.85))
		var span := maxf(float(nm["rise_at"]) - float(nm["laid"]), 0.01)  # Its whole wait (s).
		var f := clampf((g.time - float(nm["laid"])) / span, 0.0, 1.0)  # 0..1 toward rising.
		var w := float(lk["timer_w"])  # Bar width (px).
		var o := n.position + Vector2(-w * 0.5, float(lk["timer_y"]))  # Bar corner.
		draw_rect(Rect2(o, Vector2(w, 3.0)), Color(0, 0, 0, 0.7))
		draw_rect(Rect2(o, Vector2(w * f, 3.0)), gold.lerp(Color(1.0, 0.3, 0.2), f))
	var jr := float(lk["jar_glow"])  # Glow under every standing jar, so a small jar reads (px).
	for p: Array in rule.call("live_jars"):
		var jp: Vector2 = (p[0] as TdEnemy).position
		draw_texture_rect(_soft, Rect2(jp - Vector2(jr, jr * 0.6), Vector2(jr * 2.0, jr * 1.2)), false, Color(gold, 0.45))
	var m: TdEnemy = rule.get("marked")
	if m != null and TdEnemy.valid(m, int(rule.get("marked_gen"))) and _ring != null:
		var pr := float(lk["mark_r"]) * (1.0 + 0.12 * sin(g.time * 6.0))  # Pulsing radius (px).
		draw_texture_rect(_ring, Rect2(m.position - Vector2(pr, pr), Vector2(pr, pr) * 2.0), false, Color(gold, 0.9))
		draw_texture_rect(_soft, Rect2(m.position - Vector2(pr, pr), Vector2(pr, pr) * 2.0), false, Color(gold, 0.25))
	if bool(rule.get("storm_on")):
		_draw_storm(g, lk)


## The sand band (or its gathering strip at the edge it comes from).
func _draw_storm(g: TdGame, lk: Dictionary) -> void:
	var rr: Dictionary = Acts.data("dynasty")["RULE"]
	var w := float(rr["storm_width"])  # Band width (px).
	var sand: Color = lk["sand"]
	var x := float(rule.get("storm_x"))  # Band centre (px).
	var a := float(lk["storm_a"])  # Band alpha.
	if g.time < float(rule.get("storm_go")):
		a *= 0.35 + 0.25 * sin(g.time * 8.0)  # The telegraph: the band gathers at the edge, pulsing.
		x += float(rule.get("storm_dir")) * w * 0.35
	var step := float(lk["storm_puff"])  # Px between puffs down the band.
	var y := -step * 0.5
	var k := 0  # Puff index (sways alternate puffs).
	while y < MapView.SIZE.y + step:
		var sway := sin(g.time * 2.0 + float(k)) * w * 0.12  # Drifting sand (drawn only).
		draw_texture_rect(_soft, Rect2(Vector2(x - w * 0.6 + sway, y - step), Vector2(w * 1.2, step * 2.0)), false, Color(sand, a))
		y += step
		k += 1


## A tap on a jar (or a wine jar) marks it (or lets it go); other taps pass on to the map.
func _unhandled_input(event: InputEvent) -> void:
	var mb := event as InputEventMouseButton  # Touch arrives as emulated mouse clicks.
	if mb == null or not mb.pressed or mb.button_index != MOUSE_BUTTON_LEFT or rule.game.armed >= 0:
		return
	var p := get_global_transform_with_canvas().affine_inverse() * mb.position  # Map px.
	var tr := float(Acts.data("dynasty")["LOOK"]["tap_radius"])  # Pick radius (px).
	for j: TdEnemy in rule.call("markables"):
		if p.distance_to(j.position) <= tr:
			rule.call("toggle_mark", j)
			get_viewport().set_input_as_handled()
			return
