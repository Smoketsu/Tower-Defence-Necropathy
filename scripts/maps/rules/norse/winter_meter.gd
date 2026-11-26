## WinterMeter: the HUD cue of the Long Winter (rules/norse/long_winter.gd): a
## small frost badge in the screen's bottom-left corner (the Grave Frost icon on
## a dark disc, three pips for the cold level) and a label with the cold and
## the braziers lit ("Cold 2  4/6 fires"), coloured by the level. Textures
## only, redrawn when the rule changes. Drawing only. Numbers in the act data's
## RULE (meter_*).
extends Control

## The act rule (a long_winter.gd instance).
var rule: MapRule = null
## The cold / fires label.
var _label: Label = null


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label = UiTheme.tier_label("", UiTheme.Tier.BODY, UiTheme.TEXT_GOLD)
	add_child(_label)


func _process(_delta: float) -> void:
	var rr: Dictionary = Acts.data("norse")["RULE"]
	var m: Vector2 = rr["meter_margin"]
	position = Vector2(m.x, get_viewport_rect().size.y - float(rr["meter_px"]) - m.y)  # Bottom-left: off the roads.


func _draw() -> void:
	var rr: Dictionary = Acts.data("norse")["RULE"]
	var d := float(rr["meter_px"])  # Badge size (px).
	var lv := int(rule.get("level"))  # Cold level.
	var c: Color = rr["meter_colors"][mini(lv, (rr["meter_colors"] as Array).size() - 1)]
	SpriteBank.draw_disc(self, Vector2(d, d) * 0.5, d * 0.5, Color(0.04, 0.05, 0.1, 0.85))
	var ic := SpriteBank.texture("icons/grave_frost")
	if ic != null:
		draw_texture_rect(ic, Rect2(Vector2(d, d) * 0.14, Vector2(d, d) * 0.72), false, Color(1, 1, 1, 0.45 + 0.18 * float(lv)))
	for i in 3:
		SpriteBank.draw_disc(self, Vector2(d * 0.25 + d * 0.25 * float(i), d * 0.96), d * 0.07, c if i < lv else Color(0.3, 0.3, 0.35, 0.8))
	_label.text = "Cold %d  %d/%d fires" % [lv, int(rule.call("lit_count")), (rule.get("braziers") as Array).size()]
	_label.position = Vector2(d + 6.0, d * 0.5 - _label.size.y * 0.5)
	_label.add_theme_color_override("font_color", c)
