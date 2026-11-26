## The Luminous shield and beam (Necropathy's LumenSentinelKit: "a shield that
## soaks the first hits", "sweeping beams"): the generic shooter (its beam
## staff blinds a tower through game.hostile.fire(), args as shooter.gd) plus a
## shield of light worth `shield` x its max HP that soaks every hit first
## (never renewed; drawn as a white-gold flash while it holds). The Archon
## reuses soak(). Args: shooter.gd's + shield (share of max HP).
## vars: shooter.gd's + "shield" (HP left).
extends "res://scripts/enemies/traits/shooter.gd"


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	super(e, game)
	e.vars["shield"] = -1.0


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, hit: Dictionary) -> float:
	return soak(e, game, amount, hit)


## The shield takes `amount` first (sized on the first hit, so a wave's HP tier
## counts); returns what passes.
static func soak(e: TdEnemy, game: TdGame, amount: float, _hit: Dictionary) -> float:
	if float(e.vars.get("shield", -1.0)) < 0.0:
		e.vars["shield"] = e.max_hp * float(e.row["args"]["shield"])
	var s := float(e.vars["shield"])  # HP left on it.
	if s <= 0.0:
		return amount
	var take := minf(s, amount)  # What it soaks.
	e.vars["shield"] = s - take
	if s - take <= 0.0:
		EnemyTrait.note(game, "lumen_shields_broken")
		game.fx.spawn("holy_impact", e.position, 70.0, 0.4, Acts.data("concord")["LOOK"]["light"])
	return amount - take
