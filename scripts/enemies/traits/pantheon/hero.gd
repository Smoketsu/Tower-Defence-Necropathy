## Hero (Act VIII; Necropathy's HeroKit and Glory: "Heroes grow with every
## summon they kill"): a demigod in the column. GLORY: every blocker body that
## falls to one of its blows is a stack (at most `max_stacks`): its max HP
## grows by `hp_gain` x its spawn max HP (healed by the same through
## TdCombat.heal_enemy) and its flat armour by `armour_gain`. The act rule's
## PantheonLayer draws a gold aura that grows with the stacks. Args: hp_gain
## (fraction), armour_gain (flat), max_stacks. vars: "glory" (stacks),
## "base_hp" (max HP at spawn). Counted as event "glory".
extends EnemyTrait


func on_spawn(e: TdEnemy, _game: TdGame) -> void:
	e.vars["glory"] = 0
	e.vars["base_hp"] = e.max_hp


func on_attack(e: TdEnemy, game: TdGame, body: BlockBody) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if body.alive or int(e.vars["glory"]) >= int(a["max_stacks"]):
		return
	e.vars["glory"] = int(e.vars["glory"]) + 1
	var gain := float(e.vars["base_hp"]) * float(a["hp_gain"])  # HP this stack adds.
	e.max_hp += gain
	TdCombat.heal_enemy(game, e, gain)
	e.armour += float(a["armour_gain"])
	EnemyTrait.note(game, "glory")
	Sfx.play("glory_gain")
	if game.vfx.on:
		var lk: Dictionary = PantheonActRules.look()
		game.vfx.add(TdVfx.Kind.ANIM, e.position, float(lk["glory_burst"]), 0.5, lk["glory_tint"], "level_up")
