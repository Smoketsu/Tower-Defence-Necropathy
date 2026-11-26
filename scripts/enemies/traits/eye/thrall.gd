## The Drowned Thrall (Act XI Claims; Necropathy's EyeThrallKit): a claimed
## blocker body risen hostile. The act rule spawns it and sets its look and
## HP; this trait counts its `life` s down and then lets its soul slip back
## (it leaves the road without a kill: no souls, no lives lost). Killed, its
## soul comes home: besides its row souls the ultimate meter gets the charge
## of a `charge_rank` kill (SpellCaster.charge). Args: life (s), charge_rank.
## vars: "until" (game s it slips away).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["until"] = game.time + float(e.row["args"]["life"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var left := float(e.vars["until"]) - game.time  # s still risen.
	e.vars["vis_alpha"] = clampf(left / 1.5, 0.35, 1.0)  # It fades as its soul slips (drawn only).
	if left > 0.0:
		return
	EnemyTrait.note(game, "thralls_slipped")
	game.fx.spawn("drowned_tendrils", e.position, 60.0, 0.5, Acts.data("eye")["RULE"]["rise_tint"])
	game.remove_enemy(e, false)


func on_death(e: TdEnemy, game: TdGame) -> void:
	EnemyTrait.note(game, "thralls_freed")
	game.caster.charge(String(e.row["args"]["charge_rank"]))
	game.fx.spawn("summon_rise", e.position, 64.0, 0.45, Acts.data("eye")["RULE"]["rise_tint"])
