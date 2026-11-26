## The Clubtail's tail sweep (Necropathy's ClubtailKit: "a tail sweep that
## knocks summons back"), also Mother Clubtail's: every `every` s (first after
## `first`) it braces for `windup` s (a ring of the real reach), then the club
## sweeps round it: every body within `reach` px takes `body_damage` (x its
## weaken) and every tower within it is stunned `disable` s (0 = none). Not
## while frozen. Args: first, every, windup (s), reach (px), body_damage, disable (s).
## vars: "next", "at" (game s the sweep lands; 0 = none).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/primeval/kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["at"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]
	var at := float(e.vars["at"])
	if at > 0.0:
		if game.time >= at:
			e.vars["at"] = 0.0
			for b: BlockBody in game.bodies_near(e.position, float(a["reach"])):
				TdCombat.damage_body(game, b, float(a["body_damage"]) * e.damage_mult(), e)
			if float(a["disable"]) > 0.0:
				for t: Tower in CovenantField.of(game).towers_near(e.position, float(a["reach"])):
					TdCombat.disable_tower(game, t, float(a["disable"]), "stunned")
			Kit.ring(game, e.position, float(a["reach"]), 0.4, Kit.lk()["sweep_tint"], true)
			EnemyTrait.note(game, "tail_sweeps")
			Sfx.play("brute_slam")
		return
	if game.time >= float(e.vars["next"]) and game.time >= e.freeze_until:
		e.vars["next"] = game.time + float(a["every"])
		e.vars["at"] = game.time + float(a["windup"])
		Kit.ring(game, e.position, float(a["reach"]), float(a["windup"]), Color.WHITE, false)
