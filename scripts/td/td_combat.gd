## TdCombat: the one path for every damage, heal, status, kill and leak in a
## run (as Necropathy's CombatResolver, written small for the road). Towers,
## projectiles, spells, traits and bosses call these; nothing else changes an
## enemy's HP or a blocker body's HP. Also keeps the run's combat statistics
## (TdGame.stats) for the autotest summary.
class_name TdCombat
extends RefCounted


## Deals `amount` damage to enemy `e`. `hit` keys (all optional): source
## (tower class / spell id, for stats), tower (Tower that dealt it, for its
## kills), armour_pierce (flat armour ignored), dot (true for damage over
## time: armour does not apply), origin (map px the hit came from).
## Order: trait incoming_damage -> flat armour -> HP -> on_hit or kill.
## Returns the damage applied.
static func damage_enemy(game: TdGame, e: TdEnemy, amount: float, hit: Dictionary) -> float:
	if not e.alive or amount <= 0.0:
		return 0.0
	var dmg := amount  # Damage after every modifier.
	if e.traits != null:
		dmg = e.traits.incoming_damage(e, game, dmg, hit)
	if not bool(hit.get("dot", false)):
		var arm := maxf(e.armour - float(hit.get("armour_pierce", 0.0)), 0.0)  # Effective flat armour.
		dmg = maxf(dmg - arm, dmg * TdRulesData.ARMOUR_MIN_FRACTION)
		e.flash_until = game.time + TdRulesData.HIT_FLASH
		e.body.queue_redraw()
	dmg = minf(dmg, e.hp)
	e.hp -= dmg
	var src := String(hit.get("source", "?"))  # Stats key.
	game.stats["damage"][src] = float(game.stats["damage"].get(src, 0.0)) + dmg
	var tower: Tower = hit.get("tower", null)  # Dealer, if a tower.
	if tower != null:
		tower.damage_done += dmg
	e.queue_redraw()
	if e.hp <= 0.0:
		kill_enemy(game, e, tower)
	elif e.traits != null:
		e.traits.on_hit(e, game, dmg, hit)
	return dmg


## Kills enemy `e` (credited to `tower`, may be null): souls, ultimate charge,
## the trait's on_death, the chest for a miniboss, stats, then back to the pool.
static func kill_enemy(game: TdGame, e: TdEnemy, tower: Tower) -> void:
	if not e.alive:
		return
	var rank := String(e.row["rank"])  # fodder / elite / miniboss / boss.
	if e.traits != null:
		e.traits.on_death(e, game)
	game.economy.earn(int(EconomyData.KILL_SOULS[rank]), "kills")
	game.caster.charge(rank)
	if tower != null:
		tower.kills += 1
	game.stats["kills"][e.kind] = int(game.stats["kills"].get(e.kind, 0)) + 1
	if rank == "miniboss":
		game.grant_chest(e.position)
	game.fx.spawn("boss_death" if rank == "boss" else "enemy_death", e.position, 64.0 if rank == "fodder" else 128.0, 0.45)
	game.remove_enemy(e, false)


## Enemy `e` reached the gate: lives lost by rank (a boss ends the map).
static func leak(game: TdGame, e: TdEnemy) -> void:
	var lost := int(TdRulesData.LEAK_LIVES[String(e.row["rank"])])  # Lives lost (-1 = all).
	game.lose_lives(game.lives if lost < 0 else lost)
	game.stats["leaks"][e.kind] = int(game.stats["leaks"].get(e.kind, 0)) + 1
	game.remove_enemy(e, true)


## Slows `e` to `mult` (0..1) of its speed for `time` s (the stronger slow wins;
## a longer one extends). Mournsong-style duration bonuses would scale `time` here.
static func slow_enemy(game: TdGame, e: TdEnemy, mult: float, time: float) -> void:
	if game.time >= e.slow_until or mult <= e.slow_mult:
		e.slow_mult = mult
	e.slow_until = maxf(e.slow_until, game.time + time)


## Freezes `e` for `time` s (no movement, no attacks).
static func freeze_enemy(game: TdGame, e: TdEnemy, time: float) -> void:
	time *= float(TdRulesData.FREEZE_MULT[String(e.row["rank"])])
	e.freeze_until = maxf(e.freeze_until, game.time + time)
	e.body.queue_redraw()


## Weakens `e`: the damage it deals x `mult` (0..1) for `time` s.
static func weaken_enemy(game: TdGame, e: TdEnemy, mult: float, time: float) -> void:
	if game.time >= e.weaken_until or mult <= e.weaken_mult:
		e.weaken_mult = mult
	e.weaken_until = maxf(e.weaken_until, game.time + time)


## Hastes `e` to `mult` (>= 1) of its speed for `time` s (charges, banners).
static func haste_enemy(game: TdGame, e: TdEnemy, mult: float, time: float) -> void:
	if game.time >= e.haste_until or mult >= e.haste_mult:
		e.haste_mult = mult
	e.haste_until = maxf(e.haste_until, game.time + time)


## Puts a damage over time on `e`: `dps` damage per second for `time` s, credited to `source`.
static func add_dot(game: TdGame, e: TdEnemy, dps: float, time: float, source: String) -> void:
	e.dots.append([dps, game.time + time, source])


## Heals enemy `e` by `amount` HP (enemy healers).
static func heal_enemy(_game: TdGame, e: TdEnemy, amount: float) -> void:
	e.hp = minf(e.max_hp, e.hp + amount)
	e.queue_redraw()


## Deals `amount` damage to blocker body `b`; at 0 HP it falls, lets go of
## what it held and waits for its free respawn (Blocker behaviour).
static func damage_body(game: TdGame, b: BlockBody, amount: float) -> void:
	if not b.alive or amount <= 0.0:
		return
	b.hp -= amount
	b.flash_until = game.time + TdRulesData.HIT_FLASH
	game.stats["body_damage"] = float(game.stats["body_damage"]) + amount
	if b.hp <= 0.0:
		b.hp = 0.0
		b.alive = false
		b.release_all()
		b.respawn_at = game.time + b.respawn_time
		game.stats["bodies_lost"] = int(game.stats["bodies_lost"]) + 1
		game.fx.spawn("undead_death", b.pos, 64.0, 0.45)


## Heals blocker body `b` by `amount` HP (Mender auras).
static func heal_body(_game: TdGame, b: BlockBody, amount: float) -> void:
	if b.alive:
		b.hp = minf(b.max_hp, b.hp + amount)


## Brings fallen body `b` back at full HP (its respawn, or Dread Rally).
static func revive_body(game: TdGame, b: BlockBody) -> void:
	b.alive = true
	b.hp = b.max_hp
	game.fx.spawn("summon_rise", b.pos, 64.0, 0.4)
