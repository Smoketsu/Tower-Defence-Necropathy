## Valkyrie Duelist (Act XII elite; Necropathy's DuelistKit: "a jet-assisted
## LUNGE drives through the ring with an arm blade"): held at a post, when the
## lunge is ready she draws back for `windup` s (a thin amber line through the
## post), then her jets fire: the blade cuts the first `targets` living bodies
## of that post for `damage` each (x her weaken) and she bursts THROUGH it
## (free of the post, unholdable `dash_time` s at `dash_mult` x speed). Ready
## again `cooldown` s later; not while frozen or staggered (a freeze or a
## stagger keeps her on the post). Args: windup, damage, targets, cooldown,
## dash_time, dash_mult. vars: "next", "at" (game s the lunge fires; 0 = none).
extends EnemyTrait


func on_spawn(e: TdEnemy, _game: TdGame) -> void:
	e.vars["next"] = 0.0
	e.vars["at"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	var at := float(e.vars["at"])  # When the lunge fires.
	if at > 0.0:
		if game.time < at:
			return
		e.vars["at"] = 0.0
		e.vars["next"] = game.time + float(a["cooldown"])
		if e.holder != null and game.time >= e.freeze_until and game.time >= e.staggered_until:
			lunge(e, game, int(a["targets"]), float(a["damage"]), float(a["dash_time"]), float(a["dash_mult"]))
			EnemyTrait.note(game, "duelist_lunges")
		return
	if e.holder != null and game.time >= float(e.vars["next"]) and game.time >= e.freeze_until and game.time >= e.staggered_until:
		e.vars["at"] = game.time + float(a["windup"])
		line(game, e.position, e.holder.pos, float(a["windup"]), false)


## The jet lunge of `e` through the post holding it: the first `targets`
## bodies take `damage`, then it runs free for `dash_time` s at `mult` x speed
## (Valkyrie 2.0's jet dash uses it too).
static func lunge(e: TdEnemy, game: TdGame, targets: int, damage: float, dash_time: float, mult: float) -> void:
	var post := e.holder  # The body holding it.
	var far := post.pos  # The line runs to the last body cut.
	var n := 0  # Bodies cut.
	for b: BlockBody in post.block.bodies:
		if b.alive and n < targets:
			TdCombat.damage_body(game, b, damage * e.damage_mult(), e)
			far = b.pos
			n += 1
	post.held.erase(e)
	e.holder = null
	e.unholdable_until = game.time + dash_time
	TdCombat.haste_enemy(game, e, mult, dash_time)
	line(game, e.position, far, 0.0, true)
	Sfx.play("jet_burst")


## The act's amber line from `a` through `b`: a faint telegraph lasting `dur`
## s, or the bright cut (`bright`). Drawn only.
static func line(game: TdGame, a: Vector2, b: Vector2, dur: float, bright: bool) -> void:
	var lk: Dictionary = Acts.data("empire")["LOOK"]
	var dir := (b - a).normalized() if b != a else Vector2.RIGHT  # Line direction.
	var tail := a - dir * float(lk["line_over"])  # Line start (px).
	var head := b + dir * float(lk["line_over"])  # Line end (px).
	var f := game.vfx.add(TdVfx.Kind.STREAK, head, float(lk["cut_w"] if bright else lk["line_w"]),
			float(lk["cut_time"]) if bright else maxf(dur, 0.1), lk["cut_tint"] if bright else lk["line_tint"])
	if f != null:
		f.ang = dir.angle()
		f.size0 = tail.distance_to(head)
