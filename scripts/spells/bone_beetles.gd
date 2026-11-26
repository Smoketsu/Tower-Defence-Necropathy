## Bone Beetles (Act XIII spell, the Hive Mother's reward; Necropathy's Bone
## Beetles, "slain foes burst into bone beetles that bite the next foe"): a
## swarm of `beetles` beetles (+ the Broodbound's beetle_extra) bursts from the
## tap; each runs at `speed` px/s to a foe within `radius` px of the tap (spread
## over them, nearest first) and bites it for `damage` (TdCombat.damage_enemy,
## source "bone_beetles"). A foe a beetle kills bursts into one more beetle that
## runs to the nearest foe within `radius` px of it, at most `chain` more a
## cast. Row: SpellData "bone_beetles".
extends TdSpell

## Beetles running: [from map px, TdEnemy, its generation, game s it left, game s it bites].
var _beetles: Array = []
## Chained beetles still allowed this cast.
var _chain_left: int = 0


func cast(pos: Vector2) -> bool:
	var foes := game.foes_near(pos, float(row["radius"]))  # Its prey.
	if foes.is_empty():
		return false
	foes.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return a.position.distance_squared_to(pos) < b.position.distance_squared_to(pos))
	var n := int(row["beetles"]) + int(CharacterModifiers.innate("beetle_extra", 0))  # Beetles this cast.
	for i in n:
		_send(pos, foes[i % foes.size()])
	_chain_left = int(row["chain"])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


## One beetle from `from` to `e`.
func _send(from: Vector2, e: TdEnemy) -> void:
	var t := from.distance_to(e.position) / float(row["speed"])  # S to reach it.
	_beetles.append([from, e, e.generation, game.time, game.time + maxf(t, 0.1)])


func step(_dt: float) -> void:
	for i in range(_beetles.size() - 1, -1, -1):
		var b: Array = _beetles[i]
		if game.time < float(b[4]):
			continue
		_beetles.remove_at(i)
		var e: TdEnemy = b[1]
		if not TdEnemy.valid(e, int(b[2])):
			continue
		var at := e.position
		TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": b[0]})
		game.stats["beetle_bites"] = int(game.stats.get("beetle_bites", 0)) + 1
		if not e.alive and _chain_left > 0:
			var next := game.foes_near(at, float(row["radius"]))
			if not next.is_empty():
				_chain_left -= 1
				_send(at, next[0])


func draw(ci: CanvasItem) -> void:
	var px := float(Acts.data("concord")["LOOK"]["beetle_px"])  # Drawn size.
	var tex := SpriteBank.texture("projectiles/bone_beetle")  # The beetle (head to +x).
	for b: Array in _beetles:
		var e: TdEnemy = b[1]
		if not TdEnemy.valid(e, int(b[2])):
			continue
		var f := clampf((game.time - float(b[3])) / maxf(float(b[4]) - float(b[3]), 0.01), 0.0, 1.0)
		var p := Vector2(b[0]).lerp(e.position, f)
		var ang := (e.position - Vector2(b[0])).angle()
		if tex != null:
			ci.draw_set_transform(p, ang, Vector2.ONE)
			ci.draw_texture_rect(tex, Rect2(-px * 0.5, -px * 0.4, px, px * 0.8), false)
			ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		else:
			ci.draw_texture_rect(TdVfx._soft(), Rect2(p - Vector2(5, 5), Vector2(10, 10)), false, TdVfxData.SPELLS[id]["tint"])


func busy() -> bool:
	return not _beetles.is_empty()
