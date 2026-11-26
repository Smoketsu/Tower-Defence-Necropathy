## Hundred Shadows (Act V spell, Kage's reward; Necropathy's Hundred Shadows,
## shadow clones of the necromancer): `count` shadow clones of the Grave
## Kunoichi step out of the road at the point nearest the tap (within
## `max_snap` px) and fight there for `duration` s: every `tick` s each clone
## strikes the nearest enemy within `radius` px for `damage` (TdCombat). They
## hold nothing (shadows). Row: SpellData "hundred_shadows".
extends TdSpell

## Live clones: [map px, end game s, next strike game s, index].
var _clones: Array = []


func cast(pos: Vector2) -> bool:
	var road := game.nearest_road(pos, float(row["max_snap"]))  # Road under the tap, or null.
	if road == null:
		return false
	var d := road.project(pos)  # Distance along it (px).
	var dir := road.dir_at(d)  # Road direction there.
	var n := roundi(float(row["count"]))  # Clones this cast.
	for i in n:
		var side := float(i) - float(n - 1) * 0.5  # Across the road.
		var p := road.point_at(d) + Vector2(dir.y, -dir.x) * side * float(Acts.data("shogunate")["LOOK"]["clone_gap"])  # Where it stands.
		_clones.append([p, game.time + float(row["duration"]), game.time + float(row["tick"]) * float(i) / float(n), i])
		game.fx.spawn("spore_cloud", p, 60.0, 0.5, Acts.data("shogunate")["LOOK"]["smoke_tint"])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_clones.size() - 1, -1, -1):
		var c: Array = _clones[i]
		if game.time >= float(c[1]):
			_clones.remove_at(i)
			continue
		if game.time < float(c[2]):
			continue
		c[2] = game.time + float(row["tick"])
		var best: TdEnemy = null  # Nearest foe in reach.
		for e: TdEnemy in game.foes_near(c[0], float(row["radius"])):
			if best == null or e.position.distance_squared_to(c[0]) < best.position.distance_squared_to(c[0]):
				best = e
		if best == null:
			continue
		var at := best.position  # Where it struck.
		TdCombat.damage_enemy(game, best, float(row["damage"]), {"source": id, "origin": c[0]})
		game.stats["shadow_strikes"] = int(game.stats.get("shadow_strikes", 0)) + 1
		if game.vfx.on:
			var f := game.vfx.add(TdVfx.Kind.STREAK, at, 10.0, 0.25, TdVfxData.SPELLS[id]["tint"])
			if f != null:
				f.ang = (at - Vector2(c[0])).angle()
				f.size0 = Vector2(c[0]).distance_to(at)
			game.vfx.add(TdVfx.Kind.ANIM, at, 48.0, TdVfxData.IMPACT_TIME, TdVfxData.SPELLS[id]["tint"], "volley_hit")


func draw(ci: CanvasItem) -> void:
	var lk: Dictionary = Acts.data("shogunate")["LOOK"]
	for c: Array in _clones:
		var left := clampf((float(c[1]) - game.time) / 0.4, 0.0, 1.0)  # Fades at the end.
		var flick := 0.75 + 0.25 * sin(game.time * 9.0 + float(c[3]) * 2.0)  # Shadow flicker.
		var tint: Color = lk["clone_tint"]
		SpriteBank.draw(ci, String(row["sprite"]), c[0], false, Color(tint, tint.a * left * flick), TdVfxData.UNIT_SCALE_TOWER)


func busy() -> bool:
	return not _clones.is_empty()
