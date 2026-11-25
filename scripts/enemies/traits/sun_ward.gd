## Sun Paladin (GDD §6.1 "20% ward aura on nearby enemies"): every other
## enemy within `radius` px takes `ward_mult` of each hit while it stays in
## range (TdCombat.ward_enemy, renewed every step; several paladins do not stack).
## Args: radius (px), ward_mult (0..1), refresh (s the ward lasts after leaving).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	CovenantField.of(game).add_zone(e.position, float(e.row["args"]["radius"]), INF, Color(1.0, 0.75, 0.3, 0.25), e)


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	for o: TdEnemy in game.enemies_near(e.position, float(a["radius"])):
		if o != e and not bool(o.row.get("structure", false)):
			TdCombat.ward_enemy(game, o, float(a["ward_mult"]), float(a["refresh"]))
