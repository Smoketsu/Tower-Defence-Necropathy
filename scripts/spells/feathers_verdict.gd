## Feather's Verdict (Act VII spell, Osiris' reward; Necropathy's Feather's
## Verdict: "a gold feather lands on the strongest enemy and executes weak
## enemies in a ring around it"): a gold feather falls on the foe with the most
## HP within `radius` px of the tap; after `fall_time` s it lands: `damage` to
## that foe, then every OTHER foe within `ring` px at or under `execute` of its
## max HP (+ the Pharaoh's Shade's innate "verdict_line") is executed (TdCombat,
## a kill through its armour). Bosses, minibosses and structures are struck,
## never executed. Row: SpellData "feathers_verdict".
extends TdSpell

## Falling feathers: [TdEnemy, generation, land game s, last known map px].
var _feathers: Array = []
## Landing rings to draw: [map px, end game s] (drawn only).
var _rings: Array = []


func cast(pos: Vector2) -> bool:
	var best: TdEnemy = null  # The strongest foe in reach.
	for e: TdEnemy in game.foes_near(pos, float(row["radius"])):
		if best == null or e.hp > best.hp:
			best = e
	if best == null:
		return false
	_feathers.append([best, best.generation, game.time + float(row["fall_time"]), best.position])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_feathers.size() - 1, -1, -1):
		var f: Array = _feathers[i]
		var e: TdEnemy = f[0]
		if TdEnemy.valid(e, int(f[1])):
			f[3] = e.position
		if game.time < float(f[2]):
			continue
		_feathers.remove_at(i)
		var at: Vector2 = f[3]
		if TdEnemy.valid(e, int(f[1])):
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": at})
		var line := float(row["execute"]) + float(CharacterModifiers.innate("verdict_line", 0.0))  # Execute line (share of max HP).
		for o: TdEnemy in game.foes_near(at, float(row["ring"])):
			if o == e or String(o.row["rank"]) in ["boss", "miniboss"] or o.hp > o.max_hp * line:
				continue
			TdCombat.damage_enemy(game, o, o.hp + o.armour + 1.0, {"source": id, "origin": at, "armour_pierce": o.armour})
			game.stats["verdict_executions"] = int(game.stats.get("verdict_executions", 0)) + 1
		_rings.append([at, game.time + 0.5])
		if game.vfx.on:
			game.vfx.add(TdVfx.Kind.ANIM, at, float(row["ring"]) * 2.0, 0.5, TdVfxData.SPELLS[id]["tint"], "holy_impact")
			var ring := game.vfx.add(TdVfx.Kind.RING, at, float(row["ring"]), TdVfxData.RING_TIME, TdVfxData.SPELLS[id]["tint"])
			if ring != null:
				ring.size0 = 10.0
	_rings = _rings.filter(func(r: Array) -> bool: return game.time < float(r[1]))


func draw(ci: CanvasItem) -> void:
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	var lift := float(Acts.data("dynasty")["LOOK"]["feather_lift"])  # Px it falls from.
	for f: Array in _feathers:
		var left := clampf((float(f[2]) - game.time) / float(row["fall_time"]), 0.0, 1.0)  # 1 -> 0 as it falls.
		var p: Vector2 = Vector2(f[3]) + Vector2(sin(left * 9.0) * 10.0 * left, -lift * left)
		SpriteBank.draw_flat(ci, "projectiles/seraph_feather", p, PI * 0.5 + sin(left * 9.0) * 0.5, tint, 2.0)
		ci.draw_texture_rect(TdVfx._soft(), Rect2(Vector2(f[3]) - Vector2(20, 8), Vector2(40, 16)), false, Color(tint, 0.5 * (1.0 - left)))


func busy() -> bool:
	return not _feathers.is_empty() or not _rings.is_empty()
