## Bonehorn kit (Act XIV tower, unlocked by Old Gravejaw; Necropathy's
## BonehornBehavior "trample_charge": a skeletal horned charger). The Bound
## Ophan's way of choosing (bound_ophan.gd / fallen_hero.gd: it paws round its
## plot `patrol_r` px, picks the DENSEST PACK in range, every pick through
## t.can_hit(), flyers included) with its own landing:
##   the charge — from the landing it charges BACK along that enemy's road
##                toward the entrance for `roll_len` px: every foe within
##                `roll_w` px of the road on the way takes `damage`, is staggered
##                `slam_stagger` s and THROWN BACK `knock` px (TdCombat.knock_enemy:
##                bosses, minibosses and flyers stand firm). A flyer target or no
##                road near: a stamp of `roll_w` px where it lands.
##   volley     — from level 3 each charge throws its volley (TowerBehavior.volley()).
## Evolved into the Fossil Tyrant (EvolutionData "fossil_tyrant"): a longer,
## wider charge that throws farther, freezes what it gores `dive_stun` s and
## charges `chain_slams` more packs within `chain_range` px (fallen_hero.gd).
## Tower.vars as the Bound Ophan's ("rolls", "slams" count its charges).
extends "res://scripts/towers/bound_ophan.gd"


## One charge from `at` (see the header); returns a survivor hit, or null.
func _slam(t: Tower, at: Vector2) -> TdEnemy:
	var g := t.game  # The run.
	var w := float(t.stats["roll_w"])  # Px either side of the road.
	var rd := g.nearest_road(at, w * 2.0)  # The road it charges down.
	var first: TdEnemy = null  # A survivor.
	var hit: Array[TdEnemy] = []  # Struck this charge (once each).
	var to := at  # Where the charge ends.
	if rd != null and not rd.off_road:
		var d0 := rd.project(at)  # Px along the road where it lands.
		var d1 := maxf(d0 - float(t.stats["roll_len"]), 0.0)  # Where it stops, toward the entrance.
		to = rd.point_at(d1)
		var d := d0
		while d >= d1 - 0.5:
			for e: TdEnemy in g.foes_near(rd.point_at(d), w):
				if not hit.has(e) and t.can_hit(e):
					hit.append(e)
			d -= w
	else:
		for e: TdEnemy in g.foes_near(at, w):
			if t.can_hit(e):
				hit.append(e)
	for e: TdEnemy in hit:
		TdCombat.damage_enemy(g, e, float(t.stats["damage"]), {"source": t.tower_id, "tower": t, "origin": at})
		if not e.alive:
			continue
		TdCombat.stagger_enemy(g, e, float(t.stats["slam_stagger"]))
		if float(t.stats["dive_stun"]) > 0.0:
			TdCombat.freeze_enemy(g, e, float(t.stats["dive_stun"]))
		TdCombat.knock_enemy(g, e, float(t.stats["knock"]))
		first = e if first == null else first
	t.vars["rolls"] = int(t.vars.get("rolls", 0)) + 1
	t.vars["slams"] = int(t.vars["rolls"])  # The kit summary's counter.
	if g.vfx.on:
		var k := TdVfx.loud(t)  # Evolved: louder.
		var tint: Color = TdVfxData.SHOTS["bonehorn"]["tint"]
		var f := g.vfx.add(TdVfx.Kind.STREAK, at, float(Acts.data("primeval")["LOOK"]["bonehorn_w"]) * k, 0.45, tint)
		if f != null:
			f.ang = (at - to).angle()
			f.size0 = maxf(at.distance_to(to), 20.0)
		g.vfx.add(TdVfx.Kind.ANIM, at, w * 2.4 * k, 0.4, tint, "golem_slam")
		g.vfx.add(TdVfx.Kind.ANIM, to, w * 2.0 * k, 0.4, tint, "volley_hit")
		var ring := g.vfx.add(TdVfx.Kind.RING, to, w, TdVfxData.RING_TIME, tint)
		if ring != null:
			ring.size0 = w * TdVfxData.RING_FROM
		g.vfx.shake(1.4 * k)
	return first
