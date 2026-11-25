## Trampler (act framework; GDD §7.3 Stampedes): an enemy that disables every
## tower it passes within `radius` px for `disable` s (TdCombat.disable_tower,
## cause "trampled"), once per tower per enemy. Meant for off-road movers (map
## road key "off_road"), reusable by any act. Args: radius (px), disable (s).
## vars: "trampled" (Array of spot ids already hit).
extends EnemyTrait


func on_spawn(e: TdEnemy, _game: TdGame) -> void:
	e.vars["trampled"] = []


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # The kind's numbers.
	var done: Array = e.vars["trampled"]  # Spots already trampled.
	for t: Tower in game.towers:
		if e.position.distance_to(t.position) <= float(a["radius"]) and not done.has(t.spot.spot_id()):
			done.append(t.spot.spot_id())
			TdCombat.disable_tower(game, t, float(a["disable"]), "trampled")
