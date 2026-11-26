## EmpireKit: the Electronic Empire's shared helpers (Act XII; Necropathy's
## EmpireKit / EmpireShots / LockOn, docs/act3/). Static only: every Empire
## trait and boss fires through these, so the Line of Fire has one path:
##   towers_near()  — the towers in reach, nearest first (not already disabled).
##   fire_at()      — one straight Empire shot at a tower through
##                    game.hostile.fire() (stopped by the first blocker / Bone
##                    Wall body on its path: the Line of Fire).
##   lock()         — a Lock-On: a painted line for the act rule's `lock_time`
##                    s, then a heavy shot down it (the act rule's paint(); off
##                    the act, the shot flies at once).
## Not a trait of its own (no kind names it).
extends EnemyTrait


## Towers within `r` px of `pos`, nearest first; disabled ones skipped unless `any`.
static func towers_near(game: TdGame, pos: Vector2, r: float, any: bool = false) -> Array[Tower]:
	var out: Array[Tower] = []  # In reach.
	for t: Tower in game.towers:
		if t.position.distance_to(pos) <= r and (any or game.time >= t.disabled_until):
			out.append(t)
	out.sort_custom(func(a: Tower, b: Tower) -> bool: return a.position.distance_squared_to(pos) < b.position.distance_squared_to(pos))
	return out


## One Empire shot from enemy `e` at tower `t` (args as HostileFire.fire()).
## Returns true when it flew.
static func fire_at(game: TdGame, e: TdEnemy, t: Tower, args: Dictionary) -> bool:
	if not game.hostile.fire(e.position + Vector2(0, -14), t, args):
		return false
	EnemyTrait.note(game, "empire_shots")
	e.vis_strike_at = game.time
	e.vis_strike_dir = (t.position - e.position).normalized()
	return true


## A Lock-On from enemy `e` on tower `t`: the act rule paints it, then fires
## `args` (a heavy shot) down the line; `boss` ignores the rule's cap. Off the
## act (no rule), the shot flies at once. Returns true when it was painted / fired.
static func lock(game: TdGame, e: TdEnemy, t: Tower, args: Dictionary, boss: bool = false) -> bool:
	var rule := game.act_rule if game.act_rule != null and game.act_rule.has_method("paint") else null  # Line of Fire.
	if rule == null:
		return fire_at(game, e, t, args)
	return bool(rule.call("paint", e, t, args, boss))
