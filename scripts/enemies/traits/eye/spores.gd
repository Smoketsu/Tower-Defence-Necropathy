## The Pilgrim of the Spore (Necropathy's SporePilgrimKit): every `every` s it
## leaves a spore cloud of `radius` px on the road where it walks for `life` s,
## and bursts into a bigger one (`death_radius`, `death_life`) when killed. The
## clouds live in the act rule (Claims.add_cloud(): bodies inside choke for
## `dps` per s); off the Eye's maps there are none. Args: every (s), radius
## (px), life (s), dps, death_radius (px), death_life (s). vars: "next".
extends EnemyTrait

const Claims := preload("res://scripts/maps/rules/eye/claims.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["every"]) * 0.5


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if game.time < float(e.vars["next"]):
		return
	e.vars["next"] = game.time + float(a["every"])
	var rule := Claims.of(game)  # The act rule (null off-act).
	if rule != null:
		rule.call("add_cloud", e.position, float(a["radius"]), float(a["life"]), float(a["dps"]))


func on_death(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]
	var rule := Claims.of(game)
	if rule != null:
		rule.call("add_cloud", e.position, float(a["death_radius"]), float(a["death_life"]), float(a["dps"]))
	game.fx.spawn("spore_cloud", e.position, float(a["death_radius"]) * 2.0, 0.6)
