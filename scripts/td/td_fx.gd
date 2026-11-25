## TdFx: one-shot effect strips (Necropathy's effects/<id>.png animations:
## deaths, impacts, auras, the Rally) played on the game clock and drawn by
## this one node with SpriteBank.draw_anim (textures, no polygons). Purely
## visual; nothing reads it back. Capped so a big wave cannot flood it.
class_name TdFx
extends Node2D

## Most effects alive at once; the oldest is dropped beyond it.
const CAP: int = 96  # TUNING (not in GDD) visual budget, Necropathy's FX_CAP

## The run (for its clock).
var game: TdGame = null
## Live effects: [id, map px, diameter px, start game s, duration s, tint].
var _live: Array = []


func _ready() -> void:
	z_index = 6


## Plays effect strip `id` at `pos`, `diameter` px across, over `duration` s.
func spawn(id: String, pos: Vector2, diameter: float, duration: float, tint: Color = Color.WHITE) -> void:
	if DisplayServer.get_name() == "headless":
		return  # Nothing is seen headless; keeps the autotest lean.
	if _live.size() >= CAP:
		_live.pop_front()
	_live.append([id, pos, diameter, game.time, duration, tint])


func _process(_delta: float) -> void:
	for i in range(_live.size() - 1, -1, -1):
		var f: Array = _live[i]
		if game.time - float(f[3]) >= float(f[4]):
			_live.remove_at(i)
	queue_redraw()


func _draw() -> void:
	for f: Array in _live:
		var p := (game.time - float(f[3])) / float(f[4])  # 0..1 through the strip.
		SpriteBank.draw_anim(self, String(f[0]), f[1], float(f[2]), p, 1.0, f[5])
