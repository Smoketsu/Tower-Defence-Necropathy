## The Brood Matriarch's egg sacs (Necropathy's BroodMatriarchKit: "spits egg
## sacs over the ring: they arc over it with a landing telegraph and land as
## Infestation eggs"): every `every` s (first `first` s after she arrives),
## unless frozen, she spits `sacs` egg sacs onto her road `ahead[i]` px in
## front of her; each shows a telegraph ring of `radius` px for `windup` s,
## then `hatch` foes of `kind` hatch there (ConcordKit.hatch()). Killing her
## stops the sacs not yet hatched. She flies (row "flying": no post holds her).
## Args: first, every, windup (s), sacs, ahead (px each), hatch, kind, radius (px).
## vars: "next" (game s), "sacs" ([game s, road id, px along it] pending).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/concord/concord_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["sacs"] = []


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	var sacs: Array = e.vars["sacs"]
	for i in range(sacs.size() - 1, -1, -1):
		if game.time >= float(sacs[i][0]):
			Kit.hatch(game, String(a["kind"]), game.roads[String(sacs[i][1])], float(sacs[i][2]), int(a["hatch"]))
			sacs.remove_at(i)
			EnemyTrait.note(game, "egg_sacs_hatched")
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until:
		return
	e.vars["next"] = game.time + float(a["every"])
	var rd := e.follower.road  # Her road.
	for i in mini(int(a["sacs"]), (a["ahead"] as Array).size()):
		var d := minf(e.follower.dist + float(a["ahead"][i]), rd.length - 20.0)  # Where it lands.
		sacs.append([game.time + float(a["windup"]), rd.id, d])
		Kit.warn(game, rd.point_at(d), float(a["radius"]), float(a["windup"]))
	e.vis_strike_at = game.time
	Sfx.play("acid_spit")
