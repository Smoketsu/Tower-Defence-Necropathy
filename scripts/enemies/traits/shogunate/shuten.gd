## Shuten-doji, the Oni King (Province miniboss; Necropathy's ShutenDojiKit):
## an oni (the kanabō smash, oni.gd) who also lobs sake barrels: every
## `throw_every` s (first after `throw_first`) at the nearest working tower
## within `throw_range` px, `barrels` telegraphed strikes (game.hostile.shell):
## the first on that tower, the others `barrel_spread` px around it at fixed
## angles; each lands after `barrel_delay` s, disables the towers inside
## `barrel_radius` px for `barrel_disable` s and burns bodies there for
## `barrel_damage`. Args: oni.gd's plus those. vars: "next_throw".
extends "res://scripts/enemies/traits/shogunate/oni.gd"


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_throw"] = game.time + float(e.row["args"]["throw_first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if game.time < float(e.vars["next_throw"]) or game.time < e.freeze_until:
		return
	var best: Tower = null  # Nearest working tower in reach.
	for t: Tower in game.towers:
		var d := t.position.distance_to(e.position)  # Distance (px).
		if d <= float(a["throw_range"]) and game.time >= t.disabled_until and (best == null or d < best.position.distance_to(e.position)):
			best = t
	if best == null:
		return
	e.vars["next_throw"] = game.time + float(a["throw_every"])
	for i in int(a["barrels"]):
		var off := Vector2.ZERO if i == 0 else Vector2.RIGHT.rotated(TAU * float(i) / float(int(a["barrels"]))) * float(a["barrel_spread"])  # Fixed angles.
		game.hostile.shell(best.position + off, float(a["barrel_radius"]), float(a["barrel_delay"]), float(a["barrel_disable"]), "shelled", float(a["barrel_damage"]))
	EnemyTrait.note(game, "sake_barrels", float(int(a["barrels"])))
	Sfx.play("sake_burst")
	e.vis_strike_at = game.time  # The heave (drawn only).
	e.vis_strike_dir = (best.position - e.position).normalized()
