## General Harrow, the Hammer (Act IV, Fort Kessler's boss; GDD §7.3;
## Necropathy BossHarrow, road version). Three forms by his HP:
##   COMMAND — he rides his command car (pose 2: bosses/harrow_command, see
##     BossPoseData) and calls carpet-bombing lines: every `carpet_every` s
##     (the first after `carpet_first`) `carpet_marks` telegraphed strikes on
##     the towers nearest him within `carpet_range` px, each landing
##     `carpet_step` s after the last (`carpet_radius`, `carpet_delay`, `carpet_disable`,
##     `carpet_damage`); a rifle squad (`squad`) behind him every `squad_every` s.
##   THE HAMMER — below `hammer_hp`: out of the car in power armour (+
##     `hammer_armour` flat armour); every `slam_every` s, when a post holds
##     him, the hammer comes down on every body of it (`slam_damage`, strike
##     pose 3); a tank column (`column`) every `column_every` s.
##   BROKEN ARROW — below `arrow_hp`: a strike on his own position counts down
##     `arrow_time` s (a banner every `arrow_banner_every` s). Kill him in time; else THE STRIKE:
##     every tower within `strike_radius` px of him is disabled
##     `strike_disable` s, every body there takes `strike_damage`, and he takes
##     `strike_self` of his max HP (TdCombat.damage_enemy, source broken_arrow).
## Args in his kind row. vars: "form" (1-3), "next_carpet", "next_squad",
## "next_slam", "next_column", "arrow_at" (game s of the strike), "arrow_banner"
## (next banner s), "pose_until". Events: harrow_carpets, harrow_squads,
## harrow_slams, harrow_columns, harrow_arrow, harrow_strike.
extends EnemyTrait

## Shared boss moves.
const Tactics := preload("res://scripts/bosses/city/city_tactics.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["form"] = 1
	e.vars["next_carpet"] = game.time + float(a["carpet_first"])
	e.vars["next_squad"] = game.time + float(a["squad_every"]) * 0.5
	e.vars["next_slam"] = INF
	e.vars["next_column"] = INF
	e.vars["arrow_at"] = INF
	e.vars["arrow_banner"] = INF
	e.vars["pose_until"] = 0.0
	Tactics.phase(game, e, 2, "")


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	var t := game.time  # Now (game s).
	var form := int(e.vars["form"])  # Current form.
	if form >= 2 and e.pose != 0 and t >= float(e.vars["pose_until"]):
		Tactics.phase(game, e, 0, "")
	if form == 1 and e.hp < e.max_hp * float(a["hammer_hp"]):
		form = 2
		e.vars["form"] = 2
		e.armour += float(a["hammer_armour"])
		e.vars["next_slam"] = t + float(a["slam_every"])
		e.vars["next_column"] = t
		Tactics.phase(game, e, 1, "The Hammer: Harrow steps out in power armour!")
		e.vars["pose_until"] = t + float(a["pose_time"])
		game.fx.spawn("golem_slam", e.position, TdVfxData.CITY_POWER_D, TdVfxData.CITY_POWER_TIME)
	if form == 2 and e.hp < e.max_hp * float(a["arrow_hp"]):
		form = 3
		e.vars["form"] = 3
		e.vars["arrow_at"] = t + float(a["arrow_time"])
		e.vars["arrow_banner"] = t + float(a["arrow_banner_every"])
		Tactics.phase(game, e, 1, "Broken Arrow: %d s to stop the strike!" % roundi(float(a["arrow_time"])))
		e.vars["pose_until"] = t + float(a["pose_time"])
		game.sound("city_siren")
		EnemyTrait.note(game, "harrow_arrow")
	if t < e.freeze_until:
		return
	if form == 1:
		if t >= float(e.vars["next_carpet"]):
			e.vars["next_carpet"] = t + float(a["carpet_every"])
			_carpet(e, game, a)
		if t >= float(e.vars["next_squad"]):
			e.vars["next_squad"] = t + float(a["squad_every"])
			Tactics.squad(game, e, a["squad"], float(a["squad_gap"]))
			EnemyTrait.note(game, "harrow_squads")
		return
	if e.holder != null and t >= float(e.vars["next_slam"]):
		e.vars["next_slam"] = t + float(a["slam_every"])
		for b: BlockBody in e.holder.block.bodies:
			if b.alive:
				TdCombat.damage_body(game, b, float(a["slam_damage"]), e)
		Tactics.phase(game, e, 3, "")
		e.vars["pose_until"] = t + float(a["pose_time"])
		e.vis_strike_at = t
		e.vis_strike_dir = e.follower.direction()
		EnemyTrait.note(game, "harrow_slams")
		if game.vfx.on:
			game.fx.spawn("golem_slam", e.holder.pos if e.holder != null else e.position, TdVfxData.CITY_POWER_D, TdVfxData.CITY_POWER_TIME)
			game.vfx.shake(TdVfxData.CITY_CRASH_SHAKE)
	if t >= float(e.vars["next_column"]):
		e.vars["next_column"] = t + float(a["column_every"])
		Tactics.squad(game, e, a["column"], float(a["column_gap"]))
		EnemyTrait.note(game, "harrow_columns")
	if form == 3:
		if t >= float(e.vars["arrow_at"]):
			e.vars["arrow_at"] = INF
			e.vars["arrow_banner"] = INF
			_strike(e, game, a)
		elif t >= float(e.vars["arrow_banner"]):
			e.vars["arrow_banner"] = t + float(a["arrow_banner_every"])
			game.banner("Broken Arrow: %d s!" % roundi(float(e.vars["arrow_at"]) - t))


## A carpet-bombing line on the towers nearest him (see the header).
func _carpet(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var near: Array[Tower] = []  # Towers in range, nearest first.
	for tw: Tower in game.towers:
		if tw.position.distance_to(e.position) <= float(a["carpet_range"]):
			near.append(tw)
	if near.is_empty():
		return
	near.sort_custom(func(x: Tower, y: Tower) -> bool: return x.position.distance_squared_to(e.position) < y.position.distance_squared_to(e.position))
	for i in mini(int(a["carpet_marks"]), near.size()):
		game.hostile.shell(near[i].position, float(a["carpet_radius"]), float(a["carpet_delay"]) + float(a["carpet_step"]) * float(i),
				float(a["carpet_disable"]), "shelled", float(a["carpet_damage"]))
	e.vis_strike_at = game.time
	e.vis_strike_dir = (near[0].position - e.position).normalized()
	EnemyTrait.note(game, "harrow_carpets")


## Broken Arrow lands on his own position (see the header).
func _strike(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var r := float(a["strike_radius"])  # Reach (px).
	for tw: Tower in game.towers:
		if tw.position.distance_to(e.position) <= r:
			TdCombat.disable_tower(game, tw, float(a["strike_disable"]), "shelled")
	for b: BlockBody in game.bodies_near(e.position, r):
		TdCombat.damage_body(game, b, float(a["strike_damage"]), e)
	game.banner("Broken Arrow! The strike lands.")
	EnemyTrait.note(game, "harrow_strike")
	if game.vfx.on:
		game.fx.spawn("corpse_explosion", e.position, r * 2.0, TdVfxData.CITY_STRIKE_TIME)
		game.vfx.shake(TdVfxData.CITY_STRIKE_SHAKE)
	TdCombat.damage_enemy(game, e, e.max_hp * float(a["strike_self"]), {"source": "broken_arrow", "dot": true})
