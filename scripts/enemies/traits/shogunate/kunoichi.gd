## Kunoichi (Necropathy "smoke bombs that blind"): a ninja (ambush, douses
## lanterns: ninja.gd) whose smoke bomb, every `smoke_every` s (first after
## `smoke_first`), blinds every tower within `smoke_radius` px for `blind` s
## (TdCombat.disable_tower, cause "blinded"). Args: as ninja.gd plus
## smoke_first, smoke_every (s), smoke_radius (px), blind (s). vars: "next_smoke".
extends "res://scripts/enemies/traits/shogunate/ninja.gd"


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	super(e, game)
	e.vars["next_smoke"] = game.time + float(e.row["args"]["smoke_first"])


func step(e: TdEnemy, game: TdGame, dt: float) -> void:
	super(e, game, dt)
	if game.time < float(e.vars["next_smoke"]) or game.time < e.freeze_until:
		return
	var a: Dictionary = e.row["args"]  # Her numbers.
	var hit := false  # Some tower in the smoke.
	for t: Tower in game.towers.duplicate():
		if t.position.distance_to(e.position) <= float(a["smoke_radius"]):
			TdCombat.disable_tower(game, t, float(a["blind"]), "blinded")
			hit = true
	if not hit:
		return
	e.vars["next_smoke"] = game.time + float(a["smoke_every"])
	EnemyTrait.note(game, "kunoichi_smokes")
	game.fx.spawn("spore_cloud", e.position, float(a["smoke_radius"]) * 2.0, 0.8, Acts.data("shogunate")["LOOK"]["smoke_tint"])
	Sfx.play("smoke_puff")
