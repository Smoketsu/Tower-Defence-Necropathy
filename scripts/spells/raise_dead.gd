## Raise Dead (GDD §5 "temporary blockers anywhere on the road"): `count` Risen
## climb out of the road at the point nearest the tap (within `max_snap` px),
## side by side (TempBlockers: `hp` each, hold `hold`, `damage` every `interval`
## s, for `duration` s; the Grave Herald's Restless lengthens it). Row:
## SpellData "raise_dead".
extends TdSpell

## Its Risen (made on the first cast).
var _risen: TempBlockers = null


func cast(pos: Vector2) -> bool:
	var road := game.nearest_road(pos, float(row["max_snap"]))  # Road under the tap, or null.
	if road == null:
		return false
	if _risen == null:
		_risen = TempBlockers.new(game)
	var d := road.project(pos)  # Distance along it (px).
	_risen.raise(road.id, d, roundi(float(row["count"])), float(row["hp"]), int(row["hold"]), float(row["damage"]),
			float(row["interval"]), float(row["duration"]), id)
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	if _risen != null:
		_risen.step()


func draw(ci: CanvasItem) -> void:
	if _risen != null:
		_risen.draw(ci)


func busy() -> bool:
	return _risen != null and _risen.busy()
