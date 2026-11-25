## CourtKit: static helpers shared by the Sanguine Court's traits and bosses
## (preloaded by path, not a trait itself): the Blood Moon query, the act
## rule's pools and shields, a road lunge (break free and leap forward), a
## feeding bite on a blocker body, a hex circle on towers, and telegraph marks
## drawn through CovenantField. Holds no numbers: callers pass their args.
extends RefCounted


## The run's Blood Moon rule, or null (a Court kind forced onto another map).
static func rule(game: TdGame) -> MapRule:
	if game.act_rule != null and game.act_rule.has_method("moon_up"):
		return game.act_rule
	return null


## True while the Blood Moon is up (false off the Court's maps).
static func moon_up(game: TdGame) -> bool:
	var r := rule(game)  # The act rule.
	return r != null and bool(r.call("moon_up"))


## Keeps the Blood Moon up until game s `until` (no-op off the Court's maps).
static func force_moon(game: TdGame, until: float) -> void:
	var r := rule(game)  # The act rule.
	if r != null:
		r.call("force_moon", until)


## Opens a healing blood pool (no-op off the Court's maps).
static func pool(game: TdGame, pos: Vector2, radius: float, life: float, heal: float) -> void:
	var r := rule(game)  # The act rule.
	if r != null:
		r.call("add_pool", pos, radius, life, heal)


## A telegraph / effect mark of `radius` px at `pos` for `time` s (drawn only).
static func mark(game: TdGame, pos: Vector2, radius: float, time: float, tint: Color) -> void:
	if game.vfx.on:
		CovenantField.of(game).add_zone(pos, radius, game.time + time, tint)


## The look colour `key` of the act data file's LOOK.
static func tint(key: String) -> Color:
	return Acts.data("court")["LOOK"][key]


## `e` breaks free of any post and leaps `px` along its road (never past the
## gate's last `keep` px); returns the px leapt.
static func lunge(e: TdEnemy, game: TdGame, px: float, keep: float = 120.0) -> float:
	var room := -game.progress(e) - keep  # Px it may still leap.
	var jump := minf(px, room)  # Px leapt.
	if jump <= 0.0:
		return 0.0
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	e.follower.advance(jump)
	e.position = e.follower.position()
	game.fx.spawn("enemy_death", e.position, 70.0, 0.35, Color(1.0, 0.3, 0.3))
	return jump


## A feeding bite: `amount` damage to body `b` from `e`, which heals `feed` x the
## damage dealt (a red thread from the body to the feeder).
static func bite(game: TdGame, e: TdEnemy, b: BlockBody, amount: float, feed: float) -> void:
	var before := b.hp + (b.barrier if game.time < b.barrier_until else 0.0)  # HP + barrier before.
	TdCombat.damage_body(game, b, amount, e)
	var dealt := maxf(before - b.hp - (b.barrier if game.time < b.barrier_until else 0.0), 0.0)  # Damage taken.
	if feed > 0.0 and dealt > 0.0 and e.alive:
		TdCombat.heal_enemy(game, e, dealt * feed)
	game.vfx.enemy_blow(e, b)
	if game.vfx.on:
		var f := game.vfx.add(TdVfx.Kind.THREAD, b.pos + Vector2(0, -10), 6.0, 0.45, tint("feed_tint"))
		if f != null:
			f.to = e.position + Vector2(0, -12)


## The living blocker body within `r` px of `pos` with the least HP (null = none).
static func weakest_body(game: TdGame, pos: Vector2, r: float) -> BlockBody:
	var best: BlockBody = null  # Least HP so far.
	for b: BlockBody in game.bodies_near(pos, r):
		if best == null or b.hp < best.hp:
			best = b
	return best


## The tower nearest `pos` within `r` px, skipping those in `skip` (null = none).
static func nearest_tower(game: TdGame, pos: Vector2, r: float, skip: Array = []) -> Tower:
	var best: Tower = null  # Nearest so far.
	for t: Tower in game.towers:
		if not skip.has(t) and t.position.distance_to(pos) <= r and (best == null or t.position.distance_squared_to(pos) < best.position.distance_squared_to(pos)):
			best = t
	return best


## A hex circle of `r` px on tower `t`: every tower in it is suppressed to `mult`
## for `time` s (TdCombat.suppress_tower) and the circle shows meanwhile.
static func hex(game: TdGame, t: Tower, r: float, mult: float, time: float) -> void:
	for o: Tower in game.towers:
		if o.position.distance_to(t.position) <= r:
			TdCombat.suppress_tower(game, o, mult, time)
	mark(game, t.position, r, time, tint("circle_tint"))
	EnemyTrait.note(game, "hex_circles")


## Spawns `n` of kind `kind` just behind `e` on its road, `gap` px apart; returns them.
static func call_out(game: TdGame, e: TdEnemy, kind: String, n: int, gap: float) -> Array[TdEnemy]:
	var out: Array[TdEnemy] = []  # Spawned.
	for i in n:
		var d := maxf(e.follower.dist - gap * float(i + 1), 0.0)  # Behind it.
		out.append(game.waves.spawn_extra(kind, e.follower.road.id, d, float(i % 2 * 2 - 1) * 9.0))
	return out


## Swaps `e`'s look and body for the rest of its life (a per-enemy copy of its
## row: the werewolf's beast, the Elder's forms): `sprite`, and `radius` when > 0.
static func reshape(e: TdEnemy, sprite: String, radius: float) -> void:
	e.row = e.row.duplicate()
	e.row["sprite"] = sprite
	if radius > 0.0:
		e.radius = radius
	e.body.walk_frame = -1
	e.body.queue_redraw()
	e.queue_redraw()
