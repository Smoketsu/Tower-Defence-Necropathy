## Charge (the Great Stag; Necropathy's GreatStagKit / WildChargeKit, "a
## telegraphed antler charge that scatters the ring"): every `every` s (first
## `first` s after it arrives) it lowers its antlers for `windup` s (a line
## along its road), then charges: `speed_mult` x its speed for `time` s, held by
## no post, striking the living bodies of each post it passes for
## `body_damage` (WildKit.start_charge / charge_step). Not while frozen or
## staggered: a freeze or a stun answers it.
## Args: first, every, windup, time (s), speed_mult, body_damage.
## vars: "next", "at" (game s the charge starts; 0 = none), WildKit's.
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/wild/wild_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["at"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	Kit.charge_step(e, game, float(a["body_damage"]))
	var at := float(e.vars["at"])
	if at > 0.0:
		if game.time >= at:
			e.vars["at"] = 0.0
			Kit.start_charge(e, game, float(a["speed_mult"]), float(a["time"]))
			EnemyTrait.note(game, "stag_charges")
			Sfx.play("roots_grab", e.position, 0.7)
		return
	if game.time >= float(e.vars["next"]) and game.time >= e.freeze_until and game.time >= e.staggered_until:
		e.vars["next"] = game.time + float(a["every"])
		e.vars["at"] = game.time + float(a["windup"])
		Kit.charge_line(e, game, float(a["windup"]))
