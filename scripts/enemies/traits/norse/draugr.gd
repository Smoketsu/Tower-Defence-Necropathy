## Draugr (Act VI; Necropathy's DraugrKit, "a COLD TOUCH that slows the summon
## it strikes"): every blow on the body holding it chills that body: its next
## strike comes `chill` s later (BlockBody.next_attack pushed back), shown as a
## small frost splash. Args: chill (s).
extends EnemyTrait


func on_attack(e: TdEnemy, game: TdGame, body: BlockBody) -> void:
	if body == null or not body.alive:
		return
	body.next_attack = maxf(body.next_attack, game.time) + float(e.row["args"]["chill"])
	EnemyTrait.note(game, "draugr_chills")
	if game.vfx.on:
		game.fx.spawn("frost_nova", body.pos, 34.0, 0.4, Acts.data("norse")["LOOK"]["chill_tint"])
