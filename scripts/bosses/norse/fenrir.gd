## Fenrir (Vigrid, at Odin's side; Necropathy's FenrirKit: "the great wolf
## hunts and SWALLOWS"). Every `swallow_every` s (first after `swallow_first`)
## while a post holds him he swallows the body holding him (`swallow_damage`),
## breaks free and runs on: unholdable for `free_time` s at `speed_mult`.
## Odin drives his phases through his vars: "chained" (he stands frozen where
## he is, out of reach: vars "untargetable", hidden by the Long Winter's
## can_target(), every hit does nothing) and, in Ragnarok, a rage haste of
## `rage_speed`. When he falls Odin follows `doom_time` s later; when Odin
## falls first, "doom_at" makes him follow (the boss kill path).
## Args in his row. vars: "next_swallow", "odin" ([TdEnemy, generation]),
## "chained", "untargetable", "doom_at".
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_swallow"] = game.time + float(e.row["args"]["swallow_first"])


func incoming_damage(e: TdEnemy, _game: TdGame, amount: float, _hit: Dictionary) -> float:
	return 0.0 if bool(e.vars.get("untargetable", false)) else amount


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if e.vars.has("doom_at"):
		if game.time >= float(e.vars["doom_at"]):
			EnemyTrait.note(game, "fenrir_doomed")
			TdCombat.kill_enemy(game, e, null)
		return
	if bool(e.vars.get("chained", false)):
		e.freeze_until = maxf(e.freeze_until, game.time + 0.1)
		e.vars["vis_alpha"] = 0.6  # Drawn bound in Gleipnir (visual only).
		return
	if e.vars.has("vis_alpha"):
		e.vars.erase("vis_alpha")
		e.body.queue_redraw()
		TdCombat.haste_enemy(game, e, float(a["rage_speed"]), 600.0)  # Unchained in Ragnarok: he runs in a rage.
	if e.holder == null or game.time < float(e.vars["next_swallow"]) or game.time < e.freeze_until:
		return
	e.vars["next_swallow"] = game.time + float(a["swallow_every"])
	var b := e.holder  # The body he swallows.
	TdCombat.damage_body(game, b, float(a["swallow_damage"]) * e.damage_mult(), e)
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	e.unholdable_until = game.time + float(a["free_time"])
	TdCombat.haste_enemy(game, e, float(a["speed_mult"]), float(a["free_time"]))
	EnemyTrait.note(game, "fenrir_swallows")
	Sfx.play("berserk_roar")
	if game.vfx.on:
		game.vfx.add(TdVfx.Kind.ANIM, b.pos, float(Acts.data("norse")["LOOK"]["swallow_d"]), 0.45, Color(0.8, 0.85, 1.0), "golem_slam")


func on_death(e: TdEnemy, game: TdGame) -> void:
	var op: Array = e.vars.get("odin", [])
	if not op.is_empty() and TdEnemy.valid(op[0], int(op[1])) and not (op[0] as TdEnemy).vars.has("doom_at"):
		(op[0] as TdEnemy).vars["doom_at"] = game.time + float((op[0] as TdEnemy).row["args"]["doom_time"])
		game.banner("Fenrir falls: the All-Father will follow him")
