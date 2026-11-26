## Lilim Witch (Necropathy LilimWitchKit): her PIT CURSE, every `pit_every` s
## (first after `pit_first`), opens a Hell Pit of `pit_radius` px under the
## living blocker body nearest her within `range` px (the act rule's
## open_pit(): `pit_telegraph` s of rim, `pit_life` s of fire); her PORTAL
## RITE, every `heal_every` s while an open portal stands within
## `portal_reach` px of her, heals every other enemy within `heal_radius` px of
## that portal by `heal` HP (TdCombat.heal_enemy; silenced: no rite,
## EnemyTrait.can_heal). Args as named. vars: "next_pit", "next_heal".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/inferno/inferno_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_pit"] = game.time + float(e.row["args"]["pit_first"])
	e.vars["next_heal"] = game.time + float(e.row["args"]["heal_every"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if game.time < e.freeze_until:
		return
	if game.time >= float(e.vars["next_pit"]):
		var b := Kit.nearest_body(game, e.position, float(a["range"]))  # Under whom the pit opens.
		if b != null and Kit.pit(game, b.pos, float(a["pit_radius"]), float(a["pit_life"]), float(a["pit_telegraph"])):
			e.vars["next_pit"] = game.time + float(a["pit_every"])
			EnemyTrait.note(game, "lilim_pits")
	var r := Kit.rule(game)  # The act rule.
	if r == null or game.time < float(e.vars["next_heal"]) or not EnemyTrait.can_heal(e, game):
		return
	for p: Dictionary in r.get("portals"):
		if String(p["state"]) != "open" or Vector2(p["at"]).distance_to(e.position) > float(a["portal_reach"]):
			continue
		e.vars["next_heal"] = game.time + float(a["heal_every"])
		for o: TdEnemy in game.foes_near(p["at"], float(a["heal_radius"])):
			if o != e:
				TdCombat.heal_enemy(game, o, float(a["heal"]))
		game.fx.spawn("level_up", p["at"], float(a["heal_radius"]) * 2.0, 0.5, Acts.data("inferno")["LOOK"]["charm_tint"])
		EnemyTrait.note(game, "lilim_rites")
		return
