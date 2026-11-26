## Ironjaw's nest (Necropathy's PrimevalNestKit: "the nest spawns Scuttlers
## until it is destroyed"): a stationary mound beside the road (speed 0); every
## `every` s it hatches `brood` `kind`s on its road at its place (extras of the
## latest wave). It falls with its mother (traits/primeval/ironjaw.gd removes
## it). Args: every (s), brood, kind. vars: "next" (game s), "mother" / "mother_gen".
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["every"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]
	if game.time < float(e.vars["next"]):
		return
	e.vars["next"] = game.time + float(a["every"])
	for i in int(a["brood"]):
		game.waves.spawn_extra(String(a["kind"]), e.follower.road.id, e.follower.dist + float(i) * 8.0, float(i - 1) * 8.0)
	game.fx.spawn("summon_rise", e.position, 60.0, 0.4)
	EnemyTrait.note(game, "nest_broods")
	Sfx.play("pack_hiss")
