## Temptation (Act IX spell, Lilith's reward; Necropathy's Temptation, id
## "tempt": "charm the strongest foe near you: it fights for you for a
## while"): the `charms` foes with the most HP within `radius` px of the tap
## (never a boss, miniboss or structure) are charmed `charm_time` s (x the
## Succubus Queen's innate "tempt_time"): each stands and strikes the foes
## beside it (`reach` px) for `damage` (TdCombat.charm_enemy). Nothing to
## charm: no cast. Row: SpellData "tempt".
extends TdSpell


func cast(pos: Vector2) -> bool:
	var foes := game.foes_near(pos, float(row["radius"]))  # Candidates.
	foes.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return a.hp > b.hp)
	var n := 0  # Foes charmed.
	var time := float(row["charm_time"]) * float(CharacterModifiers.innate("tempt_time", 1.0))  # Charm length (s).
	for e: TdEnemy in foes:
		if n >= int(row["charms"]):
			break
		if TdCombat.charm_enemy(game, e, time, float(row["damage"]), float(row["reach"]), id, null):
			n += 1
			if game.vfx.on:
				var lk: Dictionary = Acts.data("inferno")["LOOK"]
				var f := game.vfx.add(TdVfx.Kind.THREAD, pos, float(lk["thread_w"]), 0.4, lk["charm_tint"])
				if f != null:
					f.to = e.position + Vector2(0, -14)
				game.vfx.add(TdVfx.Kind.ANIM, e.position + Vector2(0, -14), float(lk["kiss_d"]), 0.45, lk["charm_tint"], "volley_flash")
	if n == 0:
		return false
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true
