## MapSelect: the map pick (GDD §9.3, §8.3), grouped by act (ActData, the
## one ordered act list): a row of act tabs (numerals; a locked act's tab is
## dimmed), the act's title, then one card per playable map of that act with
## its lock state (a map opens when the previous map's boss is beaten, across
## acts: Meta.unlock_after()), its best skulls per difficulty and its best
## Reckoning wave; an act with no playable map shows "Coming soon". Picking an
## open card goes on to the pre-map setup (Main). Built from the tables, so new
## acts and maps appear by themselves; hidden acts only with --test-act.
class_name MapSelect
extends MenuScreen

## Emitted with the chosen map id.
signal picked(map_id: String)

## Act shown now (ActData id).
var _act: String = ""
## Act id -> its tab button.
var _tabs: Dictionary = {}
## The act's subtitle line (its faction) and the cards row.
var _faction: Label = null
## See _faction.
var _row: HBoxContainer = null


func _init() -> void:
	_act = Acts.act_of_map(String(Meta.prerun("map", MapRegistry.DEFAULT_ID)))
	if _act == "" or not Acts.shown(Acts.row(_act)):
		_act = String(ActData.ACTS[0]["id"])
	title_text = _title(_act)


## "Act N: name" of act `id`.
static func _title(id: String) -> String:
	return "Act %s: %s" % [Acts.numeral(id), String(Acts.row(id)["name"])]


## True when act `id` can be played now: it has a playable map whose lock is open.
static func act_open(id: String) -> bool:
	var maps := Acts.maps_of(id)  # Its playable maps.
	return not maps.is_empty() and (GameState.autotest or Meta.map_open(maps[0]))


func _build(b: VBoxContainer) -> void:
	var tabs := HBoxContainer.new()  # Act tabs.
	tabs.alignment = BoxContainer.ALIGNMENT_CENTER
	tabs.add_theme_constant_override("separation", MenuData.ACT_TAB_GAP)
	b.add_child(tabs)
	for r: Dictionary in Acts.visible_acts():
		var id := String(r["id"])  # The act.
		var t := Button.new()  # Its tab.
		t.text = Acts.numeral(id)
		t.custom_minimum_size = MenuData.ACT_TAB
		t.tooltip_text = "%s (%s)" % [_title(id), String(r["faction"])]
		if not act_open(id):
			t.modulate = MenuData.ACT_LOCKED
		t.pressed.connect(_show_act.bind(id))
		tabs.add_child(t)
		_tabs[id] = t
	_faction = UiTheme.tier_label("", UiTheme.Tier.BODY, UiTheme.TEXT_DIM)
	_faction.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	b.add_child(_faction)
	_row = HBoxContainer.new()
	_row.alignment = BoxContainer.ALIGNMENT_CENTER
	_row.add_theme_constant_override("separation", 14)
	_row.custom_minimum_size.y = MenuData.MAP_CARD.y
	b.add_child(_row)
	_show_act(_act, true)


## Shows act `id`: highlights its tab, sets the title and builds its cards
## (focus: the remembered map, else the first open card; on a tab press the tab keeps it).
func _show_act(id: String, opening: bool = false) -> void:
	_act = id
	for k: String in _tabs:
		UiTheme.style_button(_tabs[k], "button", "gold" if k == id else "")
	if box != null and box.get_child_count() > 0 and box.get_child(0) is Label:
		(box.get_child(0) as Label).text = _title(id)
	var row := Acts.row(id)  # Its ActData row.
	_faction.text = String(row["faction"])
	for n: Node in _row.get_children():
		_row.remove_child(n)
		n.queue_free()
	var maps := Acts.maps_of(id)  # Its playable maps.
	var first: Button = null  # Card to focus.
	var last := String(Meta.prerun("map", MapRegistry.DEFAULT_ID))  # Map picked last time.
	for m: String in maps:
		var card := _card(m)  # The map's card.
		_row.add_child(card)
		if not card.disabled and (first == null or m == last):
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


## The card of map `id`: name, records, or the lock line.
func _card(id: String) -> Button:
	var m := MapRegistry.get_map(id)  # Its data.
	var open := GameState.autotest or Meta.map_open(id)  # Playable now.
	var c := Button.new()  # The card (a button holding a column).
	c.custom_minimum_size = MenuData.MAP_CARD
	c.disabled = not open
	UiTheme.style_button(c, "card", "gold" if Meta.cleared(id) else "violet")
	c.pressed.connect(func() -> void: picked.emit(id))
	var col := VBoxContainer.new()  # Card content.
	col.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 12)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_theme_constant_override("separation", 6)
	c.add_child(col)
	var nm := UiTheme.tier_label(String(m["name"]), UiTheme.Tier.NAME, UiTheme.TEXT_GOLD if Meta.cleared(id) else UiTheme.TEXT)
	nm.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(nm)
	col.add_child(UiTheme.divider("gold" if Meta.cleared(id) else "violet"))
	if not open:
		var lock := UiTheme.para("Beat the boss of %s" % String(MapRegistry.get_map(_unlock_after(id))["name"]), 0.0, MenuData.CRIMSON)
		lock.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		col.add_child(lock)
		return c
	for d: String in DifficultyData.ORDER:
		var line := HBoxContainer.new()  # Difficulty name and its best skulls.
		line.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var l := UiTheme.tier_label(String(DifficultyData.LEVELS[d]["name"]), UiTheme.Tier.BODY, UiTheme.TEXT_DIM)
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		line.add_child(l)
		line.add_child(MenuScreen.skull_row(Meta.skulls(id, d), MenuData.SKULL))
		col.add_child(line)
	var rk := Meta.best_reckoning(id)  # Best Reckoning wave.
	var r := UiTheme.tier_label("Reckoning %s" % (str(rk) if rk > 0 else "-"), UiTheme.Tier.BODY, MenuData.CRIMSON if rk > 0 else UiTheme.TEXT_DIM)
	r.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(r)
	return c


## Map whose boss opens map `id` (Meta.unlock_after(); the previous map, across acts).
func _unlock_after(id: String) -> String:
	return Meta.unlock_after(id)
