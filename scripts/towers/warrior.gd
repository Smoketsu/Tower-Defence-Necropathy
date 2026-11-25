## Skeleton Warrior kit (GDD §4.1): the cheap blocker of blocker.gd. Evolved
## into the Death Knight (EvolutionData "death_knight", keys in its "set"):
## each strike cleaves every other enemy its post holds for `cleave_fraction`
## of the hit, and the striking body drains `lifesteal` of the damage it
## dealt back as HP (through TdCombat.heal_body()).
extends "res://scripts/towers/blocker.gd"


func strike(t: Tower, b: BlockBody) -> float:
	var first: TdEnemy = b.held[0]  # Its main target (not cleaved again).
	var dealt := super(t, b)  # The normal strike on its first held enemy.
	var cleave := float(t.stats.get("cleave_fraction", 0.0))  # Death Knight cleave share (0 = none).
	if cleave > 0.0:
		for body: BlockBody in t.block.bodies:
			for e: TdEnemy in body.held.duplicate():
				if e != first:
					dealt += TdCombat.damage_enemy(t.game, e, float(t.stats["damage"]) * cleave, {"source": "death_knight_cleave", "tower": t, "origin": b.pos})
	var steal := float(t.stats.get("lifesteal", 0.0))  # Death Knight lifesteal share (0 = none).
	if steal > 0.0 and dealt > 0.0:
		TdCombat.heal_body(t.game, b, dealt * steal)
	return dealt
