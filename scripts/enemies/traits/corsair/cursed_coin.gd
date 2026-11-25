## Cursed Coin (the Black Tide; Necropathy CursedCoinKit, Admiral Marrec's
## Gold Fever): a coin lying still on the road; while it stands near her it
## shields Marrec (her trait counts coins within its reach). Unbroken, it sinks
## into the deck `life` s after it fell (leaves the road: no souls).
## Args in its row. vars: "sink_at" (game s).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["sink_at"] = game.time + float(e.row["args"]["life"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time >= float(e.vars["sink_at"]):
		game.remove_enemy(e, false)
