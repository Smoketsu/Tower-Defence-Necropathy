## Kage, Mistress of the Hidden Hand (Province boss; Necropathy's BossKage:
## "splits into shadow clones, only one is real, revealed by light; plants
## smoke fields"). Every `split_every` s (first after `split_first`;
## `split_every_p2` and `clones_p2` below `phase2_hp` of her HP) she splits:
## `clones` shadows of her (kind `clone_kind`, her very look) step out beside
## her on the road, `clone_gap` px apart. While any shadow stands and she is NOT
## in light (the Sun's Course's in_light(): day, or a lit lantern's pool) she
## takes only `hidden_mult` of every hit: relight the lanterns. Every
## `smoke_every` s (first after `smoke_first`) a smoke field blinds every tower
## within `smoke_radius` px for `smoke_blind` s. Her shadows fade when she falls.
## Args in her row. vars: "next_split", "next_smoke", "pose_until" (game s),
## "clones" ([[TdEnemy, generation], ...]).
extends EnemyTrait

const Ninja := preload("res://scripts/enemies/traits/shogunate/ninja.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["next_split"] = game.time + float(a["split_first"])
	e.vars["next_smoke"] = game.time + float(a["smoke_first"])
	e.vars["pose_until"] = 0.0
	e.vars["clones"] = []


## Her shadows still standing (prunes the fallen).
static func _live(e: TdEnemy) -> Array:
	var live: Array = (e.vars["clones"] as Array).filter(func(p: Array) -> bool: return TdEnemy.valid(p[0], int(p[1])))
	e.vars["clones"] = live
	return live


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	if game.time < e.freeze_until:
		return
	var p2 := e.hp < e.max_hp * float(a["phase2_hp"])  # Second phase.
	if game.time >= float(e.vars["next_split"]):
		e.vars["next_split"] = game.time + float(a["split_every_p2"] if p2 else a["split_every"])
		var live := _live(e)
		var lk: Dictionary = Acts.data("shogunate")["LOOK"]
		for i in int(a["clones_p2"] if p2 else a["clones"]):
			var side := float(i % 2 * 2 - 1)  # Behind / ahead in turn.
			var d := maxf(e.follower.dist + side * float(a["clone_gap"]) * float(i / 2 + 1), 0.0)  # Px along her road.
			var c := game.waves.spawn_extra(String(a["clone_kind"]), e.follower.road.id, d, e.follower.lane + side * 10.0)
			live.append([c, c.generation])
			game.fx.spawn("spore_cloud", c.position, float(lk["smoke_puff"]), 0.6, lk["smoke_tint"])
		e.vars["clones"] = live
		_pose(e, game, a)
		Sfx.play("kage_split")
		EnemyTrait.note(game, "kage_splits")
	if game.time >= float(e.vars["next_smoke"]):
		e.vars["next_smoke"] = game.time + float(a["smoke_every"])
		for t: Tower in game.towers.duplicate():
			if t.position.distance_to(e.position) <= float(a["smoke_radius"]):
				TdCombat.disable_tower(game, t, float(a["smoke_blind"]), "blinded")
		game.fx.spawn("spore_cloud", e.position, float(a["smoke_radius"]) * 2.0, 0.9, Acts.data("shogunate")["LOOK"]["smoke_tint"])
		Sfx.play("smoke_puff")
		EnemyTrait.note(game, "kage_smokes")


## Shows her cast pose for `pose_time` s (drawn only).
func _pose(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	e.pose = 1
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, _hit: Dictionary) -> float:
	var s := Ninja.sun(game)  # The act rule (light).
	if _live(e).is_empty() or (s != null and bool(s.call("in_light", e.position))) or s == null:
		return amount
	EnemyTrait.note(game, "kage_hidden_hits")
	return amount * float(e.row["args"]["hidden_mult"])


func on_death(e: TdEnemy, game: TdGame) -> void:
	for p: Array in _live(e):
		var c: TdEnemy = p[0]
		game.fx.spawn("spore_cloud", c.position, 60.0, 0.6, Acts.data("shogunate")["LOOK"]["smoke_tint"])
		game.remove_enemy(c, false)
