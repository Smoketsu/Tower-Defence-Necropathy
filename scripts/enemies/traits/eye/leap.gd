## The Deep Kin's leap (Necropathy's DeepKinKit: "a telegraphed leap onto the
## front rank"): walking, when a post with a living body lies `near`..`range`
## px ahead on its road and the leap is ready, it crouches `windup` s (a ring
## of `radius` px on the post), then lands on it: every body within `radius`
## px of the post takes `damage` (x its weaken), and it stands at the post,
## caught by it like any walker. It stands still while it crouches (EyeKit.stand). Ready again `cooldown` s later. Not while
## frozen or staggered. Args: range, near, windup (s), radius (px), damage,
## cooldown (s). vars: "next", "at" (game s it lands; 0 = none), "dist" (px
## along its road where it lands).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/eye/eye_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + 2.0
	e.vars["at"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var at := float(e.vars["at"])  # When it lands (0 = not leaping).
	if at > 0.0:
		if game.time < at:
			return
		Kit.walk(e)
		e.vars["at"] = 0.0
		e.vars["next"] = game.time + float(a["cooldown"])
		var rd := e.follower.road  # Its road.
		var to := minf(float(e.vars["dist"]) - e.radius - TdRulesData.HOLD_GAP - 2.0, rd.length - 1.0)  # Just before the post.
		if to > e.follower.dist:
			e.follower.advance(to - e.follower.dist)
			e.position = e.follower.position()
			e.last_dist = e.follower.dist
			e.last_moved = game.time
		var land := rd.point_at(float(e.vars["dist"]))  # The post.
		for b: BlockBody in game.bodies_near(land, float(a["radius"])):
			TdCombat.damage_body(game, b, float(a["damage"]) * e.damage_mult(), e)
		Kit.ring(game, land, float(a["radius"]), 0.35, true, "tide_splash")
		game.vfx.shake(1.2)
		EnemyTrait.note(game, "eye_leaps")
		Sfx.play("abom_stomp")
		return
	if e.holder != null or game.time < float(e.vars["next"]) or game.time < e.freeze_until or game.time < e.staggered_until:
		return
	var blk := Kit.block_ahead(e, game, float(a["near"]), float(a["range"]))  # The post to land on.
	if blk == null:
		return
	e.vars["at"] = game.time + float(a["windup"])
	e.vars["dist"] = blk.dist
	Kit.stand(e)
	Kit.ring(game, e.follower.road.point_at(blk.dist), float(a["radius"]), float(a["windup"]), false)
