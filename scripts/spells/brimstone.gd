## Brimstone (Act IX spell, Moloch's reward; Necropathy's Brimstone, "burning
## stones fall on the thickest crowd and leave fire where they land"):
## `stones` stones (+ the Furnace Priest's innate "brimstone_stones") fall on
## the foes within `radius` px of the tap with the most foes around them
## (one stone per pick, the densest first), `fall_time` s later: `damage` to
## every foe within `blast` px, then a fire field burns there (`field_radius`
## px, `field_life` s, `field_dps` per s, ticking every `field_tick` s; TdProjectiles.add_field, "flame").
## Cast on a portal (within RULE spell_seal_radius) it SEALS it (the Portals
## act rule's seal_near()). Row: SpellData "brimstone".
extends TdSpell

## Falling stones: [map px, landing game s].
var _stones: Array = []


func cast(pos: Vector2) -> bool:
	var sealed := 0  # Portals sealed by this cast.
	if game.act_rule != null and game.act_rule.has_method("seal_near"):
		sealed = int(game.act_rule.call("seal_near", pos, float(Acts.data("inferno")["RULE"]["spell_seal_radius"])))
	var foes := game.foes_near(pos, float(row["radius"]))  # Candidates.
	if foes.is_empty() and sealed == 0:
		return false
	var n := int(row["stones"]) + int(CharacterModifiers.innate("brimstone_stones", 0))  # Stones this cast.
	var blast := float(row["blast"])  # Px.
	foes.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return game.foes_near(a.position, blast).size() > game.foes_near(b.position, blast).size())
	for i in n:
		var at: Vector2 = foes[i % foes.size()].position if not foes.is_empty() else pos  # Where it falls.
		_stones.append([at, game.time + float(row["fall_time"])])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_stones.size() - 1, -1, -1):
		var s: Array = _stones[i]
		if game.time < float(s[1]):
			continue
		_stones.remove_at(i)
		var at: Vector2 = s[0]
		for e: TdEnemy in game.foes_near(at, float(row["blast"])):
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": at})
		game.projectiles.add_field(at, float(row["field_radius"]), float(row["field_life"]), float(row["field_tick"]), float(row["field_dps"]) * float(row["field_tick"]), id, null, "flame")
		game.stats["brimstone_stones"] = int(game.stats.get("brimstone_stones", 0)) + 1
		if game.vfx.on:
			var tint: Color = TdVfxData.SPELLS[id]["tint"]
			game.vfx.add(TdVfx.Kind.ANIM, at, float(Acts.data("inferno")["LOOK"]["stone_d"]), TdVfxData.IMPACT_TIME * 1.4, tint, "corpse_explosion")
			game.vfx.add(TdVfx.Kind.CRACK, at, 1.0, TdVfxData.CRACK_TIME, Color.WHITE)


func draw(ci: CanvasItem) -> void:
	var tg := SpriteBank.texture("telegraphs/target")  # Landing circle.
	var lift := float(Acts.data("inferno")["LOOK"]["fall_lift"])  # Px the stone starts above.
	var b := float(row["blast"])
	for s: Array in _stones:
		var k := 1.0 - clampf((float(s[1]) - game.time) / float(row["fall_time"]), 0.0, 1.0)  # 0..1 through the fall.
		var at: Vector2 = s[0]
		if tg != null:
			ci.draw_texture_rect(tg, Rect2(at - Vector2(b, b), Vector2(b, b) * 2.0), false, Color(TdVfxData.SPELLS[id]["tint"], 0.4 + 0.5 * k))
		SpriteBank.draw_flat(ci, "projectiles/corpse_boulder_burning", at - Vector2(0, lift * (1.0 - k)), PI * 0.5, Color.WHITE, 1.4)


func busy() -> bool:
	return not _stones.is_empty()
