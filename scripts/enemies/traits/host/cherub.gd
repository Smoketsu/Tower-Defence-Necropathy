## The Cherub's flaming sword (Necropathy's CherubKit: "a flaming sword that
## SWEEPS ALL AROUND IT"): every `every` s (first `first` s after it arrives)
## it raises the sword for `windup` s (a telegraph ring of its real reach),
## then the sword turns a full circle: every living blocker body within
## `reach` px takes `body_damage` (x its weaken) and every tower whose spot lies
## within `reach` px is stunned `disable` s (TdCombat.disable_tower, cause
## "blinded": the white flame). Not while frozen. The Cherub of the Gate uses
## the same kit with a wider reach. Args: first, every, windup (s), reach (px),
## body_damage, disable (s). vars: "next", "at" (game s the sweep lands; 0 = none).
extends EnemyTrait

const Lunge := preload("res://scripts/enemies/traits/host/lunge.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["at"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var at := float(e.vars["at"])
	if at > 0.0:
		if game.time >= at:
			e.vars["at"] = 0.0
			sweep(e, game, float(a["reach"]), float(a["body_damage"]), float(a["disable"]))
		return
	if game.time >= float(e.vars["next"]) and game.time >= e.freeze_until:
		e.vars["next"] = game.time + float(a["every"])
		e.vars["at"] = game.time + float(a["windup"])
		Lunge.sweep_ring(game, e.position, float(a["reach"]), float(a["windup"]), false)


## One full turn of a flaming sword round `e`: bodies within `reach` px take
## `dmg` (x its weaken), towers within it are stunned `stun` s. Returns bodies hit.
static func sweep(e: TdEnemy, game: TdGame, reach: float, dmg: float, stun: float) -> int:
	var n := 0  # Bodies struck.
	for b: BlockBody in game.bodies_near(e.position, reach):
		TdCombat.damage_body(game, b, dmg * e.damage_mult(), e)
		n += 1
	for t: Tower in CovenantField.of(game).towers_near(e.position, reach):
		TdCombat.disable_tower(game, t, stun, "blinded")
	Lunge.sweep_ring(game, e.position, reach, 0.35, true)
	game.vfx.shake(1.5)
	EnemyTrait.note(game, "sword_sweeps")
	Sfx.play("power_lunge")
	return n
