## Phalanx (Act VIII, the Olympian Republic: the act rule's shield fronts,
## GDD §7.3; Necropathy's Phalanx / PantheonRules.hit_from_front()): a
## hoplite's (legionary's, shade hoplite's, Achilles') shield faces its
## walking direction. ONE facing test, side(), asked once per hit from
## TdCombat.damage_enemy() through incoming_damage():
##   front (the hit came from within the cone whose cosine to its facing is at
##          least `front_cos`) -> x `front_mult`;
##   flank / back -> full damage (the answer: plots past a bend, towers that
##          shoot what has passed them, splash landing behind the line,
##          blockers that stop the column while towers upstream hit its back).
## Where a hit came from: its `origin` when that lies off the struck body
## (splash, spells, blockers: their body stands in front), else the dealing
## tower's spot. Undirected hits (damage over time, no origin, and the sources
## in `ignore`: arcing boulders and the gods' wrath from above) go around the
## shield; a LEGIONARY with `roof_n` other phalanx bodies within `roof_radius`
## px locks the testudo and takes `roof_mult` of those too.
## Args: front_mult (0..1), front_cos (-1..1), ignore (Array of hit sources),
## roof_mult (0..1, 1 = no testudo), roof_n (count), roof_radius (px).
## Look: the act rule's PantheonLayer draws the shield arc on every phalanx body;
## a blocked hit throws a bronze deflect spark (drawn only, throttled).
## Counted for the act rule's summary: events phalanx_front / phalanx_back /
## phalanx_roof (hits) and phalanx_saved (damage the shields kept off).
extends EnemyTrait

## Hit sides returned by side().
enum Side { UNDIRECTED, FRONT, FLANK, BACK }


func incoming_damage(e: TdEnemy, game: TdGame, amount: float, hit: Dictionary) -> float:
	var a: Dictionary = e.row["args"]  # The kind's numbers.
	var s := side(e, hit)  # Where the hit came from.
	var m := 1.0  # Damage multiplier.
	if s == Side.FRONT:
		m = float(a["front_mult"])
		EnemyTrait.note(game, "phalanx_front")
	elif s == Side.UNDIRECTED:
		if not bool(hit.get("dot", false)) and float(a.get("roof_mult", 1.0)) < 1.0 and roofed(e, game):
			m = float(a["roof_mult"])
			EnemyTrait.note(game, "phalanx_roof")
	else:
		EnemyTrait.note(game, "phalanx_back" if s == Side.BACK else "phalanx_flank")
	if m < 1.0:
		EnemyTrait.note(game, "phalanx_saved", amount * (1.0 - m))
		_spark(e, game, hit)
	return amount * m


## The side of `e` hit `hit` came from (Side): THE one facing test of the act.
static func side(e: TdEnemy, hit: Dictionary) -> int:
	if bool(hit.get("dot", false)):
		return Side.UNDIRECTED
	var a: Dictionary = e.row["args"]  # The kind's numbers.
	if (a.get("ignore", []) as Array).has(String(hit.get("source", ""))):
		return Side.UNDIRECTED
	var from: Variant = origin_of(e, hit)  # Map px it came from, or null.
	if from == null:
		return Side.UNDIRECTED
	var to := Vector2(from) - e.position  # Toward the dealer.
	if to.length_squared() < 0.01:
		return Side.UNDIRECTED
	var c := to.normalized().dot(e.follower.direction())  # Cosine to its facing.
	if c >= float(a["front_cos"]):
		return Side.FRONT
	return Side.BACK if c <= -float(a["front_cos"]) else Side.FLANK


## Map px hit `hit` on `e` came from: its origin when that lies off the body
## (more than ORIGIN_MIN px away), else the dealing tower's spot, else the
## origin, else null.
static func origin_of(e: TdEnemy, hit: Dictionary) -> Variant:
	var o: Variant = hit.get("origin", null)  # The hit's own origin.
	if o != null and Vector2(o).distance_to(e.position) > float(PantheonActRules.r()["origin_min"]):
		return o
	var tower: Tower = hit.get("tower", null)  # Dealer, if a tower.
	if tower != null and is_instance_valid(tower):
		return tower.position
	return o


## True when `e` (a legionary) has locked the testudo: `roof_n` other phalanx
## bodies stand within `roof_radius` px.
static func roofed(e: TdEnemy, game: TdGame) -> bool:
	var a: Dictionary = e.row["args"]  # The kind's numbers.
	var n := 0  # Shield mates near.
	for o: TdEnemy in game.enemies_near(e.position, float(a["roof_radius"])):
		if o != e and o.traits != null and o.traits.get_script() == e.traits.get_script():
			n += 1
	return n >= int(a["roof_n"])


## A bronze deflect spark where the hit struck the shield (drawn only, at most
## one per PantheonActRules LOOK spark_every s per body).
func _spark(e: TdEnemy, game: TdGame, _hit: Dictionary) -> void:
	if not game.vfx.on:
		return
	var lk: Dictionary = PantheonActRules.look()
	if game.time < float(e.vars.get("vis_spark_at", -INF)) + float(lk["spark_every"]):
		return
	e.vars["vis_spark_at"] = game.time
	var at := e.position + e.follower.direction() * (e.radius + float(lk["arc_gap"])) + Vector2(0, -float(lk["arc_lift"]))  # The shield's face.
	game.vfx.add(TdVfx.Kind.ANIM, at, float(lk["spark_d"]), TdVfxData.IMPACT_TIME, lk["spark_tint"], "volley_hit")
