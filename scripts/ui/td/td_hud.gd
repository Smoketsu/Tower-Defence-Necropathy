## TdHud: the in-map interface (GDD §9.1), on a CanvasLayer over the map:
## the top bar (lives, souls, wave of total, next-wave preview, Call, chest
## credits, speed, pause), the spell bar (three spells with cooldown sweeps
## and the ultimate with its meter), the banner line, the spot menu
## (SpotMenu), the pause menu (PauseMenu) and the results (ResultsScreen).
## Keyboard / pad actions (GDD §9.2) are handled here too. It only reads the
## run and calls TdGame's player actions; it never changes state itself.
class_name TdHud
extends CanvasLayer

## The run.
var game: TdGame = null
## Full-rect root (ignores the mouse so map taps pass through).
var root: Control = null
## Top bar labels.
var _lives: Label = null
## See _lives.
var _souls: Label = null
## See _lives.
var _wave: Label = null
## See _lives.
var _chest: Label = null
## Next-wave preview row.
var _preview: HBoxContainer = null
## Top bar buttons.
var _call: Button = null
## See _call.
var _speed: Button = null
## Spell slot buttons, then the ultimate's.
var _spells: Array[SpellButton] = []
## See _spells.
var _ult: SpellButton = null
## The banner ribbon and its label.
var _banner: PanelContainer = null
## See _banner.
var _banner_label: Label = null
## Banner lines waiting to be shown.
var _banner_queue: Array[String] = []
## Real seconds left on the current banner (0 = none showing).
var _banner_left: float = 0.0
## The spot menu.
var menu: SpotMenu = null
## Wave number the preview was built for (rebuilt when it changes).
var _preview_wave: int = -2


func _ready() -> void:
	layer = 5
	root = Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.theme = UiTheme.get_theme()
	add_child(root)
	_build_top_bar()
	_build_spell_bar()
	_banner = UiTheme.ribbon("gold")
	_banner_label = UiTheme.tier_label("", UiTheme.Tier.NAME, UiTheme.TEXT_GOLD)
	_banner.add_child(_banner_label)
	_banner.visible = false
	root.add_child(_banner)
	menu = SpotMenu.new()
	menu.game = game
	root.add_child(menu)
	game.changed.connect(_refresh)
	game.caster.changed.connect(_refresh)
	game.banner_requested.connect(_queue_banner)
	game.ended.connect(_on_ended)
	_refresh()


## An icon (TdArt role) as a TextureRect.
func _icon(role: String) -> TextureRect:
	var r := TextureRect.new()  # The icon.
	r.texture = TdArt.texture(role)
	r.custom_minimum_size = Vector2(TdUiData.ICON, TdUiData.ICON)
	r.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


## A top-bar button with icon role `role` and text `text` calling `cb`.
func _button(role: String, text: String, cb: Callable) -> Button:
	var b := Button.new()  # The button.
	b.text = text
	b.icon = TdArt.texture(role) if role != "" else null
	b.focus_mode = Control.FOCUS_NONE
	b.pressed.connect(cb)
	return b


func _build_top_bar() -> void:
	var bar := PanelContainer.new()  # The strip across the top.
	bar.add_theme_stylebox_override("panel", UiTheme.style("panel", "dim"))
	bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	bar.custom_minimum_size = Vector2(0, TdUiData.TOP_BAR_H)
	root.add_child(bar)
	var row := HBoxContainer.new()  # Its contents.
	row.add_theme_constant_override("separation", 10)
	bar.add_child(row)
	row.add_child(_icon("icon_lives"))
	_lives = UiTheme.tier_label("", UiTheme.Tier.NAME)
	row.add_child(_lives)
	row.add_child(_icon("icon_souls"))
	_souls = UiTheme.tier_label("", UiTheme.Tier.NAME, UiTheme.TEXT_GOLD)
	row.add_child(_souls)
	row.add_child(_icon("icon_wave"))
	_wave = UiTheme.tier_label("", UiTheme.Tier.NAME)
	row.add_child(_wave)
	_preview = HBoxContainer.new()
	row.add_child(_preview)
	_chest = UiTheme.tier_label("", UiTheme.Tier.BODY, UiTheme.TEXT_GOLD)
	row.add_child(_chest)
	var spacer := Control.new()  # Pushes the buttons right.
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(spacer)
	_call = _button("icon_call", "Call", game.call_wave)
	row.add_child(_call)
	_speed = _button("icon_speed", "x1", game.cycle_speed)
	row.add_child(_speed)
	row.add_child(_button("", "Pause", open_pause))


func _build_spell_bar() -> void:
	var bar := HBoxContainer.new()  # Bottom centre.
	bar.add_theme_constant_override("separation", 8)
	bar.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	bar.grow_horizontal = Control.GROW_DIRECTION_BOTH
	bar.grow_vertical = Control.GROW_DIRECTION_BEGIN
	bar.position.y -= TdUiData.SPELL_BAR_MARGIN
	root.add_child(bar)
	for i in game.caster.loadout.size():
		var b := SpellButton.new()  # One spell slot.
		b.icon_key = String(SpellData.SPELLS[game.caster.loadout[i]]["icon"])
		b.tooltip_text = String(SpellData.SPELLS[game.caster.loadout[i]]["name"])
		b.custom_minimum_size = Vector2(TdUiData.SPELL_BUTTON, TdUiData.SPELL_BUTTON)
		b.focus_mode = Control.FOCUS_NONE
		b.pressed.connect(_arm.bind(i))
		bar.add_child(b)
		_spells.append(b)
	_ult = SpellButton.new()
	_ult.icon_key = String(SpellData.ULTIMATE["icon"])
	_ult.tooltip_text = String(SpellData.ULTIMATE["name"])
	_ult.is_ultimate = true
	_ult.custom_minimum_size = Vector2(TdUiData.SPELL_BUTTON, TdUiData.SPELL_BUTTON)
	_ult.focus_mode = Control.FOCUS_NONE
	_ult.pressed.connect(func() -> void: game.caster.cast_ultimate())
	UiTheme.style_button(_ult, "button", "gold")
	bar.add_child(_ult)


## Arms spell slot `i` for targeting (the next map tap casts it); again = disarm.
func _arm(i: int) -> void:
	if game.over or not game.caster.is_ready(i):
		game.sound("denied")
		return
	game.armed = -1 if game.armed == i else i
	game.selected = null
	_refresh()


## Rebuilds every top-bar text and enables buttons from the run's state.
func _refresh() -> void:
	_lives.text = str(game.lives)
	_souls.text = str(game.economy.souls)
	var w := game.waves.current + 1  # Current wave number (0 before wave 1).
	_wave.text = "%d/%d" % [w, game.waves.total()]
	_chest.text = "Free x%d" % game.free_upgrades if game.free_upgrades > 0 else ""
	_call.disabled = not game.waves.can_call()
	var left := game.waves.time_to_next()  # Seconds to the next wave.
	_call.text = "Call" if left == INF or game.waves.current < 0 else "Call +%d" % floori(left * EconomyData.CALL_PER_SECOND)
	_speed.text = "x%d" % game.speed
	if _preview_wave != game.waves.current:
		_preview_wave = game.waves.current
		_build_preview()
	menu.refresh()


## The next wave's kinds as small sprites with counts.
func _build_preview() -> void:
	for c: Node in _preview.get_children():
		c.queue_free()
	for pair: Array in game.waves.next_preview():
		var r := TextureRect.new()  # The kind's sprite.
		r.texture = SpriteBank.texture(String(TdEnemyData.KINDS[pair[0]]["sprite"]))
		r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		r.custom_minimum_size = Vector2(TdUiData.PREVIEW_ICON, TdUiData.PREVIEW_ICON)
		r.tooltip_text = String(TdEnemyData.KINDS[pair[0]]["name"])
		_preview.add_child(r)
		_preview.add_child(UiTheme.tier_label("x%d" % int(pair[1]), UiTheme.Tier.BODY, UiTheme.TEXT_DIM))


func _process(delta: float) -> void:
	for i in _spells.size():
		_spells[i].frac = game.caster.cooldown_frac(i) if game.caster.spells[i] != null else 0.0
		_spells[i].armed = game.armed == i
		_spells[i].disabled = game.caster.spells[i] == null
		_spells[i].queue_redraw()
	_ult.frac = game.caster.meter / float(SpellData.ULTIMATE["meter_max"])
	_ult.disabled = not game.caster.ultimate_ready()
	_ult.queue_redraw()
	if game.waves.current >= 0 and game.waves.can_call():
		_call.text = "Call +%d" % floori(game.waves.time_to_next() * EconomyData.CALL_PER_SECOND)
	_step_banner(delta)


## Queues banner line `text` (shown one after another).
func _queue_banner(text: String) -> void:
	_banner_queue.append(text)


## Shows, holds and fades the banners on real time (UI motion, not gameplay).
func _step_banner(delta: float) -> void:
	if _banner_left <= 0.0:
		if _banner_queue.is_empty():
			_banner.visible = false
			return
		_banner_label.text = _banner_queue.pop_front()
		_banner_left = TdUiData.BANNER_HOLD + TdUiData.BANNER_FADE
		_banner.visible = true
		_banner.reset_size()
	_banner_left -= delta
	_banner.modulate.a = clampf(_banner_left / TdUiData.BANNER_FADE, 0.0, 1.0)
	_banner.position = Vector2((root.size.x - _banner.size.x) * 0.5, TdUiData.BANNER_Y - _banner.size.y * 0.5)


func open_pause() -> void:
	if game.over or root.has_node("PauseMenu"):
		return
	game.set_paused(true)
	var p := PauseMenu.new()  # The pause overlay.
	p.name = "PauseMenu"
	p.game = game
	root.add_child(p)


func _on_ended(won: bool) -> void:
	game.armed = -1
	game.selected = null
	menu.refresh()
	var r := ResultsScreen.new()  # Win / lose card.
	r.game = game
	r.won = won
	root.add_child(r)


func _unhandled_input(event: InputEvent) -> void:
	if game.over:
		return
	for i in 3:
		if event.is_action_pressed("spell_%d" % (i + 1)) and i < _spells.size():
			_arm(i)
	if event.is_action_pressed("ultimate"):
		game.caster.cast_ultimate()
	elif event.is_action_pressed("call_wave"):
		game.call_wave()
	elif event.is_action_pressed("speed"):
		game.cycle_speed()
	elif event.is_action_pressed("pause") and not game.paused:
		open_pause()
