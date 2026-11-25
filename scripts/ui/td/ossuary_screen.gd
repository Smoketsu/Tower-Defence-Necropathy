## OssuaryScreen: permanent upgrades bought with Soul Ash (GDD §8.2): the Ash
## held, one tile per MetaData.UPGRADES row (icon, name, level of max, what a
## level does, Buy with its cost: soul-teal when affordable, dim when not,
## gold at max), the Masteries row (every tower class, lit once mastered,
## dark until then) and Refund all (asks first). Every purchase goes through
## Meta.buy() (saved at once; MetaModifiers follows).
class_name OssuaryScreen
extends MenuScreen

## Soul Ash label.
var _ash: Label = null
## Upgrade grid (rebuilt after each purchase).
var _grid: GridContainer = null


func _init() -> void:
	title_text = "The Ossuary"


func _build(b: VBoxContainer) -> void:
	var top := HBoxContainer.new()  # Soul Ash held.
	top.alignment = BoxContainer.ALIGNMENT_CENTER
	top.add_child(MenuScreen.icon_rect(SpriteBank.texture("icons/soul_ash"), 32.0))
	_ash = UiTheme.tier_label("", UiTheme.Tier.HEADER, UiTheme.TEXT_GOLD)
	top.add_child(_ash)
	b.add_child(top)
	_grid = GridContainer.new()
	_grid.columns = 3
	_grid.add_theme_constant_override("h_separation", 8)
	_grid.add_theme_constant_override("v_separation", 8)
	b.add_child(_grid)
	b.add_child(section("Masteries"))
	var m := HBoxContainer.new()  # One badge per class.
	m.alignment = BoxContainer.ALIGNMENT_CENTER
	m.add_theme_constant_override("separation", 6)
	b.add_child(m)
	for id: String in TowerData.ORDER:
		var row: Dictionary = TowerData.TOWERS[id]
		var on: bool = (Meta.data["masteries"] as Dictionary).has(id)  # Mastered.
		var r := MenuScreen.icon_rect(SpriteBank.texture("icons/" + String(row["icon"])), MenuData.MASTERY_ICON, not on)
		r.mouse_filter = Control.MOUSE_FILTER_STOP
		r.tooltip_text = "%s: %s" % [String(row["name"]), "+%d%%" % roundi((MetaData.MASTERY_MULT - 1.0) * 100.0) if on else "Lv %d in any map" % MetaData.MASTERY_LEVEL]
		m.add_child(r)
	_refresh()


func _after_nav() -> void:
	button(nav, "Refund", func() -> void: ConfirmDialog.ask(self, "Refund all?", "Every upgrade is returned as Soul Ash.", "Refund", _refund), "crimson")


func _refund() -> void:
	Meta.refund_all()
	_refresh()


## Rebuilds the Ash line and every tile.
func _refresh() -> void:
	_ash.text = str(Meta.ash())
	var focus_id := ""  # Tile that had the focus (kept across the rebuild).
	var f := get_viewport().gui_get_focus_owner() if is_inside_tree() else null
	if f != null and f.has_meta("upgrade"):
		focus_id = String(f.get_meta("upgrade"))
	for c: Node in _grid.get_children():
		_grid.remove_child(c)
		c.queue_free()
	for id: String in MetaData.ORDER:
		var t := _tile(id)  # The tile's Buy button.
		if id == focus_id:
			UiTheme.focus_deferred(t)


## The tile of upgrade `id`; returns its Buy button.
func _tile(id: String) -> Button:
	var u: Dictionary = MetaData.UPGRADES[id]
	var lv := Meta.level(id)  # Owned level.
	var mx := (u["costs"] as Array).size()  # Max level.
	var cost := Meta.next_cost(id)  # Next price (-1 at max).
	var p := PanelContainer.new()  # The tile.
	p.add_theme_stylebox_override("panel", UiTheme.style("panel", "gold" if lv >= mx else "violet"))
	p.custom_minimum_size = MenuData.OSSUARY_TILE
	_grid.add_child(p)
	var row := HBoxContainer.new()  # Icon | text | Buy.
	row.add_theme_constant_override("separation", 8)
	p.add_child(row)
	var art := String(u["icon"])  # Icon key.
	row.add_child(MenuScreen.icon_rect(TdArt.texture(art.substr(3)) if art.begins_with("td:") else SpriteBank.texture(art), 32.0))
	var col := VBoxContainer.new()  # Name, level, line.
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 0)
	row.add_child(col)
	var head := HBoxContainer.new()  # Name and level.
	head.add_child(UiTheme.tier_label(String(u["name"]), UiTheme.Tier.NAME, UiTheme.TEXT_GOLD if lv >= mx else UiTheme.TEXT))
	var lvl := UiTheme.tier_label("%d/%d" % [lv, mx], UiTheme.Tier.BODY, UiTheme.TEXT_DIM)
	lvl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lvl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	head.add_child(lvl)
	col.add_child(head)
	col.add_child(UiTheme.para(String(u["desc"]), 150.0))
	var b := Button.new()  # Buy.
	b.set_meta("upgrade", id)
	b.custom_minimum_size = Vector2(76, 44)
	b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	if cost < 0:
		b.text = "Max"
		b.disabled = true
	else:
		b.text = str(cost)
		var can := Meta.ash() >= cost  # Affordable.
		b.disabled = not can
		if can:
			UiTheme.style_button(b, "button", "soul")
			b.add_theme_color_override("font_color", MenuData.TEAL)
	b.pressed.connect(_buy.bind(id))
	row.add_child(b)
	return b


func _buy(id: String) -> void:
	if Meta.buy(id):
		Sfx.play_ui("purchase")
	else:
		Sfx.play_ui("denied")
	_refresh()
