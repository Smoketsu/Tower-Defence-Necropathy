## Radiant Inquisitor (GDD §6.1 "Holy zone suppresses towers in a small
## radius"): every `interval` s (first after `first`) it lays a holy zone of
## `radius` px where it stands; every tower inside is suppressed (damage x
## `suppress_mult`) for `duration` s (TdCombat.suppress_tower). The zone is
## drawn by the CovenantField. Kill it first, or build out of its reach.
## Args: first, interval, radius, duration (s / px), suppress_mult (0..1).
## vars: "next_zone" (game s).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_zone"] = game.time + float(e.row["args"]["first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < float(e.vars["next_zone"]) or game.time < e.freeze_until:
		return
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["next_zone"] = game.time + float(a["interval"])
	var field := CovenantField.of(game)  # Draws the zone.
	var towers := field.towers_near(e.position, float(a["radius"]))  # Towers it catches.
	if towers.is_empty():
		return  # Only casts on undead it can reach.
	field.add_zone(e.position, float(a["radius"]), game.time + float(a["duration"]), Color(1.0, 0.85, 0.4, 0.75))
	for t: Tower in towers:
		TdCombat.suppress_tower(game, t, float(a["suppress_mult"]), float(a["duration"]))
	EnemyTrait.note(game, "holy_zones")
