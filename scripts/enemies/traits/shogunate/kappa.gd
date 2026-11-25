## Kappa (Necropathy's KappaKit, "grapples a summon briefly"): every
## `grapple_every`-th blow on the body holding it, it grapples that body: the
## body makes no strike for `grapple` s (BlockBody.next_attack pushed back).
## Args: grapple_every, grapple (s). vars: "blows" (count).
extends EnemyTrait


func on_attack(e: TdEnemy, game: TdGame, body: BlockBody) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["blows"] = int(e.vars.get("blows", 0)) + 1
	if int(e.vars["blows"]) % int(a["grapple_every"]) != 0:
		return
	body.next_attack = maxf(body.next_attack, game.time + float(a["grapple"]))
	EnemyTrait.note(game, "kappa_grapples")
	var lk: Dictionary = Acts.data("shogunate")["LOOK"]
	game.fx.spawn("frost_nova", body.pos, float(lk["grapple_d"]), float(a["grapple"]), lk["grapple_tint"])
