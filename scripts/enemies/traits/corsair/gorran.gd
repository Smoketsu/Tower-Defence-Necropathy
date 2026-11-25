## Bosun Gorran (the Smuggler's Cutter's miniboss; Necropathy BosunGorranKit):
## THE CHAIN SWEEP: every `sweep_every` s, when a blocker body stands within
## `sweep_radius` px of him, he whirls his chain-hook: a telegraphed strike on
## his own spot (game.hostile.shell(), the one telegraph path) lands
## `sweep_windup` s later and every body in it takes `sweep_damage`.
## THE BELLOW: every `bellow_every` s his crew within `bellow_radius` px runs at
## `bellow_speed` for `bellow_time` s (Bellow.bellow_at(), the one bellow).
## Args in his row. vars: "next_sweep", "next_bellow" (game s).
extends EnemyTrait

## The shared bellow.
const Bellow = preload("res://scripts/enemies/traits/corsair/bellow.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["next_sweep"] = game.time + float(a["sweep_every"]) * 0.5
	e.vars["next_bellow"] = game.time + float(a["bellow_every"]) * 0.3


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if game.time >= float(e.vars["next_bellow"]):
		e.vars["next_bellow"] = game.time + float(a["bellow_every"])
		Bellow.bellow_at(e, game, float(a["bellow_radius"]), float(a["bellow_speed"]), float(a["bellow_ward"]), float(a["bellow_time"]))
	if game.time < float(e.vars["next_sweep"]) or game.bodies_near(e.position, float(a["sweep_radius"])).is_empty():
		return
	e.vars["next_sweep"] = game.time + float(a["sweep_every"])
	game.hostile.shell(e.position, float(a["sweep_radius"]), float(a["sweep_windup"]), 0.0, "stunned", float(a["sweep_damage"]))
	EnemyTrait.note(game, "gorran_sweeps")
	e.vis_strike_at = game.time
	e.vis_strike_dir = e.follower.direction()
