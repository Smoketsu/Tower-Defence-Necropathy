## Don Marrow, the Kingpin (Act IV, Skid Row's boss; GDD §7.3; Necropathy
## BossDonMarrow, road version). Three phases by his HP:
##   THE BOUNTY — `board_after` s after he arrives he raises his Bounty Board
##     (kind bounty_board, a structure) `board_ahead` px ahead of him on his
##     road, `board_lane` px beside it; while it stands a gang squad
##     (`bounty_squad`) climbs in behind him every `bounty_every` s. Break the
##     board to end it (it also falls with him).
##   THE CALL — below `call_hp`: he phones the police; a police / SWAT squad
##     (`call_squad`) every `call_every` s, on top of the bounty.
##   THE LAST STAND — below `stand_hp`: his limo's cover lets only
##     `cover_mult` of each hit through, and every `sweep_every` s his gold
##     minigun sweeps the road ahead: `sweep_marks` telegraphed circles over
##     `sweep_reach` px (CityTactics.road_line: towers pinned `sweep_disable`
##     s, bodies take `sweep_damage`), after a `sweep_windup` s wind-up pose.
## Args in his kind row. vars: "stage" (1-3), "board_at" (game s), "board"
## (TdEnemy) + "board_gen", "next_bounty", "next_call", "next_sweep",
## "pose_until" (game s). Events: marrow_board, marrow_bounty_squads,
## marrow_call_squads, marrow_sweeps.
extends EnemyTrait

## Shared boss moves.
const Tactics := preload("res://scripts/bosses/city/city_tactics.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["stage"] = 1
	e.vars["board_at"] = game.time + float(a["board_after"])
	e.vars["board"] = null
	e.vars["board_gen"] = -1
	e.vars["next_bounty"] = INF
	e.vars["next_call"] = INF
	e.vars["next_sweep"] = INF
	e.vars["pose_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	var t := game.time  # Now (game s).
	if e.pose != 0 and t >= float(e.vars["pose_until"]):
		Tactics.phase(game, e, 0, "")
	if t >= float(e.vars["board_at"]):
		e.vars["board_at"] = INF
		_raise_board(e, game, a)
	var board_up := TdEnemy.valid(e.vars["board"], int(e.vars["board_gen"]))  # The bounty runs.
	if board_up and t >= float(e.vars["next_bounty"]) and t >= e.freeze_until:
		e.vars["next_bounty"] = t + float(a["bounty_every"])
		Tactics.squad(game, e, a["bounty_squad"], float(a["squad_gap"]))
		EnemyTrait.note(game, "marrow_bounty_squads")
	var stage := int(e.vars["stage"])  # Current phase.
	if stage == 1 and e.hp < e.max_hp * float(a["call_hp"]):
		e.vars["stage"] = 2
		e.vars["next_call"] = t
		game.sound("city_siren")
		Tactics.phase(game, e, 1, "Don Marrow calls the cops on you!")
		e.vars["pose_until"] = t + float(a["pose_time"])
	elif stage == 2 and e.hp < e.max_hp * float(a["stand_hp"]):
		e.vars["stage"] = 3
		e.vars["next_sweep"] = t + float(a["sweep_windup"])
		Tactics.phase(game, e, 1, "The Last Stand: Don Marrow fights from behind his limo!")
		e.vars["pose_until"] = t + float(a["pose_time"])
	if int(e.vars["stage"]) >= 2 and t >= float(e.vars["next_call"]) and t >= e.freeze_until:
		e.vars["next_call"] = t + float(a["call_every"])
		Tactics.squad(game, e, a["call_squad"], float(a["squad_gap"]))
		EnemyTrait.note(game, "marrow_call_squads")
	if int(e.vars["stage"]) == 3 and t >= float(e.vars["next_sweep"]) and t >= e.freeze_until:
		e.vars["next_sweep"] = t + float(a["sweep_every"])
		Tactics.road_line(game, e, float(a["sweep_reach"]), int(a["sweep_marks"]), float(a["sweep_radius"]),
				float(a["sweep_windup"]), 0.0, float(a["sweep_disable"]), float(a["sweep_damage"]))
		Tactics.phase(game, e, 1, "")
		e.vars["pose_until"] = t + float(a["sweep_windup"])
		game.sound("city_gun")
		EnemyTrait.note(game, "marrow_sweeps")


func incoming_damage(e: TdEnemy, _game: TdGame, amount: float, hit: Dictionary) -> float:
	if int(e.vars.get("stage", 1)) == 3 and not bool(hit.get("dot", false)):
		return amount * float(e.row["args"]["cover_mult"])  # Behind the limo.
	return amount


func on_death(e: TdEnemy, game: TdGame) -> void:
	var b: TdEnemy = e.vars.get("board", null)  # His board falls with him.
	if TdEnemy.valid(b, int(e.vars.get("board_gen", -1))):
		game.remove_enemy(b, false)


## Raises the Bounty Board ahead of `e` (see the header).
func _raise_board(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var r: Road = e.follower.road  # His road.
	var d := minf(e.follower.dist + float(a["board_ahead"]), r.length - 1.0)  # Along it (px).
	var b := game.spawn_at("bounty_board", r.id, 0, d, float(a["board_lane"]))  # The board (a structure: no wave).
	e.vars["board"] = b
	e.vars["board_gen"] = b.generation
	e.vars["next_bounty"] = game.time + float(a["bounty_every"]) * 0.5
	Tactics.phase(game, e, 1, "The Bounty: break Don Marrow's board!")
	e.vars["pose_until"] = game.time + float(a["pose_time"])
	EnemyTrait.note(game, "marrow_board")
	if game.vfx.on:
		game.fx.spawn("summon_rise", b.position, TdVfxData.CITY_POWER_D, TdVfxData.CITY_POWER_TIME)
