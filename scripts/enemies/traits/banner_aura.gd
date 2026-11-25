## Banner Bearer (GDD §6.1): nearby enemies move faster. Every step it gives
## each other enemy within `radius` px a short haste of `speed_mult`.
## Args: radius, speed_mult, refresh (s each aura haste lasts; renewed every step in range).
extends EnemyTrait


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # The kind's numbers.
	for o: TdEnemy in game.enemies_near(e.position, float(a["radius"])):
		if o != e:
			TdCombat.haste_enemy(game, o, float(a["speed_mult"]), float(a["refresh"]))
