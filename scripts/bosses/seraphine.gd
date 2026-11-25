## Grand Inquisitor Seraphine, road version (GDD §6.3 "teleports forward
## along the road, suppresses towers with beams, is healed by High Confessor
## attendants"). She arrives with `attendants` escorts of kind
## `attendant_kind` (a Confessor row: they heal her). Every `teleport_every`
## s (first after `teleport_first`; `teleport_every_p2` below `phase2_hp` of
## her HP) she breaks free of any post and blinks `teleport_dist` px down the
## road (never closer than `keep_away` px to the gate); her escorts that are
## not held blink with her, `attendant_gap` px apart behind her. Where she
## lands, a judgment beam suppresses every tower within `beam_radius` px
## (damage x `beam_mult`) for `beam_time` s. Args in TdEnemyData "seraphine".
## vars: "next_tp", "pose_until" (game s), "escorts" ([[TdEnemy, generation], ...]).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["next_tp"] = game.time + float(a["teleport_first"])
	e.vars["pose_until"] = 0.0
	var escorts: Array = []  # Her attendants.
	for i in int(a["attendants"]):
		var c := game.waves.spawn_extra(String(a["attendant_kind"]), e.follower.road.id, -float(a["attendant_gap"]) * float(i + 1), float(i % 2 * 2 - 1) * 8.0)
		escorts.append([c, c.generation])
	e.vars["escorts"] = escorts


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	if game.time < float(e.vars["next_tp"]) or game.time < e.freeze_until:
		return
	var p2 := e.hp < e.max_hp * float(a["phase2_hp"])  # Second phase.
	e.vars["next_tp"] = game.time + float(a["teleport_every_p2"] if p2 else a["teleport_every"])
	var room := -game.progress(e) - float(a["keep_away"])  # Px she may still blink.
	var jump := minf(float(a["teleport_dist"]), room)  # Px blinked.
	if jump <= 0.0:
		return
	game.fx.spawn("holy_impact", e.position, 96.0, 0.5)
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	e.follower.advance(jump)
	e.position = e.follower.position()
	var i := 0  # Escort index.
	for pair: Array in e.vars["escorts"]:
		var c: TdEnemy = pair[0]
		if TdEnemy.valid(c, int(pair[1])) and c.holder == null:
			i += 1
			c.follower.road = e.follower.road
			c.follower.dist = maxf(e.follower.dist - float(a["attendant_gap"]) * float(i), 0.0)
			c.position = c.follower.position()
	var field := CovenantField.of(game)  # Draws the beam's mark.
	for t: Tower in field.towers_near(e.position, float(a["beam_radius"])):
		TdCombat.suppress_tower(game, t, float(a["beam_mult"]), float(a["beam_time"]))
	field.add_zone(e.position, float(a["beam_radius"]), game.time + float(a["beam_time"]), Color(1.0, 0.95, 0.6, 0.6))
	game.fx.spawn("holy_impact", e.position, 128.0, 0.6)
	e.pose = 1
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()
	EnemyTrait.note(game, "seraphine_teleports")
