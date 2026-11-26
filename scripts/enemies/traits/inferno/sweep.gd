## Hell Knight's sweep (Necropathy HellKnightKit: "a burning greatsword, a
## telegraphed sweep in front of it"): while a post holds it, every `every` s
## it raises the blade for `windup` s (a fiery arc on the post), then cuts
## EVERY living body of that post for `damage` (TdCombat.damage_body).
## Frozen or staggered: no sweep. Args: every, windup (s), damage.
## vars: "next" (game s of the next windup), "land" (game s the raised blade
## falls, 0 = none).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/inferno/inferno_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["every"]) * 0.5
	e.vars["land"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if e.holder == null or game.time < e.freeze_until or game.time < e.staggered_until:
		e.vars["land"] = 0.0
		return
	if float(e.vars["land"]) > 0.0:
		if game.time < float(e.vars["land"]):
			return
		e.vars["land"] = 0.0
		for b: BlockBody in Kit.post_bodies(e):
			TdCombat.damage_body(game, b, float(a["damage"]) * e.damage_mult(), e)
		EnemyTrait.note(game, "knight_sweeps")
		if game.vfx.on:
			game.vfx.add(TdVfx.Kind.ANIM, e.holder.block.bodies[0].pos if not e.holder.block.bodies.is_empty() else e.position, float(Acts.data("inferno")["LOOK"]["sweep_d"]), 0.4, Acts.data("inferno")["LOOK"]["fire_tint"], "sentinel_sweep")
		return
	if game.time >= float(e.vars["next"]):
		e.vars["next"] = game.time + float(a["every"])
		e.vars["land"] = game.time + float(a["windup"])
		if game.vfx.on:
			var ring := game.vfx.add(TdVfx.Kind.RING, e.position, float(Acts.data("inferno")["LOOK"]["sweep_d"]) * 0.5, float(a["windup"]), Acts.data("inferno")["LOOK"]["fire_tint"])
			if ring != null:
				ring.size0 = 8.0
