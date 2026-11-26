## PrimevalCue: the HUD cue of the Stampedes (rules/primeval/stampedes.gd): the
## Stampede icon (icons/stampede) in the screen's top-left corner, under the
## top bar (game.top_inset), with a label: "Stampede in 3 s!" (hot) while a herd
## is marked, "Stampede!" while it runs, else "Herds turned 2/5" (and "Meteor!" while one falls on the
## Last Day). Textures only. Drawing only. Numbers in the act data's RULE (cue_*).
extends Control

## The act rule (a stampedes.gd instance).
var rule: MapRule = null
## The label.
var _label: Label = null


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label = UiTheme.tier_label("", UiTheme.Tier.BODY, UiTheme.TEXT_GOLD)
	add_child(_label)


func _process(_delta: float) -> void:
	var rr: Dictionary = Acts.data("primeval")["RULE"]
	var mg: Vector2 = rr["cue_margin"]
	position = Vector2(mg.x, maxf(mg.y, rule.game.top_inset + 10.0))
	var nh: Array = rule.call("next_herd")
	var c: Dictionary = rule.get("counts")
	var hot := float(nh[0]) < INF
	var txt := "Herds turned %d/%d" % [int(c["turned"]), int(c["herds"])]
	if hot:
		txt = "Stampede in %d s!" % ceili(float(nh[0])) if float(nh[0]) > 0.0 else "Stampede!"
	if not (rule.get("meteors") as Array).is_empty():
		txt += "  Meteor!"
		hot = true
	if _label.text != txt:
		_label.text = txt
		_label.add_theme_color_override("font_color", rr["cue_hot"] if hot else rr["cue_color"])
	var d := float(rr["cue_px"])
	_label.position = Vector2(d + 6.0, d * 0.5 - _label.size.y * 0.5)


func _draw() -> void:
	var d := float(Acts.data("primeval")["RULE"]["cue_px"])
	SpriteBank.draw_disc(self, Vector2(d, d) * 0.5, d * 0.5, Color(0.08, 0.06, 0.04, 0.8))
	SpriteBank.draw_icon_art(self, "stampede", Rect2(Vector2(d * 0.12, d * 0.12), Vector2(d, d) * 0.76))
