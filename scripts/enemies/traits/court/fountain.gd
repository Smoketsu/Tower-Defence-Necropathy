## Blood fountain (Castle Sanguis' Banquet): a structure that, every `interval` s,
## heals every Court foe within `radius` px by `heal` (a red pulse); the
## towers break it like any structure. Args: heal, interval, radius.
## vars: "next_heal" (game s).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_heal"] = game.time + float(e.row["args"]["interval"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < float(e.vars["next_heal"]):
		return
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["next_heal"] = game.time + float(a["interval"])
	var healed := false  # Anyone hurt was healed.
	for o: TdEnemy in game.foes_near(e.position, float(a["radius"])):
		if o.hp < o.max_hp:
			TdCombat.heal_enemy(game, o, float(a["heal"]))
			healed = true
	if healed:
		game.fx.spawn("level_up", e.position, float(a["radius"]), 0.5, Color(1.0, 0.3, 0.35))
		EnemyTrait.note(game, "fountain_heals")
