## Tractor Beam (Act XIII spell, the Harvester's reward; Necropathy's Tractor
## Beam, "lifts the strongest enemy into the air and slams it down"): lifts the
## `lifts` strongest foes (+ the Starborn's tractor_extra) within `radius` px
## of the tap: frozen in a column of light `lift_time` s (TdCombat.freeze_enemy,
## rank multipliers apply), then slammed down: `slam_damage` to it and to every
## foe within `slam_radius` px (source "tractor_lift"). Row: SpellData "tractor_lift".
extends TdSpell

## Lifts: [TdEnemy, its generation, game s cast, game s it slams].
var _lifts: Array = []


func cast(pos: Vector2) -> bool:
	var foes := game.foes_near(pos, float(row["radius"]))  # Candidates.
	if foes.is_empty():
		return false
	foes.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return a.hp > b.hp)
	var n := int(row["lifts"]) + int(CharacterModifiers.innate("tractor_extra", 0))  # Foes lifted.
	for i in mini(n, foes.size()):
		var e := foes[i]
		TdCombat.freeze_enemy(game, e, float(row["lift_time"]))
		_lifts.append([e, e.generation, game.time, e.freeze_until])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	Sfx.play("tractor_beam")
	return true


func step(_dt: float) -> void:
	for i in range(_lifts.size() - 1, -1, -1):
		var l: Array = _lifts[i]
		var e: TdEnemy = l[0]
		if not TdEnemy.valid(e, int(l[1])):
			_lifts.remove_at(i)
			continue
		if game.time < float(l[3]):
			continue
		_lifts.remove_at(i)
		var at := e.position
		for o: TdEnemy in game.foes_near(at, float(row["slam_radius"])):
			TdCombat.damage_enemy(game, o, float(row["slam_damage"]), {"source": id, "origin": at})
		game.stats["tractor_slams"] = int(game.stats.get("tractor_slams", 0)) + 1
		if game.vfx.on:
			var tint: Color = TdVfxData.SPELLS[id]["tint"]
			game.vfx.add(TdVfx.Kind.ANIM, at, float(row["slam_radius"]) * 2.0, 0.45, tint, "golem_slam")
			var ring := game.vfx.add(TdVfx.Kind.RING, at, float(row["slam_radius"]), TdVfxData.RING_TIME, tint)
			if ring != null:
				ring.size0 = float(row["slam_radius"]) * TdVfxData.RING_FROM
			game.vfx.shake(2.0)


func draw(ci: CanvasItem) -> void:
	var tint: Color = Acts.data("concord")["LOOK"]["tractor_tint"]
	var streak := TdArt.texture("vfx_streak")
	for l: Array in _lifts:
		var e: TdEnemy = l[0]
		if not TdEnemy.valid(e, int(l[1])) or streak == null:
			continue
		var k := 0.7 + 0.3 * sin(game.time * 9.0)
		ci.draw_set_transform(e.position + Vector2(0, 10), -PI * 0.5, Vector2.ONE)
		ci.draw_texture_rect(streak, Rect2(-130.0, -22.0, 140.0, 44.0), false, Color(tint, 0.6 * k))
		ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		ci.draw_texture_rect(TdVfx._soft(), Rect2(e.position + Vector2(-30, 0), Vector2(60, 24)), false, Color(tint, 0.5))


func busy() -> bool:
	return not _lifts.is_empty()
