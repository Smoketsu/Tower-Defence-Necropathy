## Anchor Drop (the Black Tide; Necropathy AnchorDrop, owner-approved "a
## spectral anchor slams the strongest enemy, stuns it and shocks a ring around
## it (no pull)"): the strongest foe (most HP) within `pick_radius` px of the
## tap (+ the next strongest for the Ghost Helmsman's Second Anchor, innate
## "anchor_extra") is marked; the anchor falls `fall` s and lands: `damage` to
## it, a stun of `stun` s (TdCombat.freeze_enemy: rank multipliers apply) and
## `shock` x the damage to every other foe within `shock_radius` px. Nothing is
## moved. No foe in reach = no cast. Row: SpellData "anchor_drop".
extends TdSpell

## Falling anchors: [target TdEnemy, its generation, last map px, landing game s, cast game s].
var _anchors: Array = []


func cast(pos: Vector2) -> bool:
	var cands := game.foes_near(pos, float(row["pick_radius"]))  # Foes in reach.
	if cands.is_empty():
		return false
	cands.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return a.hp > b.hp or (a.hp == b.hp and game.progress(a) > game.progress(b)))
	var n := mini(1 + int(CharacterModifiers.innate("anchor_extra", 0)), cands.size())  # Anchors this cast.
	for i in n:
		var e: TdEnemy = cands[i]
		_anchors.append([e, e.generation, e.position, game.time + float(row["fall"]), game.time])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_anchors.size() - 1, -1, -1):
		var a: Array = _anchors[i]
		var e: TdEnemy = a[0]
		var live := TdEnemy.valid(e, int(a[1]))  # Its target still stands.
		if live:
			a[2] = e.position
		if game.time < float(a[3]):
			continue
		_anchors.remove_at(i)
		var at: Vector2 = a[2]
		var dmg := float(row["damage"])  # The slam.
		if live:
			TdCombat.damage_enemy(game, e, dmg, {"source": id, "origin": at})
			if e.alive:
				TdCombat.freeze_enemy(game, e, float(row["stun"]))
		for o: TdEnemy in game.foes_near(at, float(row["shock_radius"])):
			if o != e:
				TdCombat.damage_enemy(game, o, dmg * float(row["shock"]), {"source": id, "origin": at})
		if game.vfx.on:
			var tint: Color = TdVfxData.SPELLS[id]["tint"]
			var r := float(row["shock_radius"])  # The shock's REAL radius.
			game.vfx.add(TdVfx.Kind.ANIM, at, r * 2.4, TdVfxData.IMPACT_TIME * 1.5, Color.WHITE, "tide_splash")
			var ring := game.vfx.add(TdVfx.Kind.RING, at, r, TdVfxData.RING_TIME, tint)
			if ring != null:
				ring.size0 = r * 0.25
			game.vfx.add(TdVfx.Kind.CRACK, at, 1.0, TdVfxData.CRACK_TIME, Color.WHITE)
			game.vfx.shake(3.0)


func draw(ci: CanvasItem) -> void:
	for a: Array in _anchors:
		var at: Vector2 = a[2]
		var p := clampf((game.time - float(a[4])) / maxf(float(a[3]) - float(a[4]), 0.01), 0.0, 1.0)  # 0..1 to landing.
		SpriteBank.draw_flat(ci, "projectiles/harbour_anchor", at + Vector2(0, -TdVfxData.TIDE_FALL_H * (1.0 - p) - 14.0), 0.0, TdVfxData.TIDE_BALL_TINT, TdVfxData.TIDE_ANCHOR_SCALE)


func busy() -> bool:
	return not _anchors.is_empty()
