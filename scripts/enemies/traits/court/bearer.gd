## Blood Bearer (Carmilla's Waking; Necropathy BloodBearerKit): it walks the road
## to the kneeling Queen and never fights; when it comes within `pour_reach` px
## of a Carmilla who is waking, it pours: the Elder gains her bearer share
## (the Carmilla boss's pour()) and the bearer is gone (no kill, no souls). Kill
## it on the way. Args: pour_reach.
extends EnemyTrait


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	for o: TdEnemy in game.enemies_near(e.position, float(e.row["args"]["pour_reach"]) + 30.0):
		if o.kind == "carmilla" and o.traits != null and o.traits.has_method("pour") and bool(o.traits.call("pour", o, game)):
			game.fx.spawn("level_up", o.position, 90.0, 0.5, Color(1.0, 0.25, 0.3))
			game.remove_enemy(e, false)
			return
