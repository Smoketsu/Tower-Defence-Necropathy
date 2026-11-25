## Werewolf (the Sanguine Court; Necropathy WEREBEAST): a hunter with a silver
## crossbow (the shooter trait: towers disabled, blockers hurt) until the Blood
## Moon is up or its HP falls below `beast_at`; then it turns into the beast
## for good: the `beast_sprite` art, `beast_radius` px, speed x `beast_speed`,
## its blows x `beast_damage` (a weaken above 1 would not be a weaken, so the
## extra share is dealt as a second blow in on_attack), and no more shots.
## Old Greymane's howl and Vargr's Turning call turn() too.
## Args: the shooter keys + beast_at, beast_sprite, beast_speed, beast_damage,
## beast_radius. vars: "beast" (bool) and the shooter's.
extends "res://scripts/enemies/traits/shooter.gd"

## Shared Court helpers.
const CourtKit := preload("res://scripts/enemies/traits/court/court_kit.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	super(e, game)
	e.vars["beast"] = false


func step(e: TdEnemy, game: TdGame, dt: float) -> void:
	if bool(e.vars["beast"]):
		return
	if CourtKit.moon_up(game) or e.hp < e.max_hp * float(e.row["args"]["beast_at"]):
		turn(e, game)
		return
	super(e, game, dt)


## Turns `e` into the beast (once).
static func turn(e: TdEnemy, game: TdGame) -> void:
	if bool(e.vars.get("beast", true)):
		return
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["beast"] = true
	e.speed = float(e.row["speed"]) * float(a["beast_speed"])
	CourtKit.reshape(e, String(a["beast_sprite"]), float(a["beast_radius"]))
	game.fx.spawn("enemy_death", e.position, 90.0, 0.45, Color(1.0, 0.35, 0.3))
	EnemyTrait.note(game, "werewolves_turned")


func on_attack(e: TdEnemy, game: TdGame, body: BlockBody) -> void:
	if bool(e.vars["beast"]) and body.alive:
		TdCombat.damage_body(game, body, float(e.row["damage"]) * e.damage_mult() * TdRulesData.BLOCKER_HIT_MULT * (float(e.row["args"]["beast_damage"]) - 1.0), e)
