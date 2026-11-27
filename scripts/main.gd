## Main: the scene root of Necropathy: Gravewatch. Installs the copied UI
## motion hook and touch support, loads the progress file (Meta), then shows
## one screen or run at a time: title -> map select -> pre-map setup -> a
## map run (TdGame), and from the title the Codex, Ossuary, Settings and
## Credits. It records each finished run (Meta.record_run(), before the
## results card opens) and offers the next open map. Under --autotest it
## goes straight to a TdGame driven by TdAutotest (no save unless --meta-save).
extends Node

## The current screen or run (a CanvasLayer holding a screen, or a TdGame).
var _current: Node = null


func _ready() -> void:
	UiMotion.install()
	var touch := TouchSupport.install(self)  # Phones / tablets: UI scale, portrait overlay (null in the autotest).
	if touch != null:
		touch.portrait_changed.connect(_on_portrait_changed)
	if GameState.autotest:
		var bot := TdAutotest.new()  # The headless bot (it starts the run itself).
		add_child(bot)
		return
	Meta.load_save()
	_show_title()
	if GameState.menu_preview != "":
		_preview.call_deferred(GameState.menu_preview)


## Frees the current screen and shows `node`.
func _show(node: Node) -> void:
	if _current != null:
		_current.queue_free()
	_current = node
	add_child(node)


## Shows menu Control `c` on its own CanvasLayer.
func _show_screen(c: Control) -> void:
	var layer := CanvasLayer.new()  # Holds the screen.
	layer.add_child(c)
	_show(layer)


func _show_title() -> void:
	Sfx.play_music(Sfx.MUSIC_MENU)
	var t := TitleScreen.new()  # The title.
	t.chosen.connect(_on_title, CONNECT_DEFERRED)
	_show_screen(t)


## A title item was picked.
func _on_title(id: String) -> void:
	var s: MenuScreen = null  # The screen opened.
	match id:
		"play":
			_show_map_select()
			return
		"codex": s = CodexScreen.new()
		"ossuary": s = OssuaryScreen.new()
		"settings": s = SettingsScreen.new()
		"credits": s = CreditsScreen.new()
	if s != null:
		s.back.connect(_show_title, CONNECT_DEFERRED)
		_show_screen(s)


func _show_map_select() -> void:
	var m := MapSelect.new()  # Map pick with records.
	m.picked.connect(_show_setup, CONNECT_DEFERRED)
	m.back.connect(_show_title, CONNECT_DEFERRED)
	_show_screen(m)


func _show_setup(map_id: String) -> void:
	var p := PreRunSetup.new()  # Character, spells, ultimate, difficulty.
	p.map_id = map_id
	p.start.connect(_start_run, CONNECT_DEFERRED)
	p.back.connect(_show_map_select, CONNECT_DEFERRED)
	_show_screen(p)


## Starts map `map_id` on `difficulty` with `character` and spells `loadout`
## (a new seed each time from the run count; the autotest picks its own seeds).
func _start_run(map_id: String, difficulty: String, character: String, loadout: Array[String]) -> void:
	GameState.map_id = map_id
	GameState.difficulty = difficulty
	GameState.character = character
	GameState.loadout = loadout
	GameState.run_seed += 1
	CharacterModifiers.current = character
	var g := TdGame.new()  # The run.
	g.setup(map_id, difficulty, GameState.run_seed, CharacterModifiers.loadout(loadout))
	var watch := RunWatch.new()  # Codex and masteries.
	watch.game = g
	g.add_child(watch)
	g.ended.connect(_on_run_ended.bind(g))  # Before the HUD's: the results card reads the record.
	g.restart_requested.connect(func() -> void: _start_run(map_id, difficulty, character, loadout), CONNECT_DEFERRED)
	g.menu_requested.connect(_show_title, CONNECT_DEFERRED)
	Sfx.play_music(Sfx.run_mode_for(map_id))
	_show(g)


## Records the finished run (a Reckoning ending after a recorded clear adds
## only its own Ash and best wave) and offers the next open map.
func _on_run_ended(_won: bool, g: TdGame) -> void:
	if g.has_meta("recorded"):
		g.set_meta("ash_paid", Meta.record_reckoning(g))
		return
	g.set_meta("recorded", true)
	g.set_meta("ash_paid", Meta.record_run(g))
	var nxt := Acts.next_map(g.map_id)  # The next map in the campaign order ("" = none).
	if nxt != "" and Meta.map_open(nxt):
		g.set_meta("on_next", func() -> void: _start_run.call_deferred(nxt, g.difficulty, GameState.character, GameState.loadout))


## --menu=ID (Web look checks, GameState.menu_preview): opens that screen at once.
func _preview(id: String) -> void:
	var m := GameState.map_id if GameState.map_id != "" else MapRegistry.DEFAULT_ID  # Map of a previewed run.
	match id:
		"setup": _show_setup(m)
		"pause", "won", "lost":
			_start_run(m, DifficultyData.DEFAULT_ID, CharacterData.DEFAULT_ID, SpellData.DEFAULT_LOADOUT.duplicate())
			await get_tree().create_timer(0.5).timeout
			var g := _current as TdGame  # The run just started.
			if id == "pause":
				g.hud.open_pause()
			else:
				g.call("_end", id == "won")
		_: _on_title(id)


## Phones: turning to portrait pauses a run (the rotate overlay covers it).
func _on_portrait_changed(portrait: bool) -> void:
	var g := _current as TdGame  # The run, if one is shown.
	if portrait and g != null and not g.over and not g.paused:
		g.hud.open_pause()
