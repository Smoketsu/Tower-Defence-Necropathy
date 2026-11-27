## OssuaryScreen: permanent upgrades bought with Soul Ash (GDD §8.2; menu
## overhaul, DECISIONS M12). The Ash held sits in the header pill. Left: one
## tile per MetaData.UPGRADES row (badge icon, name, level pips, next cost:
## soul-teal when affordable, crimson when not, gold "Max" at the top; the
## frame gold at max). Pressing a tile (tap, click, Enter / pad A) picks it
## and moves the focus to Buy; hovering / focusing a tile shows it too.
## Right: the detail panel of the picked upgrade (big badge, name, level,
## what a level does, Buy with its cost). Below: the Masteries (every tower
## class, lit once mastered, dark until then) with their count, and Refund
## all (asks first, crimson; under Buy in the detail panel). Every purchase goes through Meta.buy() (saved
## at once; MetaModifiers follows).
class_name OssuaryScreen
extends MenuScreen

## Upgrade grid (rebuilt after each purchase).
var _grid: GridContainer = null
## Upgrade shown in the detail panel.
var _pick: String = ""
## Detail panel parts: badge, name, level line, description, Buy.
var _d_icon: TextureRect = null
## See _d_icon.
var _d_name: Label = null
## See _d_icon.
var _d_level: Label = null
## See _d_icon.
var _d_desc: Label = null
## See _d_icon.
var _buy: Button = null


func _init() -> void:
	title_text = "The Ossuary"
	show_ash = true
	_pick = MetaData.ORDER[0]


func _build(b: VBoxContainer) -> void:
	var cols := HBoxContainer.new()  # Grid | detail.
	cols.add_theme_constant_override("separation", 12)
	b.add_child(cols)
	_grid = GridContainer.new()
	_grid.columns = MenuData.OSSUARY_COLUMNS
	_grid.add_theme_constant_override("h_separation", 8)
	_grid.add_theme_constant_override("v_separation", 8)
	cols.add_child(_grid)
	cols.add_child(_detail())
	var mastered := 0  # Classes mastered.
	for id: String in TowerData.ORDER:
		mastered += 1 if (Meta.data["masteries"] as Dictionary).has(id) else 0
	b.add_child(section("Masteries  %d / %d" % [mastered, TowerData.ORDER.size()]))
	var m := HFlowContainer.new()  # One badge per class (wraps: ~30 classes with the later acts; gw2-kit).
	m.alignment = FlowContainer.ALIGNMENT_CENTER
	m.add_theme_constant_override("h_separation", 4)
	m.add_theme_constant_override("v_separation", 4)
	m.custom_minimum_size.x = MenuData.OSSUARY_TILE.x * MenuData.OSSUARY_COLUMNS + MenuData.OSSUARY_DETAIL_W
	b.add_child(m)
	for id: String in TowerData.ORDER:
		var row: Dictionary = TowerData.TOWERS[id]
		var on: bool = (Meta.data["masteries"] as Dictionary).has(id)  # Mastered.
		var badge := PanelContainer.new()  # Framed badge.
		badge.add_theme_stylebox_override("panel", UiTheme.style("slot", "grey") if not on else UiTheme.style("panel", "gold"))
		badge.mouse_filter = Control.MOUSE_FILTER_STOP
		badge.tooltip_text = "%s: %s" % [String(row["name"]), "+%d%%" % roundi((MetaData.MASTERY_MULT - 1.0) * 100.0) if on else "Lv %d in any map" % MetaData.MASTERY_LEVEL]
		badge.add_child(MenuScreen.icon_rect(SpriteBank.texture("icons/" + String(row["icon"])), MenuData.MASTERY_ICON, not on))
		m.add_child(badge)
	_refresh()


## The detail panel (filled by _show_detail()).
func _detail() -> PanelContainer:
	var p := PanelContainer.new()  # The panel.
	p.add_theme_stylebox_override("panel", UiTheme.style("card", "violet"))
	p.custom_minimum_size = Vector2(MenuData.OSSUARY_DETAIL_W, 0)
	var col := VBoxContainer.new()  # Its rows.
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", 6)
	p.add_child(col)
	var slot := PanelContainer.new()  # Badge frame.
	slot.add_theme_stylebox_override("panel", UiTheme.style("slot", "grey"))
	slot.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	col.add_child(slot)
	_d_icon = MenuScreen.icon_rect(null, MenuData.OSSUARY_DETAIL_ICON)
	_d_icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	slot.add_child(_d_icon)
	_d_name = UiTheme.tier_label("", UiTheme.Tier.HEADER, UiTheme.TEXT)
	_d_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(_d_name)
	_d_level = UiTheme.tier_label("", UiTheme.Tier.LABEL, UiTheme.TEXT_DIM)
	_d_level.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(_d_level)
	_d_desc = UiTheme.para("", MenuData.OSSUARY_DETAIL_W - 30.0, UiTheme.TEXT)
	_d_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(_d_desc)
	_buy = Button.new()
	_buy.custom_minimum_size = MenuData.OSSUARY_BUY
	_buy.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_buy.pressed.connect(func() -> void: _buy_it(_pick))
	col.add_child(_buy)
	var gap := Control.new()  # Keeps Refund apart from Buy.
	gap.custom_minimum_size.y = 8.0
	col.add_child(gap)
	var r := button(col, "Refund", func() -> void: ConfirmDialog.ask(self, "Refund all?", "Every upgrade is returned as Soul Ash.", "Refund", _refund), "crimson")  # Refund all (asks first).
	r.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	return p


func _refund() -> void:
	Meta.refund_all()
	_refresh()


## Rebuilds the Ash line, every tile and the detail panel.
func _refresh() -> void:
	if ash_label != null:
		ash_label.text = str(Meta.ash())
	var focus_id := ""  # Tile that had the focus (kept across the rebuild).
	var f := get_viewport().gui_get_focus_owner() if is_inside_tree() else null
	if f != null and f.has_meta("upgrade"):
		focus_id = String(f.get_meta("upgrade"))
	for c: Node in _grid.get_children():
		_grid.remove_child(c)
		c.queue_free()
	for id: String in MetaData.ORDER:
		var t := _tile(id)  # The tile.
		if id == focus_id:
			UiTheme.focus_deferred(t)
	_show_detail(_pick)


## The icon texture of upgrade row `u` ("td:" keys are Gravewatch art).
static func _icon(u: Dictionary) -> Texture2D:
	var art := String(u["icon"])  # Icon key.
	return TdArt.texture(art.substr(3)) if art.begins_with("td:") else SpriteBank.texture(art)


## The tile of upgrade `id` (a card Button).
func _tile(id: String) -> Button:
	var u: Dictionary = MetaData.UPGRADES[id]
	var lv := Meta.level(id)  # Owned level.
	var mx := (u["costs"] as Array).size()  # Max level.
	var cost := Meta.next_cost(id)  # Next price (-1 at max).
	var can := cost >= 0 and Meta.ash() >= cost  # Affordable.
	var t := Button.new()  # The tile.
	t.set_meta("upgrade", id)
	t.custom_minimum_size = MenuData.OSSUARY_TILE
	UiTheme.style_button(t, "card", "gold" if lv >= mx else "violet")
	t.pressed.connect(func() -> void:
		_show_detail(id)
		UiTheme.focus_deferred(_buy if not _buy.disabled else t))
	t.focus_entered.connect(_show_detail.bind(id))
	t.mouse_entered.connect(_show_detail.bind(id))
	_grid.add_child(t)
	var row := HBoxContainer.new()  # Badge | name, pips, cost.
	row.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 8)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_theme_constant_override("separation", 8)
	t.add_child(row)
	var slot := PanelContainer.new()  # Badge frame.
	slot.add_theme_stylebox_override("panel", UiTheme.style("slot", "grey"))
	slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	slot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(slot)
	var ic := MenuScreen.icon_rect(_icon(u), MenuData.OSSUARY_ICON)  # Badge.
	ic.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	slot.add_child(ic)
	var col := VBoxContainer.new()  # Name, pips, cost.
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_theme_constant_override("separation", 2)
	row.add_child(col)
	var nm := UiTheme.tier_label(String(u["name"]), UiTheme.Tier.NAME, UiTheme.TEXT_GOLD if lv >= mx else UiTheme.TEXT)
	nm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	col.add_child(nm)
	col.add_child(pips(lv, mx))
	var cl := HBoxContainer.new()  # Cost line.
	cl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cl.add_theme_constant_override("separation", 4)
	col.add_child(cl)
	if cost < 0:
		cl.add_child(UiTheme.tier_label("Max", UiTheme.Tier.BODY, UiTheme.TEXT_GOLD))
	else:
		cl.add_child(MenuScreen.icon_rect(SpriteBank.texture("icons/soul_ash"), MenuData.OSSUARY_COST_ICON))
		cl.add_child(UiTheme.tier_label(str(cost), UiTheme.Tier.BODY, MenuData.TEAL if can else MenuData.CRIMSON))
	return t


## A row of `mx` level pips, `lv` lit (soul-teal; all gold at max).
static func pips(lv: int, mx: int) -> HBoxContainer:
	var row := HBoxContainer.new()  # The pips.
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_theme_constant_override("separation", 3)
	for i in mx:
		var p := ColorRect.new()  # One pip.
		p.custom_minimum_size = MenuData.OSSUARY_PIP
		p.color = (UiTheme.TEXT_GOLD if lv >= mx else MenuData.TEAL) if i < lv else MenuData.PIP_OFF
		p.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(p)
	return row


## Shows upgrade `id` in the detail panel.
func _show_detail(id: String) -> void:
	_pick = id
	var u: Dictionary = MetaData.UPGRADES[id]
	var lv := Meta.level(id)  # Owned level.
	var mx := (u["costs"] as Array).size()  # Max level.
	var cost := Meta.next_cost(id)  # Next price (-1 at max).
	var can := cost >= 0 and Meta.ash() >= cost  # Affordable.
	_d_icon.texture = _icon(u)
	_d_name.text = String(u["name"])
	_d_name.add_theme_color_override("font_color", UiTheme.TEXT_GOLD if lv >= mx else UiTheme.TEXT)
	_d_level.text = "Level %d / %d" % [lv, mx]
	_d_desc.text = "Each level: %s" % String(u["desc"])
	_buy.disabled = not can
	_buy.text = "Max" if cost < 0 else "Buy  %d" % cost
	UiTheme.style_button(_buy, "button", "soul" if can else "")
	if can:
		_buy.add_theme_color_override("font_color", MenuData.TEAL)
	else:
		_buy.remove_theme_color_override("font_color")
	_buy.add_theme_color_override("font_disabled_color", UiTheme.TEXT_GOLD if cost < 0 else MenuData.CRIMSON)


func _buy_it(id: String) -> void:
	if Meta.buy(id):
		Sfx.play_ui("purchase")
	else:
		Sfx.play_ui("denied")
	_refresh()
	if not _buy.disabled:
		UiTheme.focus_deferred(_buy)
		return
	for t: Node in _grid.get_children():
		if String(t.get_meta("upgrade", "")) == id:
			UiTheme.focus_deferred(t as Control)
