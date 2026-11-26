## The saucer's tractor beam (Act XIII's Abduction; Necropathy's SaucerKit and
## Abduction.lift()). A saucer flies its sky lane (the act rule spawns it);
## every `scan` s, while it has lifts left, it looks for the strongest tower
## within `reach` px of it (highest level, evolved first, then nearest; a post
## needs a living body; a tower already lifted or disabled is skipped). Found:
## it STOPS over it and a light cone grows from it to the target for `windup`
## s (the telegraph, drawn by the act's layer), then it LIFTS: a post loses its
## strongest living body (TdCombat.damage_body: it falls and comes back by its
## normal respawn), a plot tower is lifted out of the fight for `lift_time` s
## (TdCombat.disable_tower, cause "abducted"). It hovers `hold` s more, then
## flies on. Shot down, frozen or staggered during the windup: no lift. With
## `moves` false it never moves (the Harvester's reap emitters) and lifts again
## every `every` s. Args: reach (px), windup (s), hold (s), lift_time (s),
## lifts (per saucer), moves (bool), scan (s), every (s, standing emitters).
## vars: "next_scan", "beam_at" (game s it lifts; 0 = not beaming),
## "beam_from" (game s the cone began), "target" (Tower), "target_pos" (map px),
## "hold_until" (game s), "lifts" (done), "base_speed" (px/s, restored after),
## "priority_until" (game s: "first" towers turn on it while it beams).
extends EnemyTrait

const Abduction := preload("res://scripts/maps/rules/concord/abduction.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_scan"] = game.time + float(e.row["args"]["scan"])
	e.vars["beam_at"] = 0.0
	e.vars["beam_from"] = 0.0
	e.vars["hold_until"] = 0.0
	e.vars["lifts"] = 0
	e.vars["base_speed"] = -1.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if float(e.vars["base_speed"]) < 0.0:
		e.vars["base_speed"] = e.speed  # After any act-rule tier (on_spawn order).
	if game.time < float(e.vars["hold_until"]):
		return
	var at := float(e.vars["beam_at"])  # When the lift lands (0 = not beaming).
	if at > 0.0:
		var t: Tower = e.vars.get("target")
		if not is_instance_valid(t) or not game.towers.has(t) or game.time < e.freeze_until or game.time < e.staggered_until:
			_end_beam(e, game)
			var rule := Abduction.of(game)
			if rule != null:
				rule.call("note_cancel")
			EnemyTrait.note(game, "saucer_beams_cut")
			return
		if game.time >= at:
			_lift(e, game, t, a)
		return
	e.speed = float(e.vars["base_speed"]) if bool(a["moves"]) else 0.0
	if int(e.vars["lifts"]) >= int(a["lifts"]) or game.time < float(e.vars["next_scan"]) or game.time < e.freeze_until:
		return
	e.vars["next_scan"] = game.time + float(a["scan"])
	var best: Tower = null  # Its pick.
	var score := -INF  # The pick's score.
	for t: Tower in game.towers:
		var d := e.position.distance_to(t.position)  # Px.
		if d > float(a["reach"]) or game.time < t.disabled_until:
			continue
		if t.block != null and not t.block.bodies.any(func(b: BlockBody) -> bool: return b.alive):
			continue
		var s := float(t.level) * 100.0 + (300.0 if t.evolution != "" else 0.0) - d  # Strongest first, then nearest.
		if s > score:
			score = s
			best = t
	if best == null:
		return
	e.vars["target"] = best
	e.vars["target_pos"] = best.position
	e.vars["beam_from"] = game.time
	e.vars["beam_at"] = game.time + float(a["windup"])
	e.vars["priority_until"] = e.vars["beam_at"]  # The towers in reach turn on it (TdRulesData.PRIORITY_BONUS).
	e.speed = 0.0
	EnemyTrait.note(game, "saucer_beams")
	Sfx.play("tractor_beam")


## Lifts tower `t` (see the header).
func _lift(e: TdEnemy, game: TdGame, t: Tower, a: Dictionary) -> void:
	var rule := Abduction.of(game)  # The act rule (null off-act: counted as events only).
	if t.block != null:
		var best: BlockBody = null  # Its strongest living body.
		for b: BlockBody in t.block.bodies:
			if b.alive and (best == null or b.hp > best.hp):
				best = b
		if best != null:
			TdCombat.damage_body(game, best, (best.hp + maxf(best.barrier, 0.0)) / maxf(1.0 - best.damage_cut, 0.05) + 1.0, e)
			EnemyTrait.note(game, "abducted_bodies")
			if rule != null:
				rule.call("note_lift", t, true, 0.0)
	else:
		TdCombat.disable_tower(game, t, float(a["lift_time"]), "abducted")
		EnemyTrait.note(game, "abducted_towers")
		if rule != null:
			rule.call("note_lift", t, false, float(a["lift_time"]))
	e.vars["lifts"] = int(e.vars["lifts"]) + 1
	e.vars["beam_at"] = 0.0
	e.vars["hold_until"] = game.time + float(a["hold"])
	e.vars["next_scan"] = game.time + float(a.get("every", a["scan"]))
	game.fx.spawn("beam_hit", t.position + Vector2(0, -16), 84.0, 0.5, Acts.data("concord")["LOOK"]["plasma"])
	Sfx.play("abduction")


## Ends a beam that did not lift.
func _end_beam(e: TdEnemy, game: TdGame) -> void:
	e.vars["beam_at"] = 0.0
	e.vars["priority_until"] = 0.0
	e.vars["next_scan"] = game.time + float(e.row["args"]["scan"])
