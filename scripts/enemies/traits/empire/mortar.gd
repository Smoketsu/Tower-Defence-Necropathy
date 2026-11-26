## Mortar Walker (Act XII elite; Necropathy's MortarKit: "lobs shells over the
## army onto a telegraphed circle"): every `every` s (first after `first`),
## unless frozen or staggered, it lobs a shell at the nearest tower within
## `range` px: game.hostile.shell() telegraphs a closing circle of `radius` px
## for `delay` s, then every tower inside is disabled `disable` s and every
## blocker body inside takes `body_damage`. An arcing shell flies over the
## posts: the answer is to kill the walker. Args: first, every, range, radius,
## delay, disable, body_damage. vars: "next".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/empire/empire_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until or game.time < e.staggered_until:
		return
	var ts := Kit.towers_near(game, e.position, float(a["range"]))  # Towers in reach, nearest first.
	if ts.is_empty():
		return
	e.vars["next"] = game.time + float(a["every"])
	game.hostile.shell(ts[0].position, float(a["radius"]), float(a["delay"]), float(a["disable"]), "shelled", float(a["body_damage"]))
	e.vis_strike_at = game.time
	e.vis_strike_dir = (ts[0].position - e.position).normalized()
	EnemyTrait.note(game, "mortar_shells")
	Sfx.play("mortar_launch")
