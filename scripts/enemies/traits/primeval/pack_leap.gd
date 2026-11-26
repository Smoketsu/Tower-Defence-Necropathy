## The Razorclaw's pack leap (Necropathy: "Pack leap over the first blocker,
## rakes the nearest summon"): the first time a post holds it, it crouches for
## `windup` s (a line shows the leap), then rakes the body holding it for
## `rake` (x its weaken) and LEAPS `leap` px on down the road past the post,
## unholdable for `unhold` s. Once a life, and only every `one_in`-th
## Razorclaw of the run is a leaper (the pack's hunters; a run counter, so
## deterministic). Not while frozen or staggered.
## Args: windup (s), leap (px), rake, unhold (s), one_in. vars: "leapt" (bool), "at" (game s it springs; 0 = not crouched).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/primeval/kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var n := int(game.stats.get("razor_spawns", 0))  # Razorclaws so far this run (only every `one_in`-th one leaps).
	game.stats["razor_spawns"] = n + 1
	e.vars["leapt"] = n % int(e.row["args"]["one_in"]) != 0
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
	var h := e.holder  # The body holding it (the rake may fell it: it then lets go by itself).
	if h != null:
		TdCombat.damage_body(game, h, rake * e.damage_mult(), e)
		h.held.erase(e)
		e.holder = null
	e.follower.advance(minf(px, maxf(e.follower.road.length - e.follower.dist - 1.0, 0.0)))
	e.position = e.follower.position()
	e.unholdable_until = game.time + unhold
	Kit.line(game, from, e.position, 0.0, true)
	Sfx.play("pack_rush")
