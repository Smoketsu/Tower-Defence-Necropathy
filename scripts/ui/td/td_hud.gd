## TdHud: the in-map interface (GDD §9.1), on a CanvasLayer over the map:
## the top bar (lives, souls, wave of total, next-wave preview, Call, chest
## credits, speed, pause), the spell bar (three spells with cooldown sweeps
## and the ultimate with its meter), the banner line, the spot menu
## (SpotMenu), the pause menu (PauseMenu) and the results (ResultsScreen).
## Keyboard / pad actions (GDD §9.2) are handled here too; the gamepad spot
## cursor is SpotCursor and the map-space hints (range / synergy preview,
## cursor ring) are MapHints. Banners announce each wave, every enemy kind
## new to the map (violet) and a boss arrival (crimson). It only reads the
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
## Banners waiting to be shown: [text, ribbon accent] pairs.
var _banner_queue: Array = []
## Ribbon accent -> its stylebox (the banner switches between them).
var _banner_accent: String = "gold"
## Enemy kinds already announced on this map (new-kind banners).
var _announced: Dictionary = {}
## The gamepad spot cursor.
var cursor: SpotCursor = null
## Real seconds left on the current banner (0 = none showing).
var _banner_left: float = 0.0
## The spot menu.
var menu: SpotMenu = null
## Wave number the preview was built for (rebuilt when it changes).
var _preview_wave: int = -2
## Real seconds left on the lives counter's leak shake (0 = still; visual).
var _lives_shake: float = 0.0
## The lives label's x before the shake (px).
var _lives_x: float = 0.0


func _ready() -> void:
	layer = 5
	root = Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.theme = UiTheme.get_theme()
	add_child(root)
	_build_top_bar()
	_build_spell_bar()
	_banner = UiTheme.ribbon("gold")
	_banner_label = UiTheme.tier_label("", UiTheme.Tier.BODY, UiTheme.TEXT_GOLD)  # Compact: it fits in the top bar.
	_banner.add_child(_banner_label)
	_banner.visible = false
	root.add_child(_banner)
	menu = SpotMenu.new()
	menu.game = game
	root.add_child(menu)
	game.changed.connect(_refresh)
	game.caster.changed.connect(_refresh)
	game.banner_requested.connect(_queue_banner)
	game.wave_started.connect(_announce)
	cursor = SpotCursor.new()
	cursor.game = game
	cursor.hud = self
	add_child(cursor)
	var hints := MapHints.new()  # Range / synergy preview and the cursor ring, in map space.
	hints.hud = self
	game.world.add_child(hints)
	game.ended.connect(_on_ended)
	_refresh()


## Size multiplier of the tappable HUD buttons (TdUiData.TOUCH_SCALE on phones / tablets).
static func _touch() -> float:
	return TdUiData.TOUCH_SCALE if TouchSupport.is_mobile() else 1.0


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
	b.custom_minimum_size = TdUiData.TOP_BUTTON * (TdUiData.TOUCH_TOP_SCALE if TouchSupport.is_mobile() else 1.0)
	b.pressed.connect(cb)
	return b


func _build_top_bar() -> void:
	var bar := PanelContainer.new()  # The strip across the top.
	bar.add_theme_stylebox_override("panel", UiTheme.style("panel", "dim"))
	bar.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	bar.custom_minimum_size = Vector2(0, TdUiData.TOP_BAR_H)
	root.add_child(bar)
	bar.resized.connect(func() -> void: game.set_top_inset(bar.get_global_rect().end.y))
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
	row.add_child(UiTheme.tier_label("Next", UiTheme.Tier.LABEL, UiTheme.TEXT_DIM))
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
	var vp := get_viewport().get_visible_rect().size  # Layout size.
	var side := TouchSupport.is_mobile() and vp.x / vp.y >= TdUiData.SIDE_SPELL_ASPECT  # Wide phone: a column in the free left margin.
	var bar: BoxContainer = VBoxContainer.new() if side else HBoxContainer.new()  # Bottom centre, or left column.
	bar.add_theme_constant_override("separation", 8)
	if side:
		bar.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
		bar.grow_vertical = Control.GROW_DIRECTION_BOTH
		bar.position.x += TdUiData.SPELL_BAR_MARGIN
	else:
		bar.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
		bar.grow_horizontal = Control.GROW_DIRECTION_BOTH
		bar.grow_vertical = Control.GROW_DIRECTION_BEGIN
		bar.position.y -= TdUiData.SPELL_BAR_MARGIN
	root.add_child(bar)
	for i in game.caster.loadout.size():
		var b := SpellButton.new()  # One spell slot.
		b.icon_key = String(SpellData.SPELLS[game.caster.loadout[i]]["icon"])
		b.tooltip_text = String(SpellData.SPELLS[game.caster.loadout[i]]["name"])
		b.custom_minimum_size = Vector2(TdUiData.SPELL_BUTTON, TdUiData.SPELL_BUTTON) * _touch()
		b.focus_mode = Control.FOCUS_NONE
		b.pressed.connect(_arm.bind(i))
		bar.add_child(b)
		_spells.append(b)
	_ult = SpellButton.new()
	_ult.icon_key = String(SpellData.ULTIMATE["icon"])
	_ult.tooltip_text = String(SpellData.ULTIMATE["name"])
	_ult.is_ultimate = true
	_ult.custom_minimum_size = Vector2(TdUiData.SPELL_BUTTON, TdUiData.SPELL_BUTTON) * _touch()
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
	_call.text = "Call"  # _process adds the bonus while a gap runs.
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
		r.texture = SpriteBank.texture(String(Acts.kinds()[pair[0]]["sprite"]))
		r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		r.custom_minimum_size = Vector2(TdUiData.PREVIEW_ICON, TdUiData.PREVIEW_ICON)
		r.tooltip_text = String(Acts.kinds()[pair[0]]["name"])
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
	elif _call.text != "Call":
		_call.text = "Call"
	_step_banner(delta)
	_step_lives_shake(delta)


## Viewport px of the soul counter's centre (TdVfx soul wisps fly there).
func souls_screen_pos() -> Vector2:
	return _souls.get_global_rect().get_center()


## A life was lost: the lives counter flashes red and shakes (real time; no
## shake under Reduce motion).
func shake_lives() -> void:
	if _lives_shake <= 0.0:
		_lives_x = _lives.position.x
	_lives_shake = TdVfxData.LIVES_SHAKE_TIME


## Advances the lives counter's shake by `delta` real s.
func _step_lives_shake(delta: float) -> void:
	if _lives_shake <= 0.0:
		return
	_lives_shake = maxf(_lives_shake - delta, 0.0)
	var f := _lives_shake / TdVfxData.LIVES_SHAKE_TIME  # 1 -> 0.
	_lives.modulate = Color.WHITE.lerp(TdVfxData.LEAK_TINT, f)
	if TdVfx.motion():
		_lives.position.x = _lives_x + sin(f * 40.0) * TdVfxData.LIVES_SHAKE_PX * f
	if _lives_shake <= 0.0:
		_lives.position.x = _lives_x


## Queues banner line `text` (shown one after another) on an `accent` ribbon.
func _queue_banner(text: String, accent: String = "gold") -> void:
	_banner_queue.append([text, accent])
	while _banner_queue.size() > TdUiData.BANNER_QUEUE_MAX:
		_banner_queue.pop_front()  # Stale: a newer line replaces it.


## Wave `n` (1-based) started: announces the kinds new to this map and a boss.
func _announce(n: int) -> void:
	if n - 1 >= (game.map["waves"] as Array).size():
		return
	for g: Dictionary in game.map["waves"][n - 1]["groups"]:
		var kind := String(g["kind"])  # The group's kind.
		if _announced.has(kind) or not Acts.kinds().has(kind):
			continue
		_announced[kind] = true
		var row: Dictionary = Acts.kinds()[kind]
		if String(row["rank"]) == "boss":
			_queue_banner("%s arrives" % String(row["name"]), TdUiData.BANNER_BOSS)
		elif n > 1:
			_queue_banner("New foe: %s" % String(row["name"]), TdUiData.BANNER_NEW)


## Shows, holds and fades the banners on real time (UI motion, not gameplay).
func _step_banner(delta: float) -> void:
	if _banner_left <= 0.0:
		if _banner_queue.is_empty():
			_banner.visible = false
			return
		var next: Array = _banner_queue.pop_front()  # [text, accent].
		_banner_label.text = String(next[0])
		if String(next[1]) != _banner_accent:
			_banner_accent = String(next[1])
			_banner.add_theme_stylebox_override("panel", UiTheme.style("ribbon", _banner_accent))
			_banner_label.add_theme_color_override("font_color", UiTheme.HEADER_TEXT.get(_banner_accent, UiTheme.TEXT))
		_banner_left = TdUiData.BANNER_HOLD + TdUiData.BANNER_FADE
		_banner.visible = true
		_banner.reset_size()
	_banner_left -= delta
	_banner.modulate.a = clampf(_banner_left / TdUiData.BANNER_FADE, 0.0, 1.0)
	_banner.position = Vector2((root.size.x - _banner.size.x) * 0.5, TdUiData.TOP_BAR_H * _touch() * TdUiData.BANNER_BAR_FRAC - _banner.size.y * 0.5)


func open_pause() -> void:
	if game.over or root.has_node("PauseMenu"):
		return
	game.set_paused(true)
	game.selected = null  # The spot menu closes under the pause card.
	game.armed = -1
	menu.refresh()
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
	for i in _spells.size():
		if InputMap.has_action("spell_%d" % (i + 1)) and event.is_action_pressed("spell_%d" % (i + 1)):
			_arm(i)
	if event.is_action_pressed("ultimate"):
		game.caster.cast_ultimate()
	elif event.is_action_pressed("call_wave"):
		game.call_wave()
	elif event.is_action_pressed("speed"):
		game.cycle_speed()
	elif event.is_action_pressed("pause") and not game.paused:
		if game.selected != null or game.armed >= 0:
			game.selected = null  # Esc first closes the spot menu / disarms the spell.
			game.armed = -1
			game.changed.emit()
		else:
			open_pause()
