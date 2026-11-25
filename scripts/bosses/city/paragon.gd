## Paragon, the Last Hero (Act IV, Liberty Heights' boss and the act's
## finale; GDD §7.3; Necropathy BossParagon, road version). Three phases by
## his HP:
##   THE HERO — heat vision: every `heat_every` s (the first after
##     `heat_first`) his eyes burn `heat_windup` s (pose 1, a thin red line to
##     the target), then the beam runs from him to the farthest tower within
##     `heat_range` px: every tower within `heat_width` px of that line is
##     disabled `heat_disable` s (cause "blinded"). The punch: every
##     `punch_every` s while a post holds him, the body holding him takes
##     `punch_damage` (strike pose).
##   HOPE — below `hope_hp`: while any Super (a city/super kind) stands, he
##     takes only `hope_ward` of each hit (TdCombat.ward_enemy) and heals every
##     Super by `hope_heal` every `hope_every` s. Kill the heroes first.
##   NO RESTRAINT — below `restraint_hp`: every `dive_every` s he flies up and
##     dives from orbit `dive_dist` px down his road (never into the last
##     `keep_away` px before the gate): the crater is telegraphed `dive_delay`
##     s (game.hostile.shell: `dive_radius`, `dive_disable`, `dive_damage`),
##     he is unholdable meanwhile and lands where it falls.
## Heat vision and the punch go on in every phase. Args in his kind row.
## vars: "stage" (1-3), "next_heat", "heat_at" (beam game s), "heat_to"
## (beam end px), "next_punch", "next_hope", "next_dive", "dive_at",
## "dive_d" (landing px along his road), "pose_until". Events: paragon_heat,
## paragon_heat_towers, paragon_punches, paragon_hope_heals, paragon_dives.
extends EnemyTrait

## Shared boss moves.
const Tactics := preload("res://scripts/bosses/city/city_tactics.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["stage"] = 1
	e.vars["next_heat"] = game.time + float(a["heat_first"])
	e.vars["heat_at"] = INF
	e.vars["heat_to"] = Vector2.ZERO
	e.vars["next_punch"] = game.time + float(a["punch_every"])
	e.vars["next_hope"] = INF
	e.vars["next_dive"] = INF
	e.vars["dive_at"] = INF
	e.vars["dive_d"] = 0.0
	e.vars["pose_until"] = 0.0
	game.sound("city_super")


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	var t := game.time  # Now (game s).
	if e.pose != 0 and t >= float(e.vars["pose_until"]) and float(e.vars["heat_at"]) == INF and float(e.vars["dive_at"]) == INF:
		Tactics.phase(game, e, 0, "")
	var stage := int(e.vars["stage"])  # Current phase.
	if stage == 1 and e.hp < e.max_hp * float(a["hope_hp"]):
		e.vars["stage"] = 2
		e.vars["next_hope"] = t
		Tactics.phase(game, e, 1, "Hope: Paragon draws strength from every hero still standing!")
		e.vars["pose_until"] = t + float(a["pose_time"])
	elif stage == 2 and e.hp < e.max_hp * float(a["restraint_hp"]):
		e.vars["stage"] = 3
		e.vars["next_dive"] = t
		Tactics.phase(game, e, 1, "No Restraint: Paragon stops holding back!")
		e.vars["pose_until"] = t + float(a["pose_time"])
	stage = int(e.vars["stage"])
	if stage >= 2 and t >= float(e.vars["next_hope"]):
		e.vars["next_hope"] = t + float(a["hope_every"])
		var heroes := 0  # Supers standing.
		for o: TdEnemy in game.enemies:
			if o.alive and String(o.row["trait"]) == "city/super":
				heroes += 1
				TdCombat.heal_enemy(game, o, float(a["hope_heal"]))
				game.fx.spawn("level_up", o.position, TdVfxData.CITY_POWER_D * 0.5, TdVfxData.CITY_POWER_TIME)
		if heroes > 0:
			TdCombat.ward_enemy(game, e, float(a["hope_ward"]), float(a["hope_every"]))
			EnemyTrait.note(game, "paragon_hope_heals", float(heroes))
	if float(e.vars["dive_at"]) != INF:
		if t >= float(e.vars["dive_at"]):
			_land(e, game)
		return
	if t < e.freeze_until:
		return
	if float(e.vars["heat_at"]) != INF:
		if t >= float(e.vars["heat_at"]):
			_beam(e, game, a)
		return
	if stage == 3 and t >= float(e.vars["next_dive"]):
		e.vars["next_dive"] = t + float(a["dive_every"])
		_dive(e, game, a)
		return
	if t >= float(e.vars["next_heat"]):
		_aim(e, game, a)
	if e.holder != null and t >= float(e.vars["next_punch"]):
		e.vars["next_punch"] = t + float(a["punch_every"])
		TdCombat.damage_body(game, e.holder, float(a["punch_damage"]), e)
		game.vfx.enemy_blow(e, e.holder)
		Tactics.phase(game, e, 3, "")
		e.vars["pose_until"] = t + float(a["pose_time"])
		EnemyTrait.note(game, "paragon_punches")
		if game.vfx.on:
			game.fx.spawn("golem_slam", e.holder.pos, TdVfxData.CITY_POWER_D, TdVfxData.CITY_POWER_TIME)
	elif e.holder == null:
		e.vars["next_punch"] = maxf(float(e.vars["next_punch"]), t + float(a["punch_every"]) * 0.5)


## Heat vision wind-up: picks the farthest tower in range and burns his eyes.
func _aim(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var best: Tower = null  # The beam's far end.
	for tw: Tower in game.towers:
		var d := tw.position.distance_to(e.position)  # Distance (px).
		if d <= float(a["heat_range"]) and (best == null or d > best.position.distance_to(e.position)):
			best = tw
	e.vars["next_heat"] = game.time + float(a["heat_every"])
	if best == null:
		return
	e.vars["heat_at"] = game.time + float(a["heat_windup"])
	e.vars["heat_to"] = best.position
	e.speed = 0.0  # He stands to burn.
	Tactics.phase(game, e, 1, "")
	if game.vfx.on:
		var f := game.vfx.add(TdVfx.Kind.THREAD, e.position + TdVfxData.CITY_EYES, TdVfxData.CITY_HEAT_AIM_W, float(a["heat_windup"]), TdVfxData.CITY_HEAT_AIM_TINT)
		if f != null:
			f.to = best.position


## The beam fires along the aimed line (see the header).
func _beam(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	e.vars["heat_at"] = INF
	e.speed = float(e.row["speed"])
	var from := e.position  # Line start.
	var to: Vector2 = e.vars["heat_to"]
	var n := 0  # Towers hit.
	for tw: Tower in game.towers:
		if Geometry2D.get_closest_point_to_segment(tw.position, from, to).distance_to(tw.position) <= float(a["heat_width"]):
			TdCombat.disable_tower(game, tw, float(a["heat_disable"]), "blinded")
			n += 1
	e.vars["pose_until"] = game.time + float(a["pose_time"]) * 0.5
	EnemyTrait.note(game, "paragon_heat")
	EnemyTrait.note(game, "paragon_heat_towers", float(n))
	if game.vfx.on:
		var f := game.vfx.add(TdVfx.Kind.THREAD, from + TdVfxData.CITY_EYES, TdVfxData.CITY_HEAT_W, TdVfxData.CITY_HEAT_TIME, TdVfxData.CITY_HEAT_TINT)
		if f != null:
			f.to = to
		game.vfx.shake(TdVfxData.CITY_CRASH_SHAKE)


## Takes off for a dive from orbit (see the header).
func _dive(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var r: Road = e.follower.road  # His road.
	var limit := r.length - float(a["keep_away"]) if r.next_id == "" else r.length  # Never into the gate's last stretch.
	var d := minf(e.follower.dist + float(a["dive_dist"]), limit)  # Landing (px along his road).
	if d <= e.follower.dist:
		return
	e.vars["dive_d"] = d
	e.vars["dive_at"] = game.time + float(a["dive_delay"])
	e.unholdable_until = e.vars["dive_at"] + 0.1
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	e.speed = 0.0
	game.hostile.shell(r.point_at(d), float(a["dive_radius"]), float(a["dive_delay"]), float(a["dive_disable"]), "shelled", float(a["dive_damage"]))
	Tactics.phase(game, e, 1, "")
	EnemyTrait.note(game, "paragon_dives")


## Lands from the dive where the crater fell.
func _land(e: TdEnemy, game: TdGame) -> void:
	e.vars["dive_at"] = INF
	e.follower.dist = float(e.vars["dive_d"])
	e.position = e.follower.position()
	e.last_dist = e.follower.dist
	e.last_moved = game.time
	e.speed = float(e.row["speed"])
	Tactics.phase(game, e, 3, "")
	e.vars["pose_until"] = game.time + float(e.row["args"]["pose_time"])
	if game.vfx.on:
		game.vfx.add(TdVfx.Kind.CRACK, e.position, TdVfxData.CITY_CRATER, TdVfxData.CRACK_TIME, Color.WHITE)
		game.vfx.shake(TdVfxData.CITY_STRIKE_SHAKE)
