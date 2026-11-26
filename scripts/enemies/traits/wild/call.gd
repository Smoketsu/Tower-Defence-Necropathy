## Call (the Turning Year's callers: the Corpse-Bloom's buds, the Rider's and
## the Huntsman's hunting horn; Necropathy's CorpseBloomKit / WildRiderKit /
## HuntsmanKit): every `every` s (first `first` s after it arrives) it winds up
## for `windup` s (a ring in its look's colour), then CALLS the next squad of
## `squads` (rows of [kind, count]; cycled) on its road just behind it, `gap` px
## apart, at the wave's HP (WildKit.call_squad); with `radius` > 0 the posts
## whose spot lies within it are shaken too (TdCombat.disable_tower, cause
## "stunned", `stun` s). At most `calls` calls; not while frozen or silenced.
## Args: first, every, windup (s), calls, squads, radius (px), stun (s), gap
## (px), look ("bud" | "horn"). vars: "next", "at" (game s the call lands; 0 =
## none), "called" (count).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/wild/wild_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["at"] = 0.0
	e.vars["called"] = 0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if int(e.vars["called"]) >= int(a["calls"]):
		return
	var at := float(e.vars["at"])
	if at > 0.0:
		if game.time >= at:
			e.vars["at"] = 0.0
			_call(e, game, a)
		return
	if game.time >= float(e.vars["next"]) and game.time >= e.freeze_until and game.time >= e.silenced_until:
		e.vars["next"] = game.time + float(a["every"])
		e.vars["at"] = game.time + float(a["windup"])
		Kit.ring(game, e.position, maxf(float(a["radius"]), 50.0), float(a["windup"]), Kit.lk()["warn_tint"], false)


## The call: the squad behind it, the posts shaken (see the header).
func _call(e: TdEnemy, game: TdGame, a: Dictionary) -> void:
	var i := int(e.vars["called"])  # This call.
	e.vars["called"] = i + 1
	var horn := String(a["look"]) == "horn"
	if float(a["radius"]) > 0.0:
		Kit.stop_towers(game, e.position, float(a["radius"]), float(a["stun"]), "stunned", true)
	var squads: Array = a["squads"]
	Kit.call_squad(e, game, squads[i % squads.size()], float(a["gap"]))
	var tint: Color = Kit.lk()["horn_tint" if horn else "bud_tint"]
	Kit.ring(game, e.position, maxf(float(a["radius"]), 60.0), 0.45, tint, true)
	game.fx.spawn("volley_flash" if horn else "spore_cloud", e.position, maxf(float(a["radius"]), 70.0), 0.5, tint)
	EnemyTrait.note(game, "horn_calls" if horn else "bloom_buds")
	Sfx.play("spring_horn" if horn else "thicket_grow")
