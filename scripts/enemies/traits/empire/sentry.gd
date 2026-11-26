## Sentry Turret (Act XII; Necropathy's SentryKit, "a fixed gun emplacement,
## the one exception to 'enemies always advance'"): it is carried down the road
## until `stand` px along it, then PLANTS there (speed 0 for good) and keeps
## firing at towers like a shooter (the generic shooter.gd, its args) until it
## is destroyed. Also the Motherboard's turrets (stand 0: they plant where they
## are built). Args: stand (px along its road), plus every shooter arg.
## vars: "planted" (bool), plus the shooter's.
extends "res://scripts/enemies/traits/shooter.gd"


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	super(e, game)
	e.vars["planted"] = false


func step(e: TdEnemy, game: TdGame, dt: float) -> void:
	if not bool(e.vars["planted"]) and e.follower.dist >= float(e.row["args"]["stand"]):
		e.vars["planted"] = true
		e.speed = 0.0
		if e.holder != null:
			e.holder.held.erase(e)
			e.holder = null
		EnemyTrait.note(game, "sentries_planted")
		Sfx.play("turret_fire")
	super(e, game, dt)
