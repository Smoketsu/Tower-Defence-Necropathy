## The Trojan Horse (Scrap Wastes miniboss; Necropathy's TrojanKit: "a
## horse-shaped drone tank: rocket volleys your summons can intercept, a stomp,
## and badly damaged its hull splits open and a swarm of Scout Drones pours
## out"):
##   rocket volley — every `volley_every` s (first after `volley_first`) its pods
##                   fire `volley_count` Swarm Rockets at the nearest working
##                   towers within `volley_range` px (one each, round robin):
##                   straight Empire shots (`rocket`), so a post in the way eats them.
##   stomp         — held at a post, every `stomp_every` s its hooves come down on
##                   every body of that post for `stomp_damage`.
##   hull split    — once, below `split_hp` of its HP: the hull opens (sprite
##                   empire/trojan_horse_split) and `split_count` `split_kind`
##                   pour out around it; its volleys come `split_mult` x as often
##                   with `split_volley` rockets.
## Args in its row. vars: "next_volley", "next_stomp", "split".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/empire/empire_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["next_volley"] = game.time + float(a["volley_first"])
	e.vars["next_stomp"] = 0.0
	e.vars["split"] = false


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var lk: Dictionary = Acts.data("empire")["LOOK"]
	var split := bool(e.vars["split"])
	if not split and e.hp <= e.max_hp * float(a["split_hp"]):
		e.vars["split"] = true
		e.vars["sprite"] = "empire/trojan_horse_split"
		var r := e.follower.road  # Its road.
		for i in int(a["split_count"]):
			var d := clampf(e.follower.dist + float(i % 4 - 2) * 14.0, 0.0, r.length - 1.0)  # Around it.
			game.waves.spawn_extra(String(a["split_kind"]), r.id, d, float(i % 3 - 1) * 12.0)
		game.banner("The Trojan Horse's hull splits open: drones pour out!")
		game.vfx.add(TdVfx.Kind.ANIM, e.position, float(lk["blast_d"]), 0.6, Color.WHITE, "empire_blast")
		e.body.queue_redraw()
		EnemyTrait.note(game, "trojan_splits")
		Sfx.play("shield_break")
	if game.time < e.freeze_until:
		return
	if e.holder != null and game.time >= float(e.vars["next_stomp"]):
		e.vars["next_stomp"] = game.time + float(a["stomp_every"])
		for b: BlockBody in e.holder.block.bodies:
			if b.alive:
				TdCombat.damage_body(game, b, float(a["stomp_damage"]) * e.damage_mult(), e)
		game.vfx.add(TdVfx.Kind.ANIM, e.holder.pos, float(lk["stomp_d"]), 0.45, lk["stomp_tint"], "golem_slam")
		game.vfx.add(TdVfx.Kind.CRACK, e.holder.pos, 1.2, TdVfxData.CRACK_TIME, Color.WHITE)
		EnemyTrait.note(game, "trojan_stomps")
	if game.time < float(e.vars["next_volley"]) or game.time < e.staggered_until:
		return
	var ts := Kit.towers_near(game, e.position, float(a["volley_range"]))  # Towers in reach.
	if ts.is_empty():
		return
	e.vars["next_volley"] = game.time + float(a["volley_every"]) * (float(a["split_mult"]) if split else 1.0)
	var n := int(a["split_volley"] if split else a["volley_count"])  # Rockets now.
	for i in n:
		Kit.fire_at(game, e, ts[i % ts.size()], a["rocket"])
	EnemyTrait.note(game, "trojan_volleys")
	Sfx.play("rocket_launch")
