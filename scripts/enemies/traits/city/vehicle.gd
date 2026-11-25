## Vehicle (Act IV, the Last Line; GDD §7.3 "Vehicles and armour"): squad
## cars, limos, tanks and the Mammoth. Armoured (the row's flat armour:
## Wither, the Catapult's pierce and the Fallen Hero's slam shred it). A
## blocker body holding it whose max HP is below `crush_hp` cannot stop it:
## the vehicle crashes through, every living body of that post takes
## `crush_damage` (TdCombat.damage_body, the vehicle as the blow's dealer), it
## lets go and drives on unholdable for `pass_time` s. A heavier body
## (an upgraded Abomination or Bone Golem; a high-level Warrior for a car)
## holds it as any enemy. Optional turret: every `shell_every` s (0 = none)
## it shells the nearest tower within `shell_range` px that is not already
## disabled (game.hostile.shell: `shell_radius` px, `shell_delay` s of
## telegraph, `shell_disable` s, `shell_damage` to bodies in the circle).
## Args: crush_hp, crush_damage, pass_time, shell_every, and when it shells
## shell_range, shell_radius, shell_delay, shell_disable, shell_damage.
## vars: "next_shell" (game s). Events: vehicle_crashes, vehicle_held, vehicle_shells.
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var every := float(e.row["args"]["shell_every"])  # Turret cadence (s), 0 = none.
	e.vars["next_shell"] = game.time + every * 0.5 if every > 0.0 else INF


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # The kind's numbers.
	if e.holder != null:
		if e.holder.max_hp < float(a["crush_hp"]) and game.time >= e.freeze_until:
			_crash(e, game, a)
		elif not e.vars.has("held_noted"):
			e.vars["held_noted"] = true
			EnemyTrait.note(game, "vehicle_held")
	if game.time >= float(e.vars["next_shell"]) and game.time >= e.freeze_until and game.time >= e.staggered_until:
		_shell(e, game, a)


## Crashes through the post holding `e` (see the header).
func _crash(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var block := e.holder.block  # The post it runs over.
	e.holder.held.erase(e)
	e.holder = null
	for b: BlockBody in block.bodies:
		if b.alive:
			TdCombat.damage_body(game, b, float(a["crush_damage"]), e)
			b.vis_flinch_at = game.time  # Knocked aside (drawn only).
			b.vis_flinch_dir = (game.roads[block.road_id] as Road).dir_at(block.dist)
	e.unholdable_until = game.time + float(a["pass_time"])
	EnemyTrait.note(game, "vehicle_crashes")
	if game.vfx.on:
		game.fx.spawn("vael_cleave", e.position, TdVfxData.CITY_CRASH_D, TdVfxData.CITY_CRASH_TIME)
		game.vfx.shake(TdVfxData.CITY_CRASH_SHAKE)
	game.sound("city_crash")


## Shells the nearest tower in range that is not disabled (see the header).
func _shell(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var best: Tower = null  # Its target.
	var best_d := float(a["shell_range"])  # Nearest distance so far (px).
	for t: Tower in game.towers:
		var d := e.position.distance_to(t.position)  # Distance (px).
		if d <= best_d and game.time >= t.disabled_until:
			best_d = d
			best = t
	if best == null:
		e.vars["next_shell"] = game.time + float(a["shell_every"]) * 0.25  # Nothing in range: look again soon.
		return
	e.vars["next_shell"] = game.time + float(a["shell_every"])
	game.hostile.shell(best.position, float(a["shell_radius"]), float(a["shell_delay"]), float(a["shell_disable"]), "shelled", float(a["shell_damage"]))
	EnemyTrait.note(game, "vehicle_shells")
	e.vis_strike_at = game.time  # Its recoil (drawn only).
	e.vis_strike_dir = (best.position - e.position).normalized()
