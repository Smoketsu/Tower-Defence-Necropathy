## Holy Ward Generator (GDD §7.2, the Crimson March's rule): a structure
## standing beside the road (speed 0, row key "structure") that shields
## every enemy within `radius` px: they take `ward_mult` of each hit
## (TdCombat.ward_enemy, renewed every step) until it is destroyed. Towers
## shoot it when nothing else is in range (Tower.pick_target) or on Strongest.
## Args: radius (px), ward_mult (0..1), refresh (s the ward lasts after leaving).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	if float(e.row["args"]["radius"]) <= 0.0:
		return  # A ward crystal: no shield of its own.
	CovenantField.of(game).add_zone(e.position, float(e.row["args"]["radius"]), INF, Color(0.55, 0.85, 1.0, 0.35), e)


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if float(a["radius"]) <= 0.0:
		return
	for o: TdEnemy in game.enemies_near(e.position, float(a["radius"])):
		if o != e and not bool(o.row.get("structure", false)):
			TdCombat.ward_enemy(game, o, float(a["ward_mult"]), float(a["refresh"]))


func on_death(_e: TdEnemy, game: TdGame) -> void:
	EnemyTrait.note(game, "structures_destroyed")
