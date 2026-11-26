## Paris's Arrow (Act VIII spell, Achilles' reward; Necropathy's ParisArrow:
## "a ghost arrow from behind its target's facing: full damage through a shield
## front or a testudo, it finds Achilles' back"): tapped near enemies, `arrows`
## arrows (+ the Doomed Prophetess's `arrow_extra`) strike the strongest foes
## (most HP) within `pick_radius` px, each `damage`, x `fated_mult` on bosses
## and minibosses, x the Prophetess's innate `fated_mult` on every non-fodder
## foe (Foretold Fall). The hit's origin lies `behind` px BEHIND the foe (its
## walking direction reversed): through TdCombat.damage_enemy() the phalanx
## facing test reads it as a hit in the back. Row: SpellData "paris_arrow".
extends TdSpell


func cast(pos: Vector2) -> bool:
	var cands := game.foes_near(pos, float(row["pick_radius"]))  # Who it may strike.
	if cands.is_empty():
		return false
	cands.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return a.hp > b.hp)
	var n := mini(roundi(float(row["arrows"])) + int(CharacterModifiers.innate("arrow_extra", 0)), cands.size())  # Arrows this cast.
	for i in n:
		var e: TdEnemy = cands[i]
		var rank := String(e.row["rank"])  # Its rank.
		var dmg := float(row["damage"]) * (float(row["fated_mult"]) if rank == "boss" or rank == "miniboss" else 1.0)  # This arrow.
		if rank != "fodder":
			dmg *= float(CharacterModifiers.innate("fated_mult", 1.0))
		var from := e.position - e.follower.direction() * float(row["behind"])  # Behind it.
		TdCombat.damage_enemy(game, e, dmg, {"source": id, "origin": from})
		game.stats["fated_arrows"] = int(game.stats.get("fated_arrows", 0)) + 1
		if game.vfx.on:
			var tint: Color = TdVfxData.SPELLS[id]["tint"]
			var f := game.vfx.add(TdVfx.Kind.STREAK, e.position, float(row["streak_w"]), 0.35, tint)
			if f != null:
				f.ang = (e.position - from).angle()
				f.size0 = float(row["behind"])
			game.vfx.add(TdVfx.Kind.ANIM, e.position, float(row["impact_d"]), TdVfxData.IMPACT_TIME, tint, "volley_hit")
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true
