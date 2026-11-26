## The Librarian, the Hollow Archive's miniboss (Necropathy's LibrarianKit: a
## floating eye wrapped in tendrils). Between `gap` s pauses (first `first` s
## after it arrives) it uses one of two telegraphed specials:
##   the Index beam — walking, toward the nearest tower within `beam_range`
##                    px: a lane `beam_len` px long and `beam_w` px wide is
##                    telegraphed for `beam_windup` s (a slow, readable tell),
##                    then the beam burns down it: every tower whose spot lies
##                    in the lane is blinded `beam_disable` s
##                    (TdCombat.disable_tower, cause "inked"), every blocker
##                    body in it takes `beam_body`.
##   Tendril lash   — held by a post: a ring of `lash_radius` px for
##                    `lash_windup` s, then its tendrils sweep it: every body
##                    inside takes `lash_damage` (x its weaken).
## Args: first, gap, beam_range, beam_len, beam_w, beam_windup, beam_disable,
## beam_body, lash_windup, lash_radius, lash_damage. vars: "next", "at",
## "move" ("beam" | "lash"), "dir" (the beam's unit direction).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/eye/eye_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["at"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var lk: Dictionary = Acts.data("eye")["LOOK"]
	var at := float(e.vars["at"])
	if at > 0.0:
		if game.time < at:
			return
		e.vars["at"] = 0.0
		e.vars["next"] = game.time + float(a["gap"])
		Kit.walk(e)
		if String(e.vars["move"]) == "beam":
			var dir: Vector2 = e.vars["dir"]
			var ln := float(a["beam_len"])  # Lane length (px).
			var hw := float(a["beam_w"]) * 0.5  # Half its width (px).
			var n := 0  # Towers blinded.
			for t: Tower in game.towers.duplicate():
				if _in_lane(t.position, e.position, dir, ln, hw):
					TdCombat.disable_tower(game, t, float(a["beam_disable"]), "inked")
					n += 1
			for blk: RoadBlock in game.blocks:
				for b: BlockBody in blk.bodies:
					if b.alive and _in_lane(b.pos, e.position, dir, ln, hw):
						TdCombat.damage_body(game, b, float(a["beam_body"]) * e.damage_mult(), e)
			Kit.line(game, e.position, e.position + dir * ln, 0.0, true, lk["ink_tint"])
			EnemyTrait.note(game, "eye_index_beams")
			EnemyTrait.note(game, "eye_index_blinded", float(n))
			Sfx.play("bolt_cast")
		else:
			for b: BlockBody in game.bodies_near(e.position, float(a["lash_radius"])):
				TdCombat.damage_body(game, b, float(a["lash_damage"]) * e.damage_mult(), e)
			Kit.ring(game, e.position, float(a["lash_radius"]), 0.35, true, "drowned_tendrils")
			EnemyTrait.note(game, "eye_tendril_lashes")
			Sfx.play("boss_impact")
		return
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until:
		return
	if e.holder != null:
		e.vars["move"] = "lash"
		e.vars["at"] = game.time + float(a["lash_windup"])
		Kit.ring(game, e.position, float(a["lash_radius"]), float(a["lash_windup"]), false)
	else:
		var t := Kit.nearest_tower(game, e.position, float(a["beam_range"]))
		if t == null:
			return
		var dir := (t.position - e.position).normalized()  # Down the lane.
		e.vars["move"] = "beam"
		e.vars["dir"] = dir
		e.vars["at"] = game.time + float(a["beam_windup"])
		var f := game.vfx.add(TdVfx.Kind.STREAK, e.position + dir * float(a["beam_len"]), float(a["beam_w"]), float(a["beam_windup"]), Color(lk["warn_tint"], 0.35))
		if f != null:
			f.ang = dir.angle()
			f.size0 = float(a["beam_len"])
	Kit.stand(e)


## True when `p` lies in the lane from `o` along unit `dir`, `ln` px long and `hw` px either side.
func _in_lane(p: Vector2, o: Vector2, dir: Vector2, ln: float, hw: float) -> bool:
	var v := p - o  # From the eye.
	var along := v.dot(dir)  # Px down the lane.
	return along >= 0.0 and along <= ln and absf(v.dot(Vector2(-dir.y, dir.x))) <= hw
