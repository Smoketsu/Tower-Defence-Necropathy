## Osiris, Lord of the Dead, and Ammit the Devourer (Hall of Two Truths boss;
## Necropathy's BossOsiris: one body and one health bar for the pair).
##   * OSIRIS (above `ammit_hp`) — THE WEIGHING: while he sits in judgment
##     every Name rises in `weigh_rise` of its time (the act rule's
##     set_rise_mult()). THE JUDGMENT: every `judge_every` s (first after
##     `judge_first`) he writes Heka glyphs on the `glyphs` highest-level
##     towers within `glyph_range` px (damage x `glyph_mult` for `glyph_time`
##     s, dynasty/heka's write()). THE COURT: every `court_every` s his court
##     steps out behind him (`court`: [kind, count] rows, `court_gap` px apart).
##   * AMMIT (below `ammit_hp`) — he gives the throne to the Devourer: her
##     sprite (`ammit_sprite`), x `ammit_speed` speed; every `eat_every` s she
##     eats every Name within `eat_reach` px (healing `eat_heal` per Name,
##     dynasty/devour's eat()), and every `charge_every` s a post holding her is
##     charged through (corsair/lunge's lunge_through(): `charge_damage`,
##     unholdable `charge_time` s at `charge_speed`). The Names' time returns.
## Args in his row. vars: "next_judge", "next_court", "next_eat", "next_charge",
## "pose_until" (game s), "ammit" (bool), "sprite" / TdEnemy draw override.
extends EnemyTrait

const Anubis := preload("res://scripts/bosses/dynasty/anubis.gd")
const Heka := preload("res://scripts/enemies/traits/dynasty/heka.gd")
const Devour := preload("res://scripts/enemies/traits/dynasty/devour.gd")
const Lunge := preload("res://scripts/enemies/traits/corsair/lunge.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["next_judge"] = game.time + float(a["judge_first"])
	e.vars["next_court"] = game.time + float(a["court_every"]) * 0.5
	e.vars["next_eat"] = 0.0
	e.vars["next_charge"] = 0.0
	e.vars["pose_until"] = 0.0
	e.vars["ammit"] = false
	var r := Anubis.rule(game)
	if r != null:
		r.call("set_rise_mult", float(a["weigh_rise"]))


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	if not bool(e.vars["ammit"]) and e.hp < e.max_hp * float(a["ammit_hp"]):
		_become_ammit(e, game, a)
	if game.time < e.freeze_until:
		return
	if bool(e.vars["ammit"]):
		if game.time >= float(e.vars["next_eat"]):
			e.vars["next_eat"] = game.time + float(a["eat_every"])
			EnemyTrait.note(game, "ammit_eaten", Devour.eat(e, game, float(a["eat_reach"]), float(a["eat_heal"])))
		if e.holder != null and game.time >= float(e.vars["next_charge"]):
			e.vars["next_charge"] = game.time + float(a["charge_every"])
			Lunge.lunge_through(e, game, float(a["charge_damage"]), float(a["charge_time"]), float(a["charge_speed"]))
			EnemyTrait.note(game, "ammit_charges")
		return
	if game.time >= float(e.vars["next_judge"]):
		e.vars["next_judge"] = game.time + float(a["judge_every"])
		var near: Array[Tower] = []  # Towers in his sight.
		var gr := float(a["glyph_range"])
		for t: Tower in game.towers:
			if t.position.distance_squared_to(e.position) <= gr * gr:
				near.append(t)
		near.sort_custom(func(x: Tower, y: Tower) -> bool: return x.level > y.level or (x.level == y.level and x.damage_done > y.damage_done))
		for i in mini(int(a["glyphs"]), near.size()):
			Heka.write(game, near[i], float(a["glyph_mult"]), float(a["glyph_time"]))
		_pose(e, game, a)
		EnemyTrait.note(game, "osiris_judgments")
	if game.time >= float(e.vars["next_court"]):
		e.vars["next_court"] = game.time + float(a["court_every"])
		var k := 0
		for row: Array in a["court"]:
			for i in int(row[1]):
				k += 1
				var d := maxf(e.follower.dist - float(a["court_gap"]) * float(k), 0.0)  # Behind him.
				game.waves.spawn_extra(String(row[0]), e.follower.road.id, d, e.follower.lane + float(k % 2 * 2 - 1) * 8.0)
		_pose(e, game, a)
		EnemyTrait.note(game, "osiris_courts")


## Osiris gives the throne to Ammit.
func _become_ammit(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	e.vars["ammit"] = true
	e.vars["sprite"] = String(a["ammit_sprite"])
	e.speed *= float(a["ammit_speed"])
	e.body.queue_redraw()
	var r := Anubis.rule(game)
	if r != null:
		r.call("set_rise_mult", 1.0)
	game.banner("The heart is heavy: Ammit the Devourer takes the throne!")
	game.fx.spawn("boss_death", e.position, 140.0, 0.8, Color(0.9, 0.35, 0.3))
	game.vfx.shake(4.0)
	EnemyTrait.note(game, "ammit_at", 1.0)


## His judgment pose for `pose_time` s (drawn only).
static func _pose(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	e.pose = 1
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()


func on_death(_e: TdEnemy, game: TdGame) -> void:
	var r := Anubis.rule(game)
	if r != null:
		r.call("set_rise_mult", 1.0)
