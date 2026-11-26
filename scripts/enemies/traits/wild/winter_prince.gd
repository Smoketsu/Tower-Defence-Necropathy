## The Winter Prince (Fae Court miniboss; Necropathy's WinterPrinceKit): his
## arrival brings `winter` s of Winter to the endless Summer (the act rule's
## set_override(); nothing off-act). Every `every` s (first `first` s after he
## arrives) he draws a frost breath for `windup` s (an ice ring), then freezes
## every tower within `radius` px for `freeze` s (TdCombat.disable_tower,
## cause "frozen"). Not while frozen or silenced.
## Args: winter, first, every, windup, freeze (s), radius (px).
## vars: "next", "at" (game s the breath lands; 0 = none).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/wild/wild_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["next"] = game.time + float(a["first"])
	e.vars["at"] = 0.0
	if game.act_rule != null and game.act_rule.has_method("set_override"):
		game.act_rule.call("set_override", 3, game.time + float(a["winter"]))
		game.banner("The Winter Prince rides in: a minute of winter at the Court!")


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	var at := float(e.vars["at"])
	if at > 0.0:
		if game.time >= at:
			e.vars["at"] = 0.0
			Kit.stop_towers(game, e.position, float(a["radius"]), float(a["freeze"]), "frozen", false)
			Kit.ring(game, e.position, float(a["radius"]), 0.5, Kit.lk()["frost_tint"], true)
			game.fx.spawn("frost_nova", e.position, float(a["radius"]) * 2.0, 0.6, Kit.lk()["frost_tint"])
			EnemyTrait.note(game, "frost_breaths")
			Sfx.play("blizzard")
		return
	if game.time >= float(e.vars["next"]) and game.time >= e.freeze_until and game.time >= e.silenced_until:
		e.vars["next"] = game.time + float(a["every"])
		e.vars["at"] = game.time + float(a["windup"])
		Kit.ring(game, e.position, float(a["radius"]), float(a["windup"]), Kit.lk()["frost_tint"], false)


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("The Winter Prince falls: the summer returns")
