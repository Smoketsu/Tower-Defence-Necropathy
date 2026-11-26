## Frost Giant (Act VI; Necropathy's FrostGiantKit: "throws a BOULDER onto a
## telegraphed landing circle; DOUSES the braziers it passes"): the shooter
## trait with an arcing boulder at the nearest tower (it flies over the posts
## and freezes the tower, cause "frozen"), and the seer's douse as it walks.
## Args: the shooter keys + douse_radius. vars: the shooter's + "doused".
extends "res://scripts/enemies/traits/shooter.gd"

const Seer := preload("res://scripts/enemies/traits/norse/seer.gd")


func step(e: TdEnemy, game: TdGame, dt: float) -> void:
	Seer.douse_step(e, game, float(e.row["args"]["douse_radius"]))
	super(e, game, dt)
