## Bound Ophan kit (Act X tower, unlocked by the Voice; Necropathy's
## BoundOphanBehavior "orbit_roll": a wheel of bone and eyes that circles the
## ring, then rolls through the densest pack). The Fallen Hero's flight
## (fallen_hero.gd: it circles its plot `patrol_r` px, picks the DENSEST PACK in
## range, every pick through t.can_hit(), flyers included) with its own landing:
##   the roll — from the landing it rolls BACK along that enemy's road toward
##              the entrance for `roll_len` px: every foe within `roll_w` px of
##              the road on the way takes `damage` and is staggered
##              `slam_stagger` s (TdCombat.stagger_enemy: no attacks; an Ophan
##              staggered can be held). A flyer target or no road near: a slam
##              of `roll_w` px where it lands.
##   volley   — from level 3 each roll throws its volley (TowerBehavior.volley()).
##   shade    — the act rule reads it (RULE shade_towers): its plot's shade
##              hides the towers round it from the Hallowed Light.
## Evolved into the Throne of Bones (EvolutionData "throne_of_bones"): a longer,
## wider roll that freezes what it hits `dive_stun` s, and `chain_slams` more
## rolls on the next densest packs within `chain_range` px (fallen_hero.gd).
## Tower.vars as the Fallen Hero's, plus "rolls" (count) and "roll_from" /
## "roll_to" / "roll_at" (map px and game s of the last roll: drawn only).
extends "res://scripts/towers/fallen_hero.gd"


## One roll from `at` (see the header); returns a survivor hit, or null.
func _slam(t: Tower, at: Vector2) -> TdEnemy:
	var g := t.game  # The run.
	var w := float(t.stats["roll_w"])  # Px either side of the road.
	var rd := g.nearest_road(at, w * 2.0)  # The road it rolls down.
	var first: TdEnemy = null  # A survivor.
	var hit: Array[TdEnemy] = []  # Struck this roll (once each).
	var to := at  # Where the roll ends.
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
		first = e if first == null else first
	t.vars["rolls"] = int(t.vars.get("rolls", 0)) + 1
	t.vars["slams"] = int(t.vars["rolls"])  # The kit summary's counter.
	if g.vfx.on:
		var k := TdVfx.loud(t)  # Evolved: louder.
		var tint: Color = TdVfxData.SHOTS["bound_ophan"]["tint"]
		var f := g.vfx.add(TdVfx.Kind.STREAK, at, float(Acts.data("host")["LOOK"]["ophan_roll_w"]) * k, 0.45, tint)
		if f != null:
			f.ang = (at - to).angle()
			f.size0 = maxf(at.distance_to(to), 20.0)
		g.vfx.add(TdVfx.Kind.ANIM, at, w * 2.4 * k, 0.4, tint, "golem_slam")
		g.vfx.add(TdVfx.Kind.ANIM, to, w * 2.0 * k, 0.4, tint, "volley_flash")
		var ring := g.vfx.add(TdVfx.Kind.RING, to, w, TdVfxData.RING_TIME, tint)
		if ring != null:
			ring.size0 = w * TdVfxData.RING_FROM
		g.vfx.shake(1.2 * k)
	return first
