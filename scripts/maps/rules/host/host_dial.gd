## HostDial: the HUD cue of the Hallowed Light and Judgment
## (rules/host/hallowed_light.gd): the scales of Judgment (markers/host_scales)
## in the screen's top-left corner, under the top bar, with a label "Sins 7/10
## Light x2" (sins toward the next Judge, shafts burning now). The label turns
## red once a Judge is due. Textures only. Drawing only. Numbers in the act
## data's RULE (dial_*).
extends Control

## The act rule (a hallowed_light.gd instance).
var rule: MapRule = null
## The label.
var _label: Label = null


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label = UiTheme.tier_label("", UiTheme.Tier.BODY, UiTheme.TEXT_GOLD)
	add_child(_label)


func _process(_delta: float) -> void:
	var rr: Dictionary = Acts.data("host")["RULE"]
	position = rr["dial_margin"]
	var per := int(rr["judgment"]["per_judge"])  # Sins per Judge.
	var sins := int(rule.get("sins"))
	var burning := 0  # Shafts burning now.
	for sh: Dictionary in rule.get("shafts"):
		burning += 1 if bool(rule.call("burning", sh)) else 0
	var txt := "Sins %d/%d  Light x%d" % [sins, per, burning]
	if sins >= per:
		txt = "Sins %d: Judgment due  Light x%d" % [sins, burning]
	if _label.text != txt:
		_label.text = txt
		_label.add_theme_color_override("font_color", rr["dial_hot"] if sins >= per else rr["dial_color"])
		queue_redraw()
	var d := float(rr["dial_px"])  # Icon size (px).
	_label.position = Vector2(d + 6.0, d * 0.5 - _label.size.y * 0.5)


func _draw() -> void:
	var rr: Dictionary = Acts.data("host")["RULE"]
	var d := float(rr["dial_px"])  # Icon size (px).
	SpriteBank.draw_disc(self, Vector2(d, d) * 0.5, d * 0.5, Color(0.05, 0.06, 0.12, 0.8))
	var tex := SpriteBank.texture("markers/host_scales")  # The scales (24 x 20).
	if tex != null:
		draw_texture_rect(tex, Rect2(Vector2(d * 0.5 - 12.0, d * 0.5 - 10.0), Vector2(24.0, 20.0)), false)
