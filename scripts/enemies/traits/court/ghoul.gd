## Ghoul (the Sanguine Court; Necropathy GhoulKit): a fresh corpse beside a
## free ghoul (offered by the act rule's on_kill) is a meal: it stops on the
## road for `eat_time` s, healing `eat_heal` of its max HP over the meal
## (TdCombat.heal_enemy), then waits `eat_cooldown` s before the next. A held
## ghoul fights instead. Args: eat_time, eat_heal, eat_cooldown.
## vars: "eat_until", "next_meal" (game s).
extends EnemyTrait


func on_spawn(e: TdEnemy, _game: TdGame) -> void:
	e.vars["eat_until"] = 0.0
	e.vars["next_meal"] = 0.0


## A corpse fell beside it: it eats when free and ready.
func offer_meal(e: TdEnemy, game: TdGame) -> void:
	if e.holder != null or game.time < float(e.vars["next_meal"]):
		return
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["eat_until"] = game.time + float(a["eat_time"])
	e.vars["next_meal"] = game.time + float(a["eat_time"]) + float(a["eat_cooldown"])
	e.speed = 0.0
	EnemyTrait.note(game, "ghoul_meals")


func step(e: TdEnemy, game: TdGame, dt: float) -> void:
	if e.speed > 0.0:
		return
	var a: Dictionary = e.row["args"]  # Its numbers.
	if game.time >= float(e.vars["eat_until"]) or e.holder != null:
		e.speed = float(e.row["speed"])
		return
	TdCombat.heal_enemy(game, e, e.max_hp * float(a["eat_heal"]) * dt / float(a["eat_time"]))
