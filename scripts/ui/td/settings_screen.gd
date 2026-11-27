## SettingsScreen: the options (GDD §9.2, §9.3), over the title or the pause
## menu, in four tabs: Audio (Master / Music / SFX), Video (fullscreen where
## the platform has it, effects quality, Reduce motion), Controls (rebind the
## keyboard key of every Settings.REBINDABLE action; Reset asks first; the
## pad and touch layouts are fixed and shown as InputHints chips) and Save (backup / restore code,
## SaveBackup; Restore only from the title). Every change goes through the
## Settings autoload; the file is written when the screen closes.
## Menu overhaul (DECISIONS M14): kit tabs, the page in a framed card.
class_name SettingsScreen
extends MenuScreen

## True when opened from a run (Restore is refused there).
var in_run: bool = false
## Tab id -> its button.
var _tabs: Dictionary = {}
## The tab's content (rebuilt per tab).
var _page: VBoxContainer = null
## Action waiting for a key (rebinding), "" = none.
var _waiting: String = ""
## Action -> its key button (Controls tab).
var _keys: Dictionary = {}
## Save tab status line.
var _status: Label = null


func _init() -> void:
	title_text = "Settings"


func _build(b: VBoxContainer) -> void:
	_tabs = tab_row(b, MenuData.SETTINGS_TABS, _show)
	var card := PanelContainer.new()  # The page's frame.
	card.add_theme_stylebox_override("panel", UiTheme.style("card", "violet"))
	b.add_child(card)
	var pad := MarginContainer.new()  # Room inside the frame.
	for side: String in ["left", "right", "top", "bottom"]:
		pad.add_theme_constant_override("margin_" + side, MenuData.CARD_PAD)
	card.add_child(pad)
	_page = VBoxContainer.new()
	_page.custom_minimum_size = MenuData.SETTINGS_PAGE
	_page.add_theme_constant_override("separation", 10)
	pad.add_child(_page)
	_show("audio")
	UiTheme.focus_deferred(_tabs["audio"])


## A labelled row in the page; returns the row to add a control to.
func _line(text: String) -> HBoxContainer:
	var row := HBoxContainer.new()  # Label | control.
	row.add_theme_constant_override("separation", 12)
	var l := UiTheme.tier_label(text, UiTheme.Tier.NAME)
	l.custom_minimum_size = Vector2(MenuData.SETTINGS_LABEL_W, 0)
	row.add_child(l)
	_page.add_child(row)
	return row


## A toggle (CheckButton) row.
func _toggle(text: String, on: bool, cb: Callable) -> void:
	var c := CheckButton.new()  # The toggle.
	c.button_pressed = on
	c.toggled.connect(cb)
	_line(text).add_child(c)


func _show(id: String) -> void:
	_waiting = ""
	_keys.clear()
	mark_tabs(_tabs, id)
	for c: Node in _page.get_children():
		_page.remove_child(c)
		c.queue_free()
	match id:
		"audio":
			for bus: String in ["Master", "Music", "SFX"]:
				var s := HSlider.new()  # Volume 0..1.
				s.min_value = 0.0
				s.max_value = 1.0
				s.step = 0.05
				s.value = float(Settings.volumes[bus])
				s.custom_minimum_size = Vector2(MenuData.SLIDER_W, 32)
				s.size_flags_vertical = Control.SIZE_SHRINK_CENTER
				s.value_changed.connect(func(v: float) -> void: Settings.set_volume(bus, v))
				_line("Sound" if bus == "SFX" else bus).add_child(s)
		"video":
			Settings.sync_fullscreen()
			match Settings.fullscreen_mode():
				Settings.FULLSCREEN_TOGGLE:
					_toggle("Fullscreen", Settings.fullscreen, Settings.set_fullscreen)
				Settings.FULLSCREEN_HOME_SCREEN:
					_page.add_child(UiTheme.para("Fullscreen: add the page to your Home Screen."))
			_toggle("Reduced effects", Settings.effects == "reduced", func(on: bool) -> void: Settings.set_effects("reduced" if on else "full"))
			_toggle("Reduce motion", Settings.reduce_motion, Settings.set_reduce_motion)
			_toggle("Screen shake", Settings.screen_shake, Settings.set_screen_shake)
			_toggle("Damage numbers", Settings.damage_numbers, Settings.set_damage_numbers)
		"controls":
			var grid := GridContainer.new()  # Two columns of action | key.
			grid.columns = 4
			grid.add_theme_constant_override("h_separation", 12)
			_page.add_child(grid)
			for action: String in Settings.REBINDABLE:
				var l := UiTheme.tier_label(String(Settings.ACTION_LABELS.get(action, action)), UiTheme.Tier.BODY)
				l.custom_minimum_size = Vector2(110, 0)
				grid.add_child(l)
				var k := Button.new()  # The key; press to rebind.
				k.custom_minimum_size = Vector2(150, 40)
				k.text = Settings.key_name(action)
				k.pressed.connect(_rebind.bind(action))
				grid.add_child(k)
				_keys[action] = k
			_page.add_child(InputHints.strip([["ui_accept", "Select"], [["spell_1", "spell_2", "spell_3", "spell_4"], "Spells"], ["ultimate", "Ultimate"], ["call_wave", "Call"], ["pause", "Pause"]]))
			_page.add_child(UiTheme.para("Touch: tap a spot to build, tap a spell then its target."))
			var r := Button.new()  # Reset keys (asks first).
			r.text = "Reset"
			r.custom_minimum_size = MenuData.NAV_BUTTON
			r.pressed.connect(func() -> void: ConfirmDialog.ask(self, "Reset keys?", "Every key goes back to its default.", "Reset", _reset_keys))
			_page.add_child(r)
		"save":
			_page.add_child(UiTheme.para(SaveBackupData.INFO))
			var row := HBoxContainer.new()  # Backup | Restore.
			row.add_theme_constant_override("separation", 12)
			_page.add_child(row)
			button(row, SaveBackupData.BACKUP, _backup)
			button(row, SaveBackupData.RESTORE, _restore)
			_status = UiTheme.tier_label("", UiTheme.Tier.BODY, MenuData.TEAL)
			_page.add_child(_status)


func _rebind(action: String) -> void:
	_waiting = action
	(_keys[action] as Button).text = "Press a key"


func _reset_keys() -> void:
	Settings.reset_bindings()
	_show("controls")


func _input(event: InputEvent) -> void:
	if _waiting == "":
		return
	var k := event as InputEventKey
	if k == null or not k.pressed or k.echo:
		return
	get_viewport().set_input_as_handled()
	var action := _waiting  # The action being rebound.
	_waiting = ""
	if k.physical_keycode != KEY_ESCAPE or action == "pause":
		Settings.set_binding(action, int(k.physical_keycode if k.physical_keycode != KEY_NONE else k.keycode))
	for a: String in _keys:
		(_keys[a] as Button).text = Settings.key_name(a)


func _backup() -> void:
	var code := SaveBackup.export_code()  # The progress as a code.
	if code == "":
		_status.text = SaveBackupData.NOTHING
		return
	SaveBackup.give_to_player(code)
	_status.text = SaveBackupData.COPIED if not OS.has_feature("web") else SaveBackupData.SHOWN


func _restore() -> void:
	if in_run:
		_status.text = SaveBackupData.IN_RUN
		return
	var code := SaveBackup.ask_player()  # Pasted code.
	if code.strip_edges() == "":
		return
	if SaveBackup.decode(code) == "":
		_status.text = SaveBackupData.INVALID
		return
	ConfirmDialog.ask(self, SaveBackupData.CONFIRM[0], SaveBackupData.CONFIRM[1], SaveBackupData.CONFIRM[2], func() -> void:
		_status.text = SaveBackupData.RESTORED if SaveBackup.import_code(code) == OK else SaveBackupData.FAILED)


func _on_back() -> void:
	if UiMotion.is_closing(self):
		return
	Settings.save_settings()
	back.emit()
