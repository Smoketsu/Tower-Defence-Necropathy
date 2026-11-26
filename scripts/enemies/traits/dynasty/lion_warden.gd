## The Lion Warden (Temple of the Lioness miniboss; Necropathy's LionWardenKit:
## "the slam ... the roar"): the ground slam (dynasty/slam) and, every
## `roar_every` s (first after `roar_first`), THE ROAR: every other enemy
## within `roar_radius` px is driven on (TdCombat.haste_enemy x `roar_haste`
## for `roar_time` s). Args: the slam's plus roar_first, roar_every,
## roar_radius, roar_haste, roar_time. vars: the slam's plus "next_roar".
extends "res://scripts/enemies/traits/dynasty/slam.gd"


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	super(e, game)
	e.vars["next_roar"] = game.time + float(e.row["args"]["roar_first"])


func step(e: TdEnemy, game: TdGame, dt: float) -> void:
	super(e, game, dt)
	if game.time < float(e.vars["next_roar"]) or game.time < e.freeze_until:
		return
	var a: Dictionary = e.row["args"]  # His numbers.
	e.vars["next_roar"] = game.time + float(a["roar_every"])
	for o: TdEnemy in game.foes_near(e.position, float(a["roar_radius"])):
		if o != e:
			TdCombat.haste_enemy(game, o, float(a["roar_haste"]), float(a["roar_time"]))
	EnemyTrait.note(game, "warden_roars")
	var ring := game.vfx.add(TdVfx.Kind.RING, e.position, float(a["roar_radius"]), TdVfxData.RING_TIME * 1.5, Acts.data("dynasty")["LOOK"]["roar_tint"])
	if ring != null:
		ring.size0 = 30.0
	game.vfx.shake(2.0)
