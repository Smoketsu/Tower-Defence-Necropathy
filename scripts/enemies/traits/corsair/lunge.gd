## Swashbuckler (the Black Tide; Necropathy SwashbucklerKit "a rapier lunge
## over the first blocker"): every `every` s while a blocker body holds her she
## draws back for `windup` s, then lunges through it: the body takes `damage`,
## she is let go and cannot be held for `time` s, running at `speed_mult`.
## Args in her row. vars: "next" (game s the next lunge may start), "wind_at"
## (game s the lunge lands; absent = not winding).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["every"]) * 0.5


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if e.vars.has("wind_at"):
		if game.time < float(e.vars["wind_at"]):
			return
		e.vars.erase("wind_at")
		lunge_through(e, game, float(a["damage"]), float(a["time"]), float(a["speed_mult"]))
		EnemyTrait.note(game, "lunges")
		return
	if e.holder == null or game.time < float(e.vars["next"]) or game.time < e.freeze_until or game.time < e.staggered_until:
		return
	e.vars["next"] = game.time + float(a["every"])
	e.vars["wind_at"] = game.time + float(a["windup"])


## The lunge (shared with Marrec): the holding body takes `damage`, `e` is let go,
## unholdable for `time` s and hasted by `speed_mult`. Nothing when nothing holds it.
static func lunge_through(e: TdEnemy, game: TdGame, damage: float, time: float, speed_mult: float) -> void:
	if e.holder == null:
		return
	var b := e.holder  # The body she lunges through.
	TdCombat.damage_body(game, b, damage * e.damage_mult(), e)
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	e.unholdable_until = game.time + time
	TdCombat.haste_enemy(game, e, speed_mult, time)
	e.vis_strike_at = game.time  # The lunge's lunge (drawn only).
	e.vis_strike_dir = e.follower.direction()
	if game.vfx.on:
		var lk: Dictionary = Acts.data("corsair")["LOOK"]  # Looks.
		var f := game.vfx.add(TdVfx.Kind.SLASH, b.pos, float(lk["slash_d"]), TdVfxData.SLASH_TIME, lk["slash_tint"], "kit")
		if f != null:
			f.ang = e.follower.direction().angle()
