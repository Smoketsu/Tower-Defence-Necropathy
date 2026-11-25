## Sister of the Scourge (GDD §6.1 "Lash hits two blockers in a line"): each
## attack on the body holding her also strikes one more living blocker body
## within `reach` px of it (the next body of the same post first: spread the
## blockers to avoid it), for `second_mult` of her damage.
## Args: reach (px), second_mult (0..1).
extends EnemyTrait


func on_attack(e: TdEnemy, game: TdGame, body: BlockBody) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	var best: BlockBody = null  # The second body struck.
	for b: BlockBody in game.bodies_near(body.pos, float(a["reach"])):
		if b != body and (best == null or b.pos.distance_squared_to(body.pos) < best.pos.distance_squared_to(body.pos)):
			best = b
	if best != null:
		TdCombat.damage_body(game, best, float(e.row["damage"]) * float(a["second_mult"]) * e.damage_mult())
		EnemyTrait.note(game, "lash_second")
