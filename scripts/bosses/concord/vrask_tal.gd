## Vrask'Tal, the Hunt-Lord (Proving Moon boss; Necropathy's BossVraskTal /
## VraskTalData). Three phases by HP (`phase_hp`: [phase 2 from, phase 3 from]):
##   the Stalk       — CLOAKED while he walks (the Vrask cloak, cloak.gd: the
##                     towers cannot see him, a shimmer of `alpha`); a post
##                     holding him or a spell hit (`reveal` s) shows him. Every
##                     body his blows fell hangs a SKULL on his belt: each of
##                     his blows then strikes again for `skull_step` x his damage
##                     per skull (at most `skull_cap`).
##   the Duel        — he drops the cloak and every `leap_every` s (first
##                     `leap_first` s into the phase), unless frozen, he LEAPS
##                     `leap_dist` px down the road over the posts: a landing
##                     ring of `leap_radius` px for `leap_windup` s, then bodies
##                     there take `leap_damage` and towers there are stunned
##                     `leap_disable` s.
##   the Last Trophy — he arms the bomb on his wrist: kill him within
##                     `trophy_time` s (the HUD cue counts it down; vars
##                     "bomb_at") or it goes off where he stands: towers within
##                     `bomb_radius` px are stunned `bomb_disable` s and bodies
##                     there take `bomb_damage`. He walks `trophy_speed` x faster.
## Args in his row. vars: "phase", "skulls", "next_leap", "leap_at" (game s; 0 =
## none), "bomb_at" (game s; 0 = none), cloak.gd's "cloak_until" / "revealed_until" / "vis_alpha".
extends EnemyTrait

const Cloak := preload("res://scripts/enemies/traits/concord/cloak.gd")
const Kit := preload("res://scripts/enemies/traits/concord/concord_kit.gd")


func on_spawn(e: TdEnemy, _game: TdGame) -> void:
	e.vars["phase"] = 1
	e.vars["skulls"] = 0
	e.vars["next_leap"] = INF
	e.vars["leap_at"] = 0.0
	e.vars["bomb_at"] = 0.0
	e.vars["revealed_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	var f := e.hp / e.max_hp  # HP share.
	var ph := 1 + (1 if f <= float(a["phase_hp"][0]) else 0) + (1 if f <= float(a["phase_hp"][1]) else 0)  # Phase now.
	if ph > int(e.vars["phase"]):
		e.vars["phase"] = ph
		if ph == 2:
			game.banner("The Duel: Vrask'Tal drops his cloak and leaps over your posts!")
			e.vars["next_leap"] = game.time + float(a["leap_first"])
		else:
			game.banner("The Last Trophy: Vrask'Tal arms his wrist bomb. Kill him in time!")
			e.vars["bomb_at"] = game.time + float(a["trophy_time"])
			TdCombat.haste_enemy(game, e, float(a["trophy_speed"]), float(a["trophy_time"]))
		Sfx.play("beam_charge")
	Cloak.cloaked(e, game, float(a["alpha"]), ph == 1)
	if ph == 3 and float(e.vars["bomb_at"]) > 0.0 and game.time >= float(e.vars["bomb_at"]):
		e.vars["bomb_at"] = 0.0
		_detonate(e, game, a)
	var la := float(e.vars["leap_at"])
	if la > 0.0:
		if game.time >= la:
			e.vars["leap_at"] = 0.0
			_leap(e, game, a)
		return
	if ph >= 2 and game.time >= float(e.vars["next_leap"]) and game.time >= e.freeze_until:
		e.vars["next_leap"] = game.time + float(a["leap_every"])
		e.vars["leap_at"] = game.time + float(a["leap_windup"])
		e.vars["leap_d"] = _leap_px(e, float(a["leap_dist"]))
		Kit.warn(game, e.follower.road.point_at(e.follower.dist + float(e.vars["leap_d"])), float(a["leap_radius"]), float(a["leap_windup"]))
		e.pose = 1
		e.body.queue_redraw()


func on_hit(e: TdEnemy, game: TdGame, _amount: float, hit: Dictionary) -> void:
	Cloak.reveal_on_spell(e, game, hit, float(e.row["args"]["reveal"]))


func on_attack(e: TdEnemy, game: TdGame, body: BlockBody) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if not body.alive:
		if int(e.vars["skulls"]) < int(a["skull_cap"]):
			e.vars["skulls"] = int(e.vars["skulls"]) + 1
			EnemyTrait.note(game, "vrask_skulls")
		return
	var extra := float(e.row["damage"]) * float(a["skull_step"]) * float(e.vars["skulls"])  # The trophies' weight.
	if extra > 0.0:
		TdCombat.damage_body(game, body, extra * e.damage_mult() * TdRulesData.BLOCKER_HIT_MULT, e)


## Px he may leap from here (never off the end of the last road).
func _leap_px(e: TdEnemy, want: float) -> float:
	var rd := e.follower.road
	if rd.next_id != "":
		return minf(want, rd.length - e.follower.dist)  # Up to the join (the next road's tail is counted by the follower).
	return maxf(minf(want, rd.length - e.follower.dist - 60.0), 0.0)


## The leap lands (see the header).
func _leap(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	var d := float(e.vars.get("leap_d", 0.0))
	if d > 0.0:
		e.follower.advance(d)
		e.position = e.follower.position()
	e.unholdable_until = game.time + 0.4
	var r := float(a["leap_radius"])  # Px.
	for b: BlockBody in game.bodies_near(e.position, r):
		TdCombat.damage_body(game, b, float(a["leap_damage"]) * e.damage_mult(), e)
	for t: Tower in game.towers:
		if t.position.distance_to(e.position) <= r:
			TdCombat.disable_tower(game, t, float(a["leap_disable"]), "stunned")
	Kit.burst(game, e.position, r, Acts.data("concord")["LOOK"]["plasma"])
	e.pose = 0
	e.body.queue_redraw()
	EnemyTrait.note(game, "vrask_leaps")
	Sfx.play("burrow_rumble")


## The trophy bomb goes off (see the header).
func _detonate(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var r := float(a["bomb_radius"])  # Px.
	for b: BlockBody in game.bodies_near(e.position, r):
		TdCombat.damage_body(game, b, float(a["bomb_damage"]), e)
	for t: Tower in game.towers:
		if t.position.distance_to(e.position) <= r:
			TdCombat.disable_tower(game, t, float(a["bomb_disable"]), "shelled")
	Kit.burst(game, e.position, r, Acts.data("concord")["LOOK"]["bomb_tint"], "corpse_explosion")
	game.vfx.shake(4.0)
	game.banner("The trophy bomb goes off!")
	EnemyTrait.note(game, "trophy_bombs")
	Sfx.play("beam_fire")


func on_death(e: TdEnemy, game: TdGame) -> void:
	if float(e.vars.get("bomb_at", 0.0)) > game.time:
		EnemyTrait.note(game, "hunter_hunted")
		game.banner("The Hunter hunted: Vrask'Tal falls before his bomb")
	else:
		game.banner("Vrask'Tal falls: the Hunt is over")
