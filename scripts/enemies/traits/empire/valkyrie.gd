## Valkyrie 2.0 (Iron Citadel miniboss; Necropathy's ValkyrieKit: "taller,
## heavier chrome armour, a big jet pack, a tower shield on one arm and the arm
## blade on the other. Jet dash, shield bash, blade storm"):
##   jet dash    — held at a post, every `dash_every` s she draws back
##                 `dash_windup` s (an amber line), then cuts `dash_targets`
##                 bodies for `dash_damage` and bursts through the post
##                 (empire/duelist.gd lunge(): unholdable `dash_time` s).
##   shield      — her tower shield: a hit from in front of her (the way she
##                 walks) counts `front_mult` (shield_front.gd's facing test);
##                 dots and arcing boulders pass it.
##   blade storm — every `storm_every` s (first after `storm_first`) she spins:
##                 every blocker body within `storm_radius` px takes `storm_damage`.
## Args in its row. vars: "next_dash", "dash_at", "next_storm".
extends EnemyTrait

const Duelist := preload("res://scripts/enemies/traits/empire/duelist.gd")
const Front := preload("res://scripts/enemies/traits/shield_front.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["next_dash"] = 0.0
	e.vars["dash_at"] = 0.0
	e.vars["next_storm"] = game.time + float(a["storm_first"])


func incoming_damage(e: TdEnemy, _game: TdGame, amount: float, hit: Dictionary) -> float:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if bool(hit.get("dot", false)) or (a["ignore"] as Array).has(String(hit.get("source", ""))):
		return amount
	return amount * float(a["front_mult"]) if Front.from_front(e, hit) else amount


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	var lk: Dictionary = Acts.data("empire")["LOOK"]
	if game.time < e.freeze_until:
		return
	if game.time >= float(e.vars["next_storm"]) and not game.bodies_near(e.position, float(a["storm_radius"])).is_empty():
		e.vars["next_storm"] = game.time + float(a["storm_every"])
		for b: BlockBody in game.bodies_near(e.position, float(a["storm_radius"])):
			TdCombat.damage_body(game, b, float(a["storm_damage"]) * e.damage_mult(), e)
		var ring := game.vfx.add(TdVfx.Kind.RING, e.position, float(a["storm_radius"]), TdVfxData.RING_TIME, lk["cut_tint"])
		if ring != null:
			ring.size0 = float(a["storm_radius"]) * 0.3
		game.vfx.add(TdVfx.Kind.ANIM, e.position, float(a["storm_radius"]) * 2.0, 0.45, lk["cut_tint"], "sentinel_sweep")
		EnemyTrait.note(game, "valkyrie_storms")
		Sfx.play("blade_storm")
	var at := float(e.vars["dash_at"])  # When the dash fires.
	if at > 0.0:
		if game.time < at:
			return
		e.vars["dash_at"] = 0.0
		e.vars["next_dash"] = game.time + float(a["dash_every"])
		if e.holder != null and game.time >= e.staggered_until:
			Duelist.lunge(e, game, int(a["dash_targets"]), float(a["dash_damage"]), float(a["dash_time"]), float(a["dash_mult"]))
			EnemyTrait.note(game, "valkyrie_dashes")
		return
	if e.holder != null and game.time >= float(e.vars["next_dash"]) and game.time >= e.staggered_until:
		e.vars["dash_at"] = game.time + float(a["dash_windup"])
		Duelist.line(game, e.position, e.holder.pos, float(a["dash_windup"]), false)
