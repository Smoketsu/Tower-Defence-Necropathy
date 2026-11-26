## A Footnote, one of the Archivist's copies (Necropathy's ArchivistCopy):
## it walks beside her and TAKES NO DAMAGE (every hit on it is wasted:
## incoming_damage 0; counted as "eye_footnote_hits"); it never attacks and
## fades after the boss's `foot_time` (vars "until", set by her) without a
## kill, leaking nothing (row leak_lives 0). vars: "until" (game s it fades).
extends EnemyTrait


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	if game.time >= float(e.vars.get("until", INF)):
		game.fx.spawn("ink_burst", e.position, 80.0, 0.45)
		game.remove_enemy(e, false)


func incoming_damage(_e: TdEnemy, game: TdGame, _amount: float, _hit: Dictionary) -> float:
	EnemyTrait.note(game, "eye_footnote_hits")
	return 0.0
