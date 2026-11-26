## TitleScreen: the front door (GDD §9.3; menu overhaul, DECISIONS M5): the
## living graveyard (MenuBackdrop) with a dark band behind the centre column,
## the Gravewatch logo, a progress plaque (maps cleared, skulls, best
## Reckoning), the Soul Ash pill top-right, and Play (gold, first and larger) /
## Codex / Ossuary / Settings / Credits (Quit too, off the Web; it asks first),
## each with a small pixel icon (MaskIcon), and the bottom hint strip. Emits
## `chosen` with the item id (MenuData.TITLE_ITEMS); Main opens the screen.
class_name TitleScreen
extends Control

## Emitted with the picked item id ("play", "codex", "ossuary", "settings", "credits").
signal chosen(id: String)


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	theme = UiTheme.get_theme()
	var bd := MenuBackdrop.new()  # The living graveyard.
	add_child(bd)
	bd.set_band(0.0, MenuData.TITLE_BAND_DARK_W, MenuData.TITLE_BAND_ALPHA)
	var center := CenterContainer.new()  # Centres the column.
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center)
	var col := VBoxContainer.new()  # Logo, plaque and buttons.
	col.add_theme_constant_override("separation", MenuData.TITLE_GAP)
	center.add_child(col)
	var logo := MenuScreen.icon_rect(TdArt.texture("logo"), 0.0)  # NECROPATHY + Gravewatch, at 2x.
	logo.custom_minimum_size = MenuData.LOGO_SIZE
	col.add_child(logo)
	col.add_child(_plaque())
	var first: Button = null  # Focused on open.
	var buttons: Array = []  # For the staggered entrance.
	for item: Array in MenuData.TITLE_ITEMS:
		var id := String(item[0])  # Item id.
		if id == "quit" and OS.has_feature("web"):
			continue
		var b := Button.new()  # One item.
		b.text = String(item[1])
		b.custom_minimum_size = MenuData.TITLE_PLAY if id == "play" else MenuData.TITLE_BUTTON
		b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		if id == "quit":
			b.pressed.connect(func() -> void: ConfirmDialog.ask(self, "Quit?", "Leave the crypt for now.", "Quit", get_tree().quit))
		else:
			b.pressed.connect(func() -> void: chosen.emit(id))
		if id == "play":
			UiTheme.style_button(b, "button", "gold")
			b.add_theme_color_override("font_color", UiTheme.TEXT_GOLD)
			UiTheme.set_tier(b, UiTheme.Tier.HEADER)
		var key := String(item[2])  # Icon: a MaskIcon id, or a SpriteBank "icons/..." key.
		var ic: Control = MenuScreen.icon_rect(SpriteBank.texture(key), MenuData.TITLE_SPRITE_ICON) if key.begins_with("icons/") else MaskIcon.new(key, MenuData.TITLE_ICON_SCALE)  # Its icon, left inside the button.
		ic.anchor_top = 0.5
		ic.anchor_bottom = 0.5
		ic.offset_top = -ic.custom_minimum_size.y * 0.5
		ic.offset_bottom = ic.custom_minimum_size.y * 0.5
		ic.offset_left = MenuData.TITLE_ICON_INSET
		ic.offset_right = MenuData.TITLE_ICON_INSET + ic.custom_minimum_size.x
		b.add_child(ic)
		col.add_child(b)
		buttons.append(b)
		if first == null:
			first = b
	var pill := MenuScreen.ash_pill()  # Soul Ash held, top-right.
	pill.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	pill.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	pill.offset_left = -MenuData.SCREEN_MARGIN
	pill.offset_right = -MenuData.SCREEN_MARGIN
	pill.offset_top = MenuData.SCREEN_MARGIN
	add_child(pill)
	add_child(InputHints.bottom_strip(MenuData.DEFAULT_HINTS.slice(0, 1)))
	UiMotion.stagger(buttons)
	UiTheme.focus_deferred(first)
	TouchSupport.fit_to_screen(center)
	UiMotion.open(self)


## The progress plaque: maps cleared of all, skulls earned, best Reckoning wave
## (pixel icon + number each, the meaning in a tooltip).
func _plaque() -> Control:
	var maps := 0  # Maps in the campaign.
	var cleared := 0  # Maps beaten.
	var skulls := 0  # Best skulls summed over maps and difficulties.
	var rk := 0  # Best Reckoning wave on any map.
	for r: Dictionary in Acts.visible_acts():
		for m: String in Acts.maps_of(String(r["id"])):
			maps += 1
			cleared += 1 if Meta.cleared(m) else 0
			rk = maxi(rk, Meta.best_reckoning(m))
			for d: String in DifficultyData.ORDER:
				skulls += Meta.skulls(m, d)
	var row := HBoxContainer.new()  # Icon + number pairs.
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", MenuData.PLAQUE_GAP)
	for s: Array in [["skull_crown", "%d / %d" % [cleared, maps], "Maps cleared"], ["skull", str(skulls), "Skulls"], ["hourglass", str(rk) if rk > 0 else "-", "Best Reckoning"]]:
		var h := HBoxContainer.new()  # One stat.
		h.add_theme_constant_override("separation", 6)
		h.tooltip_text = String(s[2])
		h.mouse_filter = Control.MOUSE_FILTER_PASS
		var ic := MaskIcon.new(String(s[0]), MenuData.PLAQUE_ICON_SCALE)  # Its icon.
		ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(ic)
		h.add_child(UiTheme.tier_label(String(s[1]), UiTheme.Tier.NAME, UiTheme.TEXT))
		row.add_child(h)
	return row
