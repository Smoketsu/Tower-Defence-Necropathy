## Meteor Call (Act XIV spell, Old Gravejaw's reward; Necropathy's Meteor
## Call, "a telegraphed meteor falls on the densest group"): a circle of
## `radius` px (the Skywatcher's innate widens it by `meteor_radius`) shows at
## the tap for `delay` s, then the meteor lands: every foe inside takes
## `damage` and is frozen `stun` s (rank multipliers apply). Only the
## necromancer's foes are struck. Row: SpellData "meteor_call".
extends TdSpell

## Falling meteors: [map px, radius px, landing game s].
var _falls: Array = []


func cast(pos: Vector2) -> bool:
	var rad := float(row["radius"]) * (1.0 + float(CharacterModifiers.innate("meteor_radius", 0.0)))
	_falls.append([pos, rad, game.time + float(row["delay"])])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_falls.size() - 1, -1, -1):
		var f: Array = _falls[i]
		if game.time < float(f[2]):
			continue
		_falls.remove_at(i)
		for e: TdEnemy in game.foes_near(f[0], float(f[1])):
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": f[0]})
			if e.alive:
				TdCombat.freeze_enemy(game, e, float(row["stun"]))
			game.stats["meteor_call_hits"] = int(game.stats.get("meteor_call_hits", 0)) + 1
		if game.vfx.on:
			var tint: Color = TdVfxData.SPELLS[id]["tint"]
			game.vfx.add(TdVfx.Kind.ANIM, f[0], float(f[1]) * 2.2, TdVfxData.IMPACT_TIME * 1.4, Color.WHITE, "corpse_explosion")
			var ring := game.vfx.add(TdVfx.Kind.RING, f[0], float(f[1]), TdVfxData.RING_TIME, tint)
			if ring != null:
				ring.size0 = float(f[1]) * 0.3
			game.vfx.add(TdVfx.Kind.CRACK, f[0], 1.0, TdVfxData.CRACK_TIME, Color.WHITE)
			game.vfx.shake(3.0)
		Sfx.play("bomb_land")


func draw(ci: CanvasItem) -> void:
	var bomb := SpriteBank.texture("markers/primeval_bomb")  # Landing ring art.
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	for f: Array in _falls:
		var k := 1.0 - clampf((float(f[2]) - game.time) / float(row["delay"]), 0.0, 1.0)  # 0..1 through the fall.
		var rad := float(f[1])
		var c: Vector2 = f[0]
		ci.draw_texture_rect(TdVfx._soft(), Rect2(c - Vector2(rad, rad * 0.7), Vector2(rad, rad * 0.7) * 2.0), false, Color(tint, 0.2 + 0.3 * k))
		if bomb != null:
			ci.draw_texture_rect(bomb, Rect2(c - Vector2(rad, rad), Vector2(rad, rad) * 2.0), false, Color(1, 1, 1, 0.6 + 0.4 * k))
		var p := c + Vector2(90.0, -240.0) * (1.0 - k)  # The rock falling in from the upper right.
		ci.draw_texture_rect(TdVfx._soft(), Rect2(p - Vector2(20, 20), Vector2(40, 40)), false, Color(1.0, 0.7, 0.35, 0.95))
		SpriteBank.draw_disc(ci, p, 7.0, Color(1.0, 0.95, 0.8, 1.0))


func busy() -> bool:
	return not _falls.is_empty()
