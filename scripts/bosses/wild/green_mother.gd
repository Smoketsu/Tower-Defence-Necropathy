## The Green Mother (World-Tree boss, the campaign's last; Necropathy's
## BossGreenMother). Three phases by HP (`phase_hp`: [phase 2 from, phase 3
## from] as HP shares):
##   the Turning    — on arriving and at each new phase she casts a season
##                    (pose 1): the act rule's set_override() forces the next
##                    season after the current one for `turn_time` s (Spring
##                    plants its thickets at once).
##   the Burial     — every `burial_every` s (first after `burial_first`) she
##                    presses her hands into the earth (pose 2) for
##                    `burial_windup` s, then buries the posts within
##                    `burial_radius` px: each is held in the earth
##                    `burial_time` s (TdCombat.disable_tower, cause "rooted":
##                    its bodies stop striking) and its bodies take
##                    `burial_damage` (x her weaken).
##   her call       — every `call_every` s the Wild rises behind her (squad
##                    `call`, `gap` px apart, WildKit.call_squad).
##   the Last Claim — phase 3: every `claim_every` s she claims the right of an
##                    earlier act for `claim_time` s, in turn, each through that
##                    act's own path, and takes `claim_mult` damage meanwhile:
##                    0 the Black Tide's broadside (game.hostile.shell on the
##                    `shells` towers nearest her: `shell_radius` px,
##                    `shell_delay` s, towers stopped `shell_disable` s, bodies
##                    `shell_damage`), 1 the Inferno's temptation
##                    (TdCombat.charm_body on the `charms` living bodies nearest
##                    her, `charm_time` s at `charm_mult`), 2 the Olympian
##                    Republic's claim (blocker bodies that fall meanwhile rise
##                    as `claim_kind`: the act rule's on_body_fallen() ->
##                    TdGame.spawn_from_body()).
## Not while frozen (the claims and the call run on). Args in her row. vars:
## "phase", "next_burial", "burial_at", "next_call", "next_claim",
## "claim_until", "claims" (count), "pose_until" (game s).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/wild/wild_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["phase"] = 1
	e.vars["next_burial"] = game.time + float(a["burial_first"])
	e.vars["burial_at"] = 0.0
	e.vars["next_call"] = game.time + float(a["call_every"])
	e.vars["next_claim"] = INF
	e.vars["claim_until"] = 0.0
	e.vars["claims"] = 0
	e.vars["pose_until"] = 0.0
	_turn(e, game, a)


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, _hit: Dictionary) -> float:
	return amount * float(e.row["args"]["claim_mult"]) if game.time < float(e.vars.get("claim_until", 0.0)) else amount


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]) and float(e.vars["burial_at"]) <= 0.0:
		e.pose = 0
		e.body.queue_redraw()
	var f := e.hp / e.max_hp  # HP share.
	var ph := 1 + (1 if f <= float(a["phase_hp"][0]) else 0) + (1 if f <= float(a["phase_hp"][1]) else 0)  # Phase now.
	if ph > int(e.vars["phase"]):
		e.vars["phase"] = ph
		_turn(e, game, a)
		if ph == 3:
			e.vars["next_claim"] = game.time + 1.0
			game.banner("The Last Claim: the Green Mother calls on every act you have broken!")
	if game.time >= float(e.vars["next_claim"]):
		e.vars["next_claim"] = game.time + float(a["claim_every"])
		_claim(e, game, a)
	if game.time >= float(e.vars["next_call"]):
		e.vars["next_call"] = game.time + float(a["call_every"])
		Kit.call_squad(e, game, a["call"], float(a["gap"]))
		game.fx.spawn("summon_rise", e.position, 100.0, 0.5, Kit.lk()["turn_tint"])
		EnemyTrait.note(game, "mother_calls")
	var at := float(e.vars["burial_at"])
	if at > 0.0:
		if game.time >= at:
			e.vars["burial_at"] = 0.0
			_bury(e, game, a)
		return
	if game.time >= float(e.vars["next_burial"]) and game.time >= e.freeze_until:
		e.vars["next_burial"] = game.time + float(a["burial_every"])
		e.vars["burial_at"] = game.time + float(a["burial_windup"])
		Kit.ring(game, e.position, float(a["burial_radius"]), float(a["burial_windup"]), Kit.lk()["burial_tint"], false)
		_pose(e, game, 2, float(a["burial_windup"]) + float(a["pose_time"]))


## The Turning: the next season, forced for `turn_time` s (see the header).
func _turn(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var rule: MapRule = game.act_rule if game.act_rule != null and game.act_rule.has_method("set_override") else null
	if rule != null:
		var s := (maxi(int(rule.get("season")), 0) + 1) % 4  # The next season.
		rule.call("set_override", s, game.time + float(a["turn_time"]))
		game.banner("The Turning: the Green Mother casts %s!" % String(Acts.data("wild")["RULE"]["names"][s]))
	Kit.ring(game, e.position, 140.0, 0.6, Kit.lk()["turn_tint"], true)
	game.fx.spawn("level_up", e.position, 160.0, 0.6, Kit.lk()["turn_tint"])
	_pose(e, game, 1, float(a["pose_time"]))
	EnemyTrait.note(game, "mother_turnings")


## The Burial lands (see the header).
func _bury(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var r := float(a["burial_radius"])
	for t: Tower in CovenantField.of(game).towers_near(e.position, r):
		if String(t.row["spot"]) != "post" or t.block == null:
			continue
		TdCombat.disable_tower(game, t, float(a["burial_time"]), "rooted")
		for b: BlockBody in t.block.bodies:
			if b.alive:
				TdCombat.damage_body(game, b, float(a["burial_damage"]) * e.damage_mult(), e)
		game.fx.spawn("wild_bury", t.position, 80.0, 0.6, Kit.lk()["burial_tint"])
	Kit.ring(game, e.position, r, 0.5, Kit.lk()["burial_tint"], true)
	game.vfx.shake(2.0)
	EnemyTrait.note(game, "mother_burials")
	Sfx.play("bury")


## One claim of the Last Claim, in turn (see the header).
func _claim(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var i := int(e.vars["claims"]) % 3  # Which claim.
	e.vars["claims"] = int(e.vars["claims"]) + 1
	e.vars["claim_until"] = game.time + float(a["claim_time"])
	var tint: Color = Kit.lk()["claim_tints"][i]
	match i:
		0:
			var near := CovenantField.of(game).towers_near(e.position, 2000.0)  # Every tower, nearest first.
			near.sort_custom(func(x: Tower, y: Tower) -> bool: return x.position.distance_squared_to(e.position) < y.position.distance_squared_to(e.position))
			for k in mini(int(a["shells"]), near.size()):
				game.hostile.shell(near[k].position, float(a["shell_radius"]), float(a["shell_delay"]), float(a["shell_disable"]), "shelled", float(a["shell_damage"]))
			game.banner("The Last Claim: the Black Tide's broadside!")
		1:
			var bodies: Array[BlockBody] = []  # Living bodies, nearest first.
			for blk: RoadBlock in game.blocks:
				for b: BlockBody in blk.bodies:
					if b.alive and not b.temporary:
						bodies.append(b)
			bodies.sort_custom(func(x: BlockBody, y: BlockBody) -> bool: return x.pos.distance_squared_to(e.position) < y.pos.distance_squared_to(e.position))
			for k in mini(int(a["charms"]), bodies.size()):
				TdCombat.charm_body(game, bodies[k], float(a["charm_time"]), float(a["charm_mult"]))
			game.banner("The Last Claim: the Inferno's temptation!")
		2:
			var rule: MapRule = game.act_rule if game.act_rule != null and game.act_rule.has_method("plant") else null
			if rule != null:
				rule.set("claim_until", game.time + float(a["claim_time"]))
				rule.set("claim_kind", String(a["claim_kind"]))
			game.banner("The Last Claim: the Underworld claims your fallen!")
	Kit.ring(game, e.position, 160.0, 0.6, tint, true)
	game.fx.spawn("level_up", e.position, 180.0, 0.6, tint)
	_pose(e, game, 1, float(a["pose_time"]))
	EnemyTrait.note(game, "mother_claims")
	Sfx.play("season_turn")


## Shows pose `p` for `time` s (drawn only).
func _pose(e: TdEnemy, game: TdGame, p: int, time: float) -> void:
	e.pose = p
	e.vars["pose_until"] = game.time + time
	e.body.queue_redraw()


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("The Green Mother falls: the year stops turning")
