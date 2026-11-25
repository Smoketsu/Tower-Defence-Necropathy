## Moonfang (Act III, Ravensmoor's spell; Necropathy Moonfang: "spectral wolf
## jaws snap at the nearest group and leave bleeds"): the enemy nearest the tap
## (within `pick_radius` px) is the first pack; up to `jaws` - 1 more packs
## (+ the Moon-Cursed Huntress's innate "moonfang_jaws") are the enemies within
## `jaw_reach` px of the tap closest to the gate that stand `jaw_gap` px from
## every pack already picked. After `snap_time` s every jaw closes: each enemy
## within `jaw_radius` px of its pack takes `damage` and bleeds `bleed_dps` per s
## for `bleed_time` s (TdCombat.add_dot). Row: SpellData "moonfang".
extends TdSpell

## Jaws closing: [map px, game s they close].
var _jaws: Array = []


func cast(pos: Vector2) -> bool:
	var foes := game.foes_near(pos, float(row["jaw_reach"]))  # Candidates.
	var first: TdEnemy = null  # Nearest to the tap.
	for e: TdEnemy in foes:
		if e.position.distance_to(pos) <= float(row["pick_radius"]) and (first == null or e.position.distance_squared_to(pos) < first.position.distance_squared_to(pos)):
			first = e
	if first == null:
		return false
	var packs: Array[Vector2] = [first.position]  # Jaw centres.
	foes.sort_custom(func(x: TdEnemy, y: TdEnemy) -> bool: return game.progress(x) > game.progress(y))
	var n := int(row["jaws"]) + int(CharacterModifiers.innate("moonfang_jaws", 0))  # Jaws wanted.
	for e: TdEnemy in foes:
		if packs.size() >= n:
			break
		if packs.all(func(p: Vector2) -> bool: return p.distance_to(e.position) >= float(row["jaw_gap"])):
			packs.append(e.position)
	var at := game.time + float(row["snap_time"])  # When they close.
	for p: Vector2 in packs:
		_jaws.append([p, at])
		if game.vfx.on:
			game.vfx.add(TdVfx.Kind.ANIM, p + Vector2(0, -8), float(row["jaw_radius"]) * TdVfxData.COURT_JAW_D, 0.4, Color.WHITE, "vael_cleave", float(row["snap_time"]))
			var r := game.vfx.add(TdVfx.Kind.RING, p, float(row["jaw_radius"]), float(row["snap_time"]), TdVfxData.SPELLS[id]["tint"])
			if r != null:
				r.size0 = float(row["jaw_radius"]) * 2.0  # The jaws close in to their real bite radius.
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_jaws.size() - 1, -1, -1):
		if game.time < float(_jaws[i][1]):
			continue
		var p: Vector2 = _jaws[i][0]
		_jaws.remove_at(i)
		var bit := 0  # Enemies bitten.
		for e: TdEnemy in game.foes_near(p, float(row["jaw_radius"])):
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": p})
			if e.alive:
				TdCombat.add_dot(game, e, float(row["bleed_dps"]), float(row["bleed_time"]), id)
			bit += 1
		game.stats["moonfang_bites"] = int(game.stats.get("moonfang_bites", 0)) + bit
