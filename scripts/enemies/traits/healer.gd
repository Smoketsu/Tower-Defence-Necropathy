## Healer (Covenant Chaplain; GDD §6.1 High Confessor pattern): every
## `interval` s it heals every other living enemy within `radius` px by
## `heal` HP; not while silenced (TdEnemy.silenced_until). Args: heal, interval, radius. vars: "next_heal" (game s).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_heal"] = game.time + float(e.row["args"]["interval"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < float(e.vars["next_heal"]) or not EnemyTrait.can_heal(e, game):
		return
	var a: Dictionary = e.row["args"]  # The kind's numbers.
	e.vars["next_heal"] = game.time + float(a["interval"])
	var healed := false  # True when anyone was hurt and got healed.
	for o: TdEnemy in game.enemies_near(e.position, float(a["radius"])):
		if o != e and o.hp < o.max_hp:
			TdCombat.heal_enemy(game, o, float(a["heal"]))
			healed = true
	if healed:
		game.fx.spawn("level_up", e.position, 60.0, 0.5)
