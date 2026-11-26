## Spores (the Spore Mother; Necropathy's SporeMotherKit, "spores that rot
## summons"): every `every` s (first `first` s after it arrives) she swells for
## `windup` s (a pale ring), then bursts: every blocker body within `radius` px
## takes `body_damage` (x her weaken) and every tower there is smothered: its
## damage x `weaken` for `weaken_time` s (TdCombat.suppress_tower, the one
## weakening path). Not while frozen or silenced.
## Args: first, every, windup (s), radius (px), body_damage, weaken (0..1),
## weaken_time (s). vars: "next", "at" (game s the burst lands; 0 = none).
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/wild/wild_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])
	e.vars["at"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Her numbers.
	var at := float(e.vars["at"])
	if at > 0.0:
		if game.time >= at:
			e.vars["at"] = 0.0
			burst(e, game, float(a["radius"]), float(a["body_damage"]), float(a["weaken"]), float(a["weaken_time"]))
		return
	if game.time >= float(e.vars["next"]) and game.time >= e.freeze_until and game.time >= e.silenced_until:
		e.vars["next"] = game.time + float(a["every"])
		e.vars["at"] = game.time + float(a["windup"])
		Kit.ring(game, e.position, float(a["radius"]), float(a["windup"]), Kit.lk()["spore_tint"], false)


## One spore burst round `e` (see the header; the Summer Queen's petals use it too). Returns the towers smothered.
static func burst(e: TdEnemy, game: TdGame, radius: float, dmg: float, mult: float, time: float) -> int:
	for b: BlockBody in game.bodies_near(e.position, radius):
		TdCombat.damage_body(game, b, dmg * e.damage_mult(), e)
	var n := 0  # Towers smothered.
	for t: Tower in CovenantField.of(game).towers_near(e.position, radius):
		TdCombat.suppress_tower(game, t, mult, time)
		n += 1
	Kit.ring(game, e.position, radius, 0.5, Kit.lk()["spore_tint"], true)
	game.fx.spawn("spore_cloud", e.position, radius * 2.0, 0.7, Kit.lk()["spore_tint"])
	EnemyTrait.note(game, "spore_bursts")
	Sfx.play("plague_cast")
	return n
