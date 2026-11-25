## High Confessor (GDD §6.1 "Heals and revives nearby enemies"): every
## `heal_interval` s it heals every hurt enemy within `heal_radius` px by
## `heal` HP (bosses by `heal` x `boss_heal_mult`); every `revive_interval` s
## it raises the most recent Covenant soldier (fodder or elite, not another
## Confessor) that fell within `revive_radius` px in the last `revive_age` s,
## at `revive_hp` of its HP, at most `revive_max` times. A silenced Confessor
## (TdEnemy.silenced_until: Banshee) does neither.
## Args: heal, heal_interval, heal_radius, boss_heal_mult, revive_first,
## revive_interval, revive_radius, revive_age, revive_hp (0..1), revive_max.
## vars: "next_heal", "next_revive" (game s), "revives" (int).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["next_heal"] = game.time + float(a["heal_interval"])
	e.vars["next_revive"] = game.time + float(a["revive_first"])
	e.vars["revives"] = 0
	CovenantField.of(game)  # Starts the death record its revivals read.


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if not EnemyTrait.can_heal(e, game):
		return
	var a: Dictionary = e.row["args"]  # Its numbers.
	if game.time >= float(e.vars["next_heal"]):
		e.vars["next_heal"] = game.time + float(a["heal_interval"])
		var healed := false  # Anyone hurt was healed.
		for o: TdEnemy in game.enemies_near(e.position, float(a["heal_radius"])):
			if o != e and o.hp < o.max_hp and not bool(o.row.get("structure", false)):
				var amt := float(a["heal"]) * (float(a["boss_heal_mult"]) if String(o.row["rank"]) == "boss" else 1.0)  # HP restored.
				TdCombat.heal_enemy(game, o, amt)
				EnemyTrait.note(game, "confessor_heal", amt)
				healed = true
		if healed:
			game.fx.spawn("level_up", e.position, 60.0, 0.5)
	if game.time >= float(e.vars["next_revive"]) and int(e.vars["revives"]) < int(a["revive_max"]):
		e.vars["next_revive"] = game.time + float(a["revive_interval"])
		var field := CovenantField.of(game)  # The death record.
		for i in range(field.deaths.size() - 1, -1, -1):
			var d: Array = field.deaths[i]  # [kind, road, dist, lane, time].
			var row: Dictionary = TdEnemyData.KINDS[d[0]]
			if game.time - float(d[4]) > float(a["revive_age"]) or d[0] == e.kind or not (String(row["rank"]) in ["fodder", "elite"]):
				continue
			var road: Road = game.roads[d[1]]
			if road.point_at(float(d[2])).distance_to(e.position) > float(a["revive_radius"]):
				continue
			field.deaths.remove_at(i)
			var r := game.waves.spawn_extra(String(d[0]), String(d[1]), float(d[2]), float(d[3]))  # The raised soldier.
			r.hp = r.max_hp * float(a["revive_hp"])
			e.vars["revives"] = int(e.vars["revives"]) + 1
			game.fx.spawn("holy_impact", r.position, 80.0, 0.6)
			EnemyTrait.note(game, "confessor_revives")
			break
