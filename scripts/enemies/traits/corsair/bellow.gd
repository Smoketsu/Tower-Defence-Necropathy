## Boatswain (the Black Tide; Necropathy BoatswainKit, owner-approved "+20%
## move speed and a short shield to crew within 200 px"): every `every` s he
## bellows: every other enemy within `radius` px is hasted to `speed_mult` and
## takes `ward` x damage for `time` s (TdCombat.haste_enemy / ward_enemy). A
## silenced boatswain (Keening Lady) cannot bellow. Args in his row. vars: "next" (game s).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["every"]) * 0.4


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if game.time < float(e.vars["next"]) or not EnemyTrait.can_heal(e, game):
		return
	e.vars["next"] = game.time + float(a["every"])
	bellow_at(e, game, float(a["radius"]), float(a["speed_mult"]), float(a["ward"]), float(a["time"]))


## The bellow (shared with Bosun Gorran): haste and ward every other enemy within `radius` of `e`.
static func bellow_at(e: TdEnemy, game: TdGame, radius: float, speed_mult: float, ward: float, time: float) -> void:
	for o: TdEnemy in game.foes_near(e.position, radius):
		if o == e:
			continue
		TdCombat.haste_enemy(game, o, speed_mult, time)
		if ward < 1.0:
			TdCombat.ward_enemy(game, o, ward, time)
	EnemyTrait.note(game, "bellows")
	e.vis_strike_at = game.time  # His bellow lunge (drawn only).
	e.vis_strike_dir = Vector2.UP
	if game.vfx.on:
		var ring := game.vfx.add(TdVfx.Kind.RING, e.position, radius, TdVfxData.RING_TIME * 1.5, Acts.data("corsair")["LOOK"]["amber"])
		if ring != null:
			ring.size0 = radius * 0.2
