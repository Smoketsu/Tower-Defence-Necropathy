## EyeKit: the Ancient Eye's shared helpers (Act XI; static, no state): the
## act's telegraph line / ring and bright strike looks (biolume teal, never
## gold; drawn only, numbers in the act data's LOOK) and the post-ahead query
## the Deep Kin's leap and the Spawn's grab use. Every effect goes through
## game.vfx (off headless); nothing here touches the run.
extends RefCounted


## The act's line from `a` to `b`: a faint telegraph lasting `dur` s, or the
## bright strike (`bright`, `tint` overrides its colour when not transparent).
static func line(game: TdGame, a: Vector2, b: Vector2, dur: float, bright: bool, tint: Color = Color(0, 0, 0, 0)) -> void:
	var lk: Dictionary = Acts.data("eye")["LOOK"]
	var col: Color = lk["strike_tint"] if bright else lk["warn_tint"]
	if tint.a > 0.0:
		col = tint
	var f := game.vfx.add(TdVfx.Kind.STREAK, b, float(lk["cut_w"] if bright else lk["line_w"]),
			float(lk["cut_time"]) if bright else maxf(dur, 0.1), col)
	if f != null:
		f.ang = (b - a).angle() if b != a else 0.0
		f.size0 = maxf(a.distance_to(b), 8.0)


## A telegraph ring of `radius` px at `pos` lasting `dur` s, or the bright
## strike ring (`bright`) with strip `anim` (effects/<anim>, "" = none).
static func ring(game: TdGame, pos: Vector2, radius: float, dur: float, bright: bool, anim: String = "", tint: Color = Color(0, 0, 0, 0)) -> void:
	var lk: Dictionary = Acts.data("eye")["LOOK"]
	var col: Color = lk["strike_tint"] if bright else lk["warn_tint"]
	if tint.a > 0.0:
		col = tint
	var f := game.vfx.add(TdVfx.Kind.RING, pos, radius, maxf(dur, 0.2), col)
	if f != null:
		f.size0 = radius * (0.3 if bright else 0.95)
	if bright and anim != "":
		game.vfx.add(TdVfx.Kind.ANIM, pos, radius * 2.0, 0.45, col, anim)


## The nearest road block with a living body on `e`'s road between `near` and
## `far` px ahead of it, or null.
static func block_ahead(e: TdEnemy, game: TdGame, near: float, far: float) -> RoadBlock:
	var best: RoadBlock = null  # Nearest so far.
	var bd := INF  # Its distance ahead (px).
	for blk: RoadBlock in game.blocks:
		if blk.road_id != e.follower.road.id:
			continue
		var d := blk.dist - e.follower.dist  # Px ahead.
		if d < near or d > far or d >= bd:
			continue
		for b: BlockBody in blk.bodies:
			if b.alive:
				best = blk
				bd = d
				break
	return best


## The nearest tower within `r` px of `pos` not disabled now, or null.
static func nearest_tower(game: TdGame, pos: Vector2, r: float) -> Tower:
	var best: Tower = null  # Nearest so far.
	var bd := r * r  # Its squared distance.
	for t: Tower in game.towers:
		var d := t.position.distance_squared_to(pos)
		if d <= bd and game.time >= t.disabled_until:
			bd = d
			best = t
	return best


## Stops `e` where it stands (a windup, a sermon, a channel): its walking speed
## is kept in vars "walk_speed" until walk() gives it back.
static func stand(e: TdEnemy) -> void:
	if not e.vars.has("walk_speed"):
		e.vars["walk_speed"] = e.speed
	e.speed = 0.0


## Lets `e` walk again at the speed stand() kept (no-op when it was not standing).
static func walk(e: TdEnemy) -> void:
	if e.vars.has("walk_speed"):
		e.speed = float(e.vars["walk_speed"])
		e.vars.erase("walk_speed")
