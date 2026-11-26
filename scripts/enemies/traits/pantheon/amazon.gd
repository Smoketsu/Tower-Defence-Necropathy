## Amazon (Act VIII, Mount Olympus; Necropathy's AmazonKit: "leaps over the
## first row of the ring; Warriors, the Golem catch her"): walking, every
## `leap_every` s (first after `leap_first`) when a post that could hold her
## lies within `leap_reach` px ahead she leaps it: unholdable for `leap_time`
## s (TdEnemy.unholdable_until) and hasted x `leap_speed`. A heavy blocker
## catches her instead: when the body that would take her has at least
## `catch_hp` max HP she does not leap (she lands on its shield). Args:
## leap_first, leap_every, leap_time (s), leap_reach (px), leap_speed (x),
## catch_hp. vars: "next_leap" (game s). Counted: events amazon_leaps,
## amazon_caught.
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_leap"] = game.time + float(e.row["args"]["leap_first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if e.holder != null or game.time < float(e.vars["next_leap"]) or game.time < e.freeze_until:
		return
	var a: Dictionary = e.row["args"]  # Her numbers.
	var blk := game.block_ahead(e, float(a["leap_reach"]))  # The post ahead, if any.
	if blk == null:
		return
	e.vars["next_leap"] = game.time + float(a["leap_every"])
	var b := blk.free_body(e)  # The body that would take her.
	if b != null and b.max_hp >= float(a["catch_hp"]):
		EnemyTrait.note(game, "amazon_caught")
		return
	e.unholdable_until = game.time + float(a["leap_time"])
	TdCombat.haste_enemy(game, e, float(a["leap_speed"]), float(a["leap_time"]))
	EnemyTrait.note(game, "amazon_leaps")
	if game.vfx.on:
		var lk: Dictionary = PantheonActRules.look()
		game.vfx.add(TdVfx.Kind.ANIM, e.position, float(lk["leap_d"]), 0.4, lk["leap_tint"], "seraph_dive")
