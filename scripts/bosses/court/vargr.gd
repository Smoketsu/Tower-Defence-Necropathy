## Vargr, the Moon-Eater (Ravensmoor's boss; Necropathy BossVargr), road
## version. Three phases by his HP:
##   THE HUNT (100% to phase2_hp): every `lunge_every` s (first after
##     `lunge_first`) he crouches `lunge_windup` s (pose 1, a red mark where he
##     will land), breaks free of any post and LEAPS `lunge_jump` px down the
##     road, biting the weakest blocker body within `lunge_reach` px for
##     `lunge_damage` (a feeding bite: he heals `feed` of it).
##   THE TURNING (phase2_hp to phase3_hp): he also HOWLS every `howl_every` s:
##     every werewolf within `howl_radius` px turns into the beast, and
##     `pack_count` `pack_kind` step out behind him already turned.
##   THE MOON-EATER (below phase3_hp): he swallows the moon: the Blood Moon
##     stays up until he falls (CourtKit.force_moon), he walks `p3_speed` x
##     faster, lunges every `lunge_every_p3` s, and every blow he lands on a
##     blocker feeds him `feed_p3` of it.
## Args in the act data file's "vargr" row. vars: "next_lunge", "lunge_at",
## "next_howl", "pose_until" (game s), "phase" (1..3).
extends EnemyTrait

## Shared Court helpers.
const CourtKit := preload("res://scripts/enemies/traits/court/court_kit.gd")
## The howl (Old Greymane's).
const Greymane := preload("res://scripts/enemies/traits/court/greymane.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["next_lunge"] = game.time + float(a["lunge_first"])
	e.vars["lunge_at"] = 0.0
	e.vars["next_howl"] = 0.0
	e.vars["pose_until"] = 0.0
	e.vars["phase"] = 1


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]) and float(e.vars["lunge_at"]) <= 0.0:
		e.pose = 0
		e.body.queue_redraw()
	var phase := 1 if e.hp > e.max_hp * float(a["phase2_hp"]) else (2 if e.hp > e.max_hp * float(a["phase3_hp"]) else 3)  # Phase now.
	if phase > int(e.vars["phase"]):
		e.vars["phase"] = phase
		if phase == 2:
			game.banner("Vargr howls: the Turning")
			e.vars["next_howl"] = game.time
		else:
			game.banner("Vargr swallows the moon!")
			e.speed = float(e.row["speed"]) * float(a["p3_speed"])
		EnemyTrait.note(game, "vargr_phase%d" % phase)
	if phase == 3:
		CourtKit.force_moon(game, game.time + 1.0)
	if game.time < e.freeze_until:
		return
	if float(e.vars["lunge_at"]) > 0.0 and game.time >= float(e.vars["lunge_at"]):
		e.vars["lunge_at"] = 0.0
		CourtKit.lunge(e, game, float(a["lunge_jump"]))
		var b := CourtKit.weakest_body(game, e.position, float(a["lunge_reach"]))  # His prey.
		if b != null:
			CourtKit.bite(game, e, b, float(a["lunge_damage"]), float(a["feed"]))
		game.vfx.shake(4.0)
		EnemyTrait.note(game, "vargr_lunges")
	elif float(e.vars["lunge_at"]) <= 0.0 and game.time >= float(e.vars["next_lunge"]):
		e.vars["next_lunge"] = game.time + float(a["lunge_every_p3"] if phase == 3 else a["lunge_every"])
		e.vars["lunge_at"] = game.time + float(a["lunge_windup"])
		_pose(e, game, 1, float(a["lunge_windup"]))
		var land := e.follower.road.point_at(minf(e.follower.dist + float(a["lunge_jump"]), e.follower.road.length))  # Where he lands.
		CourtKit.mark(game, land, float(a["lunge_reach"]), float(a["lunge_windup"]), CourtKit.tint("mark_tint"))
	if phase >= 2 and game.time >= float(e.vars["next_howl"]):
		e.vars["next_howl"] = game.time + float(a["howl_every"])
		Greymane.howl(e, game, float(a["howl_radius"]), 1.0, 0.1)
		for w: TdEnemy in CourtKit.call_out(game, e, String(a["pack_kind"]), int(a["pack_count"]), float(a["pack_gap"])):
			w.traits.call("turn", w, game)
		_pose(e, game, 1, float(a["pose_time"]))


## Shows pose `p` for `time` s (drawn only; the pose number is read by the body draw).
func _pose(e: TdEnemy, game: TdGame, p: int, time: float) -> void:
	e.pose = p
	e.vars["pose_until"] = game.time + time
	e.body.queue_redraw()


func on_attack(e: TdEnemy, game: TdGame, _body: BlockBody) -> void:
	if int(e.vars["phase"]) == 3:
		TdCombat.heal_enemy(game, e, float(e.row["damage"]) * e.damage_mult() * TdRulesData.BLOCKER_HIT_MULT * float(e.row["args"]["feed_p3"]))
