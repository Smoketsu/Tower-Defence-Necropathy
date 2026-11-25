## The Last Line's act rule (ActData "city", every Act IV map's "act_rule":
## "city/escalation"; GDD §7.3 "Vehicles and armour; the escalation clock sets
## each wave's tier"). The map's "escalation" list ([first wave, tier id]
## pairs; RULE "default" when absent) sets the tier of each wave as it
## starts: gangs -> police -> SWAT -> army -> heroes. A rising tier is
## announced (banner, alarm) and lights the HUD meter (EscalationMeter);
## every enemy spawned while it holds is raised by the tier through
## TdCombat.empower_enemy() (HP x(1 + tier_hp x tier index); bosses and
## structures excepted). The vehicles' armour and the Supers' powers live in
## their traits (city/vehicle, city/super). Also repaves the roads as city
## streets (CityStreets, drawn only). Numbers in the act data's RULE.
extends MapRule

## Current tier index into RULE "tiers" (-1 before the first wave).
var tier: int = -1
## The HUD meter (null headless or before setup()).
var _meter: EscalationMeter = null
## Wave at which each tier began, tier id -> wave (summary).
var _began: Dictionary = {}
## Counters: tiered spawns, vehicles and Supers spawned.
var counts: Dictionary = {"tiered": 0, "vehicles": 0, "supers": 0}


## The act's RULE numbers.
func _r() -> Dictionary:
	return Acts.data("city")["RULE"]


func setup() -> void:
	var streets := CityStreets.new()  # The repaved streets (drawn once).
	streets.game = game
	streets.rule = _r()
	game.world.add_child(streets)
	if game.hud != null and game.hud.root != null:
		_meter = EscalationMeter.new()
		_meter.build(_r(), TdUiData.TOP_BAR_H)
		game.hud.root.add_child(_meter)
		_meter.set_tier(-1)


func on_wave_start(n: int) -> void:
	var tiers: Array = _r()["tiers"]
	var want := tier  # The tier of wave n.
	for pair: Variant in game.map.get("escalation", _r()["default"]):
		if n >= int(pair[0]):
			want = tiers.find(String(pair[1]))
	if want == tier:
		return
	tier = want
	var id := String(tiers[tier])  # Tier id.
	_began[id] = n
	if _meter != null:
		_meter.set_tier(tier)
	game.banner("Escalation: %s" % String(_r()["names"][id]))
	game.sound("city_tier")


func on_spawn(e: TdEnemy) -> void:
	var rank := String(e.row["rank"])  # Its rank.
	if String(e.row["trait"]) == "city/vehicle":
		counts["vehicles"] = int(counts["vehicles"]) + 1
	elif String(e.row["trait"]) == "city/super":
		counts["supers"] = int(counts["supers"]) + 1
	if tier <= 0 or rank == "boss" or bool(e.row.get("structure", false)):
		return
	TdCombat.empower_enemy(game, e, 1.0 + float(_r()["tier_hp"]) * float(tier))
	counts["tiered"] = int(counts["tiered"]) + 1


func summary() -> String:
	var tiers: Array = _r()["tiers"]
	var parts: Array[String] = []  # Tier@wave entries, in ladder order.
	for t: Variant in tiers:
		if _began.has(t):
			parts.append("%s@w%d" % [String(t), int(_began[t])])
	return "tiers=%s top=%s tiered=%d vehicles=%d supers=%d" % ["/".join(parts), String(tiers[tier]) if tier >= 0 else "-",
			int(counts["tiered"]), int(counts["vehicles"]), int(counts["supers"])]
