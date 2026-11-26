## The Summer Queen (Fae Court boss; Necropathy's BossSummerQueen). Two kits
## over three phases (`phase_hp`: [phase 2 from, phase 3 from] as HP shares):
##   petals     — every `petal_every` s (first after `petal_first`) she gathers
##                petals for `petal_windup` s (a pink ring, pose 1), then a
##                storm smothers every tower within `petal_radius` px: damage x
##                `petal_mult` for `petal_time` s (the Spore Mother's burst,
##                spores.gd, through TdCombat.suppress_tower).
##   the Masque — at the start of phases 2 and 3 she hides among `masks`
##                (`masks_p3`) Masked Courtiers wearing her face, set `mask_gap`
##                px apart round her on the road: no tower can pick her (vars
##                "hidden_until", the one hidden test; drawn faded) and she
##                regains `heal` of her max HP per s, until every courtier has
##                fallen or `masque_time` s have passed. Posts still hold her.
## The Bargain of Necropathy's fight is left out (DECISIONS T15).
## Not while frozen. Args in her row. vars: "phase", "next_petal", "petal_at",
## "pose_until" (game s), "masks" ([TdEnemy, generation] pairs), "hidden_until".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/wild/wild_kit.gd")
const Spores := preload("res://scripts/enemies/traits/wild/spores.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	e.vars["phase"] = 1
	e.vars["next_petal"] = game.time + float(a["petal_first"])
	e.vars["petal_at"] = 0.0
	e.vars["pose_until"] = 0.0
	e.vars["masks"] = []


func step(e: TdEnemy, game: TdGame, dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]) and float(e.vars["petal_at"]) <= 0.0:
		e.pose = 0
		e.body.queue_redraw()
	_masque_step(e, game, a, dt)
	var f := e.hp / e.max_hp  # HP share.
	var ph := 1 + (1 if f <= float(a["phase_hp"][0]) else 0) + (1 if f <= float(a["phase_hp"][1]) else 0)  # Phase now.
	if ph > int(e.vars["phase"]):
		e.vars["phase"] = ph
		_masque(e, game, a, int(a["masks_p3"] if ph == 3 else a["masks"]))
	var at := float(e.vars["petal_at"])
	if at > 0.0:
		if game.time >= at:
			e.vars["petal_at"] = 0.0
			Spores.burst(e, game, float(a["petal_radius"]), 0.0, float(a["petal_mult"]), float(a["petal_time"]))
			game.fx.spawn("volley_flash", e.position, float(a["petal_radius"]) * 2.0, 0.6, Kit.lk()["petal_tint"])
			EnemyTrait.note(game, "queen_petals")
		return
	if game.time >= float(e.vars["next_petal"]) and game.time >= e.freeze_until:
		e.vars["next_petal"] = game.time + float(a["petal_every"])
		e.vars["petal_at"] = game.time + float(a["petal_windup"])
		Kit.ring(game, e.position, float(a["petal_radius"]), float(a["petal_windup"]), Kit.lk()["petal_tint"], false)
		e.pose = 1
		e.vars["pose_until"] = game.time + float(a["pose_time"])
		e.body.queue_redraw()


## The Masque begins: `n` courtiers round her, she hides (see the header).
func _masque(e: TdEnemy, game: TdGame, a: Dictionary, n: int) -> void:
	var masks: Array = []  # [TdEnemy, generation].
	var keep := game.extra_hp_mult
	game.extra_hp_mult = game.waves.hp_ramp(maxi(game.waves.current, 0))
	for i in n:
		var off := float(a["mask_gap"]) * float(i / 2 + 1) * (1.0 if i % 2 == 0 else -1.0)  # Ahead and behind in turn.
		var d := clampf(e.follower.dist + off, 0.0, e.follower.road.length - 1.0)
		var m := game.waves.spawn_extra("wild_masked_courtier", e.follower.road.id, d, e.follower.lane + float(i % 3 - 1) * 10.0)
		m.vars["sprite"] = "wild/summer_queen_mask"  # Each wears her face (drawn only).
		masks.append([m, m.generation])
	game.extra_hp_mult = keep
	e.vars["masks"] = masks
	e.vars["hidden_until"] = game.time + float(a["masque_time"])
	e.vars["vis_alpha"] = float(Kit.lk()["queen_alpha"])
	Kit.ring(game, e.position, 120.0, 0.6, Kit.lk()["mask_tint"], true)
	game.fx.spawn("volley_flash", e.position, 160.0, 0.6, Kit.lk()["mask_tint"])
	game.banner("The Masque: the Summer Queen hides among her courtiers. Kill the masks to find her!")
	EnemyTrait.note(game, "queen_masques")
	Sfx.play("charm_kiss")


## While masked: her regrowth; the Masque ends when its courtiers have all fallen.
func _masque_step(e: TdEnemy, game: TdGame, a: Dictionary, dt: float) -> void:
	if game.time >= float(e.vars.get("hidden_until", 0.0)):
		e.vars["vis_alpha"] = 1.0
		return
	if EnemyTrait.can_heal(e, game):
		TdCombat.heal_enemy(game, e, e.max_hp * float(a["heal"]) * dt)
	var left := 0  # Courtiers still standing.
	for p: Array in e.vars["masks"]:
		if TdEnemy.valid(p[0], int(p[1])):
			left += 1
	if left == 0:
		e.vars["hidden_until"] = 0.0
		e.vars["vis_alpha"] = 1.0
		game.banner("The masks fall: the Summer Queen is revealed!")
		EnemyTrait.note(game, "queen_revealed")


func on_death(_e: TdEnemy, game: TdGame) -> void:
	game.banner("The Summer Queen falls: the endless summer ends")
