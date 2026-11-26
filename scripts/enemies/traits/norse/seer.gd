## Seer (Act VI; Necropathy's SeerKit: she "DOUSES the braziers she passes; a
## CURSE that blinds one summon a while"): while she walks she douses the first
## lit brazier within `douse_radius` px (the Long Winter's douse_near(); one per
## seer), and every `curse_every` s (first after `curse_first`) she curses the
## nearest working tower within `curse_range` px: blinded `blind` s
## (TdCombat.disable_tower, cause "blinded"). Args: douse_radius, curse_first,
## curse_every, curse_range, blind. vars: "doused", "next_curse".
extends EnemyTrait

const LongWinter := preload("res://scripts/maps/rules/norse/long_winter.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_curse"] = game.time + float(e.row["args"]["curse_first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	douse_step(e, game, float(e.row["args"]["douse_radius"]))
	var a: Dictionary = e.row["args"]  # Her numbers.
	if game.time < float(e.vars["next_curse"]) or game.time < e.freeze_until:
		return
	var best: Tower = null  # Nearest working tower in reach.
	for t: Tower in game.towers:
		if game.time >= t.disabled_until and t.position.distance_to(e.position) <= float(a["curse_range"]) and (best == null or t.position.distance_squared_to(e.position) < best.position.distance_squared_to(e.position)):
			best = t
	if best == null:
		return
	e.vars["next_curse"] = game.time + float(a["curse_every"])
	TdCombat.disable_tower(game, best, float(a["blind"]), "blinded")
	EnemyTrait.note(game, "seer_curses")
	if game.vfx.on:
		var f := game.vfx.add(TdVfx.Kind.STREAK, best.position, 6.0, 0.3, Color(0.75, 0.7, 1.0, 0.9))
		if f != null:
			f.ang = (best.position - e.position).angle()
			f.size0 = e.position.distance_to(best.position)


## Douses the first lit brazier within `radius` px of `e` (once per douser; the frost giant shares it).
static func douse_step(e: TdEnemy, game: TdGame, radius: float) -> void:
	var w := LongWinter.of(game)  # The act rule.
	if w != null and not e.vars.has("doused") and int(w.call("douse_near", e.position, radius)) > 0:
		e.vars["doused"] = true
		EnemyTrait.note(game, "braziers_doused")
