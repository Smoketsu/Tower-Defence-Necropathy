## The Twin Succubi (the Palace's miniboss pair; Necropathy TwinSuccubusKit:
## "two sisters who charm in turns; kill one and the other rages"). Each
## twin, every `every` s (first after `first`: the sisters' kisses alternate),
## kisses the `bodies` living blocker bodies nearest her within `range` px:
## charmed `time` s at `hit_mult` (TdCombat.charm_body); never the body
## holding her (she does not kiss her way free). When one falls, the
## other (kind `sister`) RAGES: hasted x`rage_haste` for good and her kisses
## come `rage_every` x as often. Args as named. vars: "next", "rage" (bool).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/inferno/inferno_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["rage"] = false


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until:
		return
	var n := 0  # Bodies kissed.
	for i in int(a["bodies"]):
		var b := Kit.nearest_body(game, e.position, float(a["range"]), e.holder)  # The next one (charmed ones and her own holder are skipped).
		if b == null:
			break
		Kit.kiss(game, e.position, b, float(a["time"]), float(a["hit_mult"]))
		n += 1
	if n == 0:
		return
	e.vars["next"] = game.time + float(a["every"]) * (float(a["rage_every"]) if bool(e.vars["rage"]) else 1.0)
	EnemyTrait.note(game, "twin_kisses")


func on_death(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	for o: TdEnemy in game.enemies:
		if o.alive and o.kind == String(a["sister"]) and not bool(o.vars.get("rage", false)):
			o.vars["rage"] = true
			TdCombat.haste_enemy(game, o, float(a["rage_haste"]), 9999.0)
			game.banner("%s falls: %s rages!" % [String(e.row["name"]), String(o.row["name"])])
			Sfx.play("twin_rage")
			EnemyTrait.note(game, "twin_rages")
			return
