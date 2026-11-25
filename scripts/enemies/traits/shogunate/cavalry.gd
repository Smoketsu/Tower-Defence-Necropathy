## Cavalry charge (Kiba-musha and the General of the Left; Necropathy's
## KibaKit, "a horse is not stopped by a blocker"): every `charge_every` s
## (first after `charge_first`), once a post holds it, it charges: the body
## holding it takes `charge_damage` (x its weaken), it breaks free and gallops
## on at `speed_mult` for `charge_time` s, unholdable (TdEnemy.unholdable_until).
## Args: charge_first, charge_every, charge_time (s), speed_mult, charge_damage.
## vars: "next_charge" (game s).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_charge"] = game.time + float(e.row["args"]["charge_first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if e.holder == null or game.time < float(e.vars["next_charge"]) or game.time < e.freeze_until or game.time < e.staggered_until:
		return
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["next_charge"] = game.time + float(a["charge_every"])
	var b := e.holder  # The body it rides down.
	TdCombat.damage_body(game, b, float(a["charge_damage"]) * e.damage_mult(), e)
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	e.unholdable_until = game.time + float(a["charge_time"])
	TdCombat.haste_enemy(game, e, float(a["speed_mult"]), float(a["charge_time"]))
	EnemyTrait.note(game, "cavalry_charges")
	game.fx.spawn("vael_cleave", b.pos, float(Acts.data("shogunate")["LOOK"]["charge_d"]), 0.4)
	Sfx.play("taiko_hit")
