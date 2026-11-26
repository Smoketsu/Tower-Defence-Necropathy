## Shared helpers of the Inferno's traits and bosses (Act IX): the act rule
## (the one portal and pit path, rules/inferno/portals.gd), the body nearest a
## point, every body of the post holding an enemy, and the charm-pink kiss
## burst. Static only; no numbers (callers pass their row args).
extends RefCounted


## The Portals act rule of this run, or null (an Inferno kind spawned elsewhere).
static func rule(game: TdGame) -> MapRule:
	return game.act_rule if game.act_rule != null and game.act_rule.has_method("open_pit") else null


## Opens a Hell Pit through the act rule (no-op without it); true when opened.
static func pit(game: TdGame, pos: Vector2, radius: float, life: float, telegraph: float) -> bool:
	var r := rule(game)  # The act rule.
	return r != null and bool(r.call("open_pit", pos, radius, life, telegraph))


## The living, uncharmed, non-temporary blocker body nearest `pos` within
## `range` px, other than `skip` (may be null), or null.
static func nearest_body(game: TdGame, pos: Vector2, range: float, skip: BlockBody = null) -> BlockBody:
	var best: BlockBody = null  # Nearest so far.
	for b: BlockBody in game.bodies_near(pos, range):
		if b == skip or b.temporary or b.max_hp == INF or game.time < b.charm_until:
			continue
		if best == null or b.pos.distance_squared_to(pos) < best.pos.distance_squared_to(pos):
			best = b
	return best


## Every living body of the post holding `e` (empty when it walks free).
static func post_bodies(e: TdEnemy) -> Array[BlockBody]:
	var out: Array[BlockBody] = []  # Living bodies of its holder's block.
	if e.holder == null:
		return out
	for b: BlockBody in e.holder.block.bodies:
		if b.alive:
			out.append(b)
	return out


## Charms body `b` for `time` s at `hit_mult` (TdCombat.charm_body) with the kiss look and sound.
static func kiss(game: TdGame, from: Vector2, b: BlockBody, time: float, hit_mult: float) -> void:
	TdCombat.charm_body(game, b, time, hit_mult)
	Sfx.play("charm_kiss")
	if game.vfx.on:
		var lk: Dictionary = Acts.data("inferno")["LOOK"]
		var f := game.vfx.add(TdVfx.Kind.THREAD, from + Vector2(0, -16), float(lk["thread_w"]), 0.4, lk["charm_tint"])
		if f != null:
			f.to = b.pos + Vector2(0, -14)
		game.vfx.add(TdVfx.Kind.ANIM, b.pos + Vector2(0, -14), float(lk["kiss_d"]), 0.45, lk["charm_tint"], "volley_flash")
