## The Fallen Seraph General (Pandemonium's miniboss; Necropathy
## SeraphGeneralKit): the JUDGMENT CLEAVE: while a post holds him, every
## `cleave_every` s he raises the burning greatsword `cleave_windup` s, then
## cuts every living body of that post for `cleave_damage`; the WINGS OF RUIN:
## every `feather_every` s (first after `feather_first`) burnt feathers fly at
## the `feathers` towers nearest him within `feather_range` px (game.hostile
## .fire: stopped by the first blocker on their line; a hit disables
## `feather_disable` s); the FALLEN HOST: once, at `host_hp` of his HP,
## `host_count` `host_kind` drop from above beside him (`host_gap` px apart
## behind him, `host_lane` px across the road). Args as named.
## vars: "next_cleave", "land", "next_feather", "host" (bool).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/inferno/inferno_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["next_cleave"] = game.time + float(a["cleave_every"]) * 0.5
	e.vars["land"] = 0.0
	e.vars["next_feather"] = game.time + float(a["feather_first"])
	e.vars["host"] = false


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	var lk: Dictionary = Acts.data("inferno")["LOOK"]
	if not bool(e.vars["host"]) and e.hp <= e.max_hp * float(a["host_hp"]):
		e.vars["host"] = true
		for k in int(a["host_count"]):
			game.waves.spawn_extra(String(a["host_kind"]), e.follower.road.id, maxf(e.follower.dist - float(a["host_gap"]) * float(k + 1), 0.0), (float(k) - 1.0) * float(a["host_lane"]))
		game.banner("The Fallen Host descends!")
		game.fx.spawn("seraph_dive", e.position, 160.0, 0.6, lk["fire_tint"])
		EnemyTrait.note(game, "seraph_host")
	if game.time < e.freeze_until:
		return
	if float(e.vars["land"]) > 0.0:
		if game.time >= float(e.vars["land"]):
			e.vars["land"] = 0.0
			for b: BlockBody in Kit.post_bodies(e):
				TdCombat.damage_body(game, b, float(a["cleave_damage"]) * e.damage_mult(), e)
			game.vfx.add(TdVfx.Kind.ANIM, e.position, float(lk["sweep_d"]) * 1.4, 0.45, lk["fire_tint"], "vael_cleave")
			game.vfx.shake(3.0)
			EnemyTrait.note(game, "seraph_cleaves")
	elif e.holder != null and game.time >= float(e.vars["next_cleave"]):
		e.vars["next_cleave"] = game.time + float(a["cleave_every"])
		e.vars["land"] = game.time + float(a["cleave_windup"])
		var ring := game.vfx.add(TdVfx.Kind.RING, e.position, float(lk["sweep_d"]) * 0.7, float(a["cleave_windup"]), lk["fire_tint"])
		if ring != null:
			ring.size0 = 10.0
	if game.time >= float(e.vars["next_feather"]):
		var ts := game.towers.filter(func(t: Tower) -> bool: return t.position.distance_to(e.position) <= float(a["feather_range"]))
		if ts.is_empty():
			return
		e.vars["next_feather"] = game.time + float(a["feather_every"])
		ts.sort_custom(func(x: Tower, y: Tower) -> bool: return x.position.distance_squared_to(e.position) < y.position.distance_squared_to(e.position))
		for t: Tower in ts.slice(0, int(a["feathers"])):
			game.hostile.fire(e.position + Vector2(0, -24), t, {"damage": 0.0, "disable": float(a["feather_disable"]), "cause": "shot", "speed": float(a["feather_speed"]), "look": "feather"})
		EnemyTrait.note(game, "seraph_feathers")
