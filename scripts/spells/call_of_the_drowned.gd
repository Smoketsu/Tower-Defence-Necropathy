## Call of the Drowned (Act XI spell, Vhal'Neth's reward; Necropathy's Call of
## the Drowned, "the Eye's Claim turned against it"): the `targets` strongest
## foes (most HP) within `range` px of the tap are marked by a drowned ring;
## `delay` s later tendrils burst under each: `damage` to every foe within
## `radius` px, each slowed to `slow` for `slow_time` s. A foe the tendrils
## KILL (not a boss or miniboss) rises as YOUR Drowned Thrall where it fell: a
## temporary Risen through TempBlockers.raise() (`thrall_hp` x the Tide
## Widow's thrall_hp_mult, holding `thrall_hold`, `thrall_damage` every
## `thrall_interval` s, for `thrall_life` s), at most `thrall_max` (+ the Tide
## Widow's thrall_cap_bonus) standing at once. Row: SpellData "call_of_the_drowned".
extends TdSpell

## Marks waiting to burst: [TdEnemy, generation, game s it bursts, last map px].
var _marks: Array = []
## Its Thralls (made on the first raise).
var _risen: TempBlockers = null


func cast(pos: Vector2) -> bool:
	var foes := game.foes_near(pos, float(row["range"]))  # Candidates.
	if foes.is_empty():
		return false
	foes.sort_custom(func(a: TdEnemy, b: TdEnemy) -> bool: return a.hp > b.hp)
	for i in mini(roundi(float(row["targets"])), foes.size()):
		var e := foes[i]
		_marks.append([e, e.generation, game.time + float(row["delay"]), e.position])
		game.fx.spawn("drowned_tendrils", e.position, float(row["radius"]) * 1.4, float(row["delay"]), Color(TdVfxData.SPELLS[id]["tint"], 0.6))
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	if _risen != null:
		_risen.step()
	for i in range(_marks.size() - 1, -1, -1):
		var m: Array = _marks[i]
		var e: TdEnemy = m[0]
		if TdEnemy.valid(e, int(m[1])):
			m[3] = e.position
		if game.time < float(m[2]):
			continue
		_marks.remove_at(i)
		_burst(m[3])


## Tendrils burst at map px `p`: damage, slow, and the killed rise as Thralls.
func _burst(p: Vector2) -> void:
	var cap := int(row["thrall_max"]) + int(CharacterModifiers.innate("thrall_cap_bonus", 0))  # Thralls at once.
	for e: TdEnemy in game.foes_near(p, float(row["radius"])):
		var rd := e.follower.road  # Where it walks.
		var d := e.follower.dist
		var rank := String(e.row["rank"])
		TdCombat.damage_enemy(game, e, float(row["damage"]), {"source": id, "origin": p})
		if e.alive:
			TdCombat.slow_enemy(game, e, float(row["slow"]), float(row["slow_time"]))
		elif rank != "boss" and rank != "miniboss" and not rd.off_road and (_risen == null or _risen.standing() < cap):
			if _risen == null:
				_risen = TempBlockers.new(game)
				_risen.sprite = "summons/drowned_thrall_ally"
			_risen.raise(rd.id, d, 1, float(row["thrall_hp"]) * float(CharacterModifiers.innate("thrall_hp_mult", 1.0)), int(row["thrall_hold"]),
					float(row["thrall_damage"]), float(row["thrall_interval"]), float(row["thrall_life"]), id)
			game.stats["drowned_risen"] = int(game.stats.get("drowned_risen", 0)) + 1
	game.fx.spawn("drowned_tendrils", p, float(Acts.data("eye")["LOOK"]["tendril_d"]), 0.5, TdVfxData.SPELLS[id]["tint"])
	game.stats["drowned_bursts"] = int(game.stats.get("drowned_bursts", 0)) + 1


func draw(ci: CanvasItem) -> void:
	if _risen != null:
		_risen.draw(ci)
	var ring := TdArt.texture("range_ring")
	for m: Array in _marks:
		var r := float(row["radius"])
		if ring != null:
			ci.draw_texture_rect(ring, Rect2(Vector2(m[3]) - Vector2(r, r), Vector2(r, r) * 2.0), false, TdVfxData.SPELLS[id]["tint"])


func busy() -> bool:
	return not _marks.is_empty() or (_risen != null and _risen.busy())
