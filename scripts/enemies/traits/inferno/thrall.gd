## Burning Thrall (Moloch's swallow): a blocker body he swallowed walks back
## out burning, as his, and crumbles to ash `life` s later (no kill, no souls).
## Args: life (s). vars: "until" (game s it crumbles).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["until"] = game.time + float(e.row["args"]["life"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time >= float(e.vars["until"]):
		EnemyTrait.note(game, "thralls_crumbled")
		game.fx.spawn("undead_death", e.position, 60.0, 0.45, Acts.data("inferno")["LOOK"]["fire_tint"])
		game.remove_enemy(e, false)
