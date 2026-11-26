## Hellhound (Necropathy LavaHoundKit: "lava hounds; leave a short fire
## trail"): fast pack fodder. While a post holds it, every `pit_every` s its
## burning hide opens a small Hell Pit under the body holding it (the act
## rule's open_pit(): the post burns until the hound dies or the pit cools).
## Args: pit_every (s), pit_radius (px), pit_life (s), pit_telegraph (s).
## vars: "next" (game s of its next pit).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/inferno/inferno_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["pit_every"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if e.holder == null or game.time < e.freeze_until or game.time < float(e.vars["next"]):
		return
	e.vars["next"] = game.time + float(a["pit_every"])
	if Kit.pit(game, e.holder.pos, float(a["pit_radius"]), float(a["pit_life"]), float(a["pit_telegraph"])):
		EnemyTrait.note(game, "hound_pits")
