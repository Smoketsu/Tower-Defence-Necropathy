## Arc Engineer (Act XII support; Necropathy's ArcEngineerKit: "repairs the
## machines around it and briefly JAMS the summons near it"): every
## `heal_every` s (not while silenced: EnemyTrait.can_heal) it repairs every
## other wounded enemy within `heal_radius` px by `heal` HP; every `jam_every`
## s (first after `jam_first`), unless frozen or staggered, an arc of static
## jams the nearest working tower within `jam_range` px for `jam_time` s
## (TdCombat.disable_tower, cause "jammed"). A priority target. Args: heal,
## heal_every, heal_radius, jam_first, jam_every, jam_range, jam_time.
## vars: "next_heal", "next_jam".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/empire/empire_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["next_heal"] = game.time + float(a["heal_every"])
	e.vars["next_jam"] = game.time + float(a["jam_first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if game.time >= float(e.vars["next_heal"]) and EnemyTrait.can_heal(e, game):
		e.vars["next_heal"] = game.time + float(a["heal_every"])
		var healed := false  # Anyone repaired.
		for o: TdEnemy in game.enemies_near(e.position, float(a["heal_radius"])):
			if o != e and o.hp < o.max_hp:
				TdCombat.heal_enemy(game, o, float(a["heal"]))
				healed = true
		if healed:
			game.fx.spawn("level_up", e.position, 60.0, 0.5, Acts.data("empire")["LOOK"]["arc_tint"])
			EnemyTrait.note(game, "arc_repairs")
	if game.time < float(e.vars["next_jam"]) or game.time < e.freeze_until or game.time < e.staggered_until:
		return
	var ts := Kit.towers_near(game, e.position, float(a["jam_range"]))  # Towers in reach.
	if ts.is_empty():
		return
	e.vars["next_jam"] = game.time + float(a["jam_every"])
	TdCombat.disable_tower(game, ts[0], float(a["jam_time"]), "jammed")
	EnemyTrait.note(game, "arc_jams")
	Sfx.play("arc_jam")
	if game.vfx.on:
		var f := game.vfx.add(TdVfx.Kind.THREAD, e.position + Vector2(0, -16), 10.0, 0.35, Acts.data("empire")["LOOK"]["arc_tint"])
		if f != null:
			f.to = ts[0].position + Vector2(0, -16)
