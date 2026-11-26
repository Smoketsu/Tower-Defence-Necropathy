## The Vrask cloak (Necropathy's VraskHunterKit: "CLOAKED while it moves, a
## shimmer"): while it walks (no post holds it) it is cloaked: the towers
## cannot see it (vars "cloak_until", the one hidden test) and it is drawn as a
## shimmer (vars "vis_alpha" = `alpha`). Held by a post, frozen or staggered
## it shows itself. A SPELL hit (a hit whose source is a spell, never a tower)
## reveals it for `reveal` s. Answer: posts hold it, spells reveal it.
## Helper cloaked() (Vrask'Tal and the Harvester reuse the rule).
## Args: alpha (0..1), reveal (s). vars: "cloak_until", "revealed_until" (game s), "vis_alpha".
extends EnemyTrait


func on_spawn(e: TdEnemy, _game: TdGame) -> void:
	e.vars["revealed_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	cloaked(e, game, float(e.row["args"]["alpha"]), true)


func on_hit(e: TdEnemy, game: TdGame, _amount: float, hit: Dictionary) -> void:
	reveal_on_spell(e, game, hit, float(e.row["args"]["reveal"]))


## Keeps `e` cloaked while `on` and it walks free (see the header); returns true when cloaked.
static func cloaked(e: TdEnemy, game: TdGame, alpha: float, on: bool) -> bool:
	var c := on and e.holder == null and game.time >= e.freeze_until and game.time >= e.staggered_until \
			and game.time >= float(e.vars.get("revealed_until", 0.0))  # Cloaked this step.
	e.vars["cloak_until"] = game.time + 0.1 if c else 0.0
	var va := alpha if c else 1.0  # Drawn alpha.
	if float(e.vars.get("vis_alpha", 1.0)) != va:
		e.vars["vis_alpha"] = va
		e.body.queue_redraw()
	return c


## A spell hit on `e` reveals it for `time` s (towers' hits carry a "tower" key).
static func reveal_on_spell(e: TdEnemy, game: TdGame, hit: Dictionary, time: float) -> void:
	var src := String(hit.get("source", ""))
	if hit.get("tower") == null and SpellData.SPELLS.has(src):
		if game.time >= float(e.vars.get("revealed_until", 0.0)):
			EnemyTrait.note(game, "vrask_revealed")
		e.vars["revealed_until"] = game.time + time
