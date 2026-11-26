## Spotter (Act XII elite; Necropathy's SpotterKit: "an elite marksman that
## paints a Lock-On line on a target for 1.5 s, then fires a heavy rail shot
## down it"): every `every` s (first after `first`), unless frozen or
## staggered, it paints the nearest tower within `range` px that is not
## disabled (EmpireKit.lock(): the act rule's paint), then the rail shot
## `shot` flies down the line (HostileFire.fire args: disable s, damage to a
## body in the way, speed, look). A post between it and the tower takes the
## slug instead. Args: first, every (s), range (px), shot {..}. vars: "next".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/empire/empire_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next"] = game.time + float(e.row["args"]["first"])


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	if game.time < float(e.vars["next"]) or game.time < e.freeze_until or game.time < e.staggered_until:
		return
	var ts := Kit.towers_near(game, e.position, float(a["range"]))  # Towers in reach, nearest first.
	if ts.is_empty():
		return
	e.vars["next"] = game.time + float(a["every"])
	if Kit.lock(game, e, ts[0], a["shot"]):
		EnemyTrait.note(game, "spotter_paints")
