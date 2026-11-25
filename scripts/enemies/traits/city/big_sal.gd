## Big Sal (Act IV, Skid Row's miniboss; Necropathy big_sal, the Kingpin's
## enforcer): every `call_every` s (the first after `call_first`) he whistles
## up his crew: `squad_n` of kind `squad` climb in behind him on his road,
## `squad_gap` px apart (WaveDirector.spawn_extra, counted in his wave).
## Below `rage_hp` of his HP he rages: hasted x `rage_mult` for good and his
## crew comes twice as often. Args: call_first, call_every, squad, squad_n,
## squad_gap, rage_hp, rage_mult. vars: "next_call" (game s), "rage" (bool).
## Events: big_sal_calls, big_sal_rage.
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_call"] = game.time + float(e.row["args"]["call_first"])
	e.vars["rage"] = false


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	var rage := bool(e.vars["rage"])  # Raging now.
	if not rage and e.hp < e.max_hp * float(a["rage_hp"]):
		rage = true
		e.vars["rage"] = true
		game.banner("Big Sal sees red!")
		EnemyTrait.note(game, "big_sal_rage")
	if rage:
		TdCombat.haste_enemy(game, e, float(a["rage_mult"]), 1.0)
	if game.time < float(e.vars["next_call"]) or game.time < e.freeze_until:
		return
	e.vars["next_call"] = game.time + float(a["call_every"]) * (0.5 if rage else 1.0)
	for i in int(a["squad_n"]):
		var d := maxf(e.follower.dist - float(a["squad_gap"]) * float(i + 1), 0.0)  # Behind him (px).
		game.waves.spawn_extra(String(a["squad"]), e.follower.road.id, d, e.follower.lane + float(i % 2 * 2 - 1) * 6.0)
	EnemyTrait.note(game, "big_sal_calls")
	e.vis_strike_at = game.time  # His whistle (drawn only).
	e.vis_strike_dir = Vector2.UP
	if game.vfx.on:
		game.fx.spawn("volley_flash", e.position, TdVfxData.CITY_POWER_D, TdVfxData.CITY_POWER_TIME, TdVfxData.CITY_GANG_TINT)
