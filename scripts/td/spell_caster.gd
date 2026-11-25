## SpellCaster: the necromancer's spell slots and the ultimate meter (GDD §5).
## Owns each slot's spell script instance (scripts/spells/<id>.gd, loaded by
## name), the cooldowns (x MetaModifiers.spell_cooldown_mult()), the target
## snapping by the row's "target" kind, and the kill-charged meter of the
## ultimate. Casting never costs souls.
class_name SpellCaster
extends RefCounted

## Emitted after a cast or a meter change (HUD refresh).
signal changed

## Ultimate the next run brings (SpellData.ULTIMATE id or a SpellData.ULTIMATES
## key; set by the pre-map pick / the autotest's --ultimate; gw2-kit).
static var ultimate_id: String = "dread_rally"

## The run.
var game: TdGame = null
## Spell ids in slot order.
var loadout: Array[String] = []
## Slot -> its spell instance, or null when its script is not built yet (row "ready": false).
var spells: Array = []
## Slot -> game time (s) it is ready again.
var ready_at: Array[float] = []
## The ultimate's instance.
var ultimate: TdSpell = null
## Ultimate meter (0 .. SpellData.ULTIMATE.meter_max).
var meter: float = 0.0
## Casts per spell id (summary).
var casts: Dictionary = {}


func _init(p_game: TdGame, p_loadout: Array[String]) -> void:
	game = p_game
	loadout = p_loadout
	for id: String in loadout:
		spells.append(_make(id, SpellData.SPELLS[id]))
		ready_at.append(0.0)
	var uid := ultimate_id if SpellData.ULTIMATES.has(ultimate_id) else String(SpellData.ULTIMATE["id"])  # The run's ultimate.
	ultimate = _make(uid, ult_row(uid))


## The row of ultimate `id`: Dread Rally's SpellData.ULTIMATE, else its
## SpellData.ULTIMATES row (every ultimate shares ULTIMATE's meter).
static func ult_row(id: String) -> Dictionary:
	return SpellData.ULTIMATES.get(id, SpellData.ULTIMATE)


## The spell script instance for `id` with row `row`, or null when not built.
func _make(id: String, row: Dictionary) -> TdSpell:
	var path := "res://scripts/spells/%s.gd" % id  # Its script.
	if not bool(row.get("ready", true)) or not ResourceLoader.exists(path):
		return null
	var s := (load(path) as GDScript).new() as TdSpell  # The instance.
	s.game = game
	s.id = id
	s.row = CharacterModifiers.spell_row(id, row)  # The character's own spell is boosted.
	return s


## True when slot `i` holds a built spell off cooldown.
func is_ready(i: int) -> bool:
	return i < spells.size() and spells[i] != null and game.time >= ready_at[i]


## Cooldown progress of slot `i`, 0 (just cast) .. 1 (ready).
func cooldown_frac(i: int) -> float:
	var cd := _cooldown(i)  # Full cooldown (s).
	return 1.0 if cd <= 0.0 else clampf(1.0 - (ready_at[i] - game.time) / cd, 0.0, 1.0)


## Full cooldown (s) of slot `i`.
func _cooldown(i: int) -> float:
	return float(SpellData.SPELLS[loadout[i]]["cooldown"]) * MetaModifiers.spell_cooldown_mult() * CharacterModifiers.cooldown_mult(loadout[i])


## Casts slot `i` at map px `pos`; returns true when it was cast.
func cast(i: int, pos: Vector2) -> bool:
	if not is_ready(i):
		return false
	var s: TdSpell = spells[i]
	if not s.cast(pos):
		return false
	ready_at[i] = game.time + _cooldown(i)
	game.vfx.cast(s.id, pos)
	casts[s.id] = int(casts.get(s.id, 0)) + 1
	changed.emit()
	return true


## True when the ultimate meter is full.
func ultimate_ready() -> bool:
	return ultimate != null and meter >= float(SpellData.ULTIMATE["meter_max"])


## Casts the ultimate (empties the meter); returns true when cast.
func cast_ultimate() -> bool:
	if not ultimate_ready() or not ultimate.cast(game.necromancer_pos()):
		return false
	meter = 0.0
	game.vfx.cast(ultimate.id, game.necromancer_pos())
	casts[ultimate.id] = int(casts.get(ultimate.id, 0)) + 1
	changed.emit()
	return true


## Adds the meter charge of a kill of rank `rank`.
func charge(rank: String) -> void:
	meter = minf(meter + float(SpellData.ULTIMATE["charge"][rank]) * MetaModifiers.ultimate_charge_mult(), float(SpellData.ULTIMATE["meter_max"]))
	changed.emit()


## One fixed step of every live spell.
func step(dt: float) -> void:
	for s: TdSpell in spells:
		if s != null:
			s.step(dt)
	if ultimate != null:
		ultimate.step(dt)


## Draws every spell's lingering visuals on `ci` (map coords).
func draw(ci: CanvasItem) -> void:
	for s: TdSpell in spells:
		if s != null:
			s.draw(ci)
	if ultimate != null:
		ultimate.draw(ci)
