## The Burrower's tunnel (Necropathy's BurrowerKit: "it tunnels in"): once a
## post has held it `first` s, unless frozen, it digs UNDER the post: it BURROWS for
## `under` s: unseen by the towers (vars "hidden_until", the one hidden test),
## held by no post (TdEnemy.unholdable_until; a post holding it lets go) and
## `speed_mult` x faster, a mound of earth showing where it goes (drawn by the
## act's layer from vars "burrow_until"). It surfaces further down the road.
## Answer: posts past the first, splash, spells on the mound (they still hit it).
## Hidden helper: dig() (the Hive Mother's dive uses it).
## It digs at most `digs` times.
## Args: first (s held), digs, under (s), speed_mult. vars: "held_s" (s held so far),
## "dug" (digs made), "burrow_until" (game s).
extends EnemyTrait


func on_spawn(e: TdEnemy, _game: TdGame) -> void:
	e.vars["held_s"] = 0.0
	e.vars["dug"] = 0
	e.vars["burrow_until"] = 0.0


func step(e: TdEnemy, game: TdGame, dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	surface(e, game)
	if e.holder == null or int(e.vars["dug"]) >= int(a["digs"]) or game.time < e.freeze_until:
		return
	e.vars["held_s"] = float(e.vars["held_s"]) + dt
	if float(e.vars["held_s"]) < float(a["first"]):
		return
	e.vars["held_s"] = 0.0
	e.vars["dug"] = int(e.vars["dug"]) + 1
	dig(e, game, float(a["under"]), float(a["speed_mult"]))
	EnemyTrait.note(game, "burrows")


## Sends `e` under the ground for `time` s at `speed_mult` x its speed (see the header).
static func dig(e: TdEnemy, game: TdGame, time: float, speed_mult: float) -> void:
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	e.vars["burrow_until"] = game.time + time
	e.vars["hidden_until"] = game.time + time
	e.unholdable_until = game.time + time
	TdCombat.haste_enemy(game, e, speed_mult, time)
	e.vars["vis_alpha"] = 0.12
	e.body.queue_redraw()
	game.fx.spawn("structure_break", e.position, 46.0, 0.4, Color(0.7, 0.6, 0.45))
	Sfx.play("burrow_rumble")


## Brings `e` back into sight once its burrow time is over (drawn only).
static func surface(e: TdEnemy, game: TdGame) -> void:
	if float(e.vars.get("vis_alpha", 1.0)) < 1.0 and game.time >= float(e.vars.get("burrow_until", 0.0)):
		e.vars["vis_alpha"] = 1.0
		e.body.queue_redraw()
		game.fx.spawn("structure_break", e.position, 52.0, 0.4, Color(0.7, 0.6, 0.45))
