## Forbidden Verse (Act XI spell, the Archivist's reward; Necropathy's
## Forbidden Verse, "pages cut every enemy they pass and inscribe it; an
## inscribed enemy that dies bursts into ink"): pages sweep round the tap:
## every foe within `radius` px takes `damage` and is INSCRIBED for `inscribe`
## s (vars "k_inscribed_until", written only here). An inscribed foe that dies,
## to anything, bursts into ink on the next step (never inside the kill):
## `burst` x `damage` to every foe within `burst_radius` px (+ the Heretic
## Scribe's innate verse_burst_radius). A burst never sets off another.
## Row: SpellData "forbidden_verse".
extends TdSpell

## Ink bursts waiting for the next step: map px.
var _queued: Array[Vector2] = []
## Page sweeps drawn: [map px, game s cast].
var _sweeps: Array = []
## Bursts drawn: [map px, game s].
var _bursts: Array = []
## True once the kill listener is connected.
var _listening: bool = false


func cast(pos: Vector2) -> bool:
	var foes := game.foes_near(pos, float(row["radius"]))  # Who the pages cut.
	if foes.is_empty():
		return false
	if not _listening:
		game.enemy_killed.connect(_on_kill)
		_listening = true
	for e: TdEnemy in foes:
		e.vars["k_inscribed_until"] = game.time + float(row["inscribe"])
		TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": pos})
	game.stats["verse_cut"] = int(game.stats.get("verse_cut", 0)) + foes.size()
	_sweeps.append([pos, game.time])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


## TdGame.enemy_killed: an inscribed foe queues its burst.
func _on_kill(e: TdEnemy, _tower: Tower) -> void:
	if game.time < float(e.vars.get("k_inscribed_until", 0.0)):
		_queued.append(e.position)


func step(_dt: float) -> void:
	var q := _queued.duplicate()  # Bursts of the last step (their kills queue the next ones, never chaining here).
	_queued.clear()
	var r := float(row["burst_radius"]) + float(CharacterModifiers.innate("verse_burst_radius", 0.0))  # Px.
	for p: Vector2 in q:
		for e: TdEnemy in game.foes_near(p, r):
			e.vars.erase("k_inscribed_until")  # A burst never sets off another.
			TdCombat.damage_enemy(game, e, float(row["damage"]) * float(row["burst"]), {"source": "ink_burst", "origin": p})
		game.stats["ink_bursts"] = int(game.stats.get("ink_bursts", 0)) + 1
		game.fx.spawn("ink_burst", p, r * 2.0, 0.45, TdVfxData.SPELLS[id]["tint"])
		_bursts.append([p, game.time])
	for arr: Array in [_sweeps, _bursts]:
		for i in range(arr.size() - 1, -1, -1):
			if game.time > float(arr[i][1]) + 0.6:
				arr.remove_at(i)


func draw(ci: CanvasItem) -> void:
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	var px := float(Acts.data("eye")["LOOK"]["page_px"])
	var r := float(row["radius"])
	for s: Array in _sweeps:
		var f := clampf((game.time - float(s[1])) / 0.6, 0.0, 1.0)  # 0..1 through the sweep.
		for k in 6:
			var ang := f * TAU + float(k) * TAU / 6.0  # Each page's angle.
			var p: Vector2 = s[0] + Vector2.from_angle(ang) * r * (0.4 + 0.6 * f)
			if not SpriteBank.draw_flat(ci, "projectiles/archive_page", p, ang, Color(1, 1, 1, 1.0 - f * 0.5), 1.6):
				SpriteBank.draw_disc(ci, p, px * 0.4, tint)
	for b: Array in _bursts:
		var f := clampf((game.time - float(b[1])) / 0.6, 0.0, 1.0)
		ci.draw_texture_rect(TdVfx._soft(), Rect2(Vector2(b[0]) - Vector2(30, 30), Vector2(60, 60)), false, Color(tint, 0.5 * (1.0 - f)))


func busy() -> bool:
	return not _sweeps.is_empty() or not _bursts.is_empty() or not _queued.is_empty()
