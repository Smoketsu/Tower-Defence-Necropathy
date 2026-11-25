## Old Greymane (Ravensmoor's miniboss; Necropathy OldGreymaneKit), the pack's
## alpha, always the beast. HOWL: first after `howl_first` s, then every
## `howl_every` s, every werewolf within `howl_radius` px turns into the beast at
## once and is hasted x `haste` for `haste_time` s (and so is he). LUNGE: every
## `lunge_every` s he breaks free and leaps `lunge_jump` px down the road, then
## bites the weakest blocker body within `lunge_reach` px for `lunge_damage`,
## healing `feed` of it (CourtKit.bite). Args: howl_first, howl_every,
## howl_radius, haste, haste_time, lunge_every, lunge_jump, lunge_reach,
## lunge_damage, feed. vars: "next_howl", "next_lunge" (game s).
extends EnemyTrait

## Shared Court helpers.
const CourtKit := preload("res://scripts/enemies/traits/court/court_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["next_howl"] = game.time + float(a["howl_first"])
	e.vars["next_lunge"] = game.time + float(a["lunge_every"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time < e.freeze_until:
		return
	var a: Dictionary = e.row["args"]  # His numbers.
	if game.time >= float(e.vars["next_howl"]):
		e.vars["next_howl"] = game.time + float(a["howl_every"])
		howl(e, game, float(a["howl_radius"]), float(a["haste"]), float(a["haste_time"]))
	if game.time >= float(e.vars["next_lunge"]):
		e.vars["next_lunge"] = game.time + float(a["lunge_every"])
		CourtKit.lunge(e, game, float(a["lunge_jump"]))
		var b := CourtKit.weakest_body(game, e.position, float(a["lunge_reach"]))  # His bite.
		if b != null:
			CourtKit.bite(game, e, b, float(a["lunge_damage"]), float(a["feed"]))
		EnemyTrait.note(game, "greymane_lunges")


## A howl from `e`: werewolves within `r` px turn and are hasted (so is `e`).
static func howl(e: TdEnemy, game: TdGame, r: float, haste: float, time: float) -> void:
	TdCombat.haste_enemy(game, e, haste, time)
	for o: TdEnemy in game.foes_near(e.position, r):
		if o.kind == "werewolf":
			o.traits.call("turn", o, game)
			TdCombat.haste_enemy(game, o, haste, time)
	CourtKit.mark(game, e.position, r, 0.8, CourtKit.tint("mark_tint"))
	game.fx.spawn("level_up", e.position, 120.0, 0.6, Color(1.0, 0.3, 0.3))
	EnemyTrait.note(game, "howls")
