## WrathMeter: the HUD cue of the Wrath of the Gods (Act VIII act rule,
## rules/pantheon/pantheon_rules.gd; drawing only): a small cut-corner panel
## under the top bar at its left edge with the map god's icon and a countdown
## ("Zeus' Lightning 6s"; "... soon" before its first wave, "... NOW" while a
## strike is in the air). Never read by the simulation. Numbers in the act's
## RULE ("meter_pos", "meter_icon_px") and each map's wrath row ("name", "icon").
extends PanelContainer

## The act rule (a pantheon_rules.gd instance).
var rule: MapRule = null
## The god's icon.
var _icon: TextureRect = null
## The countdown label.
var _label: Label = null


func _ready() -> void:
	var rr: Dictionary = PantheonActRules.r()
	var w: Dictionary = rule.get("wrath")
	add_theme_stylebox_override("panel", UiTheme.style("panel", "dim"))
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	position = Vector2(0.0, TdUiData.TOP_BAR_H) + Vector2(rr["meter_pos"])
	var row := HBoxContainer.new()  # Icon then the countdown.
	row.add_theme_constant_override("separation", 4)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(row)
	_icon = TextureRect.new()
	_icon.texture = SpriteBank.texture("icons/" + String(w["icon"]))
	_icon.custom_minimum_size = Vector2.ONE * float(rr["meter_icon_px"])
	_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(_icon)
	_label = UiTheme.tier_label("", UiTheme.Tier.BODY, UiTheme.TEXT_GOLD)
	row.add_child(_label)


func _process(_delta: float) -> void:
	var w: Dictionary = rule.get("wrath")
	var left := float(rule.call("time_left"))  # s to the next strike.
	var name_s := String(w["name"])  # The god's strike.
	if left == INF:
		_label.text = "%s soon" % name_s
	elif not (rule.get("pending") as Array).is_empty():
		_label.text = "%s NOW" % name_s
	else:
		_label.text = "%s %ds" % [name_s, ceili(left)]
	_label.add_theme_color_override("font_color", PantheonActRules.r()["meter_hot" if left < float(PantheonActRules.r()["meter_warn"]) or not (rule.get("pending") as Array).is_empty() else "meter_cold"])
