## Chain Shot (the Black Tide; Necropathy ChainShot / Keelhauler: spectral
## chain-shot that flies out and spins back): cast on the road nearest the tap
## (within `max_snap` px). `shots` chain-shots (+ the Marooned Quartermaster's
## Spare Shot, innate "shot_extra"), `stagger` s apart, rake `length` px of that
## road back toward its entrance at `speed` px/s and return: every foe within
## `width` px of a shot is struck once each way for `damage`, and on the way
## out knocked `knock` px back down the road (TdCombat.knock_enemy). Row:
## SpellData "chain_shot".
extends TdSpell

## Shots: {"road": Road, "from": px along it, "to": px it turns at, "d": px now,
## "back": bool, "start": game s it leaves, "hit": {TdEnemy: generation} of this pass}.
var _shots: Array[Dictionary] = []


func cast(pos: Vector2) -> bool:
	var road := game.nearest_road(pos, float(row["max_snap"]))  # The raked road.
	if road == null:
		return false
	var d0 := road.project(pos)  # Where the shots turn back from.
	var n := int(row["shots"]) + int(CharacterModifiers.innate("shot_extra", 0))  # Shots this cast.
	for i in n:
		_shots.append({"road": road, "from": d0, "to": maxf(d0 - float(row["length"]), 0.0), "d": d0, "back": false,
			"start": game.time + float(i) * float(row["stagger"]), "hit": {}})
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(dt: float) -> void:
	for i in range(_shots.size() - 1, -1, -1):
		var s: Dictionary = _shots[i]
		if game.time < float(s["start"]):
			continue
		var r: Road = s["road"]
		var move := float(row["speed"]) * dt  # Px this step.
		if not bool(s["back"]):
			s["d"] = maxf(float(s["d"]) - move, float(s["to"]))
		else:
			s["d"] = minf(float(s["d"]) + move, float(s["from"]))
		var at := r.point_at(float(s["d"]))  # The shot now.
		var hit: Dictionary = s["hit"]
		for e: TdEnemy in game.foes_near(at, float(row["width"]) + 10.0):
			if hit.has(e) and int(hit[e]) == e.generation:
				continue
			hit[e] = e.generation
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": at})
			if e.alive and not bool(s["back"]):
				TdCombat.knock_enemy(game, e, float(row["knock"]))
			if game.vfx.on:
				game.vfx.add(TdVfx.Kind.ANIM, e.position + Vector2(0, -10), TdVfxData.TIDE_CHAIN_HIT_D, TdVfxData.IMPACT_TIME, TdVfxData.SPELLS[id]["tint"], "volley_hit")
		if not bool(s["back"]) and float(s["d"]) <= float(s["to"]):
			s["back"] = true
			s["hit"] = {}
		elif bool(s["back"]) and float(s["d"]) >= float(s["from"]):
			_shots.remove_at(i)


func draw(ci: CanvasItem) -> void:
	var streak := TdArt.texture("vfx_streak")  # Chain / trail mask.
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	for s: Dictionary in _shots:
		if game.time < float(s["start"]):
			continue
		var r: Road = s["road"]
		var d := float(s["d"])
		var at := r.point_at(d)  # The shot now.
		var dir := r.dir_at(d) * (1.0 if bool(s["back"]) else -1.0)  # Flight direction.
		var spin := game.time * TdVfxData.TIDE_CHAIN_SPIN  # The two balls whirl round each other (drawn only).
		var arm := Vector2(cos(spin), sin(spin)) * TdVfxData.TIDE_CHAIN_ARM  # Half the chain.
		if streak != null:
			if not TdVfx.reduced():
				TdVfx.draw_streak(ci, streak, at, dir.angle(), TdVfxData.TIDE_CHAIN_TRAIL, TdVfxData.TIDE_CHAIN_TRAIL_W, Color(tint, 0.6))
			TdVfx.draw_streak(ci, streak, at + arm, (-arm).angle(), TdVfxData.TIDE_CHAIN_ARM * 2.0, TdVfxData.TIDE_CHAIN_LINK_W, tint)
		SpriteBank.draw_flat(ci, "projectiles/iron_shell", at + arm, spin, TdVfxData.TIDE_BALL_TINT, TdVfxData.TIDE_BALL_SCALE)
		SpriteBank.draw_flat(ci, "projectiles/iron_shell", at - arm, spin, TdVfxData.TIDE_BALL_TINT, TdVfxData.TIDE_BALL_SCALE)


func busy() -> bool:
	return not _shots.is_empty()
