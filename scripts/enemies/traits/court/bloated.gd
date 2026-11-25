## Bloated Thrall (the Witchwood; Necropathy BloatedThrallKit): when it dies it
## bursts into a blood pool of `pool_radius` px for `pool_life` s that heals the
## Court inside `pool_heal` HP per s (the act rule's one pool path, CourtKit.pool).
## Args: pool_radius, pool_life, pool_heal.
extends EnemyTrait

## Shared Court helpers.
const CourtKit := preload("res://scripts/enemies/traits/court/court_kit.gd")


func on_death(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	CourtKit.pool(game, e.position, float(a["pool_radius"]), float(a["pool_life"]), float(a["pool_heal"]))
	game.fx.spawn("corpse_explosion", e.position, float(a["pool_radius"]) * 2.0, 0.5, Color(1.0, 0.4, 0.4))
	EnemyTrait.note(game, "bloated_bursts")
