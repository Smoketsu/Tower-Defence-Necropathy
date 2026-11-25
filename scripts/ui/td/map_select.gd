## MapSelect: the map pick (GDD §9.3, §8.3): one card per MapRegistry map in
## its order, with its lock state (a map opens when the map named by its
## "unlock_after" key, by default the previous one, has had its boss beaten),
## its best skull rating per difficulty and its best Reckoning wave. Picking
## an open card goes on to the pre-map setup (Main). Built from the tables,
## so new maps appear by themselves.
class_name MapSelect
extends MenuScreen

## Emitted with the chosen map id.
signal picked(map_id: String)


func _init() -> void:
	title_text = "Act I: the Covenant"


func _build(b: VBoxContainer) -> void:
	var row := HBoxContainer.new()  # The cards.
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 14)
	b.add_child(row)
	var first: Button = null  # Focused on open: the remembered map, else the first open one.
	var last := String(Meta.prerun("map", MapRegistry.DEFAULT_ID))  # Map picked last time.
	for id: String in MapRegistry.MAPS:
		var card := _card(id)  # The map's card.
		row.add_child(card)
		if not card.disabled and (first == null or id == last):
			first = card
	UiMotion.stagger(row.get_children())
	UiTheme.focus_deferred(first)


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


## Map whose boss opens map `id` (its "unlock_after" key, else the previous map).
func _unlock_after(id: String) -> String:
	var i := Meta.map_index(id)  # Its position.
	var prev := String(MapRegistry.MAPS.keys()[maxi(i - 1, 0)])  # The previous map.
	var after := String(MapRegistry.get_map(id).get("unlock_after", prev))
	return after if MapRegistry.MAPS.has(after) else prev
