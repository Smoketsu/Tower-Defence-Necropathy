## PauseMenu: the in-map pause overlay (GDD §9.3 "pause"): Resume, Restart,
## Settings (the SettingsScreen over the run) and Menu; Restart and Menu ask first (ConfirmDialog, Cancel focused), as in
## Necropathy. The run is paused through TdGame.set_paused (no tree pause).
## Emits through TdGame's restart / menu requests, handled by Main.
class_name PauseMenu
extends Control

## The run.
var game: TdGame = null


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
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
	var resume := _button(box, "Resume", _resume)  # Focused first.
	_button(box, "Restart", func() -> void: ConfirmDialog.ask(self, "Restart?", "This map starts over.", "Restart", func() -> void: game.restart_requested.emit()))
	_button(box, "Settings", _settings)
	_button(box, "Menu", func() -> void: ConfirmDialog.ask(self, "Leave?", "This map's progress is lost.", "Leave", func() -> void: game.menu_requested.emit()))
	UiTheme.focus_deferred(resume)
	UiMotion.open(self)


## A full-width button.
func _button(box: Container, text: String, cb: Callable) -> Button:
	var b := Button.new()  # The button.
	b.text = text
	b.custom_minimum_size = MenuData.TITLE_BUTTON
	b.pressed.connect(cb)
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
