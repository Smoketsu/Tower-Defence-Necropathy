## MapSelect: picks the map (MapRegistry order) and the difficulty
## (DifficultyData), then Start. Minimal: a later agent replaces it with the
## full map select (Part and act tabs, skull records, pre-map setup).
class_name MapSelect
extends CanvasLayer

## Emitted with the chosen map id and difficulty id.
signal start(map_id: String, difficulty: String)
## Emitted on Back.
signal back

## Chosen map id.
var _map: String = MapRegistry.DEFAULT_ID
## Chosen difficulty id.
var _difficulty: String = DifficultyData.DEFAULT_ID
## Map id -> its button; difficulty id -> its button (selection look).
var _buttons: Dictionary = {}


func _ready() -> void:
	_map = GameState.map_id if MapRegistry.MAPS.has(GameState.map_id) else MapRegistry.DEFAULT_ID
	_difficulty = GameState.difficulty
	var root := Control.new()  # Full-screen holder with the UI theme.
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.theme = UiTheme.get_theme()
	add_child(root)
	root.add_child(TitleBackdrop.new())
	var center := CenterContainer.new()  # Centres the card.
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(center)
	var panel := UiTheme.ornate_panel("violet")  # The card.
	center.add_child(panel)
	var box := VBoxContainer.new()  # Rows.
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)
	box.add_child(UiTheme.title("Act I: the Covenant"))
	for id: String in MapRegistry.MAPS:
		var b := Button.new()  # One map.
		b.text = String(MapRegistry.get_map(id)["name"])
		b.pressed.connect(_pick_map.bind(id))
		box.add_child(b)
		_buttons[id] = b
	box.add_child(UiTheme.divider())
	var row := HBoxContainer.new()  # Difficulty buttons.
	row.add_theme_constant_override("separation", 6)
	box.add_child(row)
	for id: String in DifficultyData.ORDER:
		var b := Button.new()  # One difficulty.
		b.text = String(DifficultyData.LEVELS[id]["name"])
		b.pressed.connect(_pick_difficulty.bind(id))
		row.add_child(b)
		_buttons["d:" + id] = b
	var go := HBoxContainer.new()  # Back / Start.
	go.alignment = BoxContainer.ALIGNMENT_CENTER
	go.add_theme_constant_override("separation", 12)
	box.add_child(go)
	var bk := Button.new()  # Back.
	bk.text = "Back"
	bk.pressed.connect(func() -> void: back.emit())
	go.add_child(bk)
	var st := Button.new()  # Start.
	st.text = "Start"
	st.pressed.connect(func() -> void: start.emit(_map, _difficulty))
	UiTheme.style_button(st, "button", "gold")
	go.add_child(st)
	_mark()
	UiTheme.focus_deferred(st)
	TouchSupport.fit_to_screen(center)


func _pick_map(id: String) -> void:
	_map = id
	_mark()


func _pick_difficulty(id: String) -> void:
	_difficulty = id
	_mark()


## Gold frame on the chosen map and difficulty (gold = selection, GDD §9).
func _mark() -> void:
	for k: String in _buttons:
		var on := k == _map or k == "d:" + _difficulty  # This button is chosen.
		UiTheme.style_button(_buttons[k], "button", "gold" if on else "")
