## Soul Caster (Act XIII spell, Vrask'Tal's reward; Necropathy's Soul Caster,
## "a shoulder cannon that locks three targets with three dots and fires"):
## locks the `targets` strongest foes (most HP; + the Blooded's caster_extra)
## within `radius` px of the tap, its soul-teal dots showing `lock_time` s, then
## fires one shot at each: `damage` (armour pierce `armour_pierce`) through
## TdCombat.damage_enemy (source "soul_caster"; a spell hit reveals a cloaked
## Vrask, cloak.gd). Row: SpellData "soul_caster".
extends TdSpell

## Locks: [TdEnemy, its generation, game s it fires, fired (bool)].
var _locks: Array = []


func cast(pos: Vector2) -> bool:
	var foes := game.foes_near(pos, float(row["radius"]))  # Candidates.
	if foes.is_empty():
		return false
	foes.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return a.hp > b.hp)
	var n := int(row["targets"]) + int(CharacterModifiers.innate("caster_extra", 0))  # Locks this cast.
	for i in mini(n, foes.size()):
		_locks.append([foes[i], foes[i].generation, game.time + float(row["lock_time"]), false])
	Sfx.play("beam_charge")
	return true


func step(_dt: float) -> void:
	for i in range(_locks.size() - 1, -1, -1):
		var l: Array = _locks[i]
		var e: TdEnemy = l[0]
		if not TdEnemy.valid(e, int(l[1])):
			_locks.remove_at(i)
			continue
		if game.time >= float(l[2]):
			_locks.remove_at(i)
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": game.necromancer_pos(), "armour_pierce": float(row["armour_pierce"])})
			game.stats["caster_shots"] = int(game.stats.get("caster_shots", 0)) + 1
			if game.vfx.on:
				var tint: Color = Acts.data("concord")["LOOK"]["lock_tint"]
				var from := game.necromancer_pos()
				var f := game.vfx.add(TdVfx.Kind.STREAK, e.position, 10.0, 0.3, tint)
				if f != null:
					f.ang = (e.position - from).angle()
					f.size0 = minf(from.distance_to(e.position), 260.0)
				game.vfx.add(TdVfx.Kind.ANIM, e.position, 70.0, 0.35, tint, "beam_hit")
			Sfx.play(String(TdSoundData.CAST.get(id, "")))


func draw(ci: CanvasItem) -> void:
	var lk: Dictionary = Acts.data("concord")["LOOK"]
	var px := float(lk["lock_px"])  # Dot size.
	for l: Array in _locks:
		var e: TdEnemy = l[0]
		if not TdEnemy.valid(e, int(l[1])):
			continue
		for k in 3:  # Three dots in a triangle on the foe (the Vrask's lock, in soul-teal).
			var p := e.position + Vector2.from_angle(TAU * float(k) / 3.0 - PI * 0.5 + game.time * 3.0) * (e.radius + 4.0)
			ci.draw_texture_rect(TdVfx._soft(), Rect2(p - Vector2(px, px) * 0.5, Vector2(px, px)), false, lk["lock_tint"])


func busy() -> bool:
	return not _locks.is_empty()
