## Hades, Lord of the Dead (Asphodel Underworld boss, the act's finale;
## Necropathy's BossHades: "the first rival necromancer, in three phases").
##   THE HELM OF DARKNESS (above `reclaim_hp`): every `cloak_every` s (first
##     after `cloak_first`) he vanishes for `cloak_time` s: no tower may target
##     him (the act rule's can_target() reads vars "cloak_until"; drawn faint);
##     revealed, he sweeps his bident (pose 1).
##   THE RECLAIMING (down to `lord_hp`): CLAIMS: every blocker body that falls
##     anywhere rises as his shade (`claim_kind`, through the act rule's
##     on_body_fallen -> game.spawn_from_body(); vars "claiming" = true while
##     he lives in this phase or the next). He still cloaks.
##   LORD OF THE DEAD (below `lord_hp`): he raises `ring_count` `ring_kind`
##     wardens around him (`ring_gap` px apart along the road, `ring_back` px
##     behind to `ring_ahead` px ahead) and again every `ring_every` s while
##     none stand; while at least `ring_hold` stand he takes x `ring_mult`
##     (TdCombat.ward_enemy, refreshed). No more cloaks.
## In every phase, every `fissure_every` s a FISSURE opens under the post
## nearest him ahead (or on the road ahead): `fissure_count` circles across the
## road `fissure_gap` px apart (game.hostile.shell: `fissure_radius` px,
## `fissure_delay` s, towers `fissure_disable` s, bodies `fissure_damage`).
## vars: "stage", "cloak_until", "next_cloak", "next_ring", "next_fissure",
## "pose_until" (game s), "claiming" (bool), "ring" ([[TdEnemy, gen]]).
## Counted: events hades_cloaks, hades_rings, hades_fissures (claims: the rule).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["stage"] = 0
	e.vars["cloak_until"] = 0.0
	e.vars["next_cloak"] = game.time + float(a["cloak_first"])
	e.vars["next_ring"] = 0.0
	e.vars["next_fissure"] = game.time + float(a["fissure_every"]) * 0.5
	e.vars["pose_until"] = 0.0
	e.vars["claiming"] = false
	e.vars["ring"] = []


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if e.pose == 1 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	var cloaked := game.time < float(e.vars["cloak_until"])  # Hidden now.
	var alpha := float(PantheonActRules.look()["cloak_alpha"]) if cloaked else 1.0  # Drawn faint while hidden (TdEnemy vars "vis_alpha", visual only).
	if not is_equal_approx(float(e.vars.get("vis_alpha", 1.0)), alpha):
		e.vars["vis_alpha"] = alpha
		e.body.queue_redraw()
	var f := e.hp / e.max_hp  # HP fraction.
	var st := 0 if f > float(a["reclaim_hp"]) else (1 if f > float(a["lord_hp"]) else 2)  # Phase.
	if st != int(e.vars["stage"]):
		e.vars["stage"] = st
		e.vars["claiming"] = true
		if st == 2:
			e.vars["cloak_until"] = 0.0
			e.vars["next_ring"] = game.time
		game.banner(["", "The Reclaiming: every blocker that falls rises as a shade of Hades!", "Lord of the Dead: Hades raises his ring of wardens!"][st])
		Sfx.play("wrath_fissure")
	if game.time < e.freeze_until or game.time < e.staggered_until:
		return
	if st < 2 and not cloaked and game.time >= float(e.vars["next_cloak"]):
		e.vars["next_cloak"] = game.time + float(a["cloak_every"])
		e.vars["cloak_until"] = game.time + float(a["cloak_time"])
		game.fx.spawn("spore_cloud", e.position, float(PantheonActRules.look()["cloak_d"]), 0.6)
		EnemyTrait.note(game, "hades_cloaks")
	if st == 2:
		var standing := _ring_alive(e)  # Wardens up.
		if standing == 0 and game.time >= float(e.vars["next_ring"]):
			e.vars["next_ring"] = game.time + float(a["ring_every"])
			_raise_ring(e, game, a)
			standing = _ring_alive(e)
		if standing >= int(a["ring_hold"]):
			TdCombat.ward_enemy(game, e, float(a["ring_mult"]), float(a["ring_refresh"]))
	if game.time >= float(e.vars["next_fissure"]):
		e.vars["next_fissure"] = game.time + float(a["fissure_every"])
		_fissure(e, game, a)


## Raises his ring of wardens on his road around him.
func _raise_ring(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var r := e.follower.road  # His road.
	var n := int(a["ring_count"])  # Wardens.
	for i in n:
		var d := clampf(e.follower.dist - float(a["ring_back"]) + (float(a["ring_back"]) + float(a["ring_ahead"])) * float(i) / maxf(float(n - 1), 1.0), 0.0, r.length - 10.0)  # Its place on the road.
		var w := game.waves.spawn_extra(String(a["ring_kind"]), r.id, d, (float(i % 2) - 0.5) * float(a["ring_gap"]))
		if w != null:
			(e.vars["ring"] as Array).append([w, w.generation])
			game.fx.spawn("summon_rise", w.position, float(PantheonActRules.look()["rise_d"]), 0.5)
	_pose(e, game, a)
	EnemyTrait.note(game, "hades_rings")


## His wardens still standing.
func _ring_alive(e: TdEnemy) -> int:
	var n := 0  # Standing.
	for w: Array in e.vars["ring"]:
		n += 1 if TdEnemy.valid(w[0], int(w[1])) else 0
	return n


## Opens a fissure across the road at the nearest post ahead of him (else on the road ahead).
func _fissure(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var r := e.follower.road  # His road.
	var d := minf(e.follower.dist + float(a["fissure_ahead"]), r.length)  # Default: ahead of him.
	var best := INF  # Nearest post ahead (px along the road).
	for blk: RoadBlock in game.blocks:
		if blk.road_id == r.id and blk.dist >= e.follower.dist and blk.dist - e.follower.dist < best:
			best = blk.dist - e.follower.dist
			d = blk.dist
	var p := r.point_at(d)  # Fissure centre.
	var dir := r.dir_at(d)  # Road direction there.
	var nrm := Vector2(dir.y, -dir.x)  # Across the road.
	var n := int(a["fissure_count"])  # Circles.
	for i in n:
		game.hostile.shell(p + nrm * (float(i) - float(n - 1) * 0.5) * float(a["fissure_gap"]), float(a["fissure_radius"]), float(a["fissure_delay"]),
				float(a["fissure_disable"]), "shelled", float(a["fissure_damage"]))
	_pose(e, game, a)
	EnemyTrait.note(game, "hades_fissures")
	Sfx.play("wrath_fissure")


## The bident sweep (pose 1) for `pose_time` s (drawn only).
func _pose(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	e.pose = 1
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()


func on_death(e: TdEnemy, game: TdGame) -> void:
	e.vars["claiming"] = false
	game.banner("Hades kneels and gives up his crown: the Underworld is yours")
