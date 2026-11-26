## Berserkergang (Act VI, the Hall of the Slain; Necropathy's NorseRulesData
## BERSERK: "below a share of its HP a Norse warrior goes berserk"): once its HP
## falls below `at` of its max (`at` above 1 = from its first step, the
## Berserker) it rages for good: it marches at `speed_mult` (a haste renewed
## every step), every blow on the body holding it lands `damage_mult` x as hard
## (the extra share dealt as a second blow in on_attack), and with
## `shrug_slow` it shakes off every slow while raging. A red flare marks the
## moment it turns. The shield-maiden reuses the statics.
## Args: at (0..1+), speed_mult, damage_mult, shrug_slow (bool).
## vars: "berserk" (true once raging).
extends EnemyTrait


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	rage_step(e, game)


func on_attack(e: TdEnemy, game: TdGame, body: BlockBody) -> void:
	rage_blow(e, game, body)


## Turns `e` berserk below its row's `at` share and keeps the rage's haste up.
static func rage_step(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if not e.vars.has("berserk"):
		if e.hp > e.max_hp * float(a["at"]):
			return
		e.vars["berserk"] = true
		EnemyTrait.note(game, "berserk")
		if game.vfx.on:
			var lk: Dictionary = Acts.data("norse")["LOOK"]
			game.fx.spawn("level_up", e.position, float(lk["rage_d"]), 0.5, lk["rage_tint"])
		if String(e.row["rank"]) != "fodder":
			Sfx.play("berserk_roar")
	TdCombat.haste_enemy(game, e, float(a["speed_mult"]), 0.2)
	if bool(a.get("shrug_slow", false)) and e.slow_until > game.time:
		e.slow_until = game.time  # The fury shakes the slow off.
		EnemyTrait.note(game, "berserk_shrugs")


## The rage's extra share of a blow on `body` (a second blow).
static func rage_blow(e: TdEnemy, game: TdGame, body: BlockBody) -> void:
	if not e.vars.has("berserk") or body == null or not body.alive:
		return
	var extra := float(e.row["damage"]) * (float(e.row["args"]["damage_mult"]) - 1.0)  # The rage's share.
	TdCombat.damage_body(game, body, extra * e.damage_mult() * TdRulesData.BLOCKER_HIT_MULT, e)
