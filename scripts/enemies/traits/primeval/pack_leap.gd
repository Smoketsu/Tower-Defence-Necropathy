## The Razorclaw's pack leap (Necropathy: "Pack leap over the first blocker,
## rakes the nearest summon"): the first time a post holds it, it crouches for
## `windup` s (a line shows the leap), then rakes the body holding it for
## `rake` (x its weaken) and LEAPS `leap` px on down the road past the post,
## unholdable for `unhold` s. Once a life. Not while frozen or staggered.
## Args: windup (s), leap (px), rake, unhold (s). vars: "leapt" (bool), "at" (game s it springs; 0 = not crouched).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/primeval/kit.gd")


func on_spawn(e: TdEnemy, _game: TdGame) -> void:
	e.vars["leapt"] = false
	e.vars["at"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if bool(e.vars["leapt"]):
		return
	var a: Dictionary = e.row["args"]
	var at := float(e.vars["at"])
	if at <= 0.0:
		if e.holder != null and game.time >= e.freeze_until and game.time >= e.staggered_until:
			e.vars["at"] = game.time + float(a["windup"])
			Kit.line(game, e.position, e.follower.road.point_at(minf(e.follower.dist + float(a["leap"]), e.follower.road.length)), float(a["windup"]), false)
		return
	if game.time < at:
		return
	e.vars["leapt"] = true
	if e.holder == null or game.time < e.freeze_until or game.time < e.staggered_until:
		return
	leap(e, game, float(a["leap"]), float(a["rake"]), float(a["unhold"]))
	EnemyTrait.note(game, "pack_leaps")


## Leaps `e` `px` down its road past its holder, raking the holder for `rake`
## first; unholdable `unhold` s. The leap Scarmaw shares.
static func leap(e: TdEnemy, game: TdGame, px: float, rake: float, unhold: float) -> void:
	var from := e.position
	if e.holder != null:
		TdCombat.damage_body(game, e.holder, rake * e.damage_mult(), e)
		e.holder.held.erase(e)
		e.holder = null
	e.follower.advance(minf(px, maxf(e.follower.road.length - e.follower.dist - 1.0, 0.0)))
	e.position = e.follower.position()
	e.unholdable_until = game.time + unhold
	Kit.line(game, from, e.position, 0.0, true)
	Sfx.play("pack_rush")
