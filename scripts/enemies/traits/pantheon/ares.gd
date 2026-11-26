## Ares, God of War (Mount Olympus miniboss, the Pantheon Trial; Necropathy's
## AresKit: "war-cry buffs every enemy on screen; charges with a spear; dies to
## blockers"). Two specials:
##   WAR-CRY — every `cry_every` s (first after `cry_first`) every other foe
##     within `cry_radius` px (not bosses / minibosses) is hasted x `cry_speed`
##     and warded x `cry_ward` for `cry_time` s (TdCombat.haste_enemy /
##     ward_enemy); a red ring shows its real reach.
##   SPEAR CHARGE — once a post holds him, every `charge_every` s (first after
##     `charge_first`) the body holding him takes `charge_damage` (x his
##     weaken), he breaks free and runs on x `charge_speed` for `charge_time`
##     s, unholdable; at most `charges` times (then he dies to the blockers).
## vars: "next_cry", "next_charge" (game s), "charged" (count). Counted: events
## ares_cries, ares_charges.
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["next_cry"] = game.time + float(a["cry_first"])
	e.vars["next_charge"] = game.time + float(a["charge_first"])
	e.vars["charged"] = 0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < e.freeze_until or game.time < e.staggered_until:
		return
	var a: Dictionary = e.row["args"]  # His numbers.
	if game.time >= float(e.vars["next_cry"]):
		e.vars["next_cry"] = game.time + float(a["cry_every"])
		for o: TdEnemy in game.foes_near(e.position, float(a["cry_radius"])):
			if o == e or o.row["rank"] == "boss" or o.row["rank"] == "miniboss":
				continue
			TdCombat.haste_enemy(game, o, float(a["cry_speed"]), float(a["cry_time"]))
			TdCombat.ward_enemy(game, o, float(a["cry_ward"]), float(a["cry_time"]))
		EnemyTrait.note(game, "ares_cries")
		Sfx.play("glory_gain")
		if game.vfx.on:
			var lk: Dictionary = PantheonActRules.look()
			var ring := game.vfx.add(TdVfx.Kind.RING, e.position, float(a["cry_radius"]), TdVfxData.RING_TIME * 2.0, lk["cry_tint"])
			if ring != null:
				ring.size0 = float(lk["ring_start"])
	if e.holder != null and int(e.vars["charged"]) < int(a["charges"]) and game.time >= float(e.vars["next_charge"]):
		e.vars["next_charge"] = game.time + float(a["charge_every"])
		e.vars["charged"] = int(e.vars["charged"]) + 1
		var b := e.holder  # The body he runs through.
		TdCombat.damage_body(game, b, float(a["charge_damage"]) * e.damage_mult(), e)
		if e.holder != null:
			e.holder.held.erase(e)
			e.holder = null
		e.unholdable_until = game.time + float(a["charge_time"])
		TdCombat.haste_enemy(game, e, float(a["charge_speed"]), float(a["charge_time"]))
		EnemyTrait.note(game, "ares_charges")
		game.fx.spawn("vael_cleave", b.pos, float(PantheonActRules.look()["charge_d"]), 0.4)
