## Powder Runner (the Black Tide; Necropathy PowderRunnerKit): it sprints at
## the blockers with a lit keg. Once a blocker body holds it, its fuse burns
## `fuse` s (a fuse spark shows), then the keg bursts: every blocker body
## within `radius` px takes `body_damage` and every OTHER enemy there takes
## `enemy_damage` (both sides, as in Necropathy), and the runner dies in its
## own blast (no souls, no kill credit). Killed before the fuse ends, the keg
## never goes off. Args in its row. vars: "fuse_at" (game s the blast is due; absent = unlit).
extends EnemyTrait


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if not e.vars.has("fuse_at"):
		if e.holder != null:
			e.vars["fuse_at"] = game.time + float(a["fuse"])
			var lk: Dictionary = Acts.data("corsair")["LOOK"]  # Looks (drawn only).
			game.fx.spawn("volley_flash", e.position + Vector2(0, -18), float(lk["fuse_spark"]), float(a["fuse"]), lk["amber"])
		return
	if game.time < float(e.vars["fuse_at"]):
		return
	var r := float(a["radius"])  # Blast radius (px).
	for b: BlockBody in game.bodies_near(e.position, r):
		TdCombat.damage_body(game, b, float(a["body_damage"]))
	for o: TdEnemy in game.foes_near(e.position, r):
		if o != e:
			TdCombat.damage_enemy(game, o, float(a["enemy_damage"]), {"source": "powder_blast", "origin": e.position})
	EnemyTrait.note(game, "powder_blasts")
	if game.vfx.on:
		game.vfx.add(TdVfx.Kind.ANIM, e.position, r * 2.2, TdVfxData.IMPACT_TIME * 1.4, Acts.data("corsair")["LOOK"]["blast_tint"], "corpse_explosion")
		game.vfx.shake(2.0)
	if e.alive:
		game.vfx.death(e)
		game.remove_enemy(e, false)  # It dies in its own blast: no souls, no credit.
