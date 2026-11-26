## Flaming Sword (Act X spell, Seraiel's reward; Necropathy's Flaming Sword, "a
## spectral sword sweeps a wide arc"): a sword of white fire sweeps round the
## tap: every foe within `radius` px takes `damage` and burns for `burn_time` s
## at `burn_dps` (TdCombat.add_dot). `sweeps` per cast, `sweep_gap` s apart (the
## Fallen Herald's boost adds one through "sweeps"). Row: SpellData "flaming_sword".
extends TdSpell

## Pending and drawn sweeps: [map px, game s it strikes, struck (bool)].
var _sweeps: Array = []


func cast(pos: Vector2) -> bool:
	if game.foes_near(pos, float(row["radius"])).is_empty():
		return false
	for i in roundi(float(row["sweeps"])):
		_sweeps.append([pos, game.time + float(row["sweep_gap"]) * float(i), false])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	var t := float(Acts.data("host")["LOOK"]["sword_time"])  # S a sweep shows.
	for i in range(_sweeps.size() - 1, -1, -1):
		var s: Array = _sweeps[i]
		if not bool(s[2]) and game.time >= float(s[1]):
			s[2] = true
			for e: TdEnemy in game.foes_near(s[0], float(row["radius"])):
				TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": s[0]})
				if e.alive:
					TdCombat.add_dot(game, e, float(row["burn_dps"]), float(row["burn_time"]), id)
			game.stats["sword_sweeps"] = int(game.stats.get("sword_sweeps", 0)) + 1
			if game.vfx.on:
				var tint: Color = TdVfxData.SPELLS[id]["tint"]
				game.vfx.add(TdVfx.Kind.ANIM, s[0], float(row["radius"]) * 2.0, t, tint, "sentinel_sweep")
				var ring := game.vfx.add(TdVfx.Kind.RING, s[0], float(row["radius"]), t, tint)
				if ring != null:
					ring.size0 = float(row["radius"]) * 0.4
		elif bool(s[2]) and game.time > float(s[1]) + t:
			_sweeps.remove_at(i)


func draw(ci: CanvasItem) -> void:
	var lk: Dictionary = Acts.data("host")["LOOK"]
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	var streak := TdArt.texture("vfx_streak")  # The blade mask.
	var r := float(row["radius"])
	for s: Array in _sweeps:
		var f := clampf((game.time - float(s[1])) / float(lk["sword_time"]), 0.0, 1.0)  # 0..1 of the sweep.
		if not bool(s[2]) or streak == null:
			continue
		var ang := -float(lk["sword_arc"]) * 0.5 + float(lk["sword_arc"]) * f - PI * 0.5  # The blade's angle now.
		var tip := Vector2(s[0]) + Vector2.from_angle(ang) * r  # The blade's tip.
		TdVfx.draw_streak(ci, streak, tip, ang, r, 14.0, Color(tint, 1.0 - f * 0.6))


func busy() -> bool:
	return not _sweeps.is_empty()
