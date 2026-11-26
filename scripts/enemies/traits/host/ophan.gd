## The Ophan (Necropathy's OphanKit: "a burning wheel that rolls straight
## through the ring"): no post holds it unless it is STAGGERED or frozen
## (TdEnemy.unholdable_until is kept ahead of the clock otherwise; one held
## while staggered rolls free when the stagger ends). Every `roll_every` s
## (first `roll_first` s after it arrives) it ROLLS: `speed_mult` x its speed
## for `roll_time` s, and each post it passes during the roll has its living
## bodies struck for `roll_damage` (x its weaken), once per post. The Throne
## rolls with the same helper (roll_over()). Answer: the Abomination's stomp,
## the Bone Golem, the Fallen Hero, a freeze.
## Args: roll_damage, roll_first, roll_every, roll_time (s), speed_mult.
## vars: "next_roll", "roll_until" (game s), "rolled" (posts struck this roll).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_roll"] = game.time + float(e.row["args"]["roll_first"])
	e.vars["roll_until"] = 0.0
	e.vars["rolled"] = []


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var held_ok := game.time < e.staggered_until or game.time < e.freeze_until  # Only a staggered / frozen wheel stops.
	e.unholdable_until = 0.0 if held_ok else game.time + 1.0
	if e.holder != null and not held_ok:
		e.holder.held.erase(e)
		e.holder = null
		EnemyTrait.note(game, "ophan_rolls_free")
	if game.time >= float(e.vars["next_roll"]) and not held_ok:
		e.vars["next_roll"] = game.time + float(a["roll_every"])
		e.vars["roll_until"] = game.time + float(a["roll_time"])
		e.vars["rolled"] = []
		TdCombat.haste_enemy(game, e, float(a["speed_mult"]), float(a["roll_time"]))
		EnemyTrait.note(game, "ophan_rolls")
	if game.time < float(e.vars["roll_until"]):
		roll_over(e, game, float(a["roll_damage"]))


## Strikes the bodies of every post `e` is passing (within its radius + 16 px
## along its road), each post once per roll (vars "rolled"); returns bodies hit.
static func roll_over(e: TdEnemy, game: TdGame, dmg: float) -> int:
	var n := 0  # Bodies struck.
	var done: Array = e.vars.get("rolled", [])
	for blk: RoadBlock in game.blocks:
		if blk.road_id != e.follower.road.id or done.has(blk) or absf(blk.dist - e.follower.dist) > e.radius + 16.0:
			continue
		done.append(blk)
		for b: BlockBody in blk.bodies:
			if b.alive:
				TdCombat.damage_body(game, b, dmg * e.damage_mult(), e)
				n += 1
		game.fx.spawn("vael_cleave", e.position, float(Acts.data("host")["LOOK"]["roll_d"]), 0.4, Acts.data("host")["LOOK"]["roll_tint"])
	e.vars["rolled"] = done
	return n
