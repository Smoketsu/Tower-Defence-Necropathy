## The Warbeast's charge (Necropathy's WarbeastKit, the Vrask war-hound): every
## `every` s (first `first` s after it arrives), unless frozen or staggered, it
## lowers its head for `windup` s (a telegraph ring), then CHARGES for
## `charge_time` s: `speed_mult` x faster, held by no post (a post holding it
## lets go), and every post it passes has its living bodies struck for
## `roll_damage` once (the Ophan's roll_over(), the act framework's one
## pass-through blow). Between charges posts hold it.
## Args: first, every, windup, charge_time (s), speed_mult, roll_damage.
## vars: "next", "charge_at", "charge_until" (game s), "rolled" (posts struck).
extends EnemyTrait

const Ophan := preload("res://scripts/enemies/traits/host/ophan.gd")
const Kit := preload("res://scripts/enemies/traits/concord/concord_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["charge_at"] = 0.0
	e.vars["charge_until"] = 0.0
	e.vars["rolled"] = []


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if game.time < float(e.vars["charge_until"]):
		e.unholdable_until = game.time + 0.2
		if e.holder != null:
			e.holder.held.erase(e)
			e.holder = null
		Ophan.roll_over(e, game, float(a["roll_damage"]))
		return
	var at := float(e.vars["charge_at"])  # When the charge starts (0 = none coming).
	if at > 0.0 and game.time >= at:
		e.vars["charge_at"] = 0.0
		e.vars["charge_until"] = game.time + float(a["charge_time"])
		e.vars["rolled"] = []
		TdCombat.haste_enemy(game, e, float(a["speed_mult"]), float(a["charge_time"]))
		EnemyTrait.note(game, "warbeast_charges")
		Sfx.play("burrow_rumble")
		return
	if at <= 0.0 and game.time >= float(e.vars["next"]) and game.time >= e.freeze_until and game.time >= e.staggered_until:
		e.vars["next"] = game.time + float(a["every"])
		e.vars["charge_at"] = game.time + float(a["windup"])
		Kit.warn(game, e.position, e.radius * 2.4, float(a["windup"]))
