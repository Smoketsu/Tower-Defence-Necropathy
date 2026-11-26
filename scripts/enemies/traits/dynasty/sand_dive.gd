## Bastet Hunter (the Necropolis Dynasty; Necropathy's BastetHunterKit, "a
## fast duellist; vanishes into the sand and ambushes; area damage reveals
## her"): every `every` s (first after `first`) she dives into the sand for
## `time` s: no post can hold her (she slips out of one that does), she runs at
## `speed_mult`, and every tower hit deals only `hidden_mult` of itself; a
## SPELL hit (a SpellData source) lands in full and throws her out of the sand.
## A sand puff where she dives and where she is revealed; drawn faded while
## hidden (row tint through vars "tint"). Args: first, every, time, speed_mult,
## hidden_mult. vars: "next", "hidden_until" (game s).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["hidden_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if e.vars.has("tint") and game.time >= float(e.vars["hidden_until"]):
		_surface(e, game)
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until:
		return
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["next"] = game.time + float(a["every"])
	e.vars["hidden_until"] = game.time + float(a["time"])
	e.unholdable_until = game.time + float(a["time"])
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	TdCombat.haste_enemy(game, e, float(a["speed_mult"]), float(a["time"]))
	e.vars["tint"] = Acts.data("dynasty")["LOOK"]["hidden_tint"]
	e.body.queue_redraw()
	game.fx.spawn("spore_cloud", e.position, 60.0, 0.5, Acts.data("dynasty")["LOOK"]["sand"])
	EnemyTrait.note(game, "bastet_dives")


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, hit: Dictionary) -> float:
	if game.time >= float(e.vars.get("hidden_until", 0.0)):
		return amount
	if SpellData.SPELLS.has(String(hit.get("source", ""))):
		e.vars["hidden_until"] = 0.0
		e.unholdable_until = 0.0
		_surface(e, game)
		EnemyTrait.note(game, "bastet_reveals")
		return amount
	return amount * float(e.row["args"]["hidden_mult"])


## Out of the sand: her own look again.
static func _surface(e: TdEnemy, game: TdGame) -> void:
	e.vars.erase("tint")
	e.body.queue_redraw()
	game.fx.spawn("spore_cloud", e.position, 50.0, 0.4, Acts.data("dynasty")["LOOK"]["sand"])
