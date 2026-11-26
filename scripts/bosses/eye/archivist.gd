## The Archivist, Keeper of the Unwritten (Hollow Archive boss; Necropathy's
## BossArchivist, a robed figure whose face is an open book). Three phases by
## HP (`phase_hp`: [phase 2 from, phase 3 from] as HP shares):
##   Recitation — every `recite_every` s (`recite_every_p3` in phase 3; first
##                after `recite_first`) she stops and reads for `recite_cast` s
##                (pose 1), then `pages` pages (`pages_p3` in phase 3) fly at
##                the nearest towers within `page_range` px (game.hostile.fire,
##                look "page"): a tower a page reaches is inked (stunned
##                `page_disable` s); a blocker body on its path stops it and
##                takes `page_damage`.
##   Footnotes  — from phase 2, every `foot_every` s: a splitting glow for
##                `foot_cast` s (pose 2), then two copies (`copy_kind`, the
##                Footnote: no damage taken, shots on them wasted) walk beside
##                her, `foot_gap` px ahead and behind, for `foot_time` s.
##   Erasure    — in phase 3, every `erase_every` s the tower nearest her within
##                `erase_range` px is erased from the page: stunned
##                `erase_time` s (cause "inked") (pose 3).
## Args in her row. vars: "phase", "next_recite", "recite_at", "next_foot",
## "foot_at", "next_erase", "pose_until" (game s).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/eye/eye_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["phase"] = 1
	e.vars["next_recite"] = game.time + float(a["recite_first"])
	e.vars["recite_at"] = 0.0
	e.vars["next_foot"] = 0.0
	e.vars["foot_at"] = 0.0
	e.vars["next_erase"] = 0.0
	e.vars["pose_until"] = 0.0
	game.banner("The Archivist opens her book: every word read against you")


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]) and float(e.vars["recite_at"]) <= 0.0 and float(e.vars["foot_at"]) <= 0.0:
		e.pose = 0
		e.body.queue_redraw()
	var f := e.hp / e.max_hp  # HP share.
	var ph := 1 + (1 if f <= float(a["phase_hp"][0]) else 0) + (1 if f <= float(a["phase_hp"][1]) else 0)  # Phase now.
	if ph > int(e.vars["phase"]):
		e.vars["phase"] = ph
		e.vars["next_foot"] = game.time + 1.0
		e.vars["next_erase"] = game.time + 2.0
		game.banner(["", "", "The Footnotes: the Archivist writes copies of herself!", "The Last Page: the Archivist erases your towers from the book!"][ph])
	var ra := float(e.vars["recite_at"])
	if ra > 0.0:
		if game.time < ra:
			return
		e.vars["recite_at"] = 0.0
		Kit.walk(e)
		_pages(e, game, a, int(a["pages_p3"] if ph == 3 else a["pages"]))
		_pose(e, game, a, 3)
		return
	var fa := float(e.vars["foot_at"])
	if fa > 0.0:
		if game.time < fa:
			return
		e.vars["foot_at"] = 0.0
		Kit.walk(e)
		_footnotes(e, game, a)
		return
	if game.time < e.freeze_until:
		return
	if ph == 3 and game.time >= float(e.vars["next_erase"]):
		e.vars["next_erase"] = game.time + float(a["erase_every"])
		var t := Kit.nearest_tower(game, e.position, float(a["erase_range"]))
		if t != null:
			TdCombat.disable_tower(game, t, float(a["erase_time"]), "inked")
			Kit.line(game, e.position, t.position, 0.0, true, Acts.data("eye")["LOOK"]["ink_tint"])
			game.fx.spawn("ink_burst", t.position, 90.0, 0.5)
			_pose(e, game, a, 3)
			EnemyTrait.note(game, "eye_erasures")
	if game.time >= float(e.vars["next_recite"]):
		e.vars["next_recite"] = game.time + float(a["recite_every_p3" if ph == 3 else "recite_every"])
		e.vars["recite_at"] = game.time + float(a["recite_cast"])
		Kit.stand(e)
		_pose(e, game, a, 1)
		Kit.ring(game, e.position, 60.0, float(a["recite_cast"]), false, "", Acts.data("eye")["LOOK"]["magenta"])
		return
	if ph >= 2 and game.time >= float(e.vars["next_foot"]):
		e.vars["next_foot"] = game.time + float(a["foot_every"])
		e.vars["foot_at"] = game.time + float(a["foot_cast"])
		Kit.stand(e)
		_pose(e, game, a, 2)


## Recitation: `n` pages at the nearest towers in reach (one page each, then round again).
func _pages(e: TdEnemy, game: TdGame, a: Dictionary, n: int) -> void:
	var towers: Array[Tower] = []  # In reach, nearest first.
	for t: Tower in game.towers:
		if t.position.distance_to(e.position) <= float(a["page_range"]):
			towers.append(t)
	if towers.is_empty():
		return
	towers.sort_custom(func(x: Tower, y: Tower) -> bool: return x.position.distance_squared_to(e.position) < y.position.distance_squared_to(e.position))
	for i in n:
		game.hostile.fire(e.position + Vector2(0, -40), towers[i % towers.size()], {"speed": float(a["page_speed"]), "damage": float(a["page_damage"]),
				"disable": float(a["page_disable"]), "cause": "inked", "arc": false, "look": "page"})
	EnemyTrait.note(game, "eye_recitations")
	Sfx.play("bolt_cast")


## Footnotes: two copies beside her on her road.
func _footnotes(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var rd := e.follower.road  # Her road.
	for s: float in [1.0, -1.0]:
		var d := clampf(e.follower.dist + s * float(a["foot_gap"]), 0.0, rd.length - 1.0)  # Ahead / behind her.
		var c := game.waves.spawn_extra(String(a["copy_kind"]), rd.id, d, e.follower.lane + s * 10.0)
		if c != null:
			c.vars["until"] = game.time + float(a["foot_time"])
			game.fx.spawn("ink_burst", c.position, 90.0, 0.45)
	EnemyTrait.note(game, "eye_footnotes")
	Sfx.play("summon_rise")


## Shows pose `p` for `pose_time` s (drawn only).
func _pose(e: TdEnemy, game: TdGame, a: Dictionary, p: int) -> void:
	e.pose = p
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()


func on_death(e: TdEnemy, game: TdGame) -> void:
	for o: TdEnemy in game.enemies.duplicate():
		if o.alive and o.kind == String(e.row["args"]["copy_kind"]):
			game.remove_enemy(o, false)
	game.banner("The Archivist's book closes: the Unwritten stays unwritten")
