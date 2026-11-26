## The Power's lunge (Necropathy's PowerKit: "a blade of white flame; a lunge
## that cuts two summons in a line"): once a post holds her and the lunge is
## ready she draws back for `windup` s (a thin white line through the post),
## then the blade cuts the first `targets` living bodies of that post for
## `damage` each (x her weaken). Ready again `cooldown` s later. Not while
## frozen or staggered. Args: windup (s), damage, cooldown (s), targets.
## vars: "next" (game s it may lunge again), "at" (game s the cut lands; 0 =
## not lunging). line() is the act's one telegraph / cut line (the Cherub,
## Seraiel and Flaming Sword use the ring look instead).
extends EnemyTrait


func on_spawn(e: TdEnemy, _game: TdGame) -> void:
	e.vars["next"] = 0.0
	e.vars["at"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	var at := float(e.vars["at"])  # When the cut lands (0 = not lunging).
	if at > 0.0:
		if game.time < at:
			return
		e.vars["at"] = 0.0
		e.vars["next"] = game.time + float(a["cooldown"])
		if e.holder != null and game.time >= e.freeze_until and game.time >= e.staggered_until:
			var far := e.holder.pos  # The line runs to the last body cut.
			var n := 0  # Bodies cut.
			for b: BlockBody in e.holder.block.bodies:
				if b.alive and n < int(a["targets"]):
					TdCombat.damage_body(game, b, float(a["damage"]) * e.damage_mult(), e)
					far = b.pos
					n += 1
			line(game, e.position, far, 0.0, true)
			EnemyTrait.note(game, "power_lunges")
			Sfx.play("power_lunge")
		return
	if e.holder != null and game.time >= float(e.vars["next"]) and game.time >= e.freeze_until:
		e.vars["at"] = game.time + float(a["windup"])
		line(game, e.position, e.holder.pos, float(a["windup"]), false)


## The act's white line from `a` through `b` (and on past it): a faint
## telegraph lasting `dur` s, or the bright cut (`bright`). Drawn only.
static func line(game: TdGame, a: Vector2, b: Vector2, dur: float, bright: bool) -> void:
	var lk: Dictionary = Acts.data("host")["LOOK"]
	var dir := (b - a).normalized() if b != a else Vector2.RIGHT  # Line direction.
	var tail := a - dir * float(lk["line_over"])  # Line start (px).
	var head := b + dir * float(lk["line_over"])  # Line end (px).
	var f := game.vfx.add(TdVfx.Kind.STREAK, head, float(lk["cut_w"] if bright else lk["line_w"]),
			float(lk["cut_time"]) if bright else maxf(dur, 0.1), lk["cut_tint"] if bright else lk["line_tint"])
	if f != null:
		f.ang = dir.angle()
		f.size0 = tail.distance_to(head)


## A telegraph ring of `radius` px at `pos` lasting `dur` s, or the bright sweep
## ring (`bright`; drawn only): the Cherub's, Seraiel's and Flaming Sword's look.
static func sweep_ring(game: TdGame, pos: Vector2, radius: float, dur: float, bright: bool) -> void:
	var lk: Dictionary = Acts.data("host")["LOOK"]
	var ring := game.vfx.add(TdVfx.Kind.RING, pos, radius, maxf(dur, 0.2), lk["sword_tint"] if bright else lk["warn_tint"])
	if ring != null:
		ring.size0 = radius * (0.3 if bright else 0.95)
	if bright:
		game.vfx.add(TdVfx.Kind.ANIM, pos, radius * 2.0, 0.4, lk["sword_tint"], "sentinel_sweep")
