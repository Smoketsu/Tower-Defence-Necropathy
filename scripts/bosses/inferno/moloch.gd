## Moloch, the Furnace King (the Burning Gate's boss; Necropathy BossMoloch:
## "he swallows summons (they come back burning, as his), vents fire waves,
## and cracks the arena into pits"):
##   SWALLOW — while a post holds him, every `swallow_every` s he swallows the
##     body holding him whole (TdCombat.damage_body for all it has: it falls
##     and comes back after its respawn) and it walks back out of his furnace
##     burning, as his: a `thrall` raised where it fell (game.spawn_from_body).
##   FIRE WAVE — every `wave_every` s (first after `wave_first`) he vents a
##     line of `wave_pits` Hell Pits on his road ahead of him (from
##     `wave_ahead` px, `wave_gap` px apart; the act rule's open_pit()).
##   CRACKS — below `crack_hp` of his HP (first `crack_first` s later), every `crack_every` s the ground
##     cracks under the `crack_count` towers nearest him (game.hostile.shell:
##     `crack_radius` px, `crack_delay` s, disabled `crack_disable` s).
## Pose 1 (the furnace roaring) for `pose_time` s on each. Args in his row.
## vars: "next_swallow", "next_wave", "next_crack", "cracking", "pose_until".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/inferno/inferno_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["next_swallow"] = game.time + float(a["swallow_every"]) * 0.5
	e.vars["next_wave"] = game.time + float(a["wave_first"])
	e.vars["next_crack"] = 0.0
	e.vars["cracking"] = false
	e.vars["pose_until"] = 0.0
	Sfx.play("moloch_roar")


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	if not bool(e.vars["cracking"]) and e.hp <= e.max_hp * float(a["crack_hp"]):
		e.vars["cracking"] = true
		e.vars["next_crack"] = game.time + float(a["crack_first"])
		game.banner("The Furnace King roars: the ground cracks under your towers!")
		Sfx.play("moloch_roar")
	if game.time < e.freeze_until:
		return
	if e.holder != null and e.holder.alive and game.time >= float(e.vars["next_swallow"]):
		e.vars["next_swallow"] = game.time + float(a["swallow_every"])
		var b := e.holder  # Swallowed whole.
		TdCombat.damage_body(game, b, b.hp + b.barrier + 1.0, e)
		game.spawn_from_body(String(a["thrall"]), b)
		game.fx.spawn("corpse_explosion", b.pos, 100.0, 0.5, Acts.data("inferno")["LOOK"]["fire_tint"])
		_pose(e, game, a)
		EnemyTrait.note(game, "moloch_swallows")
	if game.time >= float(e.vars["next_wave"]):
		e.vars["next_wave"] = game.time + float(a["wave_every"])
		var r := e.follower.road  # His road.
		for k in int(a["wave_pits"]):
			var d := e.follower.dist + float(a["wave_ahead"]) + float(a["wave_gap"]) * float(k)  # Px along his road.
			if d < r.length:
				Kit.pit(game, r.point_at(d), float(a["wave_radius"]), float(a["wave_life"]), float(a["wave_telegraph"]))
		_pose(e, game, a)
		EnemyTrait.note(game, "moloch_waves")
	if bool(e.vars["cracking"]) and game.time >= float(e.vars["next_crack"]):
		e.vars["next_crack"] = game.time + float(a["crack_every"])
		var ts := game.towers.duplicate()  # Towers, nearest him first.
		ts.sort_custom(func(x: Tower, y: Tower) -> bool: return x.position.distance_squared_to(e.position) < y.position.distance_squared_to(e.position))
		for t: Tower in ts.slice(0, int(a["crack_count"])):
			game.hostile.shell(t.position, float(a["crack_radius"]), float(a["crack_delay"]), float(a["crack_disable"]), "shelled")
		EnemyTrait.note(game, "moloch_cracks")


## Shows the roaring furnace for `pose_time` s (drawn only).
func _pose(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	e.pose = 1
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("Moloch falls: the Furnace King's fire goes out")
