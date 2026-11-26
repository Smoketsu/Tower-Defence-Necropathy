## Cerberus, the Hound of the Gates (Asphodel Underworld miniboss; Necropathy's
## CerberusKit: "three heads, three attacks, and each head must be killed on
## its own"). His heads are his HP in thirds: heads() = 3 while above 2/3, 2,
## then 1; a head falling is announced. THREE BITES: each blow on the post that
## holds him also bites up to heads() - 1 more living bodies of it (the same
## blow, through TdCombat.damage_body). FIRE BREATH: every `breath_every` s
## (first after `breath_first`) each head breathes on one of the towers nearest
## him within `breath_range` px: a telegraphed circle (game.hostile.shell:
## `breath_radius` px, after `breath_delay` s, disabling `breath_disable` s,
## bodies `breath_damage`). vars: "next_breath" (game s), "heads" (last count).
## Counted: events cerberus_bites, cerberus_breaths, cerberus_heads.
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_breath"] = game.time + float(e.row["args"]["breath_first"])
	e.vars["heads"] = 3


## Heads still up (3, 2, 1).
static func heads(e: TdEnemy) -> int:
	return clampi(ceili(e.hp / e.max_hp * 3.0), 1, 3)


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var h := heads(e)  # Heads now.
	if h < int(e.vars["heads"]):
		e.vars["heads"] = h
		game.banner("A head of Cerberus falls: %d left!" % h)
		EnemyTrait.note(game, "cerberus_heads")
		game.fx.spawn("boss_death", e.position, float(PantheonActRules.look()["head_d"]), 0.5)
	if game.time < float(e.vars["next_breath"]) or game.time < e.freeze_until or game.time < e.staggered_until:
		return
	var a: Dictionary = e.row["args"]  # His numbers.
	var r := float(a["breath_range"])  # Reach (px).
	var ts: Array[Tower] = []  # Towers in reach.
	for t: Tower in game.towers:
		if t.position.distance_squared_to(e.position) <= r * r and game.time >= t.disabled_until:
			ts.append(t)
	if ts.is_empty():
		return
	e.vars["next_breath"] = game.time + float(a["breath_every"])
	ts.sort_custom(func(x: Tower, y: Tower) -> bool: return x.position.distance_squared_to(e.position) < y.position.distance_squared_to(e.position))
	for t: Tower in ts.slice(0, h):
		game.hostile.shell(t.position, float(a["breath_radius"]), float(a["breath_delay"]), float(a["breath_disable"]), "shelled", float(a["breath_damage"]))
	EnemyTrait.note(game, "cerberus_breaths")
	Sfx.play("wrath_fissure")


func on_attack(e: TdEnemy, game: TdGame, body: BlockBody) -> void:
	if body.block == null:
		return
	var left := heads(e) - 1  # Extra bites this blow.
	var dmg := float(e.row["damage"]) * e.damage_mult() * TdRulesData.BLOCKER_HIT_MULT * float(TdRulesData.BLOCKER_HIT_RANK.get(e.row["rank"], 1.0))  # As his own blow.
	for b: BlockBody in body.block.bodies:
		if left <= 0:
			break
		if b != body and b.alive:
			TdCombat.damage_body(game, b, dmg, e)
			game.vfx.enemy_blow(e, b)
			left -= 1
			EnemyTrait.note(game, "cerberus_bites")
