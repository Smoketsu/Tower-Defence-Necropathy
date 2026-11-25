## Corpse Explosion (GDD §5 "detonates corpses on the road; rewards killing in
## one place"): every kill leaves a corpse marker where it fell (at most
## `max_corpses`, oldest dropped; each lies `corpse_life` s). A cast detonates
## up to `max_detonate` corpses within `pick_radius` px of the tap: each blasts
## every enemy within `blast_radius` px for `damage` through TdCombat. No
## corpse in reach = no cast (no cooldown). Row: SpellData "corpse_explosion".
extends TdSpell

## Corpses on the ground: [map px, end game s, variant 0..2] (oldest first).
var _corpses: Array = []
## True once it listens to TdGame.enemy_killed.
var _listening: bool = false
## Cached corpse textures by variant (a draw command keeps only the RID).
var _tex: Array = []


func step(_dt: float) -> void:
	if not _listening:
		_listening = true
		game.enemy_killed.connect(_on_kill)
	while not _corpses.is_empty() and game.time >= float(_corpses[0][1]):
		_corpses.pop_front()


## TdGame.enemy_killed: leaves a corpse (not for bosses: the map ends; not for
## structures: a generator or crystal is no body).
func _on_kill(e: TdEnemy, _tower: Tower) -> void:
	if String(e.row["rank"]) == "boss" or bool(e.row.get("structure", false)):
		return
	if _corpses.size() >= int(row["max_corpses"]):
		_corpses.pop_front()
	_corpses.append([e.position, game.time + float(row["corpse_life"]), e.generation % 3])


func cast(pos: Vector2) -> bool:
	var pr := float(row["pick_radius"])  # Search radius around the tap (px).
	var hit := {"source": id}  # TdCombat hit info.
	var n := 0  # Corpses detonated.
	for i in range(_corpses.size() - 1, -1, -1):
		var p: Vector2 = _corpses[i][0]
		if n >= int(row["max_detonate"]) or p.distance_squared_to(pos) > pr * pr:
			continue
		_corpses.remove_at(i)
		n += 1
		for e: TdEnemy in game.foes_near(p, float(row["blast_radius"])):
			TdCombat.damage_enemy(game, e, float(row["damage"]), hit.merged({"origin": p}))
		game.fx.spawn("corpse_explosion", p, float(row["blast_radius"]) * 2.0, 0.45)
	if n > 0:
		game.stats["corpses_detonated"] = int(game.stats.get("corpses_detonated", 0)) + n
	return n > 0


func draw(ci: CanvasItem) -> void:
	if _tex.is_empty():
		_tex = [SpriteBank.texture("decals/corpse"), SpriteBank.texture("decals/corpse_2"), SpriteBank.texture("decals/corpse_3")]
	for c: Array in _corpses:
		var tex: Texture2D = _tex[int(c[2])]
		if tex != null:
			SpriteBank.apply_sharp(ci)
			ci.draw_texture(tex, (Vector2(c[0]) - tex.get_size() * 0.5).round(), Color(1, 1, 1, clampf((float(c[1]) - game.time) / 2.0, 0.0, 0.85)))


func busy() -> bool:
	return not _corpses.is_empty()
