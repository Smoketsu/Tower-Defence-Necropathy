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
	var sb := UiTheme.style("panel", "violet").duplicate() as StyleBox  # The frame, with slim margins (a compact strip, DECISIONS Y8; M7 an opaque kit panel).
	sb.set_content_margin_all(TdUiData.MENU_PAD)
	add_theme_stylebox_override("panel", sb)
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
## below, above, then the diagonals) that covers the fewest other spots and the
## least road (DECISIONS X6)
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
	var road_pts: Array[Vector2] = []  # Road samples on screen (a menu over a road hides the fight, V-rule 7).
	for rd: Road in game.roads.values():
		var d := 0.0  # Distance along the road.
		while d <= rd.length:
			road_pts.append(xf * rd.point_at(d))
			d += TdUiData.MENU_ROAD_STEP
	var best := Vector2.ZERO  # Chosen corner.
	var best_n := 1 << 30  # Spots it covers.
	for c: Vector2 in tries:
		var r := Rect2(Vector2(clampf(c.x, 4.0, vp.x - size.x - 4.0), clampf(c.y, TdUiData.TOP_BAR_H * TdHud._touch() + 4.0, vp.y - size.y - 4.0)), size)  # On screen.
		var n := 0  # Covered spots (the spot itself counts heavily), road samples, plus the spell bar.
		for o: Spot in game.spots:
			if r.grow(pick * TdUiData.MENU_CLEAR).has_point(xf * o.position):
				n += 1000 if o == s else 1
		for q: Vector2 in road_pts:
			if r.has_point(q):
				n += TdUiData.MENU_ROAD_COST
		if game.hud != null and r.intersects(game.hud.spell_bar_rect):  # The spell bar where it was placed (X6).
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


## A menu button with icon texture `tex`, text and callback (an optional
## second, smaller `sub` line under the text: the next level's gains).
func _button(box: Container, tex: Texture2D, text: String, cb: Callable, accent: String = "", sub: String = "") -> Button:
	var b := Button.new()  # The button.
	b.text = text if sub == "" else ""
	b.icon = tex if sub == "" else null
	b.expand_icon = false
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.focus_mode = Control.FOCUS_ALL if pad_focus else Control.FOCUS_NONE
	b.custom_minimum_size.y = TdUiData.MENU_BUTTON_H
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.pressed.connect(cb)
	if accent != "":
		UiTheme.style_button(b, "button", accent)
	if sub != "":
		var row := HBoxContainer.new()  # Icon | text over sub line.
		row.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 6)
		row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_theme_constant_override("separation", 8)
		b.add_child(row)
		row.add_child(MenuScreen.icon_rect(tex, TdUiData.MENU_ROW_ICON))
		var col := VBoxContainer.new()  # Text, sub line.
		col.alignment = BoxContainer.ALIGNMENT_CENTER
		col.mouse_filter = Control.MOUSE_FILTER_IGNORE
		col.add_theme_constant_override("separation", -2)
		row.add_child(col)
		var l := UiTheme.tier_label(text, UiTheme.Tier.NAME)  # Main line.
		b.set_meta("main", l)
		col.add_child(l)
		col.add_child(UiTheme.tier_label(sub, UiTheme.Tier.BODY, UiTheme.TEXT_GOOD))
	box.add_child(b)
	return b


## Empty spot: a strip of build tiles (icon, name, cost) with tall < / > page
## buttons at its ends and page dots under it when more classes are open than
## TdUiData.MENU_PAGE (DECISIONS Y8, M7).
func _build_empty(box: VBoxContainer, s: Spot) -> void:
	var strip := HBoxContainer.new()  # [<] tiles [>].
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	strip.add_theme_constant_override("separation", TdUiData.MENU_GAP)
	box.add_child(strip)
	var grid := GridContainer.new()  # The page's tiles.
	grid.columns = TdUiData.MENU_COLUMNS
	grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	grid.add_theme_constant_override("h_separation", TdUiData.MENU_GAP)
	grid.add_theme_constant_override("v_separation", TdUiData.MENU_GAP)
	var ids: Array[String] = []  # Open classes that fit this spot (locked ones hidden, Unlocks).
	for id: String in TowerData.ORDER:
		if String(TowerData.TOWERS[id]["spot"]) == s.kind and Unlocks.tower_open(id):
			ids.append(id)
	var pages := maxi(ceili(float(ids.size()) / float(TdUiData.MENU_PAGE)), 1)  # Pages of tiles.
	var page := clampi(int(_page.get(s.kind, 0)), 0, pages - 1)  # Page shown.
	if pages > 1:
		_page_button(strip, s.kind, page, pages, -1)
	strip.add_child(grid)
	if pages > 1:
		_page_button(strip, s.kind, page, pages, 1)
		var dots := HBoxContainer.new()  # One dot per page, the shown one gold.
		dots.alignment = BoxContainer.ALIGNMENT_CENTER
		dots.mouse_filter = Control.MOUSE_FILTER_IGNORE
		dots.add_theme_constant_override("separation", TdUiData.MENU_DOT_GAP)
		for i in pages:
			var d := ColorRect.new()  # A page dot.
			d.custom_minimum_size = TdUiData.MENU_DOT
			d.color = UiTheme.TEXT_GOLD if i == page else TdUiData.MENU_DOT_OFF
			d.mouse_filter = Control.MOUSE_FILTER_IGNORE
			dots.add_child(d)
		box.add_child(dots)
	for id: String in ids.slice(page * TdUiData.MENU_PAGE, (page + 1) * TdUiData.MENU_PAGE):
		var row: Dictionary = TowerData.TOWERS[id]
		var joins := _would_join(id, s)  # Synergy names it would form here.
		var can := game.economy.can_afford(int(row["cost"]))  # Affordable now.
		var b := Button.new()  # The tile.
		b.custom_minimum_size = TdUiData.MENU_TILE
		b.focus_mode = Control.FOCUS_ALL if pad_focus else Control.FOCUS_NONE
		b.set_meta("ui_lift", false)  # The strip sits on the map: no rising tiles.
		b.pressed.connect(_do_build.bind(s, id))
		UiTheme.style_button(b, "card", "gold" if not joins.is_empty() and can else ("violet" if can else ""))
		b.disabled = not can
		var col := VBoxContainer.new()  # Icon, name, cost.
		col.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 4)
		col.mouse_filter = Control.MOUSE_FILTER_IGNORE
		col.add_theme_constant_override("separation", 0)
		col.alignment = BoxContainer.ALIGNMENT_CENTER
		b.add_child(col)
		var ic := MenuScreen.icon_rect(SpriteBank.texture("icons/" + String(row["icon"])), TdUiData.MENU_ICON)
		ic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		ic.modulate = Color.WHITE if can else TdUiData.MENU_DIM
		col.add_child(ic)
		var nm := UiTheme.tier_label(("+ " if not joins.is_empty() else "") + String(row.get("short", row["name"])), UiTheme.Tier.BODY, UiTheme.TEXT_GOLD if not joins.is_empty() else (UiTheme.TEXT if can else UiTheme.TEXT_DIM))
		nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		nm.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		col.add_child(nm)
		col.add_child(_cost_line(int(row["cost"]), can))
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


## A centred cost line: the souls icon and `cost` (soul-teal when affordable, else crimson).
func _cost_line(cost: int, can: bool) -> HBoxContainer:
	var line := HBoxContainer.new()  # Icon and number.
	line.alignment = BoxContainer.ALIGNMENT_CENTER
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	line.add_theme_constant_override("separation", 3)
	var si := MenuScreen.icon_rect(TdArt.texture("icon_souls"), TdUiData.MENU_COST_ICON)  # Souls icon.
	si.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	line.add_child(si)
	line.add_child(UiTheme.tier_label(str(cost), UiTheme.Tier.BODY, MenuData.TEAL if can else MenuData.CRIMSON))
	return line


## A page button of the build strip ("<" for `d` -1, ">" for +1; wraps around),
## a full tile tall, its tooltip the page it shows.
func _page_button(row: HBoxContainer, kind: String, page: int, pages: int, d: int) -> void:
	var b := Button.new()  # Previous / next page.
	b.text = "<" if d < 0 else ">"
	b.tooltip_text = "Page %d / %d" % [posmod(page + d, pages) + 1, pages]
	b.custom_minimum_size = TdUiData.MENU_PAGER
	b.focus_mode = Control.FOCUS_ALL if pad_focus else Control.FOCUS_NONE
	b.set_meta("ui_lift", false)
	b.pressed.connect(func() -> void:
		_page[kind] = posmod(page + d, pages)
		refresh())
	row.add_child(b)


## Enables `b` when affordable (soul-teal text), else dims it with a crimson cost.
func _afford(b: Button, can: bool) -> void:
	b.disabled = not can
	if can and b.get_theme_stylebox("normal") == UiTheme.style("button", "soul"):
		b.add_theme_color_override("font_color", MenuData.TEAL)
	b.add_theme_color_override("font_disabled_color", MenuData.CRIMSON)
	if b.has_meta("main"):  # A two-line button: its main line carries the colour.
		var l := b.get_meta("main") as Label
		l.add_theme_color_override("font_color", MenuData.TEAL if can and b.get_theme_stylebox("normal") == UiTheme.style("button", "soul") else (UiTheme.TEXT if can else MenuData.CRIMSON))


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
	box.custom_minimum_size.x = TdUiData.MENU_TOWER_W
	var head := HBoxContainer.new()  # Icon | name, level, kills.
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	head.add_theme_constant_override("separation", 8)
	box.add_child(head)
	var icon := String(EvolutionData.EVOLUTIONS[t.evolution]["icon"]) if t.evolution != "" else String(t.row["icon"])  # Its icon key.
	head.add_child(MenuScreen.icon_rect(SpriteBank.texture("icons/" + icon), TdUiData.MENU_HEAD_ICON))
	var hc := VBoxContainer.new()  # Name over level and kills.
	hc.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hc.add_theme_constant_override("separation", -2)
	head.add_child(hc)
	hc.add_child(UiTheme.tier_label(String(t.stats["name"]), UiTheme.Tier.NAME, UiTheme.TEXT_GOLD if t.evolution != "" else UiTheme.TEXT))
	var sub := HBoxContainer.new()  # Level pips and kills.
	sub.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sub.add_theme_constant_override("separation", 3)
	hc.add_child(sub)
	for i in 5:
		var pip := ColorRect.new()  # A level pip (gold = reached).
		pip.custom_minimum_size = TdUiData.MENU_PIP
		pip.color = (UiTheme.TEXT_GOLD if t.evolution != "" else MenuData.TEAL) if i < t.level else TdUiData.MENU_DOT_OFF
		pip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		pip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		sub.add_child(pip)
	sub.add_child(UiTheme.tier_label("  Kills %d" % t.kills, UiTheme.Tier.BODY, UiTheme.TEXT_DIM))
	box.add_child(UiTheme.tier_label(_stat_line(t), UiTheme.Tier.BODY, UiTheme.TEXT_DIM))
	if t.level < 5:
		var cost := t.upgrade_cost()  # Souls for the next level.
		var free := game.free_upgrades > 0  # A chest credit pays it.
		var can := free or game.economy.can_afford(cost)  # Affordable now.
		var b := _button(box, TdArt.texture("icon_upgrade"), "Upgrade  " + ("Free" if free else str(cost)), _act.bind(game.upgrade, t.spot), "gold" if free else ("soul" if can else ""), _gains(t))
		_afford(b, can)
	if t.can_evolve():
		var free := game.free_upgrades > 0  # A chest credit pays it.
		var e := _button(box, TdArt.texture("icon_evolve"), "Evolve  " + ("Free" if free else str(t.evolve_cost())), _act.bind(game.evolve, t.spot), "gold")
		_afford(e, free or game.economy.can_afford(t.evolve_cost()))
	var row := HBoxContainer.new()  # Target | Sell.
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_theme_constant_override("separation", TdUiData.MENU_GAP)
	box.add_child(row)
	if t.block == null:
		_button(row, TdArt.texture("icon_target_" + t.target_mode), t.target_mode.capitalize(), func() -> void: game.set_target(t.spot))
	_button(row, TdArt.texture("icon_sell"), "Sell  +%d" % t.sell_value(), _ask_sell.bind(t), "crimson")
	for pair: Array in t.synergies:
		box.add_child(UiTheme.tier_label("+ " + String(SynergyData.SYNERGIES[pair[0]]["name"]), UiTheme.Tier.BODY, UiTheme.TEXT_GOOD))


## The tower's current numbers in one line (read from its stats; display only).
func _stat_line(t: Tower) -> String:
	var parts: Array[String] = []  # "Dmg 24" ...
	if float(t.stats.get("damage", 0.0)) > 0.0:
		parts.append("Dmg %d" % roundi(float(t.stats["damage"])))
	if float(t.stats.get("interval", 0.0)) > 0.0:
		parts.append("%.1f/s" % (1.0 / float(t.stats["interval"])))
	if t.stats.has("body_hp"):
		parts.append("HP %d" % roundi(float(t.stats["body_hp"])))
	if t.stats.has("heal"):
		parts.append("Heal %d" % roundi(float(t.stats["heal"])))
	if float(t.stats.get("range", 0.0)) > 0.0:
		parts.append("Range %d" % roundi(float(t.stats["range"])))
	return "  ".join(parts)


## What the next level adds, from TowerData.LEVELS (e.g. "+26% dmg  +5% range"; "" at max).
func _gains(t: Tower) -> String:
	var lv: Array = TowerData.LEVELS.get(t.tower_id, [])
	if t.level >= lv.size():
		return ""
	var now: Dictionary = lv[t.level - 1]
	var nxt: Dictionary = lv[t.level]
	var out: Array[String] = []  # "+26% dmg" ...
	for k: String in TdUiData.MENU_GAIN_WORDS:
		var a := float(now.get(k, 1.0))  # This level's multiplier.
		var b := float(nxt.get(k, 1.0))  # The next one's.
		if b > a + 0.001:
			out.append("+%d%% %s" % [roundi((b / a - 1.0) * 100.0), String(TdUiData.MENU_GAIN_WORDS[k])])
	if int(nxt.get("bodies", 0)) > int(now.get("bodies", 0)):
		out.append("+1 body")
	return "  ".join(out)


## Sell asks first (DECISIONS M8): "Sell <tower> for N souls?" with Cancel
## focused (ConfirmDialog); the run waits while it is open (set_paused, back
## to running on close unless it was paused before). The autotest never comes here (it calls TdGame.sell()).
func _ask_sell(t: Tower) -> void:
	var s := t.spot  # The spot sold from.
	var was := game.paused  # Paused before the dialog.
	game.set_paused(true)
	var d := ConfirmDialog.ask(game.hud.root, "Sell?", "Sell %s for %d souls?" % [String(t.stats["name"]), t.sell_value()], "Sell", func() -> void:
		if s.tower == t:
			_act(game.sell, s))
	d.closed.connect(func(_ok: bool) -> void: game.set_paused(was))


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
		game.overlay.queue_redraw()  # The sold tower's range ring goes too (the overlay only redraws while something is selected).
	game.changed.emit()
