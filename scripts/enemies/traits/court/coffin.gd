## Sleeping coffin (Ravensmoor; Necropathy SleepingCoffinKit): a structure
## beside the road. When the Blood Moon rises it opens: a `kind` (a Vampire
## Noble) climbs out onto the road beside it and the coffin is gone (no souls).
## Broken before that by the towers, it pays like an elite and nothing comes
## out. Args: kind.
extends EnemyTrait

## Shared Court helpers.
const CourtKit := preload("res://scripts/enemies/traits/court/court_kit.gd")


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if not CourtKit.moon_up(game):
		return
	game.waves.spawn_extra(String(e.row["args"]["kind"]), e.follower.road.id, e.follower.dist, 0.0)
	game.fx.spawn("summon_rise", e.position, 90.0, 0.5, Color(1.0, 0.4, 0.4))
	game.fx.spawn("structure_break", e.position, 80.0, 0.5)
	EnemyTrait.note(game, "coffins_opened")
	game.remove_enemy(e, false)
