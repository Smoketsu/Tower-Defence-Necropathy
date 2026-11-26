## A herd beast of the Stampedes (Necropathy's Herds: Longnecks and Duckbills
## "wander as neutral bodies; they do not attack; they stampede"): it walks a
## herd trail (off-road, exit) and never fights. While it runs FORWARD it
## tramples: every tower within `radius` px is disabled `disable` s (the
## generic trampler, cause "trampled") and every blocker body within
## `body_radius` px is knocked down for `body_damage`, each once. Every hit it
## takes is told to the act rule (Stampedes.herd_hurt(): enough hurt turns the
## whole herd back; at the watering hole it bolts). A turned beast (vars
## "turned") tramples nothing. Args: radius, disable (s), body_radius, body_damage.
## vars: "trampled" (spot ids), "knocked" (bodies), "herd", "turned" (the rule's).
extends "res://scripts/enemies/traits/trampler.gd"

const Stampedes := preload("res://scripts/maps/rules/primeval/stampedes.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	super.on_spawn(e, game)
	e.vars["knocked"] = []


func step(e: TdEnemy, game: TdGame, dt: float) -> void:
	if bool(e.vars.get("turned", false)):
		return
	var before: int = (e.vars["trampled"] as Array).size()
	super.step(e, game, dt)
	if (e.vars["trampled"] as Array).size() > before:
		EnemyTrait.note(game, "herd_tramples")
		Sfx.play("trample")
	var a: Dictionary = e.row["args"]
	var done: Array = e.vars["knocked"]
	for b: BlockBody in game.bodies_near(e.position, float(a["body_radius"])):
		if not done.has(b):
			done.append(b)
			TdCombat.damage_body(game, b, float(a["body_damage"]), e)
			EnemyTrait.note(game, "herd_knockdowns")


func on_hit(e: TdEnemy, game: TdGame, amount: float, _hit: Dictionary) -> void:
	var rule := Stampedes.of(game)
	if rule != null:
		rule.call("herd_hurt", e, amount)
