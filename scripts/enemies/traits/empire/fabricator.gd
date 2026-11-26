## Fabricator (Act XII; Necropathy's FabricatorKit, "builds a new enemy every
## few seconds until it is smashed"): a slow crawling factory; every `every` s
## (first after `first`), unless frozen or staggered, it builds one `kind` just
## ahead of itself on its road (WaveDirector.spawn_extra), at most `max` in its
## life. While any Fabricator stands, the Beta Build patches itself
## (empire/beta_build.gd reads the group by kind). Args: first, every, kind,
## max, ahead (px). vars: "next", "built".
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["built"] = 0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if game.time < float(e.vars["next"]) or int(e.vars["built"]) >= int(a["max"]) \
			or game.time < e.freeze_until or game.time < e.staggered_until:
		return
	e.vars["next"] = game.time + float(a["every"])
	e.vars["built"] = int(e.vars["built"]) + 1
	var r := e.follower.road  # Its road now.
	var d := minf(e.follower.dist + float(a["ahead"]), r.length - 1.0)  # Just ahead of it.
	var o := game.waves.spawn_extra(String(a["kind"]), r.id, d, e.follower.lane)
	game.fx.spawn("summon_rise", o.position, 56.0, 0.4, Acts.data("empire")["LOOK"]["arc_tint"])
	EnemyTrait.note(game, "fabricated")
	Sfx.play("fabricate")
