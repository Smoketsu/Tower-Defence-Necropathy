## The Devourer's Whelp (Hall of Two Truths miniboss; Necropathy's
## DevourersWhelpKit, "it eats corpses"): every `every` s it eats every Name
## within `reach` px (the act rule's eat_near(): those bodies never return),
## healing `heal` of its max HP per Name (TdCombat.heal_enemy) and growing
## hungrier: x `haste` speed per Name (TdCombat.haste_enemy, at most
## `haste_max`, `haste_time` s). Args: reach, every, heal, haste, haste_max,
## haste_time. vars: "next" (game s), "hunger" (speed multiplier so far).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["every"])
	e.vars["hunger"] = 1.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < float(e.vars["next"]):
		return
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["next"] = game.time + float(a["every"])
	var n := eat(e, game, float(a["reach"]), float(a["heal"]))
	if n <= 0:
		return
	e.vars["hunger"] = minf(float(e.vars["hunger"]) * pow(float(a["haste"]), n), float(a["haste_max"]))
	TdCombat.haste_enemy(game, e, float(e.vars["hunger"]), float(a["haste_time"]))
	EnemyTrait.note(game, "whelp_eaten", n)


## Eats the Names within `reach` px of `e` (the act rule) and heals `heal` x its
## max HP for each (shared with Ammit). Returns how many.
static func eat(e: TdEnemy, game: TdGame, reach: float, heal: float) -> int:
	if game.act_rule == null or not game.act_rule.has_method("eat_near"):
		return 0
	var n := int(game.act_rule.call("eat_near", e.position, reach))
	if n > 0:
		TdCombat.heal_enemy(game, e, e.max_hp * heal * float(n))
		e.vis_strike_at = game.time  # The bite (drawn only).
		e.vis_strike_dir = e.follower.direction()
	return n
