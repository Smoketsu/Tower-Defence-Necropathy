## ScalesBar: the HUD cue of the Scales on the Hall of Two Truths
## (rules/dynasty/rebirth.gd): in the screen's top-right corner, under the top
## bar, the great scales sprite over a bar whose needle shows the balance
## (left, soul-teal: the player's side; right, gold: the Dynasty's), the two
## marks past which it tips the run, and a short label ("Dynasty +12", kept right of the roads).
## Textures and rects only; redrawn when the rule tips it. Drawing only.
## Numbers in the act data's LOOK (scales_*) and RULE (scale_max, scale_mark).
extends Control

## The act rule (a rebirth.gd instance).
var rule: MapRule = null
## The balance label.
var _label: Label = null


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label = UiTheme.tier_label("", UiTheme.Tier.BODY, UiTheme.TEXT_GOLD)
	add_child(_label)


func _process(_delta: float) -> void:
	var lk: Dictionary = Acts.data("dynasty")["LOOK"]
	var w := float(lk["scales_w"])  # Widget width (px).
	var m: Vector2 = lk["scales_margin"]
	position = Vector2(get_viewport_rect().size.x - w - m.x, rule.game.top_inset + m.y)


func _draw() -> void:
	var lk: Dictionary = Acts.data("dynasty")["LOOK"]
	var rr: Dictionary = Acts.data("dynasty")["RULE"]
	var w := float(lk["scales_w"])  # Widget width (px).
	var s := float(rule.get("scale"))  # The balance.
	var mx := float(rr["scale_max"])  # Its ends.
	var mark := float(rr["scale_mark"])  # Where it tips the run.
	SpriteBank.draw(self, "obstacles/dyn_great_scales", Vector2(w * 0.5, float(lk["scales_art_y"])), false)
	var y := float(lk["scales_bar_y"])  # Bar top (px).
	draw_rect(Rect2(0, y, w, 6), Color(0.05, 0.04, 0.08, 0.85))
	draw_rect(Rect2(0, y, w * 0.5 * (1.0 - mark / mx), 6), Color(lk["player_side"], 0.6))
	draw_rect(Rect2(w * 0.5 * (1.0 + mark / mx), y, w * 0.5 * (1.0 - mark / mx), 6), Color(lk["gold"], 0.6))
	var nx := w * 0.5 * (1.0 + s / mx)  # Needle x (px).
	draw_rect(Rect2(nx - 2, y - 3, 4, 12), Color.WHITE)
	_label.text = ("Dynasty %+d" if s > 0.0 else "Necro %+d") % int(s) if s != 0.0 else "Level"
	_label.add_theme_color_override("font_color", lk["gold"] if s > 0.0 else lk["player_side"])
	_label.position = Vector2(w - _label.size.x, y + 8.0)
