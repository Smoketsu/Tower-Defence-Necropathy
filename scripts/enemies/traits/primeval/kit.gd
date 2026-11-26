## The Age of Titans' shared kit helpers (preloaded by its traits and bosses;
## never a kind's trait itself): the act's telegraph / strike line and ring
## looks (LOOK), the CHARGE (gore every post a charger passes, once each; the
## rock test that stuns a charger on a map rock: MAP key "rocks") and the ROAR
## (stuns every tower round a titan). One path each, so the Horncharger, Old
## Ironbrow, the Tyrant and Old Gravejaw charge and roar alike.
extends RefCounted


## The act's look rows.
static func lk() -> Dictionary:
	return Acts.data("primeval")["LOOK"]


## A telegraph line from `a` through `b` lasting `dur` s, or the bright strike
## (`bright`). Drawn only.
static func line(game: TdGame, a: Vector2, b: Vector2, dur: float, bright: bool) -> void:
	var l := lk()
	var dir := (b - a).normalized() if b != a else Vector2.RIGHT
	var f := game.vfx.add(TdVfx.Kind.STREAK, b + dir * 20.0, float(l["cut_w"] if bright else l["line_w"]),
			float(l["cut_time"]) if bright else maxf(dur, 0.1), l["cut_tint"] if bright else l["line_tint"])
	if f != null:
		f.ang = dir.angle()
		f.size0 = a.distance_to(b) + 40.0


## A ring of `radius` px at `pos`: the telegraph (`dur` s) or the strike in
## `tint` (bright). Drawn only.
static func ring(game: TdGame, pos: Vector2, radius: float, dur: float, tint: Color, bright: bool) -> void:
	var r := game.vfx.add(TdVfx.Kind.RING, pos, radius, maxf(dur, 0.2), tint if bright else lk()["warn_tint"])
	if r != null:
		r.size0 = radius * (0.3 if bright else 0.95)
	if bright:
		game.vfx.add(TdVfx.Kind.ANIM, pos, radius * 2.0, 0.4, tint, "golem_slam")


## Starts a charge of `e`: free of its post, unholdable and hasted
## `speed_mult` x for `time` s (vars "charge_until", "gored").
static func start_charge(e: TdEnemy, game: TdGame, speed_mult: float, time: float) -> void:
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	e.unholdable_until = game.time + time
	e.vars["charge_until"] = game.time + time
	e.vars["gored"] = []
	TdCombat.haste_enemy(game, e, speed_mult, time)
	Sfx.play("stampede_run")


## True while `e` charges.
static func charging(e: TdEnemy, game: TdGame) -> bool:
	return game.time < float(e.vars.get("charge_until", 0.0))


## One charge step of `e`: the bodies of every post it passes take `gore` (x its
## weaken), each post once a charge. If it runs within `rock_r` px of a map rock
## it stops, stunned `rock_stun` s (TdCombat.freeze_enemy; the rank multipliers
## apply). Returns true when it hit a rock this step.
static func charge_step(e: TdEnemy, game: TdGame, gore: float, rock_r: float, rock_stun: float) -> bool:
	var done: Array = e.vars.get("gored", [])
	for blk: RoadBlock in game.blocks:
		if blk.road_id != e.follower.road.id or done.has(blk) or absf(blk.dist - e.follower.dist) > e.radius + 16.0:
			continue
		done.append(blk)
		for b: BlockBody in blk.bodies:
			if b.alive:
				TdCombat.damage_body(game, b, gore * e.damage_mult(), e)
		EnemyTrait.note(game, "charge_gores")
		game.fx.spawn("volley_hit", e.position, float(lk()["gore_d"]), 0.4, lk()["gore_tint"])
	e.vars["gored"] = done
	for rk: Vector2 in game.map.get("rocks", []):
		if e.position.distance_to(rk) <= rock_r:
			e.vars["charge_until"] = 0.0
			e.unholdable_until = 0.0
			e.haste_until = 0.0
			TdCombat.freeze_enemy(game, e, rock_stun)
			EnemyTrait.note(game, "rock_stuns")
			game.fx.spawn("golem_slam", rk, 90.0, 0.45, lk()["stun_tint"])
			game.vfx.shake(2.0)
			Sfx.play("boss_impact")
			return true
	return false


## The roar of `e`: every tower within `radius` px is stunned `stun` s
## (TdCombat.disable_tower, cause "stunned"). Returns the towers stunned.
static func roar(e: TdEnemy, game: TdGame, radius: float, stun: float) -> int:
	var n := 0
	for t: Tower in CovenantField.of(game).towers_near(e.position, radius):
		TdCombat.disable_tower(game, t, stun, "stunned")
		n += 1
	ring(game, e.position, radius, 0.5, lk()["roar_tint"], true)
	game.vfx.shake(2.5)
	Sfx.play("abom_stomp")
	EnemyTrait.note(game, "roars")
	return n


## Kills the first living body of `e`'s holder outright (a swallow; it comes
## back on its post's respawn). Returns true when one was swallowed.
static func swallow(e: TdEnemy, game: TdGame) -> bool:
	if e.holder == null or not e.holder.alive:
		return false
	var b := e.holder
	TdCombat.damage_body(game, b, (b.hp + b.barrier + 1.0) / maxf(1.0 - b.damage_cut, 0.05), e)
	game.fx.spawn("volley_hit", b.pos, 70.0, 0.4, lk()["gore_tint"])
	EnemyTrait.note(game, "swallowed")
	Sfx.play("boss_impact")
	return true
