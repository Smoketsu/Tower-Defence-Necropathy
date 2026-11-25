## towers_check: a headless self-check of the tower kit specials that a
## normal autotest run rarely reaches (Bone Colossus taunt and shrapnel,
## Winter Revenant shatter, Keening Lady silence, Gravebow curse, Shatterfall).
## Run: godot --headless tools/towers_check.tscn   (prints PASS / FAIL, exit 0 / 1)
extends Node

## Failed check names.
var _fails: Array[String] = []


func _ready() -> void:
	var game := TdGame.new()
	game.setup("graveyard", DifficultyData.DEFAULT_ID, 1)
	add_child(game)
	game.economy.earn(20000, "test_bonus")
	# Bone Colossus at post:1 beside a Warrior at post:2 (197 px apart).
	var col := _maxed(game, "post:1", "abomination")
	var war := _maxed(game, "post:2", "warrior")
	game.tick(1.0 / 60.0)
	_check("colossus taunt", war.block.bodies.any(func(o: BlockBody) -> bool: return o.taunt_by == col.block.bodies[0]))
	game.spawn_enemy("footman", game.first_entrance(), 1)
	var e: TdEnemy = game.enemies[0]
	e.position = col.block.bodies[0].pos
	game.tick(1.0 / 60.0)
	TdCombat.damage_body(game, col.block.bodies[0], INF)
	game.tick(1.0 / 60.0)
	_check("colossus shrapnel", int(game.stats.get("shrapnel", 0)) == 1)
	# Winter Revenant: a frozen enemy killed by anything shatters onto its neighbours.
	var rev := _maxed(game, "plot:5", "frost_wraith")
	_check("revenant evolved", rev.evolution == "winter_revenant")
	game.spawn_enemy("recruit", game.first_entrance(), 1)
	game.spawn_enemy("recruit", game.first_entrance(), 1)
	var a: TdEnemy = game.enemies[game.enemies.size() - 2]
	var b: TdEnemy = game.enemies[game.enemies.size() - 1]
	game.tick(1.0 / 60.0)
	TdCombat.freeze_enemy(game, a, 2.0)
	var hp_b := b.hp  # Neighbour HP before the shatter.
	TdCombat.kill_enemy(game, a, null)
	_check("revenant shatter", int(game.stats.get("shatters", 0)) == 1 and b.hp < hp_b)
	# Silence, curse and Shatterfall on one enemy.
	TdCombat.silence_enemy(game, b, 1.0)
	_check("silence query", TdCombat.is_silenced(game, b))
	var cat := _maxed(game, "plot:10", "corpse_catapult")
	_check("shatterfall active", cat.synergies.any(func(p: Array) -> bool: return p[0] == "shatterfall"))
	b.hp = b.max_hp
	var plain := TdCombat.damage_enemy(game, b, 10.0, {"tower": cat, "dot": true})  # Not frozen.
	TdCombat.freeze_enemy(game, b, 2.0)
	TdCombat.curse_enemy(game, b, 1.15, 2.0)
	var boosted := TdCombat.damage_enemy(game, b, 10.0, {"tower": cat, "dot": true})  # Frozen and cursed.
	_check("shatterfall + curse", is_equal_approx(boosted, plain * 1.6 * 1.15))
	print("TOWERS CHECK %s %s" % ["PASS" if _fails.is_empty() else "FAIL", ",".join(_fails)])
	get_tree().quit(0 if _fails.is_empty() else 1)


## Builds `id` on spot `spot`, raises it to level 5 and evolves it.
func _maxed(game: TdGame, spot: String, id: String) -> Tower:
	var s := game.spot_by_id(spot)  # The spot.
	game.build(s, id)
	for i in 4:
		game.upgrade(s)
	s.tower.evolution = String(s.tower.row["evolution"])  # Forced: the check is about the kit, not the recipe.
	s.tower.recompute()
	Synergies.evaluate(game.towers)
	return s.tower


## Records check `name` as failed unless `ok`.
func _check(name: String, ok: bool) -> void:
	if not ok:
		_fails.append(name)
