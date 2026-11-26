## Barrow Grasp (Act VI spell, Hrimgar's reward; Necropathy's BarrowGrasp, "cold
## hands burst from the ground in a ring and hold enemies"): `hands` cold hands
## (+ the Rune-Seer's innate `grasp_hands`) burst on a ring of `ring` px round
## the tap, evenly spread; each grabs every foe within `radius` px of it once:
## `damage` (TdCombat) and a hold of `hold` s (TdCombat.freeze_enemy: bosses and
## minibosses keep their rank's share). Row: SpellData "barrow_grasp".
extends TdSpell

## Hands showing: [map px, game s it burst].
var _hands: Array = []


func cast(pos: Vector2) -> bool:
	var n := roundi(float(row["hands"])) + int(CharacterModifiers.innate("grasp_hands", 0))  # Hands this cast.
	var grabbed: Array[TdEnemy] = []  # Each foe once per cast.
	for i in n:
		var p := pos + Vector2.RIGHT.rotated(TAU * float(i) / float(n)) * float(row["ring"])  # Where it bursts.
		_hands.append([p, game.time])
		for e: TdEnemy in game.foes_near(p, float(row["radius"])):
			if grabbed.has(e):
				continue
			grabbed.append(e)
			TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": p})
			if e.alive:
				TdCombat.freeze_enemy(game, e, float(row["hold"]))
		if game.vfx.on:
			game.vfx.add(TdVfx.Kind.ANIM, p, float(Acts.data("norse")["LOOK"]["hand_d"]), 0.5, Acts.data("norse")["LOOK"]["hand_tint"], "summon_rise")
	game.stats["barrow_grasps"] = int(game.stats.get("barrow_grasps", 0)) + grabbed.size()
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_hands.size() - 1, -1, -1):
		if game.time - float(_hands[i][1]) > float(row["hold"]):
			_hands.remove_at(i)


func draw(ci: CanvasItem) -> void:
	var lk: Dictionary = Acts.data("norse")["LOOK"]
	var d := float(lk["hand_d"])  # Burst size (px).
	for h: Array in _hands:
		var left := 1.0 - (game.time - float(h[1])) / float(row["hold"])  # 1 -> 0 as the grip fades.
		ci.draw_texture_rect(TdVfx._soft(), Rect2(Vector2(h[0]) - Vector2(d, d) * 0.5, Vector2(d, d)), false, Color(lk["hand_tint"], 0.55 * left))
		SpriteBank.draw(ci, "obstacles/barrow_open", Vector2(h[0]), false, Color(0.7, 0.9, 1.0, left))


func busy() -> bool:
	return not _hands.is_empty()
