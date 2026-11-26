## The Harbourmaster, Gullhaven Harbour's miniboss (Necropathy's
## HarbourmasterKit: a hulking Deep Kin with a chained anchor). Between
## `gap` s pauses (first `first` s after he arrives) he uses one of two
## telegraphed specials, alternating when both are ready:
##   Anchor hurl  — walking, at the nearest tower within `hurl_range` px: a
##                  line for `hurl_windup` s, then the anchor flies down it
##                  (game.hostile.fire, look "anchor"): a tower it reaches is
##                  stunned `hurl_disable` s; the FIRST blocker body on its
##                  path stops it and takes `hurl_damage` (undead shield
##                  their master).
##   Anchor sweep — held by a post: a ring of `sweep_radius` px for
##                  `sweep_windup` s, then the anchor swings round: every body
##                  inside takes `sweep_damage` (x his weaken).
## Args: first, gap, hurl_range, hurl_windup, hurl_disable, hurl_damage,
## hurl_speed, sweep_windup, sweep_radius, sweep_damage. vars: "next", "at"
## (game s the special lands; 0 = none), "move" ("hurl" | "sweep"), "aim"
## (the tower aimed at), "last" (the last special used).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/eye/eye_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["at"] = 0.0
	e.vars["last"] = "sweep"


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	var at := float(e.vars["at"])
	if at > 0.0:
		if game.time < at:
			return
		e.vars["at"] = 0.0
		e.vars["next"] = game.time + float(a["gap"])
		Kit.walk(e)
		if String(e.vars["move"]) == "hurl":
			var t: Tower = e.vars.get("aim", null)  # Still standing?
			if t != null and is_instance_valid(t) and game.towers.has(t):
				game.hostile.fire(e.position + Vector2(0, -20), t, {"speed": float(a["hurl_speed"]), "damage": float(a["hurl_damage"]),
						"disable": float(a["hurl_disable"]), "cause": "hooked", "arc": false, "look": "anchor"})
				EnemyTrait.note(game, "eye_anchor_hurls")
				Sfx.play("catapult_launch")
		else:
			for b: BlockBody in game.bodies_near(e.position, float(a["sweep_radius"])):
				TdCombat.damage_body(game, b, float(a["sweep_damage"]) * e.damage_mult(), e)
			Kit.ring(game, e.position, float(a["sweep_radius"]), 0.35, true, "vael_cleave")
			game.vfx.shake(2.0)
			EnemyTrait.note(game, "eye_anchor_sweeps")
			Sfx.play("boss_impact")
		e.pose = 0
		return
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until:
		return
	var want := "sweep" if e.holder != null else "hurl"  # What he can do now.
	if want == "hurl":
		var t := Kit.nearest_tower(game, e.position, float(a["hurl_range"]))
		if t == null:
			return
		e.vars["aim"] = t
		e.vars["at"] = game.time + float(a["hurl_windup"])
		Kit.line(game, e.position, t.position, float(a["hurl_windup"]), false)
	else:
		e.vars["at"] = game.time + float(a["sweep_windup"])
		Kit.ring(game, e.position, float(a["sweep_radius"]), float(a["sweep_windup"]), false)
	e.vars["move"] = want
	e.vars["last"] = want
	Kit.stand(e)
