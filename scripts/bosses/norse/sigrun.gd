## Sigrun, the Shield-Queen (Valgard boss; Necropathy's BossSigrun: "the Charge
## (spear dives on telegraphed lines), the Holmgang (a duel: a square of hazel
## rods closes round the two of them, and summons cannot enter), the Doors of
## the Hall (every Einherjar of the hall marches out at her side)").
##   THE CHARGE    — every `charge_every` s (first after `charge_first`) she
##                   lowers her spear for `charge_windup` s (a gold streak down
##                   the road ahead: the telegraph; her cast pose), then charges
##                   for `charge_time` s: let go by any post, unholdable, at
##                   `charge_speed` x her speed; every body within
##                   `charge_radius` px of her path takes `charge_damage` once.
##   THE HOLMGANG  — when her HP first falls below each share in `duel_at` she
##                   challenges the nearest road post within `duel_range` px: for
##                   `duel_time` s only that post's blows hurt her fully; every
##                   other hit (towers, spells) deals `duel_mult` of its damage.
##                   The Long Winter draws the hazel square round the post
##                   (set_duel()).
##   THE DOORS     — once below `doors_at` of her HP, `doors_count` Einherjar of
##                   `doors_kind` march out of the hall behind her, `doors_gap`
##                   px apart.
## Args in her row. vars: "phase" ("walk" | "windup" | "charge"), "until",
## "next_charge", "hit" (bodies struck this charge), "duels" (thresholds used),
## "duel_tower", "duel_until", "doors" (bool), "pose_until".
extends EnemyTrait

const LongWinter := preload("res://scripts/maps/rules/norse/long_winter.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["phase"] = "walk"
	e.vars["until"] = 0.0
	e.vars["next_charge"] = game.time + float(a["charge_first"])
	e.vars["hit"] = []
	e.vars["duels"] = 0
	e.vars["duel_tower"] = null
	e.vars["duel_until"] = 0.0
	e.vars["pose_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	var lk: Dictionary = Acts.data("norse")["LOOK"]
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]) and String(e.vars["phase"]) == "walk":
		e.pose = 0
		e.body.queue_redraw()
	_holmgang(e, game, a)
	if not bool(e.vars.get("doors", false)) and e.hp < e.max_hp * float(a["doors_at"]):
		e.vars["doors"] = true
		for i in int(a["doors_count"]):
			var d := maxf(e.follower.dist - float(a["doors_gap"]) * float(i + 1), 0.0)  # Px along her road.
			var c := game.waves.spawn_extra(String(a["doors_kind"]), e.follower.road.id, d, e.follower.lane + float(i % 3 - 1) * 10.0)
			game.fx.spawn("level_up", c.position, 50.0, 0.5, lk["rise_tint"])
		game.banner("The Doors of the Hall open: the Einherjar march at her side!")
		Sfx.play("horn_call")
		EnemyTrait.note(game, "sigrun_doors")
	match String(e.vars["phase"]):
		"walk":
			if game.time < float(e.vars["next_charge"]) or game.time < e.freeze_until:
				return
			e.vars["phase"] = "windup"
			e.vars["until"] = game.time + float(a["charge_windup"])
			e.speed = 0.0  # Plants her feet behind the shield.
			e.pose = 1
			e.body.queue_redraw()
			Sfx.play("boss_telegraph")
			if game.vfx.on:
				var to := e.follower.road.point_at(e.follower.dist + float(e.row["speed"]) * float(a["charge_speed"]) * float(a["charge_time"]))  # Where the charge ends.
				var f := game.vfx.add(TdVfx.Kind.STREAK, (e.position + to) * 0.5, float(lk["charge_w"]), float(a["charge_windup"]), Color(lk["charge_tint"], 0.45))
				if f != null:
					f.ang = (to - e.position).angle()
					f.size0 = e.position.distance_to(to)
		"windup":
			if game.time < float(e.vars["until"]):
				return
			if e.holder != null:
				e.holder.held.erase(e)
				e.holder = null
			e.speed = float(e.row["speed"])
			e.unholdable_until = game.time + float(a["charge_time"])
			TdCombat.haste_enemy(game, e, float(a["charge_speed"]), float(a["charge_time"]))
			e.vars["phase"] = "charge"
			e.vars["until"] = e.unholdable_until
			e.vars["hit"] = []
			e.pose = 2
			e.body.queue_redraw()
			Sfx.play("valkyrie_dive")
			EnemyTrait.note(game, "sigrun_charges")
		"charge":
			var hit: Array = e.vars["hit"]
			for b: BlockBody in game.bodies_near(e.position, float(a["charge_radius"])):
				if not hit.has(b):
					hit.append(b)
					TdCombat.damage_body(game, b, float(a["charge_damage"]) * e.damage_mult(), e)
					EnemyTrait.note(game, "sigrun_charge_hits")
					if game.vfx.on:
						var s := game.vfx.add(TdVfx.Kind.SLASH, b.pos, 70.0, TdVfxData.SLASH_TIME, lk["charge_tint"], "kit")
						if s != null:
							s.ang = e.follower.direction().angle()
			if game.time >= float(e.vars["until"]):
				e.vars["phase"] = "walk"
				e.vars["next_charge"] = game.time + float(a["charge_every"])
				e.pose = 0
				e.body.queue_redraw()


## The Holmgang: opens a duel at each `duel_at` share crossed, ends it in time.
func _holmgang(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var dt: Tower = e.vars["duel_tower"]
	if dt != null and (game.time >= float(e.vars["duel_until"]) or not game.towers.has(dt)):
		e.vars["duel_tower"] = null
		EnemyTrait.note(game, "sigrun_duels_ended")
	var used := int(e.vars["duels"])  # Thresholds crossed so far.
	var at: Array = a["duel_at"]
	if used >= at.size() or e.hp >= e.max_hp * float(at[used]):
		return
	e.vars["duels"] = used + 1
	var best: Tower = null  # Nearest road post in reach.
	for t: Tower in game.towers:
		if String(t.row["spot"]) == "post" and t.position.distance_to(e.position) <= float(a["duel_range"]) and (best == null or t.position.distance_squared_to(e.position) < best.position.distance_squared_to(e.position)):
			best = t
	if best == null:
		return
	e.vars["duel_tower"] = best
	e.vars["duel_until"] = game.time + float(a["duel_time"])
	var w := LongWinter.of(game)  # The act rule draws the square.
	if w != null:
		w.call("set_duel", best, float(e.vars["duel_until"]))
	game.banner("Holmgang! Sigrun challenges one post: only its blows bite")
	Sfx.play("horn_call")
	EnemyTrait.note(game, "sigrun_duels")


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, hit: Dictionary) -> float:
	var dt: Tower = e.vars.get("duel_tower", null)
	if dt == null or game.time >= float(e.vars["duel_until"]) or hit.get("tower", null) == dt:
		return amount
	EnemyTrait.note(game, "sigrun_duel_warded")
	return amount * float(e.row["args"]["duel_mult"])
