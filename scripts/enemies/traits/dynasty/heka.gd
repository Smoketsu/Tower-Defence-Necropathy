## Heka Priest (the Necropolis Dynasty; Necropathy's HekaPriestKit, "writes a
## glyph on a summon; a gold sigil above it"): every `every` s (first after
## `first`), unless frozen or staggered, he writes a gold Heka glyph on the
## nearest tower within `range` px: its damage x `mult` for `time` s
## (TdCombat.suppress_tower). A glyph burst over the tower and the cast sound.
## Args: first, every, range, mult, time. vars: "next" (game s).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until or game.time < e.staggered_until:
		return
	var a: Dictionary = e.row["args"]  # His numbers.
	var best: Tower = null  # Nearest tower in reach.
	var rr := float(a["range"])
	for t: Tower in game.towers:
		var d := t.position.distance_squared_to(e.position)
		if d <= rr * rr and (best == null or d < best.position.distance_squared_to(e.position)):
			best = t
	if best == null:
		return
	e.vars["next"] = game.time + float(a["every"])
	write(game, best, float(a["mult"]), float(a["time"]))


## Writes a Heka glyph on tower `t`: damage x `mult` for `time` s, with its look
## (shared with Osiris' Judgment).
static func write(game: TdGame, t: Tower, mult: float, time: float) -> void:
	TdCombat.suppress_tower(game, t, mult, time)
	EnemyTrait.note(game, "heka_glyphs")
	var lk: Dictionary = Acts.data("dynasty")["LOOK"]
	game.fx.spawn("holy_impact", t.position + Vector2(0, -24), float(lk["glyph_d"]), 0.7, lk["gold"])
	Sfx.play("heka_glyph")
