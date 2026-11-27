## MapSelect: the map pick (GDD §9.3, §8.3; menu overhaul, DECISIONS M6),
## grouped by act (ActData, the one ordered act list): Part tabs (I / II /
## III, from the rows' "part"), the part's acts as named tabs (numeral and
## name; a locked act's tab is dimmed with a padlock), the act's faction and
## how many of its maps are cleared, then one illustrated MapCard per
## playable map of the act (picture, boss, skulls, Reckoning, or its lock
## line: a map opens when the previous map's boss is beaten, across acts,
## Meta.unlock_after()); an act with no playable map shows "Coming soon". The
## header title is the act's ("Act N: name"). Picking an open card goes on to
## the pre-map setup (Main). Built from the tables, so new acts and maps
## appear by themselves; hidden acts only with --test-act.
class_name MapSelect
extends MenuScreen

## Emitted with the chosen map id.
signal picked(map_id: String)

## Act shown now (ActData id).
var _act: String = ""
## Part shown now (ActData "part").
var _part: int = 1
## Part number (as a String) -> its tab button.
var _part_tabs: Dictionary = {}
## The act tab row (rebuilt per part) and act id -> its tab.
var _act_row: HBoxContainer = null
## See _act_row.
var _tabs: Dictionary = {}
## The act's subtitle line (its faction and progress) and the cards row.
var _faction: Label = null
## See _faction.
var _row: HBoxContainer = null


func _init() -> void:
	_act = Acts.act_of_map(String(Meta.prerun("map", MapRegistry.DEFAULT_ID)))
	if _act == "" or not Acts.shown(Acts.row(_act)):
		_act = String(ActData.ACTS[0]["id"])
	_part = int(Acts.row(_act).get("part", 1))
	title_text = _title(_act)
	show_ash = true


## "Act N: name" of act `id`.
static func _title(id: String) -> String:
	return "Act %s: %s" % [Acts.numeral(id), String(Acts.row(id)["name"])]


## True when act `id` can be played now: it has a playable map whose lock is open.
static func act_open(id: String) -> bool:
	var maps := Acts.maps_of(id)  # Its playable maps.
	return not maps.is_empty() and (GameState.autotest or Meta.map_open(maps[0]))


func _build(b: VBoxContainer) -> void:
	var parts: Array = []  # [[part as String, word], ...] of the parts with visible acts.
	for r: Dictionary in Acts.visible_acts():
		var p := str(int(r.get("part", 1)))  # Its part.
		if not parts.any(func(e: Array) -> bool: return e[0] == p):
			parts.append([p, MenuData.PART_WORD % ActData.NUMERALS[clampi(int(p) - 1, 0, ActData.NUMERALS.size() - 1)]])
	_part_tabs = tab_row(b, parts, _show_part, MenuData.PART_TAB)
	_act_row = HBoxContainer.new()
	_act_row.alignment = BoxContainer.ALIGNMENT_CENTER
	_act_row.add_theme_constant_override("separation", MenuData.ACT_TAB_GAP)
	b.add_child(_act_row)
	_faction = UiTheme.tier_label("", UiTheme.Tier.BODY, UiTheme.TEXT_DIM)
	_faction.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	b.add_child(_faction)
	_row = HBoxContainer.new()
	_row.alignment = BoxContainer.ALIGNMENT_CENTER
	_row.add_theme_constant_override("separation", MenuData.MAP_CARD_GAP)
	_row.custom_minimum_size = Vector2(MenuData.MAP_CARD.x * 3.0 + MenuData.MAP_CARD_GAP * 2.0, MenuData.MAP_CARD.y)
	b.add_child(_row)
	_fill_acts()
	_show_act(_act, true)


## A Part tab: shows that part's acts and its first act (the open one nearest the end, if any).
func _show_part(p: String) -> void:
	_part = int(p)
	_fill_acts()
	var pick := ""  # Act to show.
	for id: String in _tabs:
		if pick == "" or act_open(id):
			pick = id
	_show_act(pick)


## (Re)builds the act tabs of the current part.
func _fill_acts() -> void:
	mark_tabs(_part_tabs, str(_part))
	for n: Node in _act_row.get_children():
		_act_row.remove_child(n)
		n.queue_free()
	_tabs.clear()
	for r: Dictionary in Acts.visible_acts():
		if int(r.get("part", 1)) != _part:
			continue
		var id := String(r["id"])  # The act.
		var open := act_open(id)  # Playable now.
		var t := Button.new()  # Its tab: numeral over name.
		t.custom_minimum_size = MenuData.ACT_TAB
		t.tooltip_text = "%s (%s)" % [_title(id), String(r["faction"])]
		t.set_meta("ui_lift", false)
		t.pressed.connect(_show_act.bind(id))
		var col := VBoxContainer.new()  # Numeral, name.
		col.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 4)
		col.alignment = BoxContainer.ALIGNMENT_CENTER
		col.mouse_filter = Control.MOUSE_FILTER_IGNORE
		col.add_theme_constant_override("separation", 0)
		t.add_child(col)
		var top := HBoxContainer.new()  # Numeral (and padlock while locked).
		top.alignment = BoxContainer.ALIGNMENT_CENTER
		top.mouse_filter = Control.MOUSE_FILTER_IGNORE
		top.add_theme_constant_override("separation", 4)
		col.add_child(top)
		if not open:
			var lk := MaskIcon.new("padlock", 1)  # Locked.
			lk.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			top.add_child(lk)
		top.add_child(UiTheme.tier_label(MenuData.ACT_WORD % Acts.numeral(id), UiTheme.Tier.LABEL, UiTheme.TEXT_GOLD if open else UiTheme.TEXT_DIM))
		var nm := UiTheme.tier_label(String(r["name"]), UiTheme.Tier.BODY, UiTheme.TEXT if open else UiTheme.TEXT_DIM)
		nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		nm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		col.add_child(nm)
		if not open:
			t.modulate = MenuData.ACT_LOCKED
		_act_row.add_child(t)
		_tabs[id] = t


## Shows act `id`: highlights its tab, sets the title and builds its cards
## (focus: the remembered map, else the first open card; on a tab press the tab keeps it).
func _show_act(id: String, opening: bool = false) -> void:
	_act = id
	for k: String in _tabs:
		UiTheme.style_button(_tabs[k], "button", "gold" if k == id else "")
	if title_label != null:
		title_label.text = _title(id)
	var row := Acts.row(id)  # Its ActData row.
	var maps := Acts.maps_of(id)  # Its playable maps.
	var won := maps.filter(func(m: String) -> bool: return Meta.cleared(m)).size()  # Maps beaten.
	_faction.text = "%s   %d / %d cleared" % [String(row["faction"]), won, maps.size()] if not maps.is_empty() else String(row["faction"])
	for n: Node in _row.get_children():
		_row.remove_child(n)
		n.queue_free()
	var first: Button = null  # Card to focus.
	var last := String(Meta.prerun("map", MapRegistry.DEFAULT_ID))  # Map picked last time.
	for m: String in maps:
		var open := GameState.autotest or Meta.map_open(m)  # Playable now.
		var card := MapCard.new(m, open, "Beat the boss of %s" % String(MapRegistry.get_map(Meta.unlock_after(m))["name"]))  # The map's card.
		card.pressed.connect(func() -> void: picked.emit(m))
		_row.add_child(card)
		if open and (first == null or m == last):
			first = card
	if maps.is_empty():
		var p := PanelContainer.new()  # "Coming soon".
		p.custom_minimum_size = MenuData.COMING_SOON
		p.add_theme_stylebox_override("panel", UiTheme.style("panel", "violet"))
		var l := UiTheme.tier_label(MenuData.COMING_SOON_TEXT, UiTheme.Tier.HEADER, UiTheme.TEXT_DIM)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		p.add_child(l)
		_row.add_child(p)
	UiMotion.stagger(_row.get_children())
	if opening:
		UiTheme.focus_deferred(first if first != null else _tabs[id])
