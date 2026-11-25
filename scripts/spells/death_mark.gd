## Death Mark (GDD §5 "Later"): brands the enemy nearest the tap (within
## `pick_radius` px): a damage over time of `dps` for `duration` s (TdCombat.add_dot,
## source "death_mark"). An enemy that dies while branded raises a temporary
## Risen blocker where it fell (TempBlockers: `risen_hp`, holds `risen_hold`,
## `risen_damage` every `risen_interval` s, `risen_time` s; at most `risen_max`
## standing). The Doomsayer's Ill Omen also slows the branded foe
## (CharacterModifiers innate "brand_slow"). Row: SpellData "death_mark".
extends TdSpell

## Brands: [TdEnemy, its generation, end game s].
var _brands: Array = []
## Its Risen.
var _risen: TempBlockers = null
## True once it listens to TdGame.enemy_killed.
var _listening: bool = false


func cast(pos: Vector2) -> bool:
	var best: TdEnemy = null  # Nearest enemy to the tap.
	for e: TdEnemy in game.foes_near(pos, float(row["pick_radius"])):
		if best == null or e.position.distance_squared_to(pos) < best.position.distance_squared_to(pos):
			best = e
	if best == null:
		return false
	_listen()
	var dur := float(row["duration"])  # Brand length (s).
	TdCombat.add_dot(game, best, float(row["dps"]), dur, id)
	var slow := float(CharacterModifiers.innate("brand_slow", 1.0))  # Ill Omen.
	if slow < 1.0:
		TdCombat.slow_enemy(game, best, slow, dur)
	_brands.append([best, best.generation, game.time + dur])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	if game.vfx.on:
		var f := game.vfx.add(TdVfx.Kind.THREAD, game.necromancer_pos() + Vector2(0, -24), TdVfxData.KIT_CHAIN_W, 0.35, TdVfxData.SPELLS[id]["tint"])
		if f != null:
			f.to = best.position + Vector2(0, -12)
	return true


func _listen() -> void:
	if _listening:
		return
	_listening = true
	_risen = TempBlockers.new(game)
	game.enemy_killed.connect(_on_kill)


## TdGame.enemy_killed: a branded death raises a Risen (not bosses or structures).
func _on_kill(e: TdEnemy, _tower: Tower) -> void:
	for i in range(_brands.size() - 1, -1, -1):
		var b: Array = _brands[i]
		if b[0] != e or int(b[1]) != e.generation:
			continue
		_brands.remove_at(i)
		if game.time >= float(b[2]) or String(e.row["rank"]) == "boss" or bool(e.row.get("structure", false)):
			return
		if _risen.standing() >= int(row["risen_max"]):
			return
		_risen.raise(e.follower.road.id, e.follower.dist, 1, float(row["risen_hp"]), int(row["risen_hold"]),
				float(row["risen_damage"]), float(row["risen_interval"]), float(row["risen_time"]), "death_mark_risen")
		game.stats["brand_risen"] = int(game.stats.get("brand_risen", 0)) + 1
		if game.vfx.on:
			game.vfx.add(TdVfx.Kind.ANIM, e.position, 100.0, 0.5, Color.WHITE, "doom_burst")
		return


func step(_dt: float) -> void:
	for i in range(_brands.size() - 1, -1, -1):
		var b: Array = _brands[i]
		if game.time >= float(b[2]) or not TdEnemy.valid(b[0], int(b[1])):
			_brands.remove_at(i)
	if _risen != null:
		_risen.step()


func draw(ci: CanvasItem) -> void:
	if _risen != null:
		_risen.draw(ci)
	var tex := SpriteBank.texture("icons/death_mark")  # The brand sigil.
	if tex == null:
		return
	var s := TdVfxData.KIT_BRAND_PX  # Sigil size (px).
	for b: Array in _brands:
		var e: TdEnemy = b[0]
		if TdEnemy.valid(e, int(b[1])):
			var top := e.position + Vector2(-s * 0.5, -SpriteBank.drawn_height(String(e.row["sprite"])) - s - 2.0)  # Above its head.
			ci.draw_texture_rect(tex, Rect2(top, Vector2(s, s)), false, Color(1, 1, 1, 0.75 + 0.25 * sin(game.time * 8.0)))


func busy() -> bool:
	return not _brands.is_empty() or (_risen != null and _risen.busy())
