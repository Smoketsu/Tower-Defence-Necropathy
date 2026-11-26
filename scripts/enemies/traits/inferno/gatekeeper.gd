## The Gatekeeper (the Burning Gate's miniboss; Necropathy GatekeeperKit: "a
## chained giant that drags the damned in"): every `chain_every` s (first after
## `chain_first`) his chains fly at the `chain_towers` towers nearest him within
## `chain_range` px and bind them `chain_disable` s (TdCombat.disable_tower,
## cause "chained"); every `coffle_every` s he hauls in a coffle of
## `coffle_count` `coffle_kind` behind him on his road (`coffle_gap` px apart;
## the wave's HP ramp). Args as named. vars: "next_chain", "next_coffle".
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["next_chain"] = game.time + float(a["chain_first"])
	e.vars["next_coffle"] = game.time + float(a["coffle_every"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if game.time < e.freeze_until:
		return
	if game.time >= float(e.vars["next_chain"]):
		var ts := game.towers.filter(func(t: Tower) -> bool: return t.position.distance_to(e.position) <= float(a["chain_range"]))
		if not ts.is_empty():
			e.vars["next_chain"] = game.time + float(a["chain_every"])
			ts.sort_custom(func(x: Tower, y: Tower) -> bool: return x.position.distance_squared_to(e.position) < y.position.distance_squared_to(e.position))
			var lk: Dictionary = Acts.data("inferno")["LOOK"]
			for t: Tower in ts.slice(0, int(a["chain_towers"])):
				TdCombat.disable_tower(game, t, float(a["chain_disable"]), "chained")
				var f := game.vfx.add(TdVfx.Kind.THREAD, e.position + Vector2(0, -30), float(lk["chain_w"]), 0.5, lk["chain_tint"])
				if f != null:
					f.to = t.position + Vector2(0, -16)
			Sfx.play("chain_haul")
			EnemyTrait.note(game, "gatekeeper_chains")
	if game.time >= float(e.vars["next_coffle"]):
		e.vars["next_coffle"] = game.time + float(a["coffle_every"])
		game.extra_hp_mult = game.waves.hp_ramp(maxi(game.waves.current, 0))
		for k in int(a["coffle_count"]):
			var d := maxf(e.follower.dist - float(a["coffle_gap"]) * float(k + 1), 0.0)  # Behind him.
			game.waves.spawn_extra(String(a["coffle_kind"]), e.follower.road.id, d, e.follower.lane)
		game.extra_hp_mult = 1.0
		EnemyTrait.note(game, "gatekeeper_coffles")
