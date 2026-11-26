## Valkyrie Spear (Act VI spell, Sigrun's reward; Necropathy's ValkyrieSpear, "a
## spectral spear dives on the strongest enemy and chains to the next"): a
## spear falls on the foe with the most HP within `range` px of the tap for
## `damage`, then leaps `jumps` times (+ the Shield-Maiden's `spear_jumps`) to
## the nearest foe it has not struck within `chain` px, `gap` s apart, each
## strike x `falloff` of the last (TdCombat). No foe in range: nothing happens
## (no cooldown). Row: SpellData "valkyrie_spear".
extends TdSpell

## Strikes waiting: [game s it lands, TdEnemy, generation, damage, leaps left, from map px, struck Array].
var _queue: Array = []


func cast(pos: Vector2) -> bool:
	var best: TdEnemy = null  # Strongest foe in range.
	for e: TdEnemy in game.foes_near(pos, float(row["range"])):
		if best == null or e.hp > best.hp:
			best = e
	if best == null:
		return false
	var leaps := roundi(float(row["jumps"])) + int(CharacterModifiers.innate("spear_jumps", 0))  # Leaps this cast.
	_queue.append([game.time, best, best.generation, float(row["damage"]), leaps, best.position + Vector2(0, -160), []])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_queue.size() - 1, -1, -1):
		var q: Array = _queue[i]
		if game.time < float(q[0]):
			continue
		_queue.remove_at(i)
		var e: TdEnemy = q[1]
		if not TdEnemy.valid(e, int(q[2])):
			continue
		var at := e.position  # Where it strikes.
		var struck: Array = q[6]
		struck.append(e)
		TdCombat.damage_enemy(game, e, float(q[3]), {"source": id, "origin": q[5]})
		game.stats["valkyrie_strikes"] = int(game.stats.get("valkyrie_strikes", 0)) + 1
		if game.vfx.on:
			var lk: Dictionary = Acts.data("norse")["LOOK"]
			var f := game.vfx.add(TdVfx.Kind.STREAK, (at + Vector2(q[5])) * 0.5, float(lk["spear_w"]), 0.25, lk["valk_tint"])
			if f != null:
				f.ang = (at - Vector2(q[5])).angle()
				f.size0 = at.distance_to(q[5])
			game.vfx.add(TdVfx.Kind.ANIM, at, 70.0, TdVfxData.IMPACT_TIME, lk["valk_tint"], "volley_flash")
		if int(q[4]) <= 0:
			continue
		var nxt: TdEnemy = null  # Nearest foe not struck yet.
		for o: TdEnemy in game.foes_near(at, float(row["chain"])):
			if not struck.has(o) and (nxt == null or o.position.distance_squared_to(at) < nxt.position.distance_squared_to(at)):
				nxt = o
		if nxt != null:
			_queue.append([game.time + float(row["gap"]), nxt, nxt.generation, float(q[3]) * float(row["falloff"]), int(q[4]) - 1, at, struck])


func busy() -> bool:
	return not _queue.is_empty()
