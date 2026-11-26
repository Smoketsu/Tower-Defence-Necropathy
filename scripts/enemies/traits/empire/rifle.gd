## Marching fire (Act XII riflemen, drones and turrets; Necropathy's
## TrooperKit / DroneKit: "keeps marching and firing"): every `interval` s,
## unless frozen or staggered, it fires one straight Empire shot (EmpireKit:
## game.hostile.fire(), stopped by the first blocker / Bone Wall body on its
## path) at the NEAREST tower within `range` px, even one already disabled: the
## Empire keeps the front tower's head down rather than spreading its fire (the
## generic shooter picks a fresh tower each shot). Args: range (px), interval
## (s), plus the HostileFire.fire args (disable, damage, speed, cause, look).
## vars: "next_shot" (game s).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/empire/empire_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_shot"] = game.time + float(e.row["args"]["interval"]) * 0.5


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < float(e.vars["next_shot"]) or game.time < e.freeze_until or game.time < e.staggered_until:
		return
	var a: Dictionary = e.row["args"]  # Its numbers.
	var ts := Kit.towers_near(game, e.position, float(a["range"]), true)  # Towers in reach, nearest first.
	if ts.is_empty():
		return
	e.vars["next_shot"] = game.time + float(a["interval"])
	Kit.fire_at(game, e, ts[0], a)
