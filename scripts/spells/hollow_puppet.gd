## Hollow Puppet (Act XII spell, the Motherboard's reward; Necropathy's Hollow
## Puppet: "curses the strongest nearby non-boss enemy: for 8 s it fights for
## you, then dies"): soul strings seize the foe with the most HP within `radius`
## px of the tap (never a boss, miniboss or structure: TdCombat.charm_enemy, the
## one charm path): for `puppet_life` s (x the Marionette's innate
## "puppet_time") it stands and strikes the foes beside it (`reach` px) for
## `damage` (x her "puppet_damage"); when the strings let go it DIES (killed by
## the spell: its souls are paid). Nothing to seize: no cast. Row: SpellData
## "hollow_puppet". Game stat "puppets".
extends TdSpell

## Puppets dangling: {e: TdEnemy, gen: int, until: game s it dies}.
var _puppets: Array[Dictionary] = []


func cast(pos: Vector2) -> bool:
	var foes := game.foes_near(pos, float(row["radius"]))  # Candidates.
	foes.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return a.hp > b.hp)
	var time := float(row["puppet_life"]) * float(CharacterModifiers.innate("puppet_time", 1.0))  # Its life (s).
	var dmg := float(row["damage"]) * float(CharacterModifiers.innate("puppet_damage", 1.0))  # Its blow.
	for e: TdEnemy in foes:
		if TdCombat.charm_enemy(game, e, time, dmg, float(row["reach"]), id, null):
			_puppets.append({"e": e, "gen": e.generation, "until": game.time + time})
			game.stats["puppets"] = int(game.stats.get("puppets", 0)) + 1
			if game.vfx.on:
				var lk: Dictionary = Acts.data("empire")["LOOK"]
				var f := game.vfx.add(TdVfx.Kind.THREAD, pos + Vector2(0, -60), 8.0, 0.5, lk["string_tint"])
				if f != null:
					f.to = e.position + Vector2(0, -14)
				game.vfx.add(TdVfx.Kind.ANIM, e.position + Vector2(0, -14), 70.0, 0.45, lk["string_tint"], "volley_flash")
			Sfx.play(String(TdSoundData.CAST.get(id, "")))
			return true
	return false


func step(_dt: float) -> void:
	for i in range(_puppets.size() - 1, -1, -1):
		var p: Dictionary = _puppets[i]
		var e: TdEnemy = p["e"]
		if not TdEnemy.valid(e, int(p["gen"])):
			_puppets.remove_at(i)
		elif game.time >= float(p["until"]):
			_puppets.remove_at(i)
			TdCombat.kill_enemy(game, e, null)  # The strings let go.


func draw(ci: CanvasItem) -> void:
	var lk: Dictionary = Acts.data("empire")["LOOK"]
	var streak := TdArt.texture("vfx_streak")  # String mask.
	if streak == null:
		return
	for p: Dictionary in _puppets:
		var e: TdEnemy = p["e"]
		if not TdEnemy.valid(e, int(p["gen"])):
			continue
		for k in 3:  # Three soul strings from above.
			var top := e.position + Vector2(float(k - 1) * 10.0, -70.0)
			TdVfx.draw_streak(ci, streak, e.position + Vector2(float(k - 1) * 5.0, -18.0), PI * 0.5, top.distance_to(e.position), 3.0, Color(lk["string_tint"], 0.8))


func busy() -> bool:
	return not _puppets.is_empty()
