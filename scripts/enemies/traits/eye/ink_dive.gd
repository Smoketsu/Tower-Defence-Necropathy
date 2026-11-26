## The Ink Wraith's dive (Necropathy's InkWraithKit): every `every` s (first
## `first` s after it arrives) it sinks into the ink for `time` s: unseen by the
## towers (vars "hidden_until", the one hidden test) and through the posts
## (unholdable; a post holding it lets go), drawn faded to `alpha` (vars
## "vis_alpha"). It rises where the dive ends and walks on. Args: first, every,
## time (s), alpha. vars: "next".
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if game.time < float(e.vars.get("hidden_until", 0.0)):
		return
	e.vars["vis_alpha"] = 1.0
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until:
		return
	e.vars["next"] = game.time + float(a["every"])
	e.vars["hidden_until"] = game.time + float(a["time"])
	e.unholdable_until = game.time + float(a["time"])
	e.vars["vis_alpha"] = float(a["alpha"])
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	game.fx.spawn("ink_burst", e.position, 50.0, 0.4)
	EnemyTrait.note(game, "eye_dives")
