## ConcordCue: the HUD cue of Abduction (rules/concord/abduction.gd) in the
## screen's top-right corner, under the top bar (game.top_inset): a saucer icon
## (concord/saucer) and a label, "Saucers in 12 s", "Saucers x2 overhead",
## "A saucer is beaming!" or, while Vrask'Tal's trophy bomb counts down,
## "Trophy bomb: 9 s". The label turns red while a beam or a bomb is live.
## Textures only. Drawing only. Numbers in the act data's RULE (cue_*).
extends Control

## The act rule (an abduction.gd instance).
var rule: MapRule = null
## The label.
var _label: Label = null


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label = UiTheme.tier_label("", UiTheme.Tier.BODY, UiTheme.TEXT_GOLD)
	add_child(_label)


func _process(_delta: float) -> void:
	var rr: Dictionary = Acts.data("concord")["RULE"]
	var g := rule.game
	var o: Vector2i = rule.call("overhead")  # Saucers alive, beaming.
	var hot := o.y > 0  # A beam is live.
	var txt := ""
	var bomb := 0.0  # S left on a trophy bomb (0 = none).
	for e: TdEnemy in g.enemies:
		if float(e.vars.get("bomb_at", 0.0)) > g.time:
			bomb = float(e.vars["bomb_at"]) - g.time
	if bomb > 0.0:
		txt = "Trophy bomb: %d s" % ceili(bomb)
		hot = true
	elif o.y > 0:
		txt = "A saucer is beaming!" if o.y == 1 else "%d saucers beaming!" % o.y
	elif o.x > 0:
		txt = "Saucers x%d overhead" % o.x
	elif float(rule.get("next_flight")) < INF:
		txt = "Saucers in %d s" % maxi(ceili(float(rule.get("next_flight")) - g.time), 0)
	visible = txt != ""
	if _label.text != txt:
		_label.text = txt
		_label.add_theme_color_override("font_color", rr["cue_hot"] if hot else rr["cue_color"])
	var d := float(rr["cue_px"])  # Icon size (px).
	var w := d + 8.0 + _label.size.x  # Cue width (px).
	position = Vector2(get_viewport_rect().size.x - w - float(rr["cue_margin"].x), g.top_inset + float(rr["cue_margin"].y))
	_label.position = Vector2(d + 6.0, d * 0.5 - _label.size.y * 0.5)


func _draw() -> void:
	var rr: Dictionary = Acts.data("concord")["RULE"]
	var d := float(rr["cue_px"])  # Icon size (px).
	SpriteBank.draw_disc(self, Vector2(d, d) * 0.5, d * 0.5, Color(0.04, 0.08, 0.06, 0.8))
	var tex := SpriteBank.texture("concord/saucer")  # The saucer (64 x 36).
	if tex != null:
		var sz := tex.get_size() * (d * 0.9 / maxf(tex.get_size().x, 1.0))
		draw_texture_rect(tex, Rect2(Vector2(d, d) * 0.5 - sz * 0.5, sz), false)
