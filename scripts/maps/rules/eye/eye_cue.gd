## EyeCue: the HUD cue of Claims (rules/eye/claims.gd): a drowned-thrall
## badge in the screen's top-left corner, under the top bar (game.top_inset),
## with a label "Claimed 3  Thralls 1/4". The label turns red while a Thrall
## walks. Textures only. Drawing only. Numbers in the act data's RULE (cue_*).
extends Control

## The act rule (a claims.gd instance).
var rule: MapRule = null
## The label.
var _label: Label = null


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label = UiTheme.tier_label("", UiTheme.Tier.BODY, UiTheme.TEXT_GOLD)
	add_child(_label)


func _process(_delta: float) -> void:
	var rr: Dictionary = Acts.data("eye")["RULE"]
	position = Vector2(0.0, rule.game.top_inset) + Vector2(rr["cue_margin"])
	var live := int(rule.call("live_thralls"))  # Thralls walking now.
	var txt := "Claimed %d  Thralls %d/%d" % [int(rule.get("counts")["claims"]), live, int(rr["max_thralls"])]
	if _label.text != txt:
		_label.text = txt
		_label.add_theme_color_override("font_color", rr["cue_hot"] if live > 0 else rr["cue_color"])
		queue_redraw()
	var d := float(rr["cue_px"])  # Icon size (px).
	_label.position = Vector2(d + 6.0, d * 0.5 - _label.size.y * 0.5)


func _draw() -> void:
	var rr: Dictionary = Acts.data("eye")["RULE"]
	var d := float(rr["cue_px"])  # Icon size (px).
	SpriteBank.draw_disc(self, Vector2(d, d) * 0.5, d * 0.5, Color(0.03, 0.1, 0.1, 0.8))
	SpriteBank.draw_icon_art(self, "call_of_the_drowned", Rect2(Vector2(2, 2), Vector2(d - 4.0, d - 4.0)))
