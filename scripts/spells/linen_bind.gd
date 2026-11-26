## Linen Bind (Act VII spell, Anubis' reward; Necropathy's Linen Bind:
## "spectral bandages wrap up to 5 enemies and hold them; wrapped enemies that
## die rise as temporary Mummies"): bandages wrap up to `targets` foes within
## `radius` px of the tap (nearest first; structures never): each takes
## `damage` and is held `hold` s (TdCombat.freeze_enemy, by rank), and its body
## is BOUND (vars "no_name": it leaves no Name, Rebirth). A wrapped foe that
## dies within `mark` s rises as a temporary Mummy of the necromancer's where
## it fell (TempBlockers: `mummy_hp`, hold `mummy_hold`, `mummy_damage` every
## `mummy_interval` s, `mummy_life` s + the Embalmer's innate "linen_life"),
## at most `cap` standing. Row: SpellData "linen_bind".
extends TdSpell

## The Mummies (made on the first rise).
var _risen: TempBlockers = null
## Wrapped foes: [[TdEnemy, generation, wrapped until game s], ...].
var _wrapped: Array = []
## True once connected to TdGame.enemy_killed.
var _hooked: bool = false
## Bandage lines to draw: [[from map px, to map px, end game s], ...] (drawn only).
var _lines: Array = []


func cast(pos: Vector2) -> bool:
	var near := game.foes_near(pos, float(row["radius"]))  # Candidates.
	if near.is_empty():
		return false
	if not _hooked:
		game.enemy_killed.connect(_on_kill)
		_hooked = true
	near.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return a.position.distance_squared_to(pos) < b.position.distance_squared_to(pos))
	for i in mini(roundi(float(row["targets"])), near.size()):
		var e: TdEnemy = near[i]
		e.vars["no_name"] = true
		_wrapped.append([e, e.generation, game.time + float(row["mark"])])
		TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": pos})
		if e.alive:
			TdCombat.freeze_enemy(game, e, float(row["hold"]))
		_lines.append([pos, e.position, game.time + 0.5])
		game.stats["linen_wraps"] = int(game.stats.get("linen_wraps", 0)) + 1
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


## TdGame.enemy_killed: a wrapped foe that dies rises as a Mummy.
func _on_kill(e: TdEnemy, _tower: Tower) -> void:
	for i in range(_wrapped.size() - 1, -1, -1):
		var w: Array = _wrapped[i]
		if w[0] != e or int(w[1]) != e.generation:
			continue
		_wrapped.remove_at(i)
		if game.time > float(w[2]) or e.follower.road.off_road:
			return
		if _risen == null:
			_risen = TempBlockers.new(game)
		if _risen.standing() >= int(row["cap"]):
			return
		var life := float(row["mummy_life"]) + float(CharacterModifiers.innate("linen_life", 0.0))  # The Embalmer's Linen Ward.
		_risen.raise(e.follower.road.id, e.follower.dist, 1, float(row["mummy_hp"]), int(row["mummy_hold"]), float(row["mummy_damage"]),
				float(row["mummy_interval"]), life, id)
		game.stats["linen_risen"] = int(game.stats.get("linen_risen", 0)) + 1
		return


func step(_dt: float) -> void:
	if _risen != null:
		_risen.step()
	_wrapped = _wrapped.filter(func(w: Array) -> bool: return game.time <= float(w[2]) and TdEnemy.valid(w[0], int(w[1])))
	_lines = _lines.filter(func(l: Array) -> bool: return game.time < float(l[2]))


func draw(ci: CanvasItem) -> void:
	if _risen != null:
		_risen.draw(ci)
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	for l: Array in _lines:
		var a: Vector2 = l[0]
		var b: Vector2 = l[1]
		var f := clampf((float(l[2]) - game.time) / 0.5, 0.0, 1.0)  # Fades out.
		TdVfx.draw_streak(ci, TdVfx._soft(), b, (b - a).angle(), a.distance_to(b), 10.0, Color(tint, f))
	for w: Array in _wrapped:
		var e: TdEnemy = w[0]
		if TdEnemy.valid(e, int(w[1])):
			ci.draw_texture_rect(TdVfx._soft(), Rect2(e.position - Vector2(16, 22), Vector2(32, 36)), false, Color(tint, 0.35))


func busy() -> bool:
	return not _wrapped.is_empty() or not _lines.is_empty() or (_risen != null and _risen.busy())
