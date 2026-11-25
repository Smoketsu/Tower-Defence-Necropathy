## Templar Knight (GDD §6.1): after the first hit it takes, it charges: a
## brief speed burst. Args: speed_mult (x speed), time (s of the burst).
## vars: "charged" (bool) once the burst was used.
extends EnemyTrait


func on_hit(e: TdEnemy, game: TdGame, _amount: float, _hit: Dictionary) -> void:
	if e.vars.get("charged", false):
		return
	e.vars["charged"] = true
	var a: Dictionary = e.row["args"]  # The kind's numbers.
	TdCombat.haste_enemy(game, e, float(a["speed_mult"]), float(a["time"]))
