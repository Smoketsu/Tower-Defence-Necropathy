## YearDial: the HUD cue of the Turning Year (rules/wild/turning_year.gd): the
## wheel of the year (markers/wild_season_wheel) on a dark disc in the screen's
## top-right corner, under the top bar (no Act XV road uses it), turned to the
## season, with a label to its left: "Summer: the Wild runs faster" in the
## season's colour, and the thickets choking towers ("2 choked") when there
## are any. Textures only. Drawing only. Numbers in the act data's RULE (dial_*).
extends Control

## The act rule (a turning_year.gd instance).
var rule: MapRule = null
## The label.
var _label: Label = null


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label = UiTheme.tier_label("", UiTheme.Tier.BODY, UiTheme.TEXT_GOLD)
	add_child(_label)


func _process(_delta: float) -> void:
	var rr: Dictionary = Acts.data("wild")["RULE"]
	var d := float(rr["dial_px"])  # Wheel size (px).
	var m: Vector2 = rr["dial_margin"]
	position = Vector2(get_viewport_rect().size.x - d - m.x, rule.game.top_inset + m.y)  # Top-right: off the roads.
	var s := maxi(int(rule.get("season")), 0)  # Season now.
	var choked := 0  # Thickets grown on a built spot.
	for th: Dictionary in rule.get("thickets"):
		choked += 1 if (th["spot"] as Spot).tower != null and rule.game.time >= float(th["at"]) else 0
	var txt := "%s: %s" % [String(rr["names"][s]), String(rr["rules"][s])]
	if choked > 0:
		txt += "  (%d choked)" % choked
	if _label.text != txt:
		_label.text = txt
		var c: Color = rr["tints"][s]
		_label.add_theme_color_override("font_color", Color(c.r, c.g, c.b, 1.0).lightened(0.25))
		queue_redraw()
	_label.position = Vector2(-_label.size.x - 6.0, d * 0.5 - _label.size.y * 0.5)


func _draw() -> void:
	var rr: Dictionary = Acts.data("wild")["RULE"]
	var d := float(rr["dial_px"])  # Wheel size (px).
	SpriteBank.draw_disc(self, Vector2(d, d) * 0.5, d * 0.5, Color(0.05, 0.08, 0.04, 0.85))
	var tex := SpriteBank.texture("markers/wild_season_wheel")  # The wheel (28 x 28).
	if tex != null:
		var s := maxi(int(rule.get("season")), 0)
		draw_set_transform(Vector2(d, d) * 0.5, -float(s) * PI * 0.5, Vector2.ONE)
		draw_texture_rect(tex, Rect2(Vector2(-14.0, -14.0), Vector2(28.0, 28.0)), false)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
