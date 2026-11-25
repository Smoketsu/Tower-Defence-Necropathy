## SpotMenu: the menu around the tapped spot (GDD §9.1). Empty spot: the
## towers that fit it with their costs, and the synergies each would join
## there (hinted, never secret, GDD §4.4). Occupied spot: Upgrade (or Free
## with a chest credit), Target (cycles the mode), Sell, and Evolve only
## once the hidden recipe is met (gold). Affordable choices are soul-teal,
## unaffordable ones dim with a crimson cost (GDD §9 colour meaning).
## Follows TdGame.selected; rebuilt by refresh() whenever the run changes.
## Calls only TdGame's player actions. It sits on the side of the spot that
## covers the fewest other spots, and only its buttons take taps (the panel
## lets them through), so a neighbouring spot stays tappable. `hover_id` is
## the tower class under the pointer / pad focus (MapHints previews it).
## With `pad_focus` the first button takes the focus (gamepad, SpotCursor).
class_name SpotMenu
extends PanelContainer

## The run.
var game: TdGame = null
## Spot the menu was built for.
var _for: Spot = null
## Souls / level / mode snapshot it was built with (rebuilt when it changes).
var _sig: String = ""
## Tower class whose build button is hovered / focused ("" = none; MapHints).
var hover_id: String = ""
## True: the first button grabs the focus after each build (gamepad).
var pad_focus: bool = false
## True while a rebuild is queued for the end of the frame.
var _pending: bool = false
## Build-menu page per spot kind ("plot" / "post" -> 0-based page; gw2-kit: more
## towers than TdUiData.MENU_PAGE tiles are paged, so the menu never grows).
var _page: Dictionary = {}


func _ready() -> void:
	add_theme_stylebox_override("panel", UiTheme.style("ornate", "violet"))
	mouse_filter = Control.MOUSE_FILTER_IGNORE  # Gaps between buttons pass taps to the map.
	visible = false


## Shows the menu for TdGame.selected (hides it when none), rebuilding it
## when what it shows changed. Deferred to the end of the frame, so a button
## is never freed inside its own pressed signal.
func refresh() -> void:
	if not _pending:
		_pending = true
		_rebuild.call_deferred()


func _rebuild() -> void:
	_pending = false
	if not is_inside_tree():
		return
	var s := game.selected  # The selected spot.
	if s == null or game.over:
		visible = false
		_for = null
		hover_id = ""
		pad_focus = false
		return
	var t := s.tower  # Its tower, or null.
	var sig := "%s|%d|%d|%s|%d|%s" % [s.spot_id(), game.economy.souls, game.free_upgrades,
		t.tower_id + str(t.level) + t.target_mode + t.evolution + str(t.can_evolve()) if t != null else "p%d" % int(_page.get(s.kind, 0)), game.towers.size(), str(game.over)]  # What the menu shows.
	if s == _for and sig == _sig and visible:
		return
	_for = s
	_sig = sig
	for c: Node in get_children():
		remove_child(c)  # At once, so reset_size() measures only the new rows.
		c.queue_free()
	var box := VBoxContainer.new()  # The menu's rows.
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(box)
	if t == null:
		_build_empty(box, s)
	else:
		_build_tower(box, t)
	visible = true
	reset_size()
	_place.call_deferred(s)


## Puts the menu beside spot `s`, kept on screen, on the side (right, left,
## below, above, then the diagonals) that covers the fewest other spots
## (ties: that order).
func _place(s: Spot) -> void:
	if not is_instance_valid(s) or game.selected != s:
		return
	var xf := game.world.get_global_transform_with_canvas()  # Map -> screen.
	var p := xf * s.position  # Spot on screen.
	var vp := get_viewport().get_visible_rect().size  # Screen size.
	var pick := TdRulesData.SPOT_PICK * xf.get_scale().x  # Tap radius of a spot on screen.
	reset_size()
	var off := TdUiData.MENU_OFFSET  # Gap from the spot.
	var tries: Array[Vector2] = [Vector2(p.x + off, p.y - size.y * 0.5), Vector2(p.x - off - size.x, p.y - size.y * 0.5),
		Vector2(p.x - size.x * 0.5, p.y + off), Vector2(p.x - size.x * 0.5, p.y - off - size.y),
		Vector2(p.x + off, p.y + off), Vector2(p.x - off - size.x, p.y + off),
		Vector2(p.x + off, p.y - off - size.y), Vector2(p.x - off - size.x, p.y - off - size.y)]  # Candidate top-left corners: sides, then diagonals.
	for c: Vector2 in tries.duplicate():  # The same sides one step further out (clear of crowded neighbours).
		tries.append(c + (c + size * 0.5 - p).normalized() * off * TdUiData.MENU_FAR)
	var best := Vector2.ZERO  # Chosen corner.
	var best_n := 1 << 30  # Spots it covers.
	for c: Vector2 in tries:
		var r := Rect2(Vector2(clampf(c.x, 4.0, vp.x - size.x - 4.0), clampf(c.y, TdUiData.TOP_BAR_H * TdHud._touch() + 4.0, vp.y - size.y - 4.0)), size)  # On screen.
		var n := 0  # Covered spots (the spot itself counts heavily), plus the spell bar.
		for o: Spot in game.spots:
			if r.grow(pick * TdUiData.MENU_CLEAR).has_point(xf * o.position):
				n += 1000 if o == s else 1
		var bar_w := (TdUiData.SPELL_BUTTON + 8.0) * 6.0  # Room of the spell bar (up to five buttons and a gap).
		if r.intersects(Rect2((vp.x - bar_w) * 0.5, vp.y - TdUiData.SPELL_BUTTON - TdUiData.SPELL_BAR_MARGIN * 2.0, bar_w, vp.y)):
			n += 3
		if n < best_n:
			best_n = n
			best = r.position
	position = best
	if pad_focus:
		var first := _first_button(get_child(0))  # First enabled button.
		if first != null:
			first.grab_focus()


## The first enabled Button under `n` (depth first), or null.
func _first_button(n: Node) -> Button:
	for c: Node in n.get_children():
		if c is Button and not (c as Button).disabled:
			return c as Button
		var b := _first_button(c)
		if b != null:
			return b
	return null


## A menu button with icon texture `tex`, text and callback.
func _button(box: Container, tex: Texture2D, text: String, cb: Callable, accent: String = "") -> Button:
	var b := Button.new()  # The button.
	b.text = text
	b.icon = tex
	b.expand_icon = false
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.focus_mode = Control.FOCUS_ALL if pad_focus else Control.FOCUS_NONE
	b.custom_minimum_size.y = TdUiData.MENU_BUTTON_H
	b.pressed.connect(cb)
	if accent != "":
		UiTheme.style_button(b, "button", accent)
	box.add_child(b)
	return b


func _build_empty(box: VBoxContainer, s: Spot) -> void:
	box.add_child(UiTheme.tier_label("Grave plot" if s.kind == "plot" else "Road post", UiTheme.Tier.LABEL, UiTheme.TEXT_DIM))
	var grid := GridContainer.new()  # Compact tiles (icon, name, cost) so the menu covers few spots.
	grid.columns = TdUiData.MENU_COLUMNS
	grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(grid)
	var ids: Array[String] = []  # Open classes that fit this spot (locked ones hidden, Unlocks).
	for id: String in TowerData.ORDER:
		if String(TowerData.TOWERS[id]["spot"]) == s.kind and Unlocks.tower_open(id):
			ids.append(id)
	var pages := maxi(ceili(float(ids.size()) / float(TdUiData.MENU_PAGE)), 1)  # Pages of tiles.
	var page := clampi(int(_page.get(s.kind, 0)), 0, pages - 1)  # Page shown.
	if pages > 1:
		_pager(box, s.kind, page, pages)
	for id: String in ids.slice(page * TdUiData.MENU_PAGE, (page + 1) * TdUiData.MENU_PAGE):
		var row: Dictionary = TowerData.TOWERS[id]
		var joins := _would_join(id, s)  # Synergy names it would form here.
		var can := game.economy.can_afford(int(row["cost"]))  # Affordable now.
		var b := Button.new()  # The tile.
		b.custom_minimum_size = TdUiData.MENU_TILE
		b.focus_mode = Control.FOCUS_ALL if pad_focus else Control.FOCUS_NONE
		b.pressed.connect(_do_build.bind(s, id))
		if can:
			UiTheme.style_button(b, "button", "soul")
		b.disabled = not can
		var col := VBoxContainer.new()  # Icon, name, cost.
		col.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 3)
		col.mouse_filter = Control.MOUSE_FILTER_IGNORE
		col.add_theme_constant_override("separation", 0)
		col.alignment = BoxContainer.ALIGNMENT_CENTER
		b.add_child(col)
		var ic := MenuScreen.icon_rect(SpriteBank.texture("icons/" + String(row["icon"])), TdUiData.MENU_ICON)
		ic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		ic.modulate = Color.WHITE if can else Color(0.6, 0.6, 0.6)
		col.add_child(ic)
		var nm := UiTheme.tier_label(("+ " if not joins.is_empty() else "") + String(row["name"]), UiTheme.Tier.BODY, UiTheme.TEXT_GOLD if not joins.is_empty() else UiTheme.TEXT)
		nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		nm.clip_text = true
		col.add_child(nm)
		var cost := UiTheme.tier_label(str(int(row["cost"])), UiTheme.Tier.BODY, MenuData.TEAL if can else MenuData.CRIMSON)
		cost.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		col.add_child(cost)
		b.mouse_entered.connect(func() -> void: hover_id = id)
		b.focus_entered.connect(func() -> void: hover_id = id)
		b.mouse_exited.connect(func() -> void: hover_id = "")
		var hints: Array[String] = [String(row["name"])]  # Name, then every synergy this class can join (tooltip).
		if not joins.is_empty():
			hints.append("Forms here: " + ", ".join(joins))
		for sid: String in Synergies.hints_for(id):
			hints.append(String(SynergyData.SYNERGIES[sid]["hint"]))
		b.tooltip_text = "\n".join(hints)
		grid.add_child(b)


## The page row of the build menu: < page / pages > (gw2-kit; wraps around).
func _pager(box: VBoxContainer, kind: String, page: int, pages: int) -> void:
	var row := HBoxContainer.new()  # The pager.
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(row)
	for d: int in [-1, 1]:
		var b := Button.new()  # Previous / next page.
		b.text = "<" if d < 0 else ">"
		b.custom_minimum_size = TdUiData.MENU_PAGER
		b.focus_mode = Control.FOCUS_ALL if pad_focus else Control.FOCUS_NONE
		b.pressed.connect(func() -> void:
			_page[kind] = posmod(page + d, pages)
			refresh())
		row.add_child(b)
		if d < 0:
			var l := UiTheme.tier_label("%d / %d" % [page + 1, pages], UiTheme.Tier.BODY, UiTheme.TEXT_DIM)
			l.custom_minimum_size.x = 64.0
			l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			row.add_child(l)


## Enables `b` when affordable (soul-teal text), else dims it with a crimson cost.
func _afford(b: Button, can: bool) -> void:
	b.disabled = not can
	if can and b.get_theme_stylebox("normal") == UiTheme.style("button", "soul"):
		b.add_theme_color_override("font_color", MenuData.TEAL)
	b.add_theme_color_override("font_disabled_color", MenuData.CRIMSON)


## Names of the synergies tower class `id` would form on spot `s` now.
func _would_join(id: String, s: Spot) -> Array[String]:
	var out: Array[String] = []  # Synergy names.
	for sid: String in SynergyData.SYNERGIES:
		var syn: Dictionary = SynergyData.SYNERGIES[sid]
		var other := String(syn["b"]) if String(syn["a"]) == id else (String(syn["a"]) if String(syn["b"]) == id else "")  # Partner class.
		if other == "":
			continue
		for t: Tower in game.towers:
			if t.tower_id == other and t.position.distance_to(s.position) <= float(syn["radius"]):
				out.append(String(syn["name"]))
				break
	return out


func _build_tower(box: VBoxContainer, t: Tower) -> void:
	var title := "%s  Lv %d" % [String(t.stats["name"]), t.level] if t.evolution == "" else String(t.stats["name"])  # Header line.
	box.add_child(UiTheme.tier_label(title, UiTheme.Tier.NAME, UiTheme.TEXT_GOLD if t.evolution != "" else UiTheme.TEXT))
	box.add_child(UiTheme.tier_label("Kills %d" % t.kills, UiTheme.Tier.BODY, UiTheme.TEXT_DIM))
	if t.level < 5:
		var cost := t.upgrade_cost()  # Souls for the next level.
		var free := game.free_upgrades > 0  # A chest credit pays it.
		var can := free or game.economy.can_afford(cost)  # Affordable now.
		var b := _button(box, TdArt.texture("icon_upgrade"), "Upgrade  " + ("Free" if free else str(cost)), _act.bind(game.upgrade, t.spot), "gold" if free else ("soul" if can else ""))
		_afford(b, can)
	if t.can_evolve():
		var free := game.free_upgrades > 0  # A chest credit pays it.
		var e := _button(box, TdArt.texture("icon_evolve"), "Evolve  " + ("Free" if free else str(t.evolve_cost())), _act.bind(game.evolve, t.spot), "gold")
		_afford(e, free or game.economy.can_afford(t.evolve_cost()))
	if t.block == null:
		_button(box, TdArt.texture("icon_target_" + t.target_mode), "Target  " + t.target_mode.capitalize(), func() -> void: game.set_target(t.spot))
	_button(box, TdArt.texture("icon_sell"), "Sell  +%d" % t.sell_value(), _act.bind(game.sell, t.spot), "crimson")
	for pair: Array in t.synergies:
		box.add_child(UiTheme.tier_label("+ " + String(SynergyData.SYNERGIES[pair[0]]["name"]), UiTheme.Tier.BODY, UiTheme.TEXT_GOOD))


## Builds tower `id` on `s` and closes the menu (tap the spot again for its upgrades).
func _do_build(s: Spot, id: String) -> void:
	if game.build(s, id):
		game.selected = null
	else:
		game.sound("denied")
	game.changed.emit()


## Runs action `fn(spot)`; a sale closes the menu.
func _act(fn: Callable, s: Spot) -> void:
	if not bool(fn.call(s)):
		game.sound("denied")
	if s.tower == null:
		game.selected = null
	game.changed.emit()
