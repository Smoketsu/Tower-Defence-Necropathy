## Valkyrie (Act VI; Necropathy's NorseValkyrieKit, "a SPEAR DIVE at the ring"):
## a flyer (no post holds her). Every `every` s (first after `first`) she picks
## the nearest working tower within `range` px and dives: a telegraphed circle
## of `radius` px closes on it for `delay` s, then every tower inside is stunned
## `stun` s and every body inside takes `body_damage` (game.hostile.shell(), the
## one telegraphed-strike path). Args: first, every, range, radius, delay,
## stun, body_damage. vars: "next_dive" (game s).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_dive"] = game.time + float(e.row["args"]["first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if game.time < float(e.vars["next_dive"]) or game.time < e.freeze_until:
		return
	var best: Tower = null  # Nearest working tower in reach.
	for t: Tower in game.towers:
		if game.time >= t.disabled_until and t.position.distance_to(e.position) <= float(a["range"]) and (best == null or t.position.distance_squared_to(e.position) < best.position.distance_squared_to(e.position)):
			best = t
	if best == null:
		return
	e.vars["next_dive"] = game.time + float(a["every"])
	game.hostile.shell(best.position, float(a["radius"]), float(a["delay"]), float(a["stun"]), "stunned", float(a["body_damage"]))
	EnemyTrait.note(game, "valkyrie_dives")
	Sfx.play("valkyrie_dive")
	e.vis_strike_at = game.time  # Her dive lunge (drawn only).
	e.vis_strike_dir = (best.position - e.position).normalized()
