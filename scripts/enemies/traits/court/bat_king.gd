## The Chiropteran King (Castle Sanguis' miniboss; Necropathy ChiropteranKingKit),
## a flier no blocker holds. GREAT SHRIEK: first after `shriek_first` s, then
## every `shriek_every` s, a telegraphed circle of `shriek_radius` px on the
## nearest tower within `shriek_reach` px stuns every tower in it for
## `shriek_stun` s (game.hostile.shell, cause "stunned"). CARRY-OFF: first after
## `grab_first` s, then every `grab_every` s, he seizes the living blocker body
## within `grab_reach` px with the most HP and carries it off: it falls
## (TdCombat.damage_body for all it has) and comes back on its own respawn.
## THE COLONY: once, below `swarm_at` of his HP, `swarm_count` `swarm_kind`
## burst from his wings around him. Args: shriek_first, shriek_every,
## shriek_reach, shriek_radius, shriek_delay, shriek_stun, grab_first,
## grab_every, grab_reach, swarm_at, swarm_count, swarm_kind.
## vars: "next_shriek", "next_grab" (game s), "swarmed" (bool).
extends EnemyTrait

## Shared Court helpers.
const CourtKit := preload("res://scripts/enemies/traits/court/court_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["next_shriek"] = game.time + float(a["shriek_first"])
	e.vars["next_grab"] = game.time + float(a["grab_first"])
	e.vars["swarmed"] = false


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < e.freeze_until:
		return
	var a: Dictionary = e.row["args"]  # His numbers.
	if game.time >= float(e.vars["next_shriek"]):
		var t := CourtKit.nearest_tower(game, e.position, float(a["shriek_reach"]))  # His mark.
		if t != null:
			e.vars["next_shriek"] = game.time + float(a["shriek_every"])
			game.hostile.shell(t.position, float(a["shriek_radius"]), float(a["shriek_delay"]), float(a["shriek_stun"]), "stunned")
			EnemyTrait.note(game, "king_shrieks")
	if game.time >= float(e.vars["next_grab"]):
		var best: BlockBody = null  # The body he carries off.
		for b: BlockBody in game.bodies_near(e.position, float(a["grab_reach"])):
			if not b.temporary and (best == null or b.hp > best.hp):
				best = b
		if best != null:
			e.vars["next_grab"] = game.time + float(a["grab_every"])
			CourtKit.mark(game, best.pos, 34.0, 0.8, CourtKit.tint("mark_tint"))
			game.vfx.enemy_blow(e, best)
			TdCombat.damage_body(game, best, (best.hp + best.barrier) / maxf(1.0 - best.damage_cut, 0.05) + 1.0, e)  # All it has, through any barrier or plant cut.
			EnemyTrait.note(game, "king_carries")


func on_hit(e: TdEnemy, game: TdGame, _amount: float, _hit: Dictionary) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if bool(e.vars["swarmed"]) or e.hp >= e.max_hp * float(a["swarm_at"]):
		return
	e.vars["swarmed"] = true
	CourtKit.call_out(game, e, String(a["swarm_kind"]), int(a["swarm_count"]), 12.0)
	game.fx.spawn("summon_rise", e.position, 120.0, 0.5, Color(1.0, 0.4, 0.5))
	EnemyTrait.note(game, "king_colony")
