## EmpireDial: the HUD cue of the Line of Fire (rules/empire/line_of_fire.gd):
## in the screen's top-left corner under the top bar, a red target reticle and a
## label "Cover 12/40  Lock-On 2" (Empire shots your bodies stopped of the shots
## that landed, paints live now). The label turns red while a tower is painted.
## Textures only. Drawing only. Numbers in the act data's LOOK (dial_*).
extends Control

## The act rule (a line_of_fire.gd instance).
var rule: MapRule = null
## The label.
var _label: Label = null


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label = UiTheme.tier_label("", UiTheme.Tier.BODY, UiTheme.TEXT_GOLD)
	add_child(_label)


func _process(_delta: float) -> void:
	var lk: Dictionary = Acts.data("empire")["LOOK"]
	position = Vector2(lk["dial_margin"]) + Vector2(0.0, rule.game.top_inset)
	var hc: Dictionary = rule.game.hostile.counts
	var landed := int(hc["blocked"]) + int(hc["hit_tower"]) + int(hc["hit_body"])  # Shots that landed somewhere.
	var live := (rule.get("locks") as Array).size()  # Paints live.
	var txt := "Cover %d/%d  Lock-On %d" % [int(hc["blocked"]), landed, live]
	if _label.text != txt:
		_label.text = txt
		_label.add_theme_color_override("font_color", lk["dial_hot"] if live > 0 else lk["dial_color"])
	var d := float(lk["dial_px"])  # Icon size (px).
	_label.position = Vector2(d + 6.0, d * 0.5 - _label.size.y * 0.5)


func _draw() -> void:
	var lk: Dictionary = Acts.data("empire")["LOOK"]
	var d := float(lk["dial_px"])  # Icon size (px).
	SpriteBank.draw_disc(self, Vector2(d, d) * 0.5, d * 0.5, Color(0.06, 0.05, 0.05, 0.8))
	var tex := SpriteBank.texture("telegraphs/target")  # The reticle.
	if tex != null:
		draw_texture_rect(tex, Rect2(Vector2(d, d) * 0.15, Vector2(d, d) * 0.7), false, lk["lock_tint"])
