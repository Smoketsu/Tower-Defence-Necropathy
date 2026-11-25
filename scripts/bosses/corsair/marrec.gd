## Admiral Isabeau Marrec, the Sea Wolf, road version (the Treasure Galleon's
## boss; Necropathy BossMarrec: the Fleet, the Boarding, the lunge, Gold Fever).
##   THE FLEET — while her HP is above `fleet_hp`, every `fleet_every` s her
##     flagship fires a broadside: telegraphed shells (game.hostile.shell()) on
##     the `fleet_shells` dearest towers (most souls spent), `shell_radius` px,
##     `shell_delay` s, disabling them `shell_disable` s.
##   THE BOARDING — the first time her HP falls to `fleet_hp`, her marines
##     (`marines`: [{kind, count}]) board at the start of road `marine_road`
##     (missing: the first entrance), `marine_gap` px apart (banner).
##   THE LUNGE — every `lunge_every` s while a blocker holds her, a rapier lunge
##     through it (Lunge.lunge_through(), shared with the Swashbuckler):
##     `lunge_damage`, unholdable `lunge_time` s at `lunge_speed`.
##   GOLD FEVER — below `gold_hp`, every `coin_every` s she scatters `coins`
##     cursed coins (kind tide_cursed_coin, standing still on her road around
##     her, `coin_spread` px apart). Each coin within `coin_reach` px of her cuts
##     her damage taken by `coin_cut` (at most `coin_cap`): shoot the coins.
## Args in her row. vars: "next_fleet", "next_lunge", "next_coins", "boarded"
## (bool), "gold" (bool), "pose_until" (game s).
extends EnemyTrait

## The rapier lunge shared with the Swashbuckler.
const Lunge = preload("res://scripts/enemies/traits/corsair/lunge.gd")
## The crew boarding shared with the Ghost Bosun.
const GhostBosun = preload("res://scripts/enemies/traits/corsair/ghost_bosun.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["next_fleet"] = game.time + float(a["fleet_every"]) * 0.5
	e.vars["next_lunge"] = game.time + float(a["lunge_every"])
	e.vars["next_coins"] = 0.0
	e.vars["boarded"] = false
	e.vars["gold"] = false
	e.vars["pose_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]):
		e.pose = 0
		e.body.queue_redraw()
	var frac := e.hp / e.max_hp  # Her HP fraction.
	if frac > float(a["fleet_hp"]):
		if game.time >= float(e.vars["next_fleet"]):
			e.vars["next_fleet"] = game.time + float(a["fleet_every"])
			_fleet(e, game, a)
	elif not bool(e.vars["boarded"]):
		e.vars["boarded"] = true
		var road := String(a["marine_road"]) if game.roads.has(String(a["marine_road"])) else game.first_entrance()  # Where her marines board.
		GhostBosun.board(game, road, a["marines"], float(a["marine_gap"]))
		game.banner("Marrec's marines board over the rail!")
		EnemyTrait.note(game, "marrec_boardings")
		_pose(e, game, 1, a)
	if e.holder != null and game.time >= float(e.vars["next_lunge"]):
		e.vars["next_lunge"] = game.time + float(a["lunge_every"])
		Lunge.lunge_through(e, game, float(a["lunge_damage"]), float(a["lunge_time"]), float(a["lunge_speed"]))
		EnemyTrait.note(game, "marrec_lunges")
		_pose(e, game, 3, a)
	if frac < float(a["gold_hp"]):
		if not bool(e.vars["gold"]):
			e.vars["gold"] = true
			game.banner("Gold Fever! Shoot the cursed coins that shield the Sea Wolf")
		if game.time >= float(e.vars["next_coins"]):
			e.vars["next_coins"] = game.time + float(a["coin_every"])
			_coins(e, game, a)


## Her flagship's broadside on the dearest towers.
func _fleet(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var ts := game.towers.duplicate()  # Towers, dearest first (spot order breaks ties).
	ts.sort_custom(func(x: Tower, y: Tower) -> bool: return x.spent > y.spent)
	for i in mini(int(a["fleet_shells"]), ts.size()):
		game.hostile.shell((ts[i] as Tower).position, float(a["shell_radius"]), float(a["shell_delay"]), float(a["shell_disable"]), "shelled")
	EnemyTrait.note(game, "marrec_broadsides")
	_pose(e, game, 1, a)


## Scatters her cursed coins on her road around her.
func _coins(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var n := int(a["coins"])  # Coins this scatter.
	var road := e.follower.road  # Her road.
	for i in n:
		var off := (float(i) - float(n - 1) * 0.5) * float(a["coin_spread"])  # Px along the road from her.
		var d := clampf(e.follower.dist + off, 0.0, road.length)  # Its spot.
		game.waves.spawn_extra("tide_cursed_coin", road.id, d, float(i % 2 * 2 - 1) * TdRulesData.LANE_SPREAD)
	EnemyTrait.note(game, "marrec_coins", float(n))
	game.fx.spawn("level_up", e.position, float(Acts.data("corsair")["LOOK"]["coin_burst"]), 0.5, Acts.data("corsair")["LOOK"]["coin_tint"])
	_pose(e, game, 1, a)


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, _hit: Dictionary) -> float:
	if not bool(e.vars.get("gold", false)):
		return amount
	var a: Dictionary = e.row["args"]  # Her numbers.
	var n := 0  # Coins shielding her.
	for o: TdEnemy in game.enemies_near(e.position, float(a["coin_reach"])):
		if o.kind == "tide_cursed_coin":
			n += 1
	return amount * (1.0 - minf(float(n) * float(a["coin_cut"]), float(a["coin_cap"])))


## Shows pose `p` for pose_time s.
func _pose(e: TdEnemy, game: TdGame, p: int, a: Dictionary) -> void:
	e.pose = p
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	e.body.queue_redraw()
