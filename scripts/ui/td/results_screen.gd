## ResultsScreen: the end-of-map card (GDD §3, §9.3; menu overhaul, DECISIONS
## M10): Victory (gold) with the skull rating, or Defeat (crimson) / the
## Reckoning wave reached; the map's name and difficulty; three stat tiles
## with icons (waves cleared, lives kept, the Soul Ash this run paid, counting
## up; Main records the run before the card opens and leaves the amount in the
## run's "ash_paid" meta); what a clear unlocked as soul-teal plates; a
## Reckoning offer after a clear when the run supports one
## (TdGame.start_reckoning(), read defensively), and Next (the next open map,
## the run's "on_next" meta) / Again / Menu; a hint strip at the bottom.
class_name ResultsScreen
extends Control

## The run.
var game: TdGame = null
## True for a win.
var won: bool = false


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	theme = UiTheme.get_theme()
	add_child(UiTheme.backdrop())
	var center := CenterContainer.new()  # Centres the card.
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var accent := "gold" if won else "crimson"  # Kit accent: gold = victory, crimson = defeat.
	var panel := UiTheme.ornate_panel(accent)  # The card.
	center.add_child(panel)
	var box := VBoxContainer.new()  # Its rows.
	box.add_theme_constant_override("separation", 8)
	box.custom_minimum_size = Vector2(MenuData.RESULTS_W, 0)
	panel.add_child(box)
	var rk := Meta.reckoning_of(game)  # Reckoning waves reached (0 = none).
	var band := PanelContainer.new()  # Title band.
	band.add_theme_stylebox_override("panel", UiTheme.style("header", accent))
	band.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	band.custom_minimum_size.x = MenuData.TITLE_BAND_W * 0.8
	band.add_child(UiTheme.title("Victory" if won else ("Reckoning %d" % rk if rk > 0 else "Defeat"), UiTheme.TEXT_GOLD if won else MenuData.CRIMSON))
	box.add_child(band)
	if won:
		box.add_child(MenuScreen.skull_row(game.skulls(), MenuData.SKULL_BIG))
	box.add_child(_centred(UiTheme.tier_label("%s  ·  %s" % [String(game.map["name"]), String(DifficultyData.LEVELS[game.difficulty]["name"])], UiTheme.Tier.BODY, UiTheme.TEXT_DIM)))
	var stats := HBoxContainer.new()  # Stat tiles.
	stats.alignment = BoxContainer.ALIGNMENT_CENTER
	stats.add_theme_constant_override("separation", 10)
	box.add_child(stats)
	_stat(stats, TdArt.texture("icon_wave"), "%d / %d" % [game.waves.cleared_count(), game.waves.total()], "Waves", UiTheme.TEXT)
	_stat(stats, TdArt.texture("icon_lives"), "%d / %d" % [game.lives, game.start_lives], "Lives", UiTheme.TEXT if game.lives > 0 else MenuData.CRIMSON)
	var al := _stat(stats, SpriteBank.texture("icons/soul_ash"), "+0", "Soul Ash", UiTheme.TEXT_GOLD)  # Counts up.
	UiMotion.count_up(al, int(game.get_meta("ash_paid", 0)), "+%d")
	if won and not Meta.last_unlocks.is_empty():  # What this clear opened (gw2-kit; soul-teal = new).
		box.add_child(_centred(UiTheme.tier_label("Unlocked", UiTheme.Tier.LABEL, MenuData.TEAL)))
		var flow := HFlowContainer.new()  # One plate per unlock.
		flow.alignment = FlowContainer.ALIGNMENT_CENTER
		flow.add_theme_constant_override("h_separation", 6)
		flow.add_theme_constant_override("v_separation", 6)
		box.add_child(flow)
		for u: String in Meta.last_unlocks:
			var plate := PanelContainer.new()  # One unlock.
			plate.add_theme_stylebox_override("panel", UiTheme.style("panel", "dim"))
			plate.add_child(UiTheme.tier_label(u, UiTheme.Tier.BODY, MenuData.TEAL))
			flow.add_child(plate)
	box.add_child(UiTheme.divider(accent))
	var row := HBoxContainer.new()  # Buttons.
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 12)
	box.add_child(row)
	var first: Button = null  # Focused on open.
	if won and game.has_method("start_reckoning"):
		first = _button(row, "Reckoning", _reckoning, "crimson")
	var on_next: Variant = game.get_meta("on_next") if game.has_meta("on_next") else null  # Starts the next map (null = none open).
	if won and on_next is Callable:
		var nb := _button(row, "Next", on_next, "gold")
		nb.add_theme_color_override("font_color", UiTheme.TEXT_GOLD)
		first = nb
	var again := _button(row, "Again", func() -> void: game.restart_requested.emit())
	_button(row, "Menu", func() -> void: game.menu_requested.emit())
	box.add_child(InputHints.strip(MenuData.DEFAULT_HINTS.slice(0, 1)))  # Inside the card: the spell bar holds the screen's bottom.
	UiTheme.focus_deferred(first if first != null else again)
	TouchSupport.fit_to_screen(center)
	UiMotion.open(self)


## A stat tile in `row`: icon, the value (`col`), its word; returns the value Label.
func _stat(row: HBoxContainer, tex: Texture2D, value: String, word: String, col: Color) -> Label:
	var p := PanelContainer.new()  # The tile.
	p.add_theme_stylebox_override("panel", UiTheme.style("card", "violet"))
	p.custom_minimum_size = MenuData.RESULTS_STAT
	row.add_child(p)
	var v := VBoxContainer.new()  # Icon, value, word.
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.add_theme_constant_override("separation", 0)
	p.add_child(v)
	var ic := MenuScreen.icon_rect(tex, MenuData.RESULTS_ICON)  # Its icon.
	ic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	ic.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	v.add_child(ic)
	var l := _centred(UiTheme.tier_label(value, UiTheme.Tier.HEADER, col))  # The value.
	v.add_child(l)
	v.add_child(_centred(UiTheme.tier_label(word, UiTheme.Tier.LABEL, UiTheme.TEXT_DIM)))
	return l


## `l` centred.
func _centred(l: Label) -> Label:
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return l


## A button in `row`.
func _button(row: HBoxContainer, text: String, cb: Callable, accent: String = "") -> Button:
	var b := Button.new()  # The button.
	b.text = text
	b.custom_minimum_size = MenuData.NAV_BUTTON
	b.pressed.connect(cb)
	if accent != "":
		UiTheme.style_button(b, "button", accent)
	row.add_child(b)
	return b


## Starts the Reckoning after a clear (the maps agent's TdGame.start_reckoning()).
func _reckoning() -> void:
	game.call("start_reckoning")
	queue_free()
