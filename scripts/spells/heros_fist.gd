## Hero's Fist (Act IV spell, unlocked by Paragon; Necropathy HerosFist "a
## spectral fist slams the strongest enemy and sends it flying through the
## rest"): tapped near enemies, the fist comes down on the strongest (most HP)
## within `pick_radius` px of the tap: `damage` and frozen `stun` s
## (TdCombat.freeze_enemy, rank multipliers apply); flung, it strikes every
## other enemy within `fling_radius` px of it for `fling_damage`. `fists`
## per cast, each on the next strongest (the Revenant Heroine adds
## `fist_extra`). Row: SpellData "heros_fist".
extends TdSpell

## Falling fists (drawn only): [map px, game s it lands].
var _fists: Array = []


func cast(pos: Vector2) -> bool:
	var cands := game.foes_near(pos, float(row["pick_radius"]))  # Who it may strike.
	if cands.is_empty():
		return false
	cands.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return a.hp > b.hp)
	var n := mini(roundi(float(row["fists"])) + int(CharacterModifiers.innate("fist_extra", 0)), cands.size())  # Fists this cast.
	for i in n:
		var e: TdEnemy = cands[i]
		if not e.alive:
			continue
		var at := e.position  # Where it lands.
		TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": at})
		if e.alive:
			TdCombat.freeze_enemy(game, e, float(row["stun"]))
		for o: TdEnemy in game.foes_near(at, float(row["fling_radius"])):
			if o != e:
				TdCombat.damage_enemy(game, o, float(row["fling_damage"]), {"source": id, "origin": at})
		game.stats["fists"] = int(game.stats.get("fists", 0)) + 1
		if game.vfx.on:
			_fists.append([at, game.time + TdVfxData.CITY_FIST_FALL])
			game.vfx.add(TdVfx.Kind.ANIM, at, float(row["fling_radius"]) * 2.4, TdVfxData.IMPACT_TIME * 1.4, Color.WHITE, "golem_slam", TdVfxData.CITY_FIST_FALL)
			var ring := game.vfx.add(TdVfx.Kind.RING, at, float(row["fling_radius"]), TdVfxData.RING_TIME, TdVfxData.SPELLS[id]["tint"], "", TdVfxData.CITY_FIST_FALL)
			if ring != null:
				ring.size0 = 10.0
			game.vfx.add(TdVfx.Kind.CRACK, at, 1.0, TdVfxData.CRACK_TIME, Color.WHITE, "", TdVfxData.CITY_FIST_FALL)
	game.vfx.shake(TdVfxData.LOB_SHAKE)
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_fists.size() - 1, -1, -1):
		if game.time > float(_fists[i][1]) + TdVfxData.CITY_FIST_LINGER:
			_fists.remove_at(i)


func draw(ci: CanvasItem) -> void:
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	for f: Array in _fists:
		var k := clampf(1.0 - (float(f[1]) - game.time) / TdVfxData.CITY_FIST_FALL, 0.0, 1.0)  # 0 -> 1 as it falls.
		var gone := clampf((game.time - float(f[1])) / TdVfxData.CITY_FIST_LINGER, 0.0, 1.0)  # Fades after landing.
		var p: Vector2 = Vector2(f[0]) + Vector2(0, -TdVfxData.CITY_FIST_DROP * (1.0 - k))  # The fist above its target.
		var rect := Rect2(p - Vector2(TdVfxData.CITY_FIST_PX, TdVfxData.CITY_FIST_PX * 1.6), Vector2(TdVfxData.CITY_FIST_PX, TdVfxData.CITY_FIST_PX) * 2.0)
		if not SpriteBank.draw_icon_art(ci, "heros_fist", rect):
			SpriteBank.draw_disc(ci, p, TdVfxData.CITY_FIST_PX, Color(tint, 1.0 - gone))


func busy() -> bool:
	return not _fists.is_empty()
