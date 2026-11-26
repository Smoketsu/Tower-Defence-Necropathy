## The Bog Croc (Necropathy's BogCrocKit: "an ambusher that lies submerged in
## the tar and lunges"): in a tar seep it sinks out of sight (the act rule sets
## vars "hidden_until": no tower sees it; drawn as its submerged still, args
## "sprite_sunk"); its FIRST blow on a post is a lunge for `lunge` extra damage
## (x its weaken). Args: lunge, sprite_sunk (SpriteData key). vars: "lunged",
## "sprite" (the drawn look while sunk).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/primeval/kit.gd")


func on_spawn(e: TdEnemy, _game: TdGame) -> void:
	e.vars["lunged"] = false


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var sunk := game.time < float(e.vars.get("hidden_until", 0.0))
	var want := String(e.row["args"]["sprite_sunk"]) if sunk else ""
	if String(e.vars.get("sprite", "")) != want:
		if want == "":
			e.vars.erase("sprite")
		else:
			e.vars["sprite"] = want
		e.body.queue_redraw()


func on_attack(e: TdEnemy, game: TdGame, body: BlockBody) -> void:
	if bool(e.vars["lunged"]) or not body.alive:
		return
	e.vars["lunged"] = true
	TdCombat.damage_body(game, body, float(e.row["args"]["lunge"]) * e.damage_mult(), e)
	Kit.line(game, e.position, body.pos, 0.0, true)
	EnemyTrait.note(game, "croc_lunges")
