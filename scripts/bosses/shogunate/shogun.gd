## Shogun Kurogane (Kurogane boss; Necropathy's BossShogun: "his army is his
## health bar"). He stands on his command platform `stand_dist` px down his
## road and never walks at first; while he stands every hit on him counts only
## `guard_mult` and never takes him under `duel_hp` of his HP. Every
## `regiment_every` s (first after `regiment_first`) one of his `regiments`
## ([kind, count] rows) marches in from an entrance (the two gates in turn): a
## Hatamoto (`hatamoto_kind`) leading `count` soldiers, `regiment_gap` px apart.
## Every one of them lost (killed or leaked) takes a point off him
## (`points_frac` of his HP split over every soldier and banner); killing a
## regiment's Hatamoto BREAKS it: the rest flee and count as lost. At
## `duel_hp` of his HP (or once every regiment is spent) he comes down to DUEL:
## he walks at his row speed and takes full damage, and every `cut_every` s
## (down to `cut_every_min` as he weakens) an iai cut, the act's white Draw
## line, strikes every living body of the post holding him or the next post
## ahead within `cut_reach` px for `cut_damage`; under `triple_hp` his last
## move cuts the next three posts ahead at once. Args in his row. vars:
## "regs" ([{members: [[TdEnemy, gen]...], banner: [TdEnemy, gen], broken}]),
## "reg_i", "next_reg", "next_cut", "duel", "triple", "pose_until".
extends EnemyTrait

const Draw := preload("res://scripts/enemies/traits/shogunate/draw.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.speed = 0.0  # On his platform.
	e.follower.advance(float(a["stand_dist"]))
	e.position = e.follower.position()
	e.last_dist = e.follower.dist
	e.vars["regs"] = []
	e.vars["reg_i"] = 0
	e.vars["next_reg"] = game.time + float(a["regiment_first"])
	e.vars["next_cut"] = 0.0
	e.vars["duel"] = false
	e.vars["triple"] = false
	e.vars["pose_until"] = 0.0


## HP a lost soldier takes off him.
static func _point(e: TdEnemy) -> float:
	var a: Dictionary = e.row["args"]
	var n := 0  # Soldiers and banners in all regiments.
	for rg: Array in a["regiments"]:
		n += int(rg[1]) + 1
	return e.max_hp * float(a["points_frac"]) / float(maxi(n, 1))


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	if not bool(e.vars["duel"]):
		_march(e, game, a)
		_count_losses(e, game, a)
		var spent := int(e.vars["reg_i"]) >= (a["regiments"] as Array).size() and (e.vars["regs"] as Array).all(func(r: Dictionary) -> bool: return (r["members"] as Array).is_empty())
		if e.hp <= e.max_hp * float(a["duel_hp"]) + 0.5 or spent:
			e.vars["duel"] = true
			e.speed = float(e.row["speed"])
			e.vars["next_cut"] = game.time + float(a["cut_every"])
			game.banner("Shogun Kurogane draws his blade and comes down to duel!")
			EnemyTrait.note(game, "shogun_duel")
			Sfx.play("taiko_hit")
		return
	if game.time < float(e.vars["next_cut"]) or game.time < e.freeze_until:
		return
	var f := clampf(e.hp / (e.max_hp * float(a["duel_hp"])), 0.0, 1.0)  # 1 at the duel's start .. 0.
	e.vars["next_cut"] = game.time + lerpf(float(a["cut_every_min"]), float(a["cut_every"]), f)
	var dmg := float(a["cut_damage"]) * e.damage_mult()  # One cut's damage.
	if not bool(e.vars["triple"]) and e.hp < e.max_hp * float(a["triple_hp"]):
		e.vars["triple"] = true
		for blk: RoadBlock in _posts_ahead(e, game, INF, 3):
			Draw.cut(game, e, blk, dmg)
		game.banner("The Shogun's last cut: three lines at once!")
		EnemyTrait.note(game, "shogun_triple")
	else:
		var posts := [e.holder.block] if e.holder != null else _posts_ahead(e, game, float(a["cut_reach"]), 1)  # What he cuts.
		if posts.is_empty():
			return
		Draw.cut(game, e, posts[0], dmg)
	EnemyTrait.note(game, "shogun_cuts")
	e.pose = 3
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()


## Sends the next regiment when it is due.
func _march(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var i := int(e.vars["reg_i"])  # Next regiment.
	if i >= (a["regiments"] as Array).size() or game.time < float(e.vars["next_reg"]):
		return
	e.vars["reg_i"] = i + 1
	e.vars["next_reg"] = game.time + float(a["regiment_every"])
	var gates: Array[String] = []  # Entrance roads, in map order.
	for id: String in game.roads:
		if (game.roads[id] as Road).entrance:
			gates.append(id)
	var road := gates[i % gates.size()]  # The gates in turn.
	var rg: Array = a["regiments"][i]
	var banner := game.waves.spawn_extra(String(a["hatamoto_kind"]), road, 0.0, 0.0)
	banner.vars["regiment"] = i
	var members: Array = [[banner, banner.generation]]
	for k in int(rg[1]):
		var m := game.waves.spawn_extra(String(rg[0]), road, -float(a["regiment_gap"]) * float(k + 1), float(k % 2 * 2 - 1) * 8.0)
		m.vars["regiment"] = i
		members.append([m, m.generation])
	(e.vars["regs"] as Array).append({"members": members, "banner": [banner, banner.generation], "broken": false})
	game.banner("Regiment %d of %d marches: %s" % [i + 1, (a["regiments"] as Array).size(), String(Acts.kinds()[String(rg[0])]["name"])])
	Sfx.play("taiko_hit")
	EnemyTrait.note(game, "shogun_regiments")


## Takes a point off him for every soldier lost since the last step; breaks a
## regiment whose Hatamoto fell (the rest flee and count as lost).
func _count_losses(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var lost := 0  # Soldiers lost this step.
	for rg: Dictionary in e.vars["regs"]:
		var bn: Array = rg["banner"]
		if not bool(rg["broken"]) and not TdEnemy.valid(bn[0], int(bn[1])):
			rg["broken"] = true
			for p: Array in rg["members"]:
				if TdEnemy.valid(p[0], int(p[1])):
					var m: TdEnemy = p[0]
					game.fx.spawn("spore_cloud", m.position, 40.0, 0.5, Acts.data("shogunate")["LOOK"]["smoke_tint"])
					game.remove_enemy(m, false)
			EnemyTrait.note(game, "regiments_broken")
			game.banner("A regiment's banner falls: the regiment breaks and flees!")
		var keep: Array = []  # Still marching.
		for p: Array in rg["members"]:
			if TdEnemy.valid(p[0], int(p[1])):
				keep.append(p)
			else:
				lost += 1
		rg["members"] = keep
	if lost == 0:
		return
	var amount := minf(_point(e) * float(lost), e.hp - e.max_hp * float(a["duel_hp"]))  # Never past the duel mark.
	EnemyTrait.note(game, "shogun_points", float(lost))
	if amount > 0.0:
		TdCombat.damage_enemy(game, e, amount, {"source": "shogun_regiments", "dot": true})


func incoming_damage(e: TdEnemy, _game: TdGame, amount: float, hit: Dictionary) -> float:
	if bool(e.vars.get("duel", true)) or String(hit.get("source", "")) == "shogun_regiments":
		return amount
	return clampf(amount * float(e.row["args"]["guard_mult"]), 0.0, maxf(e.hp - e.max_hp * float(e.row["args"]["duel_hp"]), 0.0))


## Up to `n` road posts ahead of `e` on his way (his road, then the roads it
## joins) within `reach` px along it, nearest first, each with a living body.
static func _posts_ahead(e: TdEnemy, game: TdGame, reach: float, n: int) -> Array:
	var found: Array = []  # [px ahead, block].
	var road := e.follower.road  # Road being searched.
	var from := e.follower.dist  # Px along it where the search starts.
	var base := 0.0  # Px already walked to reach `from`.
	while road != null:
		for blk: RoadBlock in game.blocks:
			if blk.road_id == road.id and blk.dist >= from and base + blk.dist - from <= reach and game.time < blk.until \
					and blk.bodies.any(func(b: BlockBody) -> bool: return b.alive):
				found.append([base + blk.dist - from, blk])
		base += road.length - from
		if road.next_id == "" or not game.roads.has(road.next_id):
			break
		from = road.next_at
		road = game.roads[road.next_id]
	found.sort_custom(func(x: Array, y: Array) -> bool: return float(x[0]) < float(y[0]))
	var out: Array = []  # The blocks.
	for f: Array in found.slice(0, n):
		out.append(f[1])
	return out
