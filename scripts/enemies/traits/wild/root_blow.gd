## Root blow (the Treant; Necropathy's TreantKit "its strike roots the summon it
## hits"): every `every`-th blow on the body holding it, its roots seize that
## post: the post is disabled `root` s (TdCombat.disable_tower, cause "rooted":
## its bodies stop striking) and the struck body takes `body_damage` more.
## Args: every (blows), root (s), body_damage. vars: "blows" (count).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/wild/wild_kit.gd")


func on_attack(e: TdEnemy, game: TdGame, body: BlockBody) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var n := int(e.vars.get("blows", 0)) + 1  # Blows so far.
	e.vars["blows"] = n
	if n % int(a["every"]) != 0 or body == null or body.block == null:
		return
	TdCombat.damage_body(game, body, float(a["body_damage"]) * e.damage_mult(), e)
	for t: Tower in game.towers:
		if t.block == body.block:  # The post holding it.
			TdCombat.disable_tower(game, t, float(a["root"]), "rooted")
	game.fx.spawn("wild_bury", body.pos, 56.0, 0.5, Kit.lk()["root_tint"])
	EnemyTrait.note(game, "treant_roots")
	Sfx.play("roots_grab")
