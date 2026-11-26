## Myrmidon Shades kit (Act VIII's unlockable summon class, unlocked by Hades;
## Necropathy's Myrmidon Shade: "undead hoplites that hold the ring three
## shields wide and spear through the foes behind"): a blocker (blocker.gd) of
## three bodies side by side. SHIELD WALL: while every body of the post stands,
## each takes `wall_cut` less from every blow (BlockBody.damage_cut, read by
## TdCombat.damage_body; set each step, so a broken wall shows at once). SPEAR:
## a strike runs through up to `pierce` more foes on the same road within
## `pierce_reach` px behind the struck one, `pierce_mult` x its damage each,
## and staggers them `stagger` s (TdCombat.stagger_enemy). Evolved into the
## Legion of Tartarus (EvolutionData "legion_of_tartarus", its "set"): a
## harder wall, a spear through more foes and THE GRIP: every foe the spear
## strikes is slowed to `grip_slow` for `grip_time` s (0 = none).
## While disabled its step does not run: the wall keeps its last state.
## Tower.vars: "pierced" (foes run through, the kit summary's counter).
extends "res://scripts/towers/blocker.gd"


func step(t: Tower, dt: float) -> void:
	var wall := true  # Every body stands.
	for b: BlockBody in t.block.bodies:
		wall = wall and b.alive
	for b: BlockBody in t.block.bodies:
		b.damage_cut = float(t.stats["wall_cut"]) if wall else 0.0
	super(t, dt)


func strike(t: Tower, b: BlockBody) -> float:
	var first: TdEnemy = b.held[0]  # The foe on its spear.
	var dealt := super(t, b)  # The thrust.
	var grip := float(t.stats["grip_time"])  # Legion's grip (s).
	if grip > 0.0 and first.alive:
		TdCombat.slow_enemy(t.game, first, float(t.stats["grip_slow"]), grip)
	var n := int(t.stats["pierce"])  # Foes behind it the spear reaches.
	if n <= 0:
		return dealt
	var behind: Array[TdEnemy] = []  # Foes on its road just behind the first.
	for e: TdEnemy in t.game.foes_near(b.pos, float(t.stats["pierce_reach"]) + first.radius):
		if e != first and e.follower.road == first.follower.road and e.follower.dist < first.follower.dist and t.can_hit(e):
			behind.append(e)
	behind.sort_custom(func(x: TdEnemy, y: TdEnemy) -> bool: return x.follower.dist > y.follower.dist)
	var last := first.position  # Where the spear's streak ends.
	for e: TdEnemy in behind.slice(0, n):
		last = e.position
		dealt += TdCombat.damage_enemy(t.game, e, float(t.stats["damage"]) * float(t.stats["pierce_mult"]), {"source": t.tower_id, "tower": t, "origin": b.pos})
		if e.alive:
			TdCombat.stagger_enemy(t.game, e, float(t.stats["stagger"]))
			if grip > 0.0:
				TdCombat.slow_enemy(t.game, e, float(t.stats["grip_slow"]), grip)
		t.vars["pierced"] = int(t.vars.get("pierced", 0)) + 1
	if t.game.vfx.on and last != first.position:
		var lk: Dictionary = TdVfxData.SHOTS[t.tower_id]
		var f := t.game.vfx.add(TdVfx.Kind.STREAK, last, float(lk["trail_w"]) * TdVfx.loud(t), TdVfxData.IMPACT_TIME, lk["tint"])
		if f != null:
			f.ang = (last - b.pos).angle()
			f.size0 = b.pos.distance_to(last)
		t.game.vfx.add(TdVfx.Kind.ANIM, last, float(lk["impact_d"]), TdVfxData.IMPACT_TIME, lk["tint"], "volley_hit")
	return dealt
