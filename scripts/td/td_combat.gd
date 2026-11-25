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
## Order (one place, documented in DECISIONS): trait incoming_damage -> ward ->
## tower-only bonuses (synergy hit_mult, Gravebow curse) -> flat armour -> HP ->
## on_hit or kill.
## Returns the damage applied.
static func damage_enemy(game: TdGame, e: TdEnemy, amount: float, hit: Dictionary) -> float:
	if not e.alive or amount <= 0.0:
		return 0.0
	var dmg := amount  # Damage after every modifier.
	if e.traits != null:
		dmg = e.traits.incoming_damage(e, game, dmg, hit)
	if game.time < e.ward_until:
		dmg *= e.ward_mult
	var dealer: Tower = hit.get("tower", null)  # Tower that dealt it (curse and synergy hit bonuses).
	if dealer != null:
		dmg *= Synergies.hit_mult(dealer, e, game)
		if game.time < e.curse_until:
			dmg *= e.curse_mult
	if not bool(hit.get("dot", false)):
		var arm := maxf(e.armour - float(hit.get("armour_pierce", 0.0)) - shred_of(game, e), 0.0)  # Effective flat armour (Wither shreds it).
		dmg = maxf(dmg - arm, dmg * TdRulesData.ARMOUR_MIN_FRACTION)
		e.flash_until = game.time + TdRulesData.HIT_FLASH
		e.vis_hit_at = game.time  # Its hit squash (drawn only).
		e.body.queue_redraw()
	dmg = minf(dmg, e.hp)
	e.hp -= dmg
	if not bool(hit.get("dot", false)):
		game.vfx.number(e, dmg)  # Floating number when the setting is on (drawn only).
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
		if rank != "fodder":
			tower.vars["elite_kills"] = int(tower.vars.get("elite_kills", 0)) + 1  # Shadow Reaper's deed (gw2-kit).
	game.stats["kills"][e.kind] = int(game.stats["kills"].get(e.kind, 0)) + 1
	if rank == "miniboss":
		game.grant_chest(e.position)
	game.enemy_killed.emit(e, tower)
	CovenantField.record_death(game, e)
	game.vfx.death(e)
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
	if b.damage_cut > 0.0:
		amount *= 1.0 - b.damage_cut  # Bone Golem planted (gw2-kit).
	if b.barrier > 0.0 and game.time < b.barrier_until:
		var soak := minf(b.barrier, amount)  # Barrier absorbs first (gw2-kit).
		b.barrier -= soak
		amount -= soak
		game.stats["barrier_absorbed"] = float(game.stats.get("barrier_absorbed", 0.0)) + soak
		if amount <= 0.0:
			b.flash_until = game.time + TdRulesData.HIT_FLASH
			return
	b.hp -= amount
	b.flash_until = game.time + TdRulesData.HIT_FLASH
	game.stats["body_damage"] = float(game.stats["body_damage"]) + amount
	if b.hp <= 0.0:
		b.hp = 0.0
		b.alive = false
		b.release_all()
		b.respawn_at = game.time + b.respawn_time
		if not b.temporary:
			game.stats["bodies_lost"] = int(game.stats["bodies_lost"]) + 1
		game.fx.spawn("undead_death", b.pos, 64.0, 0.45)


## Heals blocker body `b` by `amount` HP (Mender auras, lifesteal); returns the HP restored.
static func heal_body(_game: TdGame, b: BlockBody, amount: float) -> float:
	if not b.alive:
		return 0.0
	var before := b.hp  # HP before the heal.
	b.hp = minf(b.max_hp, b.hp + amount)
	return b.hp - before


## Brings fallen body `b` back at full HP (its respawn, or Dread Rally).
static func revive_body(game: TdGame, b: BlockBody) -> void:
	b.alive = true
	b.hp = b.max_hp
	game.stats["bodies_respawned"] = int(game.stats.get("bodies_respawned", 0)) + 1
	b.vis_rise_at = game.time  # It climbs out of its bone pile (drawn only).
	game.fx.spawn("summon_rise", b.pos, 64.0, 0.4)


## Curses `e` (Gravebow): tower hits on it deal x `mult` (>= 1) for `time` s
## (the stronger curse wins; a longer one extends).
static func curse_enemy(game: TdGame, e: TdEnemy, mult: float, time: float) -> void:
	if game.time >= e.curse_until or mult >= e.curse_mult:
		e.curse_mult = mult
	e.curse_until = maxf(e.curse_until, game.time + time)


## Wards `e`: it takes `mult` (0..1) of every hit for `time` s (the strongest
## ward wins; a longer one extends). Sun Paladin aura, Holy Ward Generators.
static func ward_enemy(game: TdGame, e: TdEnemy, mult: float, time: float) -> void:
	if game.time >= e.ward_until or mult <= e.ward_mult:
		e.ward_mult = mult
	e.ward_until = maxf(e.ward_until, game.time + time)


## Silences `e` for `time` s (Keening Lady / Banshee): it cannot heal or revive;
## every healer trait asks EnemyTrait.can_heal() (the one silence test).
static func silence_enemy(game: TdGame, e: TdEnemy, time: float) -> void:
	e.silenced_until = maxf(e.silenced_until, game.time + time)


## Staggers `e` for `time` s (Abomination stomp): it makes no attack meanwhile,
## and Killing Field boulders aim at it.
static func stagger_enemy(game: TdGame, e: TdEnemy, time: float) -> void:
	e.staggered_until = maxf(e.staggered_until, game.time + time)
	e.next_attack = maxf(e.next_attack, e.staggered_until)


## Suppresses tower `t` (holy zones, Seraphine's beams): its damage x `mult`
## (0..1) for `time` s, through Tower.recompute() (the strongest wins; a
## longer one extends). The tower recomputes again when it ends (Tower.step).
static func suppress_tower(game: TdGame, t: Tower, mult: float, time: float) -> void:
	if game.time >= t.suppress_until or mult <= t.suppress_mult:
		t.suppress_mult = mult
	t.suppress_until = maxf(t.suppress_until, game.time + time)
	t.recompute()


# ------------------------------------------------------------------ gw2-kit statuses

## Puts a barrier of `amount` HP on blocker body `b` for `time` s (refreshed,
## never stacked: the bigger of the old and new barrier). Returns the HP added.
static func barrier_body(game: TdGame, b: BlockBody, amount: float, time: float) -> float:
	if not b.alive:
		return 0.0
	var before := b.barrier if game.time < b.barrier_until else 0.0  # Barrier still up.
	b.barrier = maxf(before, amount)
	b.barrier_until = game.time + time
	return b.barrier - before


## Shreds `e`'s flat armour by `amount` for `time` s (Wither; the strongest wins,
## a longer one extends). Read in damage_enemy() through shred_of().
static func shred_enemy(game: TdGame, e: TdEnemy, amount: float, time: float) -> void:
	if game.time >= float(e.vars.get("k_shred_until", 0.0)) or amount >= float(e.vars.get("k_shred", 0.0)):
		e.vars["k_shred"] = amount
	e.vars["k_shred_until"] = maxf(float(e.vars.get("k_shred_until", 0.0)), game.time + time)


## Armour shredded off `e` now (0 = none).
static func shred_of(game: TdGame, e: TdEnemy) -> float:
	return float(e.vars.get("k_shred", 0.0)) if game.time < float(e.vars.get("k_shred_until", 0.0)) else 0.0


## Marks `e` swooped for `time` s (a Gargoyle landing; Death from Above and the
## Wild Hunt read it through Synergies.has_status()).
static func swoop_enemy(game: TdGame, e: TdEnemy, time: float) -> void:
	e.vars["k_swooped"] = maxf(float(e.vars.get("k_swooped", 0.0)), game.time + time)
