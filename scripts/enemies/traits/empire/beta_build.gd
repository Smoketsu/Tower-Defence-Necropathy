## The Beta Build (Assembly Halls miniboss; Necropathy's BetaBuildKit: "an
## unfinished mech that keeps patching itself from every fabricator still
## standing; a welding swipe and a rivet spray"):
##   patching    — every `patch_tick` s it regains `patch_rate` of its max HP per
##                 s for every live Fabricator (kind `patch_kind`, at most
##                 `patch_max` counted): smash the fabricators first.
##   rivet spray — every `rivets_every` s (first after `rivets_first`) the rivet
##                 cannon charges `rivets_windup` s, then fires `rivets_count`
##                 rivets across the nearest working towers within
##                 `rivets_range` px (straight Empire shots `rivet`: posts stop them).
##   weld swipe  — held at a post, every `swipe_every` s the welding arm sweeps
##                 every body of it for `swipe_damage`.
## Args in its row. vars: "next_patch", "next_rivets", "rivets_at", "next_swipe".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/empire/empire_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["next_patch"] = game.time + float(a["patch_tick"])
	e.vars["next_rivets"] = game.time + float(a["rivets_first"])
	e.vars["rivets_at"] = 0.0
	e.vars["next_swipe"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var lk: Dictionary = Acts.data("empire")["LOOK"]
	if game.time >= float(e.vars["next_patch"]):
		e.vars["next_patch"] = game.time + float(a["patch_tick"])
		var n := 0  # Live fabricators.
		for o: TdEnemy in game.enemies:
			if o.alive and o.kind == String(a["patch_kind"]):
				n += 1
		n = mini(n, int(a["patch_max"]))
		if n > 0 and e.hp < e.max_hp:
			TdCombat.heal_enemy(game, e, e.max_hp * float(a["patch_rate"]) * float(a["patch_tick"]) * float(n))
			EnemyTrait.note(game, "beta_patches")
	if game.time < e.freeze_until:
		return
	if e.holder != null and game.time >= float(e.vars["next_swipe"]):
		e.vars["next_swipe"] = game.time + float(a["swipe_every"])
		var post := e.holder  # The body holding it (it may fall below).
		for b: BlockBody in post.block.bodies:
			if b.alive:
				TdCombat.damage_body(game, b, float(a["swipe_damage"]) * e.damage_mult(), e)
		game.vfx.add(TdVfx.Kind.ANIM, post.pos, float(lk["stomp_d"]), 0.4, lk["flame_tint"], "sentinel_sweep")
		EnemyTrait.note(game, "beta_swipes")
	var at := float(e.vars["rivets_at"])  # When the charged spray fires.
	if at > 0.0 and game.time >= at:
		e.vars["rivets_at"] = 0.0
		var ts := Kit.towers_near(game, e.position, float(a["rivets_range"]))  # Towers in reach.
		for i in int(a["rivets_count"]) if not ts.is_empty() else 0:
			Kit.fire_at(game, e, ts[i % ts.size()], a["rivet"])
		EnemyTrait.note(game, "beta_rivets")
		Sfx.play("turret_shot")
	elif at <= 0.0 and game.time >= float(e.vars["next_rivets"]) and game.time >= e.staggered_until:
		if Kit.towers_near(game, e.position, float(a["rivets_range"])).is_empty():
			return
		e.vars["next_rivets"] = game.time + float(a["rivets_every"])
		e.vars["rivets_at"] = game.time + float(a["rivets_windup"])
		var ring := game.vfx.add(TdVfx.Kind.RING, e.position, 40.0, float(a["rivets_windup"]), lk["line_tint"])
		if ring != null:
			ring.size0 = 12.0
