## The Stormwing's wing gust (Necropathy's StormwingKit: "a wing gust that
## pushes the ring; she lands to peck: hit her then"), also Thunderwing's: every
## `every` s (first after `first`) she beats her wings for `windup` s (a ring
## of the real reach), then THE GUST: every tower within `radius` px is stopped
## `disable` s (cause "stunned"). Then she LANDS for `land_time` s: slowed to
## `land_slow`, she takes x`land_mult` damage and is drawn as `land_sprite`
## (vars "sprite"; "" = her still). Args: first, every, windup (s), radius (px),
## disable, land_time (s), land_mult, land_slow, land_sprite.
## vars: "next", "at" (game s the gust lands; 0 = none), "landed_until".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/primeval/kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["at"] = 0.0
	e.vars["landed_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]
	if e.vars.has("sprite") and game.time >= float(e.vars["landed_until"]):
		e.vars.erase("sprite")
		e.body.queue_redraw()
	var at := float(e.vars["at"])
	if at > 0.0:
		if game.time >= at:
			e.vars["at"] = 0.0
			for t: Tower in CovenantField.of(game).towers_near(e.position, float(a["radius"])):
				TdCombat.disable_tower(game, t, float(a["disable"]), "stunned")
			Kit.ring(game, e.position, float(a["radius"]), 0.45, Kit.lk()["gust_tint"], true)
			e.vars["landed_until"] = game.time + float(a["land_time"])
			TdCombat.slow_enemy(game, e, float(a["land_slow"]), float(a["land_time"]))
			if String(a["land_sprite"]) != "":
				e.vars["sprite"] = String(a["land_sprite"])
				e.body.queue_redraw()
			EnemyTrait.note(game, "wing_gusts")
			Sfx.play("skyraider_dive")
		return
	if game.time >= float(e.vars["next"]) and game.time >= e.freeze_until:
		e.vars["next"] = game.time + float(a["every"])
		e.vars["at"] = game.time + float(a["windup"])
		Kit.ring(game, e.position, float(a["radius"]), float(a["windup"]), Color.WHITE, false)


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, _hit: Dictionary) -> float:
	return amount * float(e.row["args"]["land_mult"]) if game.time < float(e.vars.get("landed_until", 0.0)) else amount
