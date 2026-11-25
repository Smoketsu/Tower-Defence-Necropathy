## SpotCursor: the gamepad cursor of the in-map interface
## (GDD §9.2): a stick / D-pad flick moves it to the nearest spot in that
## direction, A opens that spot's menu with the focus on its first button
## (the stick then walks the buttons, A picks), and while a spell is armed
## the stick moves it freely and A casts at it. It only calls TdGame.tap();
## MapHints draws its ring. Purely input, never game state.
class_name SpotCursor
extends Node

## The run.
var game: TdGame = null
## The HUD (its spot menu).
var hud: TdHud = null
## Cursor position (map px).
var pos: Vector2 = Vector2.ZERO
## True once the cursor has been used (it is drawn from then on).
var active: bool = false


func _process(delta: float) -> void:
	if not active or game.over or game.paused or game.armed < 0 or InputHints.device() != InputHints.Device.PAD:
		return
	var v := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")  # Stick / D-pad.
	if v != Vector2.ZERO:
		pos = (pos + v * TdUiData.CURSOR_SPEED * delta).clamp(Vector2.ZERO, MapView.SIZE)


func _unhandled_input(event: InputEvent) -> void:
	if game.over or game.paused or event.is_echo() or not (event is InputEventJoypadButton or event is InputEventJoypadMotion):
		return  # Pad only: Enter / Space / arrows stay the keyboard's (Call, ultimate).
	var dirs := {"ui_left": Vector2.LEFT, "ui_right": Vector2.RIGHT, "ui_up": Vector2.UP, "ui_down": Vector2.DOWN}  # Flick -> direction.
	for a: String in dirs:
		if event.is_action_pressed(a):
			if not active:
				active = true
				pos = game.selected.position if game.selected != null else game.necromancer_pos()
				if game.armed < 0:
					_jump(Vector2.ZERO)
			elif game.armed < 0:
				_jump(dirs[a])
			get_viewport().set_input_as_handled()
			return
	if active and event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		var was_armed := game.armed >= 0  # A cast, not a spot pick.
		hud.menu.pad_focus = not was_armed
		game.tap(pos)
	elif active and event.is_action_pressed("ui_cancel") and game.selected != null:
		get_viewport().set_input_as_handled()
		game.selected = null
		game.changed.emit()


## Moves to the nearest spot within TdUiData.CURSOR_CONE of direction `dir`
## (Vector2.ZERO = simply the nearest spot); stays put when there is none.
func _jump(dir: Vector2) -> void:
	var best: Spot = null  # Chosen spot.
	var best_d := INF  # Its weighted distance.
	for s: Spot in game.spots:
		var d := s.position - pos  # To that spot.
		if d.length() < 1.0 and dir != Vector2.ZERO:
			continue
		if dir != Vector2.ZERO and rad_to_deg(absf(dir.angle_to(d))) > TdUiData.CURSOR_CONE:
			continue
		var w := d.length() * (1.0 + (absf(dir.angle_to(d)) if dir != Vector2.ZERO else 0.0))  # Prefer straight ahead.
		if w < best_d:
			best_d = w
			best = s
	if best != null:
		pos = best.position
