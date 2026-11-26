## Shield-Maiden (Act VI; Necropathy's ShieldMaidenKit, "spear and shield; a
## SHIELD BASH that throws one summon back"): a hit from ahead of her takes
## `front_mult` of its damage (the Act I shield_front rule; `ignore` sources go
## round the shield), every `bash_every`-th blow on the body holding her is a
## shield bash that staggers it (no strike for `bash_stagger` s), and she is a
## warrior of the hall: Berserkergang below `at` of her HP (berserk.gd statics).
## Args: front_mult, ignore, at, speed_mult, damage_mult, shrug_slow,
## bash_every, bash_stagger. vars: "blows" (count) and berserk's.
extends "res://scripts/enemies/traits/shield_front.gd"

const Berserk := preload("res://scripts/enemies/traits/norse/berserk.gd")


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	Berserk.rage_step(e, game)


func on_attack(e: TdEnemy, game: TdGame, body: BlockBody) -> void:
	Berserk.rage_blow(e, game, body)
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["blows"] = int(e.vars.get("blows", 0)) + 1
	if body == null or not body.alive or int(e.vars["blows"]) % int(a["bash_every"]) != 0:
		return
	body.next_attack = maxf(body.next_attack, game.time + float(a["bash_stagger"]))
	EnemyTrait.note(game, "shield_bashes")
	if game.vfx.on:
		game.vfx.add(TdVfx.Kind.ANIM, body.pos + Vector2(0, -8), 44.0, TdVfxData.IMPACT_TIME, Color(1.0, 0.9, 0.6), "volley_hit")
