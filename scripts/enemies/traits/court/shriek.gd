## Chiropteran sonic shriek (Castle Sanguis; Necropathy ChiropteranKit): first
## after `first` s, then every `every` s, when a tower stands within `range` px,
## a telegraphed circle of `radius` px closes on it for `delay` s and every
## tower inside is stunned for `stun` s (game.hostile.shell -> the one tower
## disable path, cause "stunned"). It flies (row "flying"): no blocker holds it.
## Args: range, first, every, radius, delay, stun. vars: "next_shriek" (game s).
extends EnemyTrait

## Shared Court helpers.
const CourtKit := preload("res://scripts/enemies/traits/court/court_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_shriek"] = game.time + float(e.row["args"]["first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < float(e.vars["next_shriek"]) or game.time < e.freeze_until:
		return
	var a: Dictionary = e.row["args"]  # Its numbers.
	var t := CourtKit.nearest_tower(game, e.position, float(a["range"]))  # Its mark.
	if t == null:
		return
	e.vars["next_shriek"] = game.time + float(a["every"])
	game.hostile.shell(t.position, float(a["radius"]), float(a["delay"]), float(a["stun"]), "stunned")
	e.vis_strike_at = game.time
	e.vis_strike_dir = (t.position - e.position).normalized()
	EnemyTrait.note(game, "shrieks")
