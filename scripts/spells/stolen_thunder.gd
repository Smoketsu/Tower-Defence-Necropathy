## Stolen Thunder (Act VIII spell, Zeus's reward; Necropathy's StolenThunder:
## "a thundercloud over the necromancer strikes the foe with the most HP left
## and chains to the nearest armoured foes"): a stolen storm hangs over the tap
## for `duration` s; every `tick` s a bolt strikes the foe with the most HP
## within `radius` px for `damage` (x `armour_bonus` on a foe with flat armour,
## x the Oathbreaker's `kin_mult` on bosses, minibosses and elites: Kinslayer)
## and chains `chains` hops to the nearest foe within `chain_range` px not yet
## struck by this bolt, each hop x `chain_falloff`. From above: the hit's
## source "stolen_thunder" is undirected for the phalanx (its `ignore`).
## Row: SpellData "stolen_thunder".
extends TdSpell

## Live storms: [map px, end game s, next bolt game s].
var _storms: Array = []


func cast(pos: Vector2) -> bool:
	_storms.append([pos, game.time + float(row["duration"]), game.time + float(row["tick"]) * 0.5])
	Sfx.play(String(TdSoundData.CAST.get(id, "")))
	return true


func step(_dt: float) -> void:
	for i in range(_storms.size() - 1, -1, -1):
		var s: Array = _storms[i]
		if game.time >= float(s[1]):
			_storms.remove_at(i)
			continue
		if game.time < float(s[2]):
			continue
		s[2] = game.time + float(row["tick"])
		var best: TdEnemy = null  # Most HP in reach.
		for e: TdEnemy in game.foes_near(s[0], float(row["radius"])):
			if best == null or e.hp > best.hp:
				best = e
		if best == null:
			continue
		var struck: Array[TdEnemy] = [best]  # This bolt's chain.
		var dmg := float(row["damage"])  # Damage of this hop.
		var prev: Vector2 = Vector2(s[0]) + Vector2(0, -float(row["cloud_lift"]))  # Where the bolt comes from.
		var cur := best  # This hop's foe.
		for _hop in int(row["chains"]) + 1:
			var m := (float(row["armour_bonus"]) if cur.armour > 0.0 else 1.0) * (float(CharacterModifiers.innate("kin_mult", 1.0)) if cur.row["rank"] != "fodder" else 1.0)  # Its bonuses.
			var at := cur.position  # Where it strikes.
			TdCombat.damage_enemy(game, cur, dmg * m, {"source": id, "origin": at})
			game.stats["thunder_bolts"] = int(game.stats.get("thunder_bolts", 0)) + 1
			if game.vfx.on:
				var tint: Color = TdVfxData.SPELLS[id]["tint"]
				var f := game.vfx.add(TdVfx.Kind.STREAK, at, float(row["bolt_w"]), 0.25, tint)
				if f != null:
					f.ang = (at - prev).angle()
					f.size0 = prev.distance_to(at)
				game.vfx.add(TdVfx.Kind.ANIM, at, float(row["impact_d"]), TdVfxData.IMPACT_TIME, tint, "soul_lightning")
			prev = at
			dmg *= float(row["chain_falloff"])
			var nxt: TdEnemy = null  # Nearest unstruck foe.
			var nd := float(row["chain_range"])  # Its distance.
			for o: TdEnemy in game.foes_near(at, nd):
				if not struck.has(o) and o.position.distance_to(at) <= nd:
					nd = o.position.distance_to(at)
					nxt = o
			if nxt == null:
				break
			struck.append(nxt)
			cur = nxt
		Sfx.play("wrath_thunder")


func draw(ci: CanvasItem) -> void:
	var tint: Color = TdVfxData.SPELLS[id]["tint"]
	var ring := TdArt.texture("range_ring")  # The storm's real reach.
	var rr := float(row["radius"])  # Reach (px).
	var d := float(row["cloud_d"])  # Cloud size (px).
	for s: Array in _storms:
		var left := clampf((float(s[1]) - game.time) / 0.5, 0.0, 1.0)  # Fades at the end.
		var p: Vector2 = s[0]
		var c := p + Vector2(0, -float(row["cloud_lift"]))  # The cloud.
		ci.draw_texture_rect(TdVfx._soft(), Rect2(c - Vector2(d, d * 0.5), Vector2(d, d * 0.5) * 2.0), false, Color(0.25, 0.25, 0.35, 0.8 * left))
		ci.draw_texture_rect(TdVfx._soft(), Rect2(c - Vector2(d, d * 0.5) * 0.6, Vector2(d, d * 0.5) * 1.2), false, Color(tint, 0.5 * left))
		if ring != null:
			ci.draw_texture_rect(ring, Rect2(p - Vector2(rr, rr), Vector2(rr, rr) * 2.0), false, Color(tint, 0.35 * left))


func busy() -> bool:
	return not _storms.is_empty()
