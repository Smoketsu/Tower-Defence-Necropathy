## Shooter (act framework; GDD §7.3 Line of Fire, Broadsides): a ranged enemy
## that shoots the necromancer's side through the one hostile-fire path
## (game.hostile.fire()): every `interval` s, unless frozen or staggered, it
## fires at the nearest tower (not already disabled) or blocker body within
## `range` px. A straight shot is stopped by the first blocker / Bone Wall body
## on its path; an arcing one flies over. Reusable by any act.
## Args: range (px), interval (s), target ("tower" | "body" | "any": a tower
## first, else a body), damage (to a body), disable (s, to a tower), cause
## (HostileData.CAUSE_TINT key, default "shot"), speed (px/s), arc (bool),
## look (HostileData.LOOKS key). vars: "next_shot" (game s).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_shot"] = game.time + float(e.row["args"]["interval"]) * 0.5


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < float(e.vars["next_shot"]) or game.time < e.freeze_until or game.time < e.staggered_until:
		return
	var a: Dictionary = e.row["args"]  # The kind's numbers.
	var r := float(a["range"])  # Reach (px).
	var mode := String(a.get("target", "tower"))  # What it shoots.
	var target: Object = null  # Chosen target.
	if mode != "body":
		var best := r  # Nearest distance so far.
		for t: Tower in game.towers:
			var d := e.position.distance_to(t.position)  # Distance (px).
			if d <= best and game.time >= t.disabled_until:
				best = d
				target = t
	if target == null and mode != "tower":
		var best := r  # Nearest distance so far.
		for b: BlockBody in game.bodies_near(e.position, r):
			var d := e.position.distance_to(b.pos)  # Distance (px).
			if d <= best:
				best = d
				target = b
	if target == null:
		return
	e.vars["next_shot"] = game.time + float(a["interval"])
	if game.hostile.fire(e.position + Vector2(0, -12), target, a):
		EnemyTrait.note(game, "hostile_shots")
		e.vis_strike_at = game.time  # Its firing lunge (drawn only).
		var aim := (target as Tower).position if target is Tower else (target as BlockBody).pos  # Where it shot.
		e.vis_strike_dir = (aim - e.position).normalized()
