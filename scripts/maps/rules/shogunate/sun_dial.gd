## SunDial: the HUD cue of the Sun's Course (rules/shogunate/sun_course.gd):
## a small disc under the top bar's left end showing the sun (day), the setting
## sun (dusk) or the moon (night) and a label with the phase and the lanterns
## lit ("Night  4/6 lit"). Textures only (the shared disc), redrawn when the
## rule changes. Drawing only. Numbers in the act data's RULE (dial_*).
extends Control

## The act rule (a sun_course.gd instance).
var rule: MapRule = null
## The phase / lantern label.
var _label: Label = null


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label = UiTheme.tier_label("", UiTheme.Tier.BODY, UiTheme.TEXT_GOLD)
	add_child(_label)


func _process(_delta: float) -> void:
	var rr: Dictionary = Acts.data("shogunate")["RULE"]
	var m: Vector2 = rr["dial_margin"]
	position = Vector2(m.x, rule.game.top_inset + m.y)


func _draw() -> void:
	var rr: Dictionary = Acts.data("shogunate")["RULE"]
	var d := float(rr["dial_px"])  # Dial size (px).
	var phase := int(rule.get("phase"))  # 0 day, 1 dusk, 2 night.
	SpriteBank.draw_disc(self, Vector2(d, d) * 0.5, d * 0.5, Color(0.05, 0.04, 0.08, 0.8))
	var c: Color = rr[["sun_color", "dusk_color", "moon_color"][phase]]
	var drop: float = [0.0, d * 0.18, 0.0][phase]  # The setting sun sits low.
	SpriteBank.draw_disc(self, Vector2(d * 0.5, d * 0.5 + drop), d * 0.3, c)
	if phase == 2:
		SpriteBank.draw_disc(self, Vector2(d * 0.62, d * 0.42), d * 0.24, Color(0.05, 0.04, 0.08, 1.0))  # The crescent's shadow.
	var lan: Array = rule.get("lanterns")
	_label.text = "%s  %d/%d lit" % [["Day", "Dusk", "Night"][phase], int(rule.call("lit_count")), lan.size()] if phase > 0 else "Day"
	_label.position = Vector2(d + 6.0, d * 0.5 - _label.size.y * 0.5)
	_label.add_theme_color_override("font_color", c)
