## The Dominion of the Spheres (Wheel of Thrones miniboss; Necropathy's
## SpheresDominionKit: "keeps halos returning across the whole zone"): every
## `tick` s every other angel within `radius` px of him is hasted
## (`speed_mult`, `refresh` s) and regains `regen` of its max HP per s
## (TdCombat.heal_enemy; not while he is silenced). His reach is drawn as a
## cerulean zone while he lives (CovenantField). Args: radius (px), speed_mult,
## regen (share of max HP per s), refresh (s), tick (s). vars: "next" (game s).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time
	CovenantField.of(game).add_zone(e.position, float(e.row["args"]["radius"]), INF, Color(0.45, 0.7, 1.0, 0.35), e)


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if game.time < float(e.vars["next"]):
		return
	e.vars["next"] = game.time + float(a["tick"])
	var heal := EnemyTrait.can_heal(e, game)  # Silenced: no regrowth.
	for o: TdEnemy in game.foes_near(e.position, float(a["radius"])):
		if o == e:
			continue
		TdCombat.haste_enemy(game, o, float(a["speed_mult"]), float(a["refresh"]))
		if heal and o.hp < o.max_hp:
			TdCombat.heal_enemy(game, o, o.max_hp * float(a["regen"]) * float(a["tick"]))
			EnemyTrait.note(game, "spheres_regrowth")
