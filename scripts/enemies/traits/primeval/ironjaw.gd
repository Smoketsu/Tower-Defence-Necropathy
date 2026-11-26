## Ironjaw, the Nest Mother (Fern Basin miniboss; Necropathy's IronjawKit): on
## arrival she lays her NEST `nest_ahead` px down her road, `nest_lane` px to
## its side (kind `nest_kind`, traits/primeval/nest.gd); while it stands she
## takes x`nest_ward` damage (a bone-white thread joins them): break it first.
## Held, every `bite_every` s (first after `bite_first`) she rears for `windup`
## s (a line through the post) and her IRON JAW lunges: the first `targets`
## living bodies of the post take `bite_damage` (x her weaken). Her nest falls
## when she does. Args: nest_kind, nest_ahead, nest_lane (px), nest_ward,
## bite_first, bite_every, windup (s), bite_damage, targets.
## vars: "nest", "nest_gen", "next_bite", "bite_at".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/primeval/kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]
	var rd := e.follower.road
	var n := game.waves.spawn_extra(String(a["nest_kind"]), rd.id, minf(float(a["nest_ahead"]), rd.length * 0.5), float(a["nest_lane"]))
	e.vars["nest"] = n
	e.vars["nest_gen"] = n.generation
	e.vars["next_bite"] = game.time + float(a["bite_first"])
	e.vars["bite_at"] = 0.0
	game.banner("Ironjaw lays her nest: break it, or she shrugs off your blows!")


## Her nest while it stands, else null.
static func nest_of(e: TdEnemy) -> TdEnemy:
	var n: TdEnemy = e.vars.get("nest", null)
	return n if TdEnemy.valid(n, int(e.vars.get("nest_gen", -1))) else null


func incoming_damage(e: TdEnemy, _game: TdGame, amount: float, _hit: Dictionary) -> float:
	return amount * float(e.row["args"]["nest_ward"]) if nest_of(e) != null else amount


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]
	var n := nest_of(e)
	if n != null and game.vfx.on and int(game.ticks) % 30 == 0:
		var f := game.vfx.add(TdVfx.Kind.THREAD, e.position, 3.0, 0.5, Kit.lk()["ward_tint"])
		if f != null:
			f.to = n.position
	var at := float(e.vars["bite_at"])
	if at > 0.0:
		if game.time < at:
			return
		e.vars["bite_at"] = 0.0
		if e.holder != null and game.time >= e.freeze_until:
			var k := 0
			var far := e.holder.pos
			for b: BlockBody in e.holder.block.bodies:
				if b.alive and k < int(a["targets"]):
					TdCombat.damage_body(game, b, float(a["bite_damage"]) * e.damage_mult(), e)
					far = b.pos
					k += 1
			Kit.line(game, e.position, far, 0.0, true)
			EnemyTrait.note(game, "ironjaw_bites")
			Sfx.play("boss_impact")
		return
	if e.holder != null and game.time >= float(e.vars["next_bite"]) and game.time >= e.freeze_until:
		e.vars["next_bite"] = game.time + float(a["bite_every"])
		e.vars["bite_at"] = game.time + float(a["windup"])
		Kit.line(game, e.position, e.holder.pos, float(a["windup"]), false)


func on_death(e: TdEnemy, game: TdGame) -> void:
	var n := nest_of(e)
	if n != null:
		game.fx.spawn("structure_break", n.position, 70.0, 0.5)
		game.remove_enemy(n, false)
	game.banner("Ironjaw falls: her nest lies cold")
