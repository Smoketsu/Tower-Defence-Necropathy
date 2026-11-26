## The Judge (Necropathy's JudgeKit, Judgment's elite): a sin of the run
## returned. He descends at an entrance (the act rule's send_judges()) and walks
## the road like a soldier; his blows are the row's damage. Killing him is
## counted by the act rule (judges_slain). No args; the kit only marks him.
extends EnemyTrait


func on_spawn(_e: TdEnemy, game: TdGame) -> void:
	EnemyTrait.note(game, "judges")
