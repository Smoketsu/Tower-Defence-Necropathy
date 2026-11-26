## Flicker (the Will-o'-Wisp; Necropathy's WillOWispKit, "a drifting cold
## light"): every `every` s (first `first` s after it arrives) it gutters out
## for `hide` s: no tower can pick it meanwhile (vars "hidden_until", the one
## hidden test TdEnemy.hidden_from_towers()) and it is drawn at `alpha` (vars
## "vis_alpha", drawn only). Area hits and spells still reach it.
## Args: first, every, hide (s), alpha (0..1). vars: "next" (game s).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var hid := game.time < float(e.vars.get("hidden_until", 0.0))  # Guttered out now.
	e.vars["vis_alpha"] = float(a["alpha"]) if hid else 1.0
	if not hid and game.time >= float(e.vars["next"]):
		e.vars["next"] = game.time + float(a["every"])
		e.vars["hidden_until"] = game.time + float(a["hide"])
		EnemyTrait.note(game, "wisp_flickers")
