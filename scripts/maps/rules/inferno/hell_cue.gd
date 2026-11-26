## HellCue: the Inferno's HUD cue (Act IX, drawn only): a small cut-corner
## panel just under the top bar at its left edge naming the open portals and
## the wave the next one opens on ("Portals open 1  next w12  sealed 2"), in
## charm pink. Reads the Portals rule (rules/inferno/portals.gd); never read by
## the simulation. Position and colour in the act's RULE (cue_pos, cue_tint).
extends PanelContainer

## The act rule (a portals.gd instance).
var rule: MapRule = null
## The text.
var _label: Label = null


## Builds the panel for rule `p_rule`.
func build(p_rule: MapRule) -> void:
	rule = p_rule
	var rr: Dictionary = Acts.data("inferno")["RULE"]
	add_theme_stylebox_override("panel", UiTheme.style("panel", "dim"))
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	position = Vector2(0.0, TdUiData.TOP_BAR_H) + Vector2(rr["cue_pos"])
	_label = UiTheme.tier_label("", UiTheme.Tier.BODY, rr["cue_tint"])
	add_child(_label)


func _process(_delta: float) -> void:
	var nxt := int(rule.call("next_wave"))  # Next scheduled portal's wave (0 = none).
	var txt := "Portals open %d" % int(rule.call("open_count"))
	if nxt > 0:
		txt += "  next w%d" % nxt
	txt += "  sealed %d" % int(rule.get("counts")["sealed"])
	if _label.text != txt:
		_label.text = txt
