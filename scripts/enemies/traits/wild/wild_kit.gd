## WildKit: the Turning Year's shared helpers for its traits and bosses (not a
## trait itself; preloaded by them): the telegraph ring, the squad call behind a
## caller on its road (at the wave's HP, the Herald's spacing), the charge
## through the posts (the Great Stag, the Stag King's Rut), and the look of a
## blast on the towers round a point. Every effect goes through TdCombat (the
## one path) and every look through game.vfx / game.fx (drawn only, null
## headless). Tints in Acts.data("wild")["LOOK"].
extends RefCounted


## The act's LOOK numbers.
static func lk() -> Dictionary:
	return Acts.data("wild")["LOOK"]


## A ring of `radius` px at `pos` lasting `dur` s in `tint`: a telegraph (from
## 95% of the radius) or a blast (`blast`: from a small ring outward). Drawn only.
static func ring(game: TdGame, pos: Vector2, radius: float, dur: float, tint: Color, blast: bool) -> void:
	var rg := game.vfx.add(TdVfx.Kind.RING, pos, radius, maxf(dur, 0.2), tint)
	if rg != null:
		rg.size0 = radius * (0.15 if blast else 0.95)


## Calls squad `squad` (rows of [kind, count]) on `e`'s road just behind it,
## `gap` px apart, at the current wave's HP (WaveDirector.hp_ramp, as the
## portals do). Returns the units placed.
static func call_squad(e: TdEnemy, game: TdGame, squad: Array, gap: float) -> int:
	var k := 0  # Units placed.
	var keep := game.extra_hp_mult  # Restored after (the wave's own spawns set it).
	game.extra_hp_mult = game.waves.hp_ramp(maxi(game.waves.current, 0))
	for g: Array in squad:
		for j in int(g[1]):
			k += 1
			var d := maxf(e.follower.dist - gap * float(k), 0.0)  # Behind it on its road.
			game.waves.spawn_extra(String(g[0]), e.follower.road.id, d, e.follower.lane + float(k % 3 - 1) * 8.0)
	game.extra_hp_mult = keep
	return k


## Starts a charge of `e`: `speed_mult` x its speed for `time` s, held by no
## post meanwhile (vars "charge_until", "charged": the posts struck). Lets go of
## the body holding it.
static func start_charge(e: TdEnemy, game: TdGame, speed_mult: float, time: float) -> void:
	e.vars["charge_until"] = game.time + time
	e.vars["charged"] = []
	e.vars["broke"] = 0
	e.unholdable_until = game.time + time
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	TdCombat.haste_enemy(game, e, speed_mult, time)


## While `e` charges, strikes the living bodies of each post it passes for `dmg`
## (x its weaken), once per post per charge; the charge ends after it has broken
## through `posts` posts with living bodies (0 = never). Returns the bodies struck.
static func charge_step(e: TdEnemy, game: TdGame, dmg: float, posts: int = 0) -> int:
	if game.time >= float(e.vars.get("charge_until", 0.0)):
		return 0
	var n := 0  # Bodies struck.
	var done: Array = e.vars.get("charged", [])
	for blk: RoadBlock in game.blocks:
		if blk.road_id != e.follower.road.id or done.has(blk) or absf(blk.dist - e.follower.dist) > e.radius + 16.0:
			continue
		done.append(blk)
		for b: BlockBody in blk.bodies:
			if b.alive:
				TdCombat.damage_body(game, b, dmg * e.damage_mult(), e)
				n += 1
		game.fx.spawn("vael_cleave", e.position, 90.0, 0.4, lk()["charge_tint"])
		game.vfx.shake(1.0)
		if n > 0:
			e.vars["broke"] = int(e.vars.get("broke", 0)) + 1
	e.vars["charged"] = done
	if posts > 0 and int(e.vars.get("broke", 0)) >= posts:
		e.vars["charge_until"] = game.time  # Spent: the next post can hold it.
		e.unholdable_until = game.time
		e.haste_until = game.time
	return n


## The charge's telegraph: a line from `e` along its road `ahead` px, lasting `dur` s (drawn only).
static func charge_line(e: TdEnemy, game: TdGame, dur: float) -> void:
	var rd := e.follower.road
	var to := rd.point_at(minf(e.follower.dist + float(lk()["charge_len"]), rd.length))  # Where it points.
	var f := game.vfx.add(TdVfx.Kind.STREAK, to, float(lk()["charge_w"]), maxf(dur, 0.2), lk()["charge_tint"])
	if f != null:
		f.ang = (to - e.position).angle()
		f.size0 = maxf(e.position.distance_to(to), 20.0)


## Disables every tower within `radius` px of `pos` for `time` s (cause a
## HostileData.CAUSE_TINT key; posts only with `posts_only`). Returns how many.
static func stop_towers(game: TdGame, pos: Vector2, radius: float, time: float, cause: String, posts_only: bool) -> int:
	var n := 0  # Towers stopped.
	for t: Tower in CovenantField.of(game).towers_near(pos, radius):
		if posts_only and String(t.row["spot"]) != "post":
			continue
		TdCombat.disable_tower(game, t, time, cause)
		n += 1
	return n


## Plants up to `n` thickets on the built spots within `radius` px of `pos`,
## nearest first, through the act rule's plant() (nothing off-act). Returns how many.
static func plant_near(game: TdGame, pos: Vector2, radius: float, n: int, sprout: float) -> int:
	var rule: MapRule = game.act_rule if game.act_rule != null and game.act_rule.has_method("plant") else null
	if rule == null or n <= 0:
		return 0
	var near := CovenantField.of(game).towers_near(pos, radius)  # Built spots in reach.
	near.sort_custom(func(a: Tower, b: Tower) -> bool: return a.position.distance_squared_to(pos) < b.position.distance_squared_to(pos))
	var k := 0  # Planted.
	for t: Tower in near:
		if k >= n:
			break
		if bool(rule.call("plant", t.spot, sprout)):
			k += 1
	return k
