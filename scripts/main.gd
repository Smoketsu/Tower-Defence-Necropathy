## Main: the scene root of Necropathy: Gravewatch. Installs the copied UI
## motion hook and touch support, then shows the title screen, the map select
## and a map run (TdGame) one at a time. Under --autotest it goes straight to
## a TdGame driven by TdAutotest (never touching user:// for saves).
extends Node

## The current screen or run (title, map select or TdGame).
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
	_show_title()


## Frees the current screen and shows `node`.
func _show(node: Node) -> void:
	if _current != null:
		_current.queue_free()
	_current = node
	add_child(node)


func _show_title() -> void:
	Sfx.play_music(Sfx.MUSIC_MENU)
	var t := TitleScreen.new()  # The title.
	t.play_pressed.connect(_show_map_select, CONNECT_DEFERRED)
	_show(t)


func _show_map_select() -> void:
	var m := MapSelect.new()  # Map and difficulty pick.
	m.start.connect(_start_run, CONNECT_DEFERRED)
	m.back.connect(_show_title, CONNECT_DEFERRED)
	_show(m)


## Starts map `map_id` on `difficulty` (a new seed each time from the run count; the
## autotest picks its own seeds).
func _start_run(map_id: String, difficulty: String) -> void:
	GameState.map_id = map_id
	GameState.difficulty = difficulty
	GameState.run_seed += 1
	var g := TdGame.new()  # The run.
	g.setup(map_id, difficulty, GameState.run_seed)
	g.restart_requested.connect(func() -> void: _start_run(map_id, difficulty), CONNECT_DEFERRED)
	g.menu_requested.connect(_show_title, CONNECT_DEFERRED)
	Sfx.play_music(Sfx.run_mode_for(map_id))
	_show(g)


## Phones: turning to portrait pauses a run (the rotate overlay covers it).
func _on_portrait_changed(portrait: bool) -> void:
	var g := _current as TdGame  # The run, if one is shown.
	if portrait and g != null and not g.over and not g.paused:
		g.hud.open_pause()
