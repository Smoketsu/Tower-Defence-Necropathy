## The Siren of the Eye's song (Necropathy's SirenKit, "lures summons out of
## the ring"): every `every` s (first `first` s after she arrives), when a
## living blocker body stands within `radius` px, she stops and sings for
## `windup` s (a widening magenta ring; killing her cancels it), then every
## body within `radius` px is charmed for `time` s through the one charm path
## (TdCombat.charm_body: it lets go of what it holds and strikes its own post
## at `hit_mult` of its blow; a heal or a barrier breaks it). Args: first,
## every, windup (s), radius (px), time (s), hit_mult. vars: "next", "at".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/eye/eye_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["at"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	var at := float(e.vars["at"])
	if at > 0.0:
		if game.time < at:
			return
		e.vars["at"] = 0.0
		Kit.walk(e)
		var n := 0  # Bodies charmed.
		for b: BlockBody in game.bodies_near(e.position, float(a["radius"])):
			if not b.temporary:
				TdCombat.charm_body(game, b, float(a["time"]), float(a["hit_mult"]))
				n += 1
		Kit.ring(game, e.position, float(a["radius"]), 0.4, true, "abyssal_burst", Acts.data("eye")["LOOK"]["magenta"])
		EnemyTrait.note(game, "eye_songs")
		Sfx.play("banshee_wail")
		return
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until or game.bodies_near(e.position, float(a["radius"])).is_empty():
		return
	e.vars["next"] = game.time + float(a["every"])
	e.vars["at"] = game.time + float(a["windup"])
	Kit.stand(e)
	Kit.ring(game, e.position, float(a["radius"]), float(a["windup"]), false, "", Acts.data("eye")["LOOK"]["magenta"])
