## The Horncharger (Necropathy's HornchargerKit: "a telegraphed straight charge
## that stuns summons; a charge that runs into a rock leaves it stuck"): every
## `every` s (first after `first`) it lowers its horns for `windup` s (a line
## down the road), then CHARGES for `time` s at `speed_mult` x: no post holds
## it and every post it passes has its bodies gored for `gore` (Kit.charge_step);
## a charge that runs within `rock_r` px of a map rock (MAP "rocks") stops it,
## stunned `rock_stun` s. Not while frozen.
## Args: first, every, windup, time (s), speed_mult, gore, rock_r (px), rock_stun (s).
## vars: "next", "at" (game s the charge starts; 0 = none), "charge_until", "gored".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/primeval/kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["at"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]
	if Kit.charging(e, game):
		Kit.charge_step(e, game, float(a["gore"]), float(a["rock_r"]), float(a["rock_stun"]))
		return
	var at := float(e.vars["at"])
	if at > 0.0:
		if game.time >= at:
			e.vars["at"] = 0.0
			Kit.start_charge(e, game, float(a["speed_mult"]), float(a["time"]))
			EnemyTrait.note(game, "charges")
		return
	if game.time >= float(e.vars["next"]) and game.time >= e.freeze_until:
		e.vars["next"] = game.time + float(a["every"])
		e.vars["at"] = game.time + float(a["windup"])
		var rd := e.follower.road
		Kit.line(game, e.position, rd.point_at(minf(e.follower.dist + e.speed * float(a["speed_mult"]) * float(a["time"]), rd.length)), float(a["windup"]), false)
