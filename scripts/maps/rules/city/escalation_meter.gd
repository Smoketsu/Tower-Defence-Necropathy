## EscalationMeter: the Last Line's HUD cue (Act IV, drawn only): a small
## cut-corner panel just under the top bar, at its left edge, with one pip per
## escalation tier (gangs, police, SWAT, army, heroes) in its colour, the
## tiers reached lit, and the current tier's name. Set by the escalation act
## rule through set_tier(); never read by the simulation. Numbers and colours
## in the act's RULE (tiers, names, colours, meter_pos, pip).
class_name EscalationMeter
extends PanelContainer

## The act's RULE numbers.
var rule: Dictionary = {}
## One pip per tier (ColorRect), in RULE "tiers" order.
var _pips: Array[ColorRect] = []
## The current tier's name.
var _label: Label = null


## Builds the panel for `p_rule`, placed under a top bar `top` px tall.
func build(p_rule: Dictionary, top: float) -> void:
	rule = p_rule
	add_theme_stylebox_override("panel", UiTheme.style("panel", "dim"))
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	position = Vector2(0.0, top) + Vector2(rule["meter_pos"])
	var row := HBoxContainer.new()  # Pips then the name.
	row.add_theme_constant_override("separation", 4)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(row)
	for t: Variant in rule["tiers"]:
		var p := ColorRect.new()  # One tier pip.
		p.custom_minimum_size = Vector2(rule["pip"])
		p.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		p.mouse_filter = Control.MOUSE_FILTER_IGNORE
		p.tooltip_text = String(rule["names"][t])
		row.add_child(p)
		_pips.append(p)
	_label = UiTheme.tier_label("", UiTheme.Tier.BODY, UiTheme.TEXT_GOLD)
	row.add_child(_label)


## Lights the pips up to tier index `i` (-1 = none) and names it.
func set_tier(i: int) -> void:
	var tiers: Array = rule["tiers"]
	for k in _pips.size():
		var c: Color = rule["colours"][tiers[k]]
		_pips[k].color = c if k <= i else Color(c, 0.22)
	_label.text = String(rule["names"][tiers[i]]) if i >= 0 else ""
	_label.add_theme_color_override("font_color", Color(rule["colours"][tiers[i]]).lightened(0.35) if i >= 0 else UiTheme.TEXT_DIM)
