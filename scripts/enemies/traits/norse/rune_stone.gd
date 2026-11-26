## Rune-Stone (Act VI; Necropathy's RuneStones: "the hall's foes near a carved
## stone are warded"): a structure beside the road (speed 0, row key
## "structure") whose runes ward every other enemy within `radius` px (they
## take `ward_mult` of each hit, TdCombat.ward_enemy) and quicken them
## (`speed_mult`, TdCombat.haste_enemy), renewed every step, until the towers
## break it. Its ground glow shows the real radius (CovenantField zone).
## Args: radius (px), ward_mult (0..1), speed_mult (>= 1), refresh (s).
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	CovenantField.of(game).add_zone(e.position, float(e.row["args"]["radius"]), INF, Color(0.55, 0.8, 1.0, 0.35), e)


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	for o: TdEnemy in game.enemies_near(e.position, float(a["radius"])):
		if o != e and not bool(o.row.get("structure", false)):
			TdCombat.ward_enemy(game, o, float(a["ward_mult"]), float(a["refresh"]))
			TdCombat.haste_enemy(game, o, float(a["speed_mult"]), float(a["refresh"]))


func on_death(e: TdEnemy, game: TdGame) -> void:
	EnemyTrait.note(game, "rune_stones_broken")
	Sfx.play("rune_capture")
	if game.vfx.on:
		game.fx.spawn("frost_shatter", e.position, 90.0, 0.6, Color(0.6, 0.85, 1.0))
