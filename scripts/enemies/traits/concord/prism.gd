## The Star-Seer's prism (Necropathy's PrismKit, the Luminous support: light
## bends through her): every `refresh` s each Concord foe within `radius` px of
## her (herself too) is warded: it takes `mult` of every hit (TdCombat.ward_enemy,
## the one ward path; the strongest ward wins). A priority target.
## Args: radius (px), mult (0..1), refresh (s). vars: "next" (game s).
extends EnemyTrait


func on_spawn(e: TdEnemy, _game: TdGame) -> void:
	e.vars["next"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < float(e.vars["next"]):
		return
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["next"] = game.time + float(a["refresh"])
	for o: TdEnemy in game.foes_near(e.position, float(a["radius"])):
		TdCombat.ward_enemy(game, o, float(a["mult"]), float(a["refresh"]) * 1.5)
