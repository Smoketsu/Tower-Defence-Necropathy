## Fox-fire illusion (the Kitsune's decoy): it walks and soaks the towers'
## shots like a real kitsune, and fades after `life` s (no kill, no souls).
## Args: life (s). vars: "until" (game s it fades).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["until"] = game.time + float(e.row["args"]["life"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time >= float(e.vars["until"]):
		EnemyTrait.note(game, "fox_fire_faded")
		game.fx.spawn("level_up", e.position, 50.0, 0.5, Acts.data("shogunate")["LOOK"]["fox_tint"])
		game.remove_enemy(e, false)
