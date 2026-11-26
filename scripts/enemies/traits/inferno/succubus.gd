## Succubus (Necropathy SuccubusKit, Temptation: "charms summons; flies"):
## she flies over the posts; every `every` s (first after `first`) she blows a
## kiss at the living blocker body nearest her within `range` px: it is
## charmed `time` s and fights its own post at `hit_mult` x its blow
## (TdCombat.charm_body; a Mender heal or a Warder barrier cleanses it).
## Args: first, every (s), range (px), time (s), hit_mult. vars: "next".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/inferno/inferno_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until:
		return
	var b := Kit.nearest_body(game, e.position, float(a["range"]))  # Her mark.
	if b == null:
		return
	e.vars["next"] = game.time + float(a["every"])
	Kit.kiss(game, e.position, b, float(a["time"]), float(a["hit_mult"]))
	EnemyTrait.note(game, "succubus_kisses")
