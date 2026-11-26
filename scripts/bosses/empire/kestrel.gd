## Kestrel, the Dead Pixel (Scrap Wastes boss; Necropathy's BossKestrel: "the
## Empire's sniper commander who never misses by a single pixel: triple Lock-On
## lines, decoy drones, and in her last phase she drops the rifle for twin
## blades and charges"). Three phases by HP (`phase_hp`):
##   Marksman — every `lock_every` s (first after `lock_first`) she kneels (pose
##              1, `pose_time` s) and paints a TRIPLE Lock-On on the three nearest
##              working towers within `lock_range` px (the act rule's paint,
##              boss override), then the rail slugs `rail` fly (posts in the
##              line take them).
##   Decoys   — from phase 2, every `decoy_every` s she drops `decoy_count`
##              hologram Decoy Drones (`decoy_kind`) just ahead of her: they
##              walk first and draw the towers' fire.
##   Blades   — phase 3: the rifle drops (sprite bosses/kestrel_blades); she is
##              hasted `blade_haste`, slashes every body of the post holding her
##              for `slash_damage` every `slash_every` s, and every
##              `charge_every` s CHARGES the post: a heavy body (max HP >=
##              `heavy_hp`: an Abomination, a Golem, an Iron Revenant...) stops
##              her cold (staggered `charge_stun` s); a light one is cut
##              (`charge_damage`) and she runs through (unholdable `charge_time` s).
## Args in its row. vars: "phase", "next_lock", "next_decoy", "next_slash",
## "next_charge", "pose_until".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/empire/empire_kit.gd")
const Duelist := preload("res://scripts/enemies/traits/empire/duelist.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["phase"] = 1
	e.vars["next_lock"] = game.time + float(a["lock_first"])
	e.vars["next_decoy"] = 0.0
	e.vars["next_slash"] = 0.0
	e.vars["next_charge"] = 0.0
	e.vars["pose_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	var ph := int(e.vars["phase"])  # Phase now.
	var th: Array = a["phase_hp"]
	if ph < 3 and e.hp <= e.max_hp * float(th[ph - 1]):
		ph += 1
		e.vars["phase"] = ph
		e.vars["next_decoy"] = game.time + 1.0
		if ph == 2:
			game.banner("Kestrel releases her decoys: holograms walk ahead of her")
		else:
			game.banner("Kestrel drops the rifle: twin blades, and she charges the posts!")
			e.vars["sprite"] = "bosses/kestrel_blades"
			e.vars["next_charge"] = game.time + float(a["charge_every"]) * 0.5
			e.body.queue_redraw()
		EnemyTrait.note(game, "kestrel_phases")
	if e.pose == 1 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	if ph == 3 and game.time >= float(e.vars.get("haste_at", 0.0)):
		e.vars["haste_at"] = game.time + 1.0
		TdCombat.haste_enemy(game, e, float(a["blade_haste"]), 1.2)
	if game.time < e.freeze_until:
		return
	if ph >= 2 and ph < 3 and game.time >= float(e.vars["next_decoy"]):
		e.vars["next_decoy"] = game.time + float(a["decoy_every"])
		var r := e.follower.road  # Her road.
		for i in int(a["decoy_count"]):
			var d := minf(e.follower.dist + 30.0 + float(i) * 22.0, r.length - 1.0)  # Ahead of her.
			game.waves.spawn_extra(String(a["decoy_kind"]), r.id, d, float(i % 2 * 2 - 1) * 10.0)
		game.fx.spawn("summon_rise", e.position, 90.0, 0.5, Acts.data("empire")["LOOK"]["arc_tint"])
		EnemyTrait.note(game, "kestrel_decoys")
	if ph < 3:
		if game.time >= float(e.vars["next_lock"]) and game.time >= e.staggered_until:
			var ts := Kit.towers_near(game, e.position, float(a["lock_range"]))  # Towers in reach.
			if ts.is_empty():
				return
			e.vars["next_lock"] = game.time + float(a["lock_every"])
			for t: Tower in ts.slice(0, int(a["locks"])):
				Kit.lock(game, e, t, a["rail"], true)
			e.pose = 1
			e.vars["pose_until"] = game.time + float(a["pose_time"])
			e.body.queue_redraw()
			EnemyTrait.note(game, "kestrel_triple_locks")
		return
	if e.holder == null:
		return
	if game.time >= float(e.vars["next_charge"]) and game.time >= e.staggered_until:
		e.vars["next_charge"] = game.time + float(a["charge_every"])
		if e.holder.max_hp >= float(a["heavy_hp"]):
			TdCombat.stagger_enemy(game, e, float(a["charge_stun"]))
			game.vfx.add(TdVfx.Kind.CRACK, e.holder.pos, 1.4, TdVfxData.CRACK_TIME, Color.WHITE)
			Sfx.play("blade_clang")
			EnemyTrait.note(game, "kestrel_charges_stopped")
		else:
			Duelist.lunge(e, game, 4, float(a["charge_damage"]), float(a["charge_time"]), 2.0)
			EnemyTrait.note(game, "kestrel_charges")
		return
	if game.time >= float(e.vars["next_slash"]):
		e.vars["next_slash"] = game.time + float(a["slash_every"])
		var post := e.holder  # The body holding it (it may fall below).
		for b: BlockBody in post.block.bodies:
			if b.alive:
				TdCombat.damage_body(game, b, float(a["slash_damage"]) * e.damage_mult(), e)
		game.vfx.add(TdVfx.Kind.ANIM, post.pos, 80.0, 0.35, Acts.data("empire")["LOOK"]["cut_tint"], "sentinel_sweep")


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("Kestrel falls: the Dead Pixel goes dark")
