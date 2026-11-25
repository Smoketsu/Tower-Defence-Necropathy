## Tower: one raised undead on a grave plot or road post (GDD §4). It owns
## its level (1-5, 6 = evolved), targeting mode, cooldown and record, and
## computes its stats through recompute(), the ONE stat path (base row ->
## level row -> evolution -> synergies -> meta -> map rule -> Dread Rally). What it does
## each step is its TowerBehavior (scripts/towers/<behavior>.gd, by name):
## projectile, aura or blocker. Costs are derived here from EconomyData.
class_name Tower
extends Node2D

## The run.
var game: TdGame = null
## The spot it stands on.
var spot: Spot = null
## TowerData id (the base class; an evolved tower keeps it).
var tower_id: String = ""
## Its TowerData row (shared, read only).
var row: Dictionary = {}
## Level 1..5.
var level: int = 1
## EvolutionData id once evolved ("" = not evolved; tier 6).
var evolution: String = ""
## Current stats (every row key, after recompute()).
var stats: Dictionary = {}
## Its behaviour (shared instance per behaviour id).
var behavior: TowerBehavior = null
## Targeting mode (TowerData.TARGET_MODES).
var target_mode: String = "first"
## Game time (s) of its next shot / pulse.
var next_fire: float = 0.0
## Shots fired (drives the Lv3 volley cadence and freeze_every).
var shots: int = 0
## Enemies killed by it.
var kills: int = 0
## Damage dealt by it.
var damage_done: float = 0.0
## Souls spent on it (build + upgrades + evolution); sell refunds a share.
var spent: int = 0
## Active synergies: [synergy id, partner Tower] pairs (Synergies.evaluate()).
var synergies: Array = []
## Its road block (blockers only; null otherwise).
var block: RoadBlock = null
## Behaviour-owned state (keys documented in each behaviour).
var vars: Dictionary = {}
## Game time (s) until which it draws its fire squash (visual only).
var squash_until: float = 0.0
## Horizontal facing: -1 left, 1 right (visual only).
var facing: float = 1.0


## Sets up a new tower of class `id` on spot `p_spot`.
func setup(p_game: TdGame, p_spot: Spot, id: String) -> void:
	game = p_game
	spot = p_spot
	tower_id = id
	row = TowerData.TOWERS[id]
	target_mode = String(row["target"])
	position = spot.position
	behavior = TowerBehavior.for_id(String(row["behavior"]))
	recompute()
	behavior.setup(self)


## Rebuilds `stats` from every source, in order (see the header). Called on
## build, upgrade, evolve, any synergy change and the Rally's start and end.
func recompute() -> void:
	var s := row.duplicate()  # Start from the base row.
	var lv: Dictionary = TowerData.LEVELS[tower_id][level - 1]  # Level multipliers.
	var mult := {"damage": float(lv.get("damage", 1.0)), "rate": float(lv.get("rate", 1.0)),
		"range": float(lv.get("range", 1.0)), "hp": float(lv.get("hp", 1.0))}  # Stat multipliers so far.
	if lv.has("bodies"):
		s["bodies"] = int(lv["bodies"])
	var hold_bonus := 0  # Extra holds per body (synergies).
	if evolution != "":
		var ev: Dictionary = EvolutionData.EVOLUTIONS[evolution]  # Evolution row.
		for k: String in ev["stats"]:
			mult[k] = float(mult[k]) * float(ev["stats"][k])
		for k: String in ev["set"]:
			s[k] = ev["set"][k]
		s["sprite"] = ev["sprite"]
		s["name"] = ev["name"]
	for pair: Array in synergies:
		var syn: Dictionary = SynergyData.SYNERGIES[pair[0]]  # Synergy row.
		var side := "a" if tower_id == String(syn["a"]) else "b"  # Which partner this tower is.
		var fx: Dictionary = syn["effects"].get(side, {})  # Its effects for this side.
		for k: String in fx:
			if k == "hold_bonus":
				hold_bonus += int(fx[k])
			else:
				mult[k] = float(mult[k]) * float(fx[k])
	if game.rule != null:
		mult["damage"] = float(mult["damage"]) * game.rule.tower_damage_mult(self)
	if game.time < game.rally_until:
		mult["damage"] = float(mult["damage"]) * float(SpellData.ULTIMATE["damage_mult"])
		mult["rate"] = float(mult["rate"]) * float(SpellData.ULTIMATE["rate_mult"])
	s["damage"] = float(s["damage"]) * float(mult["damage"])
	s["interval"] = float(s["interval"]) / float(mult["rate"])
	s["range"] = float(s["range"]) * float(mult["range"])
	if s.has("body_hp"):
		s["body_hp"] = float(s["body_hp"]) * float(mult["hp"])
		s["respawn"] = float(s["respawn"]) * MetaModifiers.respawn_mult()
	if s.has("heal"):
		s["heal"] = float(s["heal"]) * float(mult["hp"])
	s["hold_bonus"] = hold_bonus
	stats = s
	if behavior != null:
		behavior.on_recompute(self)
	queue_redraw()


## One fixed step: the behaviour acts.
func step(dt: float) -> void:
	behavior.step(self, dt)


## Souls to reach the next level (-1 at level 5).
func upgrade_cost() -> int:
	if level >= 5:
		return -1
	return roundi(float(row["cost"]) * EconomyData.UPGRADE_FRACTIONS[level - 1])


## Souls to evolve (tier 6).
func evolve_cost() -> int:
	return roundi(float(row["cost"]) * EconomyData.EVOLUTION_FRACTION)


## True when Evolve is offered: level 5, not evolved, recipe met (GDD §4.3).
func can_evolve() -> bool:
	return level >= 5 and evolution == "" and Evolutions.recipe_met(self, game)


## Souls returned on a sale.
func sell_value() -> int:
	return floori(float(spent) * MetaModifiers.sell_refund())


## The enemy to attack now among those within its range, by targeting mode
## (GDD §4.3: first / last / strongest / nearest), or null.
func pick_target() -> TdEnemy:
	var best: TdEnemy = null  # Best candidate so far.
	var best_score := -INF  # Its score (higher = preferred).
	for e: TdEnemy in game.enemies_near(position, float(stats["range"])):
		var score := 0.0  # This enemy's score.
		match target_mode:
			"first": score = game.progress(e)
			"last": score = -game.progress(e)
			"strongest": score = e.hp + game.progress(e) * 0.001
			"nearest": score = -position.distance_squared_to(e.position)
		if score > best_score:
			best_score = score
			best = e
	return best


## Turns toward map px `p` (visual).
func face(p: Vector2) -> void:
	var f := -1.0 if p.x < position.x else 1.0  # New facing.
	if f != facing:
		facing = f
		queue_redraw()


## Redraws while the fire squash plays, and every frame for blockers (their
## bodies' HP bars and flashes change without a stat change). Visual only.
func _process(_delta: float) -> void:
	if game != null and (block != null or game.time < squash_until + 0.05):
		queue_redraw()


func _draw() -> void:
	behavior.draw(self)
