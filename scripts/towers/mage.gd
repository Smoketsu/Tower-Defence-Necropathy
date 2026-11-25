## Bone Mage kit (GDD §4.1): splashing bolts (projectile.gd). With Requiem
## (SynergyData "requiem") its hits stretch a Dirge already on an enemy to at
## least `extend_weaken` s more. Evolved into the Lich (EvolutionData "lich",
## keys in its "set"): every `raise_every`-th enemy its bolts kill rises where
## it fell as a Risen, a temporary road blocker (one body, `risen_hp` HP,
## holds `risen_hold`, hits for `risen_damage` every `risen_interval` s) that
## crumbles after `risen_time` s; at most `risen_max` stand at once.
## Tower.vars: "risen" — Array of [RoadBlock, end game s]; "raise_count" — kills toward the next Risen.
extends "res://scripts/towers/projectile.gd"


func impact(t: Tower, shot: TdProjectiles.Shot, victims: Array[TdEnemy]) -> void:
	var ext := float(Synergies.value(t, "extend_weaken", 0.0))  # Requiem stretch (s; 0 = none).
	var every := int(t.stats.get("raise_every", 0))  # Lich raise cadence (0 = not a Lich).
	for e: TdEnemy in victims:
		if e.alive:
			if ext > 0.0 and t.game.time < e.weaken_until:
				TdCombat.weaken_enemy(t.game, e, e.weaken_mult, ext)
		elif every > 0 and not shot.is_volley and not bool(e.row.get("structure", false)):
			t.vars["raise_count"] = int(t.vars.get("raise_count", 0)) + 1
			if int(t.vars["raise_count"]) >= every and (t.vars.get("risen", []) as Array).size() < int(t.stats["risen_max"]):
				t.vars["raise_count"] = 0
				_raise(t, e)


## Raises a Risen where enemy `e` fell (on its road, at its distance).
func _raise(t: Tower, e: TdEnemy) -> void:
	var blk := RoadBlock.new()  # The Risen's block.
	blk.road_id = e.follower.road.id
	blk.dist = e.follower.dist
	var b := BlockBody.new()  # Its one body.
	b.block = blk
	b.temporary = true
	b.max_hp = float(t.stats["risen_hp"])
	b.hp = b.max_hp
	b.capacity = int(t.stats["risen_hold"])
	b.pos = e.follower.road.point_at(blk.dist)
	blk.bodies.append(b)
	t.game.add_block(blk)
	if not t.vars.has("risen"):
		t.vars["risen"] = []
	(t.vars["risen"] as Array).append([blk, t.game.time + float(t.stats["risen_time"])])
	t.game.fx.spawn("summon_rise", b.pos, 64.0, 0.4)
	t.game.stats["risen"] = int(t.game.stats.get("risen", 0)) + 1


func step(t: Tower, dt: float) -> void:
	super(t, dt)
	var risen: Array = t.vars.get("risen", [])  # Standing Risen.
	for i in range(risen.size() - 1, -1, -1):
		var blk: RoadBlock = risen[i][0]
		var b: BlockBody = blk.bodies[0]
		if not b.alive or t.game.time >= float(risen[i][1]):
			blk.release_all()
			t.game.remove_block(blk)
			risen.remove_at(i)
			continue
		if not b.held.is_empty() and t.game.time >= b.next_attack:
			b.next_attack = t.game.time + float(t.stats["risen_interval"])
			TdCombat.damage_enemy(t.game, b.held[0], float(t.stats["risen_damage"]), {"source": "lich_risen", "tower": t, "origin": b.pos})
	if not risen.is_empty() or t.vars.has("risen"):
		t.queue_redraw()
		if risen.is_empty():
			t.vars.erase("risen")


func on_removed(t: Tower) -> void:
	for r: Array in t.vars.get("risen", []):
		(r[0] as RoadBlock).release_all()
		t.game.remove_block(r[0])
	t.vars.erase("risen")


func draw_overlay(t: Tower) -> void:
	for r: Array in t.vars.get("risen", []):
		var blk: RoadBlock = r[0]
		if not blk.bodies.is_empty():
			if not SpriteBank.draw(t, "summons/risen", blk.bodies[0].pos - t.position, t.game.time < blk.bodies[0].flash_until):
				t.draw_rect(Rect2(blk.bodies[0].pos - t.position - Vector2(6, 14), Vector2(12, 20)), Color(0.8, 0.8, 0.7))
