## TdSpell: the base of every spell and ultimate script (GDD §5). One
## instance per spell per run, made by SpellCaster from
## scripts/spells/<id>.gd; its numbers are its SpellData row (`row`).
##
## Hooks:
##   cast(pos) -> bool  — cast at map px `pos` (already snapped by the target
##                        kind); return false when nothing could be targeted
##                        (no cooldown is spent then).
##   step(dt)           — every fixed step (lingering effects, walls).
##   draw(ci)           — draw lingering visuals on the spell layer, map coords.
##   busy() -> bool     — true while it has something to draw (layer redraws).
class_name TdSpell
extends RefCounted

## The run.
var game: TdGame = null
## Spell id (SpellData key, or the ultimate's id).
var id: String = ""
## Its SpellData row (shared, read only).
var row: Dictionary = {}


## See the header.
func cast(_pos: Vector2) -> bool:
	return false


## See the header.
func step(_dt: float) -> void:
	pass


## See the header.
func draw(_ci: CanvasItem) -> void:
	pass


## See the header.
func busy() -> bool:
	return false
