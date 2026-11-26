## Einherjar (Act VI; Necropathy's EinherjarKit, the gold-lit heroes of the hall
## who fight again every day): the first blow that would kill it instead leaves
## it standing at `rise_hp` of its max HP (once), in a burst of gold; the second
## death is for good. Args: rise_hp (0..1). vars: "risen" (true once used).
extends EnemyTrait


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, _hit: Dictionary) -> float:
	if e.vars.has("risen") or amount < e.hp:
		return amount
	e.vars["risen"] = true
	TdCombat.heal_enemy(game, e, e.max_hp * float(e.row["args"]["rise_hp"]))
	EnemyTrait.note(game, "einherjar_rise")
	Sfx.play("einherjar_rise")
	if game.vfx.on:
		game.fx.spawn("level_up", e.position, 56.0, 0.6, Acts.data("norse")["LOOK"]["rise_tint"])
	return 0.0
