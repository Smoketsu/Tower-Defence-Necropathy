## The Gardener of Roots (World-Tree miniboss; Necropathy's
## GardenerOfRootsKit, "the roots answer his call in any season"): every
## `every` s (first `first` s after he arrives) he presses his root-hands into
## the earth for `windup` s (a bark ring), then the roots rise: every tower
## within `radius` px is rooted `root` s (TdCombat.disable_tower, cause
## "rooted") and `seeds` thickets sprout on the nearest built spots within
## `plant_radius` px (the act rule's plant(), in any season: a tap burns them).
## Not while frozen or silenced.
## Args: first, every, windup, root (s), radius, plant_radius (px), seeds.
## vars: "next", "at" (game s the roots rise; 0 = none).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/wild/wild_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["at"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	var at := float(e.vars["at"])
	if at > 0.0:
		if game.time >= at:
			e.vars["at"] = 0.0
			Kit.stop_towers(game, e.position, float(a["radius"]), float(a["root"]), "rooted", false)
			Kit.plant_near(game, e.position, float(a["plant_radius"]), int(a["seeds"]), 1.0)
			Kit.ring(game, e.position, float(a["radius"]), 0.5, Kit.lk()["root_tint"], true)
			game.fx.spawn("wild_bury", e.position, float(a["radius"]) * 1.6, 0.6, Kit.lk()["root_tint"])
			EnemyTrait.note(game, "gardener_roots")
			Sfx.play("roots_grab")
		return
	if game.time >= float(e.vars["next"]) and game.time >= e.freeze_until and game.time >= e.silenced_until:
		e.vars["next"] = game.time + float(a["every"])
		e.vars["at"] = game.time + float(a["windup"])
		Kit.ring(game, e.position, float(a["radius"]), float(a["windup"]), Kit.lk()["root_tint"], false)


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("The Gardener of Roots falls: his roots wither")
