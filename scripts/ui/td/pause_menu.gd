## PauseMenu: the in-map pause overlay (GDD §9.3 "pause"): Resume, Restart,
## Settings (the SettingsScreen over the run) and Menu; Restart and Menu ask first (ConfirmDialog, Cancel focused), as in
## Necropathy. The run is paused through TdGame.set_paused (no tree pause).
## Emits through TdGame's restart / menu requests, handled by Main.
## Menu overhaul (DECISIONS M11): the map, difficulty, wave and lives under the
## title, a pixel icon on each button, the hint strip at the bottom.
class_name PauseMenu
extends Control

## The run.
var game: TdGame = null


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	theme = UiTheme.get_theme()
	add_child(UiTheme.backdrop())
	var center := CenterContainer.new()  # Centres the panel.
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var panel := UiTheme.ornate_panel("violet")  # The card.
	center.add_child(panel)
	var box := VBoxContainer.new()  # Title and buttons.
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)
	box.add_child(UiTheme.title("Paused"))
	var where := UiTheme.tier_label("%s  ·  %s" % [String(game.map["name"]), String(DifficultyData.LEVELS[game.difficulty]["name"])], UiTheme.Tier.BODY, UiTheme.TEXT_DIM)  # Map and difficulty.
	where.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(where)
	var st := HBoxContainer.new()  # Wave and lives.
	st.alignment = BoxContainer.ALIGNMENT_CENTER
	st.add_theme_constant_override("separation", 18)
	box.add_child(st)
	for e: Array in [["icon_wave", "%d / %d" % [game.waves.cleared_count(), game.waves.total()]], ["icon_lives", "%d / %d" % [game.lives, game.start_lives]]]:
		var h := HBoxContainer.new()  # One stat.
		h.add_theme_constant_override("separation", 6)
		var ic := MenuScreen.icon_rect(TdArt.texture(String(e[0])), MenuData.PAUSE_STAT_ICON)  # Its icon.
		ic.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		h.add_child(ic)
		h.add_child(UiTheme.tier_label(String(e[1]), UiTheme.Tier.NAME))
		st.add_child(h)
	box.add_child(UiTheme.divider())
	var resume := _button(box, "Resume", _resume, "skull")  # Focused first.
	UiTheme.style_button(resume, "button", "gold")
	resume.add_theme_color_override("font_color", UiTheme.TEXT_GOLD)
	_button(box, "Restart", func() -> void: ConfirmDialog.ask(self, "Restart?", "This map starts over.", "Restart", func() -> void: game.restart_requested.emit()), "hourglass")
	_button(box, "Settings", _settings, "candle")
	_button(box, "Menu", func() -> void: ConfirmDialog.ask(self, "Leave?", "This map's progress is lost.", "Leave", func() -> void: game.menu_requested.emit()), "tomb")
	box.add_child(InputHints.strip([["ui_accept", "Select"], ["pause", "Resume"]]))  # Inside the card: the spell bar holds the screen's bottom.
	UiTheme.focus_deferred(resume)
	TouchSupport.fit_to_screen(center)
	UiMotion.open(self)


## A full-width button with MaskIconData icon `icon` inside its left edge.
func _button(box: Container, text: String, cb: Callable, icon: String) -> Button:
	var b := Button.new()  # The button.
	b.text = text
	b.custom_minimum_size = MenuData.TITLE_BUTTON
	b.pressed.connect(cb)
	var ic := MaskIcon.new(icon, MenuData.TITLE_ICON_SCALE)  # Its icon.
	ic.anchor_top = 0.5
	ic.anchor_bottom = 0.5
	ic.offset_top = -ic.custom_minimum_size.y * 0.5
	ic.offset_bottom = ic.custom_minimum_size.y * 0.5
	ic.offset_left = MenuData.TITLE_ICON_INSET
	ic.offset_right = MenuData.TITLE_ICON_INSET + ic.custom_minimum_size.x
	b.add_child(ic)
	box.add_child(b)
	return b


## Opens Settings over the pause card (Restore is refused in a run).
func _settings() -> void:
	var st := SettingsScreen.new()  # The options.
	st.overlay = true
	st.in_run = true
	st.back.connect(func() -> void: UiMotion.close(st, st.queue_free))
	add_child(st)


func _resume() -> void:
	game.set_paused(false)
	queue_free()


func _unhandled_input(event: InputEvent) -> void:
	if get_child_count() > 0 and get_child(get_child_count() - 1) is SettingsScreen:
		return
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_resume()
