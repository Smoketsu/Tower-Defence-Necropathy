## Fallen Hero kit (Act IV tower, unlocked by Paragon; Necropathy
## FallenHeroBehavior "hero_slam": a raised Super who flies round and slams
## into packs). The Gargoyle's flight (gargoyle.gd: it circles its plot
## `patrol_r` px in the air, dives `dive_time` s, perches, flies back) with
## the hero's own target and landing:
##   target  — the DENSEST PACK in range (the enemy with the most foes within
##             `splash` px; elites, minibosses and bosses count `elite_weight`
##             foes; ties to the one nearest the gate), flyers included; every
##             pick passes t.can_hit(e).
##   slam    — `damage` to every enemy within `splash` px, staggered
##             `slam_stagger` s (TdCombat.stagger_enemy: no attacks) and its
##             armour shredded by `slam_shred` for `shred_time` s
##             (TdCombat.shred_enemy: the act's answer to vehicles and Atlas).
##   volley  — from level 3 each slam throws its volley (TowerBehavior.volley()).
## Evolved into Black Paragon (EvolutionData "black_paragon"): every slam
## also freezes what it hits `dive_stun` s (TdCombat.freeze_enemy, rank
## multipliers apply) and it flies on to `chain_slams` more packs, each within
## `chain_range` px of the last landing, slamming each at once.
## Tower.vars as the Gargoyle's, plus "slams" and "chains" (counts).
extends "res://scripts/towers/gargoyle.gd"


## The densest pack in range (see the header), or null.
func _pick(t: Tower) -> TdEnemy:
	return _densest(t, t.position, float(t.stats["range"]), Vector2.INF)


## The best pack centre among foes within `reach` px of `from` that `t` can
## hit, skipping any within half a splash of `skip` (a chain's last landing).
func _densest(t: Tower, from: Vector2, reach: float, skip: Vector2) -> TdEnemy:
	var g := t.game  # The run.
	var r := float(t.stats["splash"])  # Pack radius (px).
	var w := float(t.stats["elite_weight"])  # Weight of a non-fodder foe.
	var best: TdEnemy = null  # Best centre so far.
	var best_s := 0.0  # Its score.
	for e: TdEnemy in g.foes_near(from, reach):
		if not t.can_hit(e) or (skip != Vector2.INF and e.position.distance_to(skip) < r * 0.5):
			continue
		var s := 0.0  # Pack score round e.
		for o: TdEnemy in g.foes_near(e.position, r):
			s += 1.0 if String(o.row["rank"]) == "fodder" else w
		if best == null or s > best_s or (is_equal_approx(s, best_s) and g.progress(e) > g.progress(best)):
			best = e
			best_s = s
	return best


## The landing (Gargoyle's dive end): the slam, then Black Paragon's chain.
func _land(t: Tower) -> void:
	var g := t.game  # The run.
	var tg: TdEnemy = t.vars.get("target", null)
	if TdEnemy.valid(tg, int(t.vars.get("target_gen", -1))):
		t.vars["at"] = tg.position  # It tracks its prey down.
	t.vars.erase("target")
	var at: Vector2 = t.vars["at"]
	var first := _slam(t, at)  # Someone hit (the volley's target).
	for i in int(t.stats["chain_slams"]):
		var next := _densest(t, at, float(t.stats["chain_range"]), at)  # The next pack.
		if next == null:
			break
		if g.vfx.on:
			var f := g.vfx.add(TdVfx.Kind.THREAD, at + Vector2(0, -16), TdVfxData.KIT_HERO_CHAIN_W, TdVfxData.KIT_HERO_CHAIN_TIME, TdVfxData.KIT_HERO_TINT)
			if f != null:
				f.to = next.position + Vector2(0, -16)
		at = next.position
		_slam(t, at)
		t.vars["chains"] = int(t.vars.get("chains", 0)) + 1
	t.vars["at"] = at  # It perches on the last crater.
	if first != null:
		volley(t, first)


## One slam at `at` (see the header); returns a survivor hit, or null.
func _slam(t: Tower, at: Vector2) -> TdEnemy:
	var g := t.game  # The run.
	var r := float(t.stats["splash"])  # Slam radius (px).
	var first: TdEnemy = null  # A survivor.
	for e: TdEnemy in g.foes_near(at, r):
		if not t.can_hit(e):
			continue
		TdCombat.damage_enemy(g, e, float(t.stats["damage"]), {"source": t.tower_id, "tower": t, "origin": at})
		if not e.alive:
			continue
		TdCombat.stagger_enemy(g, e, float(t.stats["slam_stagger"]))
		TdCombat.shred_enemy(g, e, float(t.stats["slam_shred"]), float(t.stats["shred_time"]))
		if float(t.stats["dive_stun"]) > 0.0:
			TdCombat.freeze_enemy(g, e, float(t.stats["dive_stun"]))
		first = e if first == null else first
	t.vars["slams"] = int(t.vars.get("slams", 0)) + 1
	if g.vfx.on:
		var k := TdVfx.loud(t)  # Evolved: louder.
		g.vfx.add(TdVfx.Kind.ANIM, at, r * 2.4 * k, 0.5, Color.WHITE, "golem_slam")
		var ring := g.vfx.add(TdVfx.Kind.RING, at, r * TdVfxData.RING_TO, TdVfxData.RING_TIME * 1.3, TdVfxData.KIT_HERO_TINT)
		if ring != null:
			ring.size0 = r * TdVfxData.RING_FROM
		g.vfx.add(TdVfx.Kind.CRACK, at, 0.9 * k, TdVfxData.CRACK_TIME, Color.WHITE)
		g.vfx.shake(2.0 * k)
	return first


## The trail of its dive in its own colour (the Gargoyle draws violet).
func draw_overlay(t: Tower) -> void:
	if not t.game.vfx.on or int(t.vars.get("phase", 0)) != 1:
		return
	var o := offset(t)  # Where it is.
	var from: Vector2 = t.vars["from"]
	var streak := TdArt.texture("vfx_streak")  # Trail mask.
	if streak != null and not TdVfx.reduced():
		var d := o - from  # Flight so far.
		t.material = TdVfx.additive()
		TdVfx.draw_streak(t, streak, o + Vector2(0, -16), d.angle(), minf(d.length(), 90.0), TdVfxData.KIT_SWOOP_W, TdVfxData.KIT_HERO_TINT)
