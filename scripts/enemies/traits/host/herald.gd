## The Herald's trumpet (Necropathy's HeraldKit: "a trumpet blast that calls a
## squad and pushes the ring back"): every `every` s (first `first` s after it
## arrives) it raises the trumpet for `windup` s, then blasts: the posts whose
## spot lies within `radius` px are shaken (TdCombat.disable_tower, cause
## "stunned", `stun` s: their bodies stop striking) and it CALLS the next squad
## of `squads` (rows of [kind, count]; cycled) on the road just behind it,
## `gap` px apart; at most `calls` blasts. The Herald of the Seventh Trumpet
## uses the same kit with seven squads. Not while frozen or silenced.
## Args: first, every, windup (s), calls, squads, radius (px), stun (s), gap (px).
## vars: "next", "at" (game s the blast lands; 0 = none), "called" (count).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["at"] = 0.0
	e.vars["called"] = 0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if int(e.vars["called"]) >= int(a["calls"]):
		return
	var at := float(e.vars["at"])
	if at > 0.0:
		if game.time >= at:
			e.vars["at"] = 0.0
			_blast(e, game, a)
		return
	if game.time >= float(e.vars["next"]) and game.time >= e.freeze_until and game.time >= e.silenced_until:
		e.vars["next"] = game.time + float(a["every"])
		e.vars["at"] = game.time + float(a["windup"])
		var ring := game.vfx.add(TdVfx.Kind.RING, e.position, float(a["radius"]), float(a["windup"]), Acts.data("host")["LOOK"]["warn_tint"])
		if ring != null:
			ring.size0 = float(a["radius"]) * 0.95


## The blast: posts shaken, the next squad called (see the header).
func _blast(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var i := int(e.vars["called"])  # This blast.
	e.vars["called"] = i + 1
	for t: Tower in CovenantField.of(game).towers_near(e.position, float(a["radius"])):
		if String(t.row["spot"]) == "post":
			TdCombat.disable_tower(game, t, float(a["stun"]), "stunned")
	var squads: Array = a["squads"]
	var k := 0  # Units placed.
	for g: Array in squads[i % squads.size()]:
		for j in int(g[1]):
			k += 1
			var d := maxf(e.follower.dist - float(a["gap"]) * float(k), 0.0)  # Behind it on its road.
			game.waves.spawn_extra(String(g[0]), e.follower.road.id, d, e.follower.lane + float(k % 3 - 1) * 8.0)
	var lk: Dictionary = Acts.data("host")["LOOK"]
	var ring := game.vfx.add(TdVfx.Kind.RING, e.position, float(a["radius"]), 0.45, lk["trumpet_tint"])
	if ring != null:
		ring.size0 = 12.0
	game.fx.spawn("holy_impact", e.position, float(a["radius"]), 0.5, lk["trumpet_tint"])
	EnemyTrait.note(game, "trumpet_calls")
	Sfx.play("herald_blast")
