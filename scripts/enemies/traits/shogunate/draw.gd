## The Draw (Samurai; Necropathy's DrawCuts, GDD §7.3 Act V "The Draw"): once a
## post holds him and the Draw is ready, he lays his hand on the hilt for
## `windup` s (a thin white line flashes through the post), then one cut
## strikes EVERY living body of that post for `damage` (x his weaken). Ready
## again `cooldown` s later. Args: windup (s), damage, cooldown (s).
## vars: "next_draw" (game s it may draw again), "draw_at" (game s the cut
## lands; 0 = not drawing). line() is the act's one white-line look (the
## Shogun's iai cuts use it too).
extends EnemyTrait


func on_spawn(e: TdEnemy, _game: TdGame) -> void:
	e.vars["next_draw"] = 0.0
	e.vars["draw_at"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	var at := float(e.vars["draw_at"])  # When the cut lands (0 = not drawing).
	if at > 0.0:
		if game.time < at:
			return
		e.vars["draw_at"] = 0.0
		e.vars["next_draw"] = game.time + float(a["cooldown"])
		if e.holder != null and game.time >= e.freeze_until and game.time >= e.staggered_until:
			cut(game, e, e.holder.block, float(a["damage"]) * e.damage_mult())
			EnemyTrait.note(game, "draw_cuts")
		return
	if e.holder != null and game.time >= float(e.vars["next_draw"]) and game.time >= e.freeze_until:
		e.vars["draw_at"] = game.time + float(a["windup"])
		line(game, e.position, e.holder.pos, float(a["windup"]), false)


## One cut by `e` through every living body of post `blk` for `dmg`, with its white line and sound.
static func cut(game: TdGame, e: TdEnemy, blk: RoadBlock, dmg: float) -> void:
	var far := e.position  # The body farthest from him (the line runs through the post).
	for b: BlockBody in blk.bodies:
		if b.alive:
			if b.pos.distance_squared_to(e.position) > far.distance_squared_to(e.position):
				far = b.pos
			TdCombat.damage_body(game, b, dmg, e)
	line(game, e.position, far, 0.0, true)
	Sfx.play("draw_cut")


## The white Draw line from `a` through `b` (and on past it): a faint telegraph
## lasting `dur` s, or the bright cut (`bright`). Drawn only.
static func line(game: TdGame, a: Vector2, b: Vector2, dur: float, bright: bool) -> void:
	var lk: Dictionary = Acts.data("shogunate")["LOOK"]
	var dir := (b - a).normalized() if b != a else Vector2.RIGHT  # Line direction.
	var tail := a - dir * float(lk["draw_over"])  # Line start (px).
	var head := b + dir * float(lk["draw_over"])  # Line end (px).
	var f := game.vfx.add(TdVfx.Kind.STREAK, head, float(lk["cut_w"] if bright else lk["draw_w"]),
			float(lk["cut_time"]) if bright else maxf(dur, 0.1), lk["cut_tint"] if bright else lk["draw_tint"])
	if f != null:
		f.ang = dir.angle()
		f.size0 = tail.distance_to(head)
