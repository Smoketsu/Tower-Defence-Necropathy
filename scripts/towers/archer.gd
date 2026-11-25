## Skeleton Archer kit (GDD §4.1): fast single-target arrows (projectile.gd).
## Evolved into the Gravebow (EvolutionData "gravebow", keys in its "set"):
## arrows pierce (`pierce`), every `split_every` shots `split_count` extra
## arrows split off at other enemies in range for `split_damage` x the shot,
## and every arrow curses what it hits: tower hits on it deal x `curse_mult`
## for `curse_time` s (TdCombat.curse_enemy()).
extends "res://scripts/towers/projectile.gd"


func step(t: Tower, dt: float) -> void:
	var before := t.shots  # Shots fired before this step.
	super(t, dt)
	var every := int(t.stats.get("split_every", 0))  # Split cadence (0 = not a Gravebow).
	if every <= 0 or t.shots == before or t.shots % every != 0:
		return
	var main := t.pick_target()  # The arrow's own target (split arrows look for others).
	var n := 0  # Split arrows fired.
	for e: TdEnemy in t.game.foes_near(t.position, float(t.stats["range"])):
		if e != main and n < int(t.stats["split_count"]):
			t.game.projectiles.fire(t, e, float(t.stats["damage"]) * float(t.stats["split_damage"]), String(t.stats["projectile"]), Color(0.75, 1.0, 0.8), false)
			n += 1


func impact(t: Tower, _shot: TdProjectiles.Shot, victims: Array[TdEnemy]) -> void:
	var mult := float(t.stats.get("curse_mult", 1.0))  # Gravebow curse (1 = none).
	if mult <= 1.0:
		return
	for e: TdEnemy in victims:
		if e.alive:
			TdCombat.curse_enemy(t.game, e, mult, float(t.stats["curse_time"]))
