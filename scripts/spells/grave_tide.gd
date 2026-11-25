## Grave Tide, a later ultimate (GDD §5; Necropathy's "for 10 s every foe that
## dies rises as a Risen fighting for you"): on the Dread Rally meter. For
## `duration` s every enemy that dies (not a boss or structure) rises where it
## fell as a temporary Risen blocker (TempBlockers: `risen_hp`, holds 1,
## `risen_damage` every `risen_interval` s, `risen_time` s; at most `risen_max`
## standing). Row: SpellData.ULTIMATES "grave_tide". Cast anywhere.
extends TdSpell

## Game s the tide ends (0 = not active).
var _until: float = 0.0
## Its Risen.
var _risen: TempBlockers = null


func cast(_pos: Vector2) -> bool:
	if _risen == null:
		_risen = TempBlockers.new(game)
		game.enemy_killed.connect(_on_kill)
	_until = game.time + float(row["duration"])
	Sfx.play(String(row["sound"]))
	game.banner(String(row["name"]) + "!")
	return true


## TdGame.enemy_killed: during the tide the dead rise.
func _on_kill(e: TdEnemy, _tower: Tower) -> void:
	if game.time >= _until or String(e.row["rank"]) == "boss" or bool(e.row.get("structure", false)):
		return
	if _risen.standing() >= int(row["risen_max"]):
		return
	_risen.raise(e.follower.road.id, e.follower.dist, 1, float(row["risen_hp"]), 1, float(row["risen_damage"]),
			float(row["risen_interval"]), float(row["risen_time"]), id)
	if game.vfx.on:
		game.vfx.add(TdVfx.Kind.ANIM, e.position, 90.0, 0.5, Color.WHITE, "raise_dead")


func step(_dt: float) -> void:
	if _risen != null:
		_risen.step()


func draw(ci: CanvasItem) -> void:
	if _risen != null:
		_risen.draw(ci)


func busy() -> bool:
	return game.time < _until or (_risen != null and _risen.busy())
