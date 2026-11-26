## Fall from Grace (Act IX spell, the Morning Star's reward; Necropathy's Fall
## from Grace, "a fallen star crashes down on the strongest foe near you"):
## a star falls `fall_time` s on the foe with the most HP within `radius` px
## of the tap (bosses included): `damage` to it and `splash` x that to every
## other foe within `crash` px. The Fallen Saint's innate "grace_second" drops
## a second star on the next-strongest foe at that share of the damage.
## Nothing in reach: no cast. Row: SpellData "fall_from_grace".
extends TdSpell

## Falling stars: [TdEnemy, its generation, last known map px, landing game s, damage].
var _stars: Array = []


func cast(pos: Vector2) -> bool:
	var foes := game.foes_near(pos, float(row["radius"]))  # Candidates.
	if foes.is_empty():
		return false
	foes.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return a.hp > b.hp)
	var land := game.time + float(row["fall_time"])  # Landing (game s).
	_stars.append([foes[0], foes[0].generation, foes[0].position, land, float(row["damage"])])
	var second := float(CharacterModifiers.innate("grace_second", 0.0))  # Second star's share (0 = none).
	if second > 0.0 and foes.size() > 1:
		_stars.append([foes[1], foes[1].generation, foes[1].position, land, float(row["damage"]) * second])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_stars.size() - 1, -1, -1):
		var s: Array = _stars[i]
		var e: TdEnemy = s[0]
		if TdEnemy.valid(e, int(s[1])):
			s[2] = e.position
		if game.time < float(s[3]):
			continue
		_stars.remove_at(i)
		var at: Vector2 = s[2]
		if TdEnemy.valid(e, int(s[1])):
			TdCombat.damage_enemy(game, e, float(s[4]), {"source": id, "origin": at})
		for o: TdEnemy in game.foes_near(at, float(row["crash"])):
			if o != e:
				TdCombat.damage_enemy(game, o, float(s[4]) * float(row["splash"]), {"source": id, "origin": at})
		game.stats["grace_stars"] = int(game.stats.get("grace_stars", 0)) + 1
		if game.vfx.on:
			var tint: Color = TdVfxData.SPELLS[id]["tint"]
			game.vfx.add(TdVfx.Kind.ANIM, at, float(Acts.data("inferno")["LOOK"]["star_d"]), TdVfxData.IMPACT_TIME * 1.4, tint, "holy_impact")
			var ring := game.vfx.add(TdVfx.Kind.RING, at, float(row["crash"]), TdVfxData.RING_TIME, tint)
			if ring != null:
				ring.size0 = float(row["crash"]) * 0.3
			game.vfx.shake(2.5)


func draw(ci: CanvasItem) -> void:
	var lk: Dictionary = Acts.data("inferno")["LOOK"]
	var lift := float(lk["fall_lift"])  # Px the star starts above.
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	for s: Array in _stars:
		var k := 1.0 - clampf((float(s[3]) - game.time) / float(row["fall_time"]), 0.0, 1.0)  # 0..1 through the fall.
		var at: Vector2 = s[2]
		var p := at - Vector2(-lift * 0.3, lift) * (1.0 - k)  # The star streaking down at a slant.
		var g := float(lk["star_glow"])  # Glow radius (px).
		ci.draw_texture_rect(TdVfx._soft(), Rect2(p - Vector2(g, g), Vector2(g, g) * 2.0), false, Color(tint, 0.9))
		SpriteBank.draw_disc(ci, p, float(lk["star_core"]), Color(1.0, 1.0, 0.9, 1.0))


func busy() -> bool:
	return not _stars.is_empty()
