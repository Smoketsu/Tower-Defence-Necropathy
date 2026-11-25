## The Kirin (Road to the Sun miniboss; Necropathy's KirinKit, "a holy beast of
## light"): every `every` s (first after `first`) its horn flashes: every tower
## within `radius` px is dazzled `blind` s (TdCombat.disable_tower, cause
## "blinded") and every other enemy within `ward_radius` px is warded (damage
## taken x `ward` for `ward_time` s, TdCombat.ward_enemy). Args: first, every,
## radius, blind, ward, ward_radius, ward_time. vars: "next".
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until:
		return
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["next"] = game.time + float(a["every"])
	for t: Tower in game.towers.duplicate():
		if t.position.distance_to(e.position) <= float(a["radius"]):
			TdCombat.disable_tower(game, t, float(a["blind"]), "blinded")
	for o: TdEnemy in game.foes_near(e.position, float(a["ward_radius"])):
		if o != e:
			TdCombat.ward_enemy(game, o, float(a["ward"]), float(a["ward_time"]))
	EnemyTrait.note(game, "kirin_flashes")
	game.fx.spawn("holy_impact", e.position, float(a["radius"]) * 2.0, 0.6)
