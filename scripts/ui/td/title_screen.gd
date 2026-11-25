## TitleScreen: the minimal title (GDD §9.3): the Gravewatch logo over the
## night graveyard and Play (and Quit off the Web). A later agent replaces
## this with the full menu set (Codex, Ossuary, Settings, Credits).
class_name TitleScreen
extends CanvasLayer

## Emitted when Play is pressed.
signal play_pressed


func _ready() -> void:
	var root := Control.new()  # Full-screen holder with the UI theme.
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.theme = UiTheme.get_theme()
	add_child(root)
	root.add_child(TitleBackdrop.new())
	var center := CenterContainer.new()  # Centres the column.
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(center)
	var box := VBoxContainer.new()  # Logo and buttons.
	box.add_theme_constant_override("separation", 14)
	center.add_child(box)
	var logo := TextureRect.new()  # NECROPATHY + Gravewatch, at 2x.
	logo.texture = TdArt.texture("logo")
	logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	logo.custom_minimum_size = Vector2(500, 248)
	box.add_child(logo)
	var play := Button.new()  # Play.
	play.text = "Play"
	play.pressed.connect(func() -> void: play_pressed.emit())
	box.add_child(play)
	if not OS.has_feature("web"):
		var quit := Button.new()  # Quit (asks first).
		quit.text = "Quit"
		quit.pressed.connect(func() -> void: ConfirmDialog.ask(root, "Quit?", "Leave the crypt for now.", "Quit", get_tree().quit))
		box.add_child(quit)
	UiTheme.focus_deferred(play)
	TouchSupport.fit_to_screen(center)
