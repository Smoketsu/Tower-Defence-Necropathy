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
	game.economy.earn(int(e.vars.get("souls", e.row.get("souls", EconomyData.KILL_SOULS[rank]))), "kills")  # A row's "souls" overrides its rank's (w2b-shogun); vars "souls" one enemy's (w2c-dynasty: a reborn body pays 0).
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


## Enemy `e` reached the gate: lives lost by its row's "leak_lives", else by rank.
static func leak(game: TdGame, e: TdEnemy) -> void:
	var lost := int(e.row.get("leak_lives", TdRulesData.LEAK_LIVES[String(e.row["rank"])]))  # Lives lost (-1 = all).
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
## what it held and waits for its free respawn (Blocker behaviour), and
## TdGame.body_fallen fires (`by` = the enemy that dealt the blow, or null:
## act rules raise it hostile through game.spawn_from_body()).
static func damage_body(game: TdGame, b: BlockBody, amount: float, by: TdEnemy = null) -> void:
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
		game.body_fallen.emit(b, by)


## Heals blocker body `b` by `amount` HP (Mender auras, lifesteal); returns the HP restored.
static func heal_body(game: TdGame, b: BlockBody, amount: float) -> float:
	if not b.alive:
		return 0.0
	cleanse_body(game, b)  # A heal breaks a charm (w2c-inferno).
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


## Disables tower `t` for `time` s (shelled, trampled, blinded, stunned: the
## ONE path for anything that stops a tower): it makes no attack, pulse or
## block step meanwhile (Tower.step), shows the disabled look (darkened, a
## pulsing ring in its cause's colour, HostileData.CAUSE_TINT) and a burst now.
## The longer disable wins. `cause` = a HostileData.CAUSE_TINT key.
static func disable_tower(game: TdGame, t: Tower, time: float, cause: String) -> void:
	if time <= 0.0 or not is_instance_valid(t) or not game.towers.has(t):
		return
	if game.time >= t.disabled_until or game.time + time > t.disabled_until:
		t.disabled_until = game.time + time
		t.disabled_cause = cause
	EnemyTrait.note(game, "towers_disabled_" + cause)
	game.hostile.disabled(t)


## Raises enemy `e`'s max HP (and HP) by `hp_mult` (>= 1) and its speed by
## `speed_mult`: the one path for per-wave tiers and escalations applied to a
## spawned enemy (act rules call it from on_spawn()).
static func empower_enemy(_game: TdGame, e: TdEnemy, hp_mult: float, speed_mult: float = 1.0) -> void:
	e.max_hp *= hp_mult
	e.hp = e.max_hp
	e.speed *= speed_mult
# ------------------------------------------------------------------ gw2-kit statuses

## Puts a barrier of `amount` HP on blocker body `b` for `time` s (refreshed,
## never stacked: the bigger of the old and new barrier). Returns the HP added.
static func barrier_body(game: TdGame, b: BlockBody, amount: float, time: float) -> float:
	if not b.alive:
		return 0.0
	cleanse_body(game, b)  # A barrier breaks a charm (w2c-inferno).
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


## Marks `e` pinned for `time` s (an Iron Revenant shell under Pinned Down;
## read through Synergies.has_status()).
static func pin_enemy(game: TdGame, e: TdEnemy, time: float) -> void:
	e.vars["k_pinned"] = maxf(float(e.vars.get("k_pinned", 0.0)), game.time + time)


## Knocks `e` back `px` px along its road, away from the gate (a Powder
## Wraith's keg, the Black Tide's blasts; the one knockback path): a body
## holding it lets go. Bosses, minibosses, structures and flyers stand firm;
## it never goes back past the start of its current road.
static func knock_enemy(game: TdGame, e: TdEnemy, px: float) -> void:
	var rank := String(e.row["rank"])  # Its rank.
	if px <= 0.0 or not e.alive or rank == "boss" or rank == "miniboss" or bool(e.row.get("structure", false)) or bool(e.row.get("flying", false)):
		return
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	e.follower.dist = maxf(e.follower.dist - px, 0.0)
	e.position = e.follower.position()
	EnemyTrait.note(game, "knocked_back")
## Rallies tower `t` (Banner of the Dead): its attack speed x `rate_mult` for
## `time` s through Tower.recompute() (the stronger rally wins, a longer one
## extends); Tower.step() recomputes it when the rally ends.
static func rally_tower(game: TdGame, t: Tower, rate_mult: float, time: float) -> void:
	if game.time >= float(t.vars.get("k_rally_until", 0.0)) or rate_mult >= float(t.vars.get("k_rally", 1.0)):
		t.vars["k_rally"] = rate_mult
	t.vars["k_rally_until"] = maxf(float(t.vars.get("k_rally_until", 0.0)), game.time + time)
	t.recompute()


## Chills tower `t` (the Long Winter, Act VI): its attack speed x `rate_mult`
## (0..1; 1 = warm, the chill removed) through Tower.recompute(); recomputes
## only when the value changes (the act rule calls it every warmth check).
static func chill_tower(_game: TdGame, t: Tower, rate_mult: float) -> void:
	if is_equal_approx(float(t.vars.get("k_cold", 1.0)), rate_mult):
		return
	if rate_mult >= 1.0:
		t.vars.erase("k_cold")
	else:
		t.vars["k_cold"] = rate_mult
	t.recompute()
# ------------------------------------------------------------------ w2c-inferno charms

## Charms blocker body `b` for `time` s (the Inferno's Temptation: a
## succubus's kiss): it lets go of what it holds, holds nobody
## (RoadBlock.free_body) and strikes a living body of its own post at
## `hit_mult` x its blow (blocker.gd). The longer charm wins. A heal or a
## barrier on it (heal_body / barrier_body: Mender, Warder) cleanses it.
static func charm_body(game: TdGame, b: BlockBody, time: float, hit_mult: float) -> void:
	if not b.alive or b.temporary or time <= 0.0:
		return
	b.charm_until = maxf(b.charm_until, game.time + time)
	b.charm_mult = hit_mult
	b.release_all()
	EnemyTrait.note(game, "bodies_charmed")


## Breaks the charm on body `b` (heal_body / barrier_body call it).
static func cleanse_body(game: TdGame, b: BlockBody) -> void:
	if game.time < b.charm_until:
		b.charm_until = 0.0
		EnemyTrait.note(game, "charms_cleansed")


## Charms enemy `e` for `time` s (the Bound Succubus's kiss, Temptation): it
## stops where it is (its holder lets go), towers ignore it
## (TdGame.can_target) and every attack interval it strikes the nearest other
## foe within `reach` px for `damage`, credited to `source` / `tower`
## (charm_step, called by TdEnemy.step). Bosses, minibosses and structures
## are never charmed. Returns true when it took.
static func charm_enemy(game: TdGame, e: TdEnemy, time: float, damage: float, reach: float, source: String, tower: Tower) -> bool:
	var rank := String(e.row["rank"])  # Its rank.
	if not e.alive or time <= 0.0 or rank == "boss" or rank == "miniboss" or bool(e.row.get("structure", false)):
		return false
	e.vars["k_charm_until"] = maxf(float(e.vars.get("k_charm_until", 0.0)), game.time + time)
	e.vars["k_charm_dmg"] = damage
	e.vars["k_charm_reach"] = reach
	e.vars["k_charm_src"] = source
	e.vars["k_charm_tower"] = tower
	if e.holder != null:
		e.holder.held.erase(e)
		e.holder = null
	e.next_attack = game.time + float(e.row["attack_interval"]) * 0.5
	game.stats["charmed"] = int(game.stats.get("charmed", 0)) + 1
	e.body.queue_redraw()
	return true


## One step of charmed enemy `e` (see charm_enemy): strike the nearest other
## foe in reach on its own attack cadence (frozen: no strike).
static func charm_step(game: TdGame, e: TdEnemy) -> void:
	if game.time < e.freeze_until or game.time < e.next_attack:
		return
	var best: TdEnemy = null  # Nearest other foe that is not charmed.
	for o: TdEnemy in game.foes_near(e.position, float(e.vars["k_charm_reach"])):
		if o != e and game.time >= float(o.vars.get("k_charm_until", 0.0)) and \
				(best == null or o.position.distance_squared_to(e.position) < best.position.distance_squared_to(e.position)):
			best = o
	if best == null:
		return
	e.next_attack = game.time + float(e.row["attack_interval"])
	var tw: Tower = e.vars.get("k_charm_tower", null)  # The charmer tower, if it still stands.
	if tw != null and not (is_instance_valid(tw) and game.towers.has(tw)):
		tw = null
	var hit := {"source": String(e.vars["k_charm_src"]), "origin": e.position}  # The thrall's blow.
	if tw != null:
		hit["tower"] = tw
	e.vis_strike_at = game.time
	e.vis_strike_dir = (best.position - e.position).normalized()
	damage_enemy(game, best, float(e.vars["k_charm_dmg"]), hit)
