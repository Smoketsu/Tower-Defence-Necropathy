## Soul Chains (GDD §5 "chains a pack together; slows and arcs damage"): the
## enemy nearest the tap (within `pick_radius` px) and, link by link, the
## nearest unchained enemy within `link_reach` px of the last one, up to
## `links` (+ the Soulbinder's Conductor, innate "chain_extra"), are chained:
## each takes `damage` at once and is slowed to `slow` for `duration` s, and
## every `tick` s while chained soul lightning arcs through the chain for
## `pulse` damage to each living link. Row: SpellData "soul_chains".
extends TdSpell

## Live chains: {"links": Array of [TdEnemy, generation], "until": game s, "next": game s of the next arc}.
var _chains: Array = []


func cast(pos: Vector2) -> bool:
	var first: TdEnemy = null  # Nearest enemy to the tap.
	for e: TdEnemy in game.foes_near(pos, float(row["pick_radius"])):
		if first == null or e.position.distance_squared_to(pos) < first.position.distance_squared_to(pos):
			first = e
	if first == null:
		return false
	var n := int(row["links"]) + int(CharacterModifiers.innate("chain_extra", 0))  # Links wanted.
	var chain: Array[TdEnemy] = [first]  # Chained so far, in order.
	while chain.size() < n:
		var last: TdEnemy = chain[chain.size() - 1]
		var next: TdEnemy = null  # Nearest unchained enemy to the last link.
		for e: TdEnemy in game.foes_near(last.position, float(row["link_reach"])):
			if not chain.has(e) and (next == null or e.position.distance_squared_to(last.position) < next.position.distance_squared_to(last.position)):
				next = e
		if next == null:
			break
		chain.append(next)
	var links: Array = []  # [enemy, generation] pairs.
	for e: TdEnemy in chain:
		links.append([e, e.generation])
	var dur := float(row["duration"])  # Chained time (s).
	for e: TdEnemy in chain:
		TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": pos})
		if e.alive:
			TdCombat.slow_enemy(game, e, float(row["slow"]), dur)
	_chains.append({"links": links, "until": game.time + dur, "next": game.time + float(row["tick"])})
	game.stats["chained"] = int(game.stats.get("chained", 0)) + chain.size()
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	_arc_fx(links)
	return true


## Soul lightning bursts on every living link (drawn only).
func _arc_fx(links: Array) -> void:
	if not game.vfx.on:
		return
	for l: Array in links:
		if TdEnemy.valid(l[0], int(l[1])):
			game.vfx.add(TdVfx.Kind.ANIM, (l[0] as TdEnemy).position + Vector2(0, -10), 64.0, 0.4, Color.WHITE, "soul_lightning")


func step(_dt: float) -> void:
	for i in range(_chains.size() - 1, -1, -1):
		var c: Dictionary = _chains[i]
		if game.time >= float(c["until"]):
			_chains.remove_at(i)
			continue
		if game.time >= float(c["next"]):
			c["next"] = float(c["next"]) + float(row["tick"])
			for l: Array in c["links"]:
				if TdEnemy.valid(l[0], int(l[1])):
					TdCombat.damage_enemy(game, l[0], float(row["pulse"]), {"source": id})
			_arc_fx(c["links"])


func draw(ci: CanvasItem) -> void:
	var streak := TdArt.texture("vfx_streak")  # Link mask.
	if streak == null:
		return
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	for c: Dictionary in _chains:
		var prev: Vector2 = Vector2.INF  # Previous living link.
		for l: Array in c["links"]:
			if not TdEnemy.valid(l[0], int(l[1])):
				continue
			var p := (l[0] as TdEnemy).position + Vector2(0, -10)  # Link point.
			if prev != Vector2.INF:
				var d := p - prev  # Link vector.
				TdVfx.draw_streak(ci, streak, p, d.angle(), d.length(), TdVfxData.KIT_CHAIN_W, Color(tint, 0.6 + 0.4 * sin(game.time * 20.0 + p.x)))
			prev = p


func busy() -> bool:
	return not _chains.is_empty()
