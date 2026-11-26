## MetaCheck: a headless self-check of the meta and character paths (Meta
## purchases / refunds and map unlocks, CharacterModifiers loadout and spell
## boosts, MetaModifiers.set_max()). Run:
##   godot --headless tools/meta_check.tscn -- --autotest
## (--autotest keeps it off user://). Prints META CHECK OK and exits 0, else 1.
extends Node


func _ready() -> void:
	var ok := true  # All checks passed.
	Meta.load_save()
	Meta.data["ash"]["ash"] = 1000
	ok = ok and Meta.buy("start_souls") and Meta.level("start_souls") == 1 and Meta.ash() == 940
	ok = ok and MetaModifiers.start_souls(150) == 165
	Meta.data["ash"]["ash"] = 500
	ok = ok and not Meta.buy("spell_slot")  # 700 > 500: refused.
	Meta.data["ash"]["ash"] = 2000
	ok = ok and Meta.buy("spell_slot") and MetaModifiers.spell_slots() == 4 and not Meta.buy("spell_slot")
	Meta.refund_all()
	ok = ok and Meta.ash() == 2000 - 700 + 60 + 700 and MetaModifiers.bonuses.is_empty() and MetaModifiers.spell_slots() == 3
	ok = ok and Meta.map_open(MapRegistry.DEFAULT_ID)
	ok = ok and Meta.unlock_after("crimson_march") == "graveyard" and not Meta.map_open("crimson_march")  # The act unlock chain (fresh save).
	CharacterModifiers.current = "gravecaller"
	var base: Array[String] = ["shadow_bolt", "bone_wall", "corpse_explosion"]
	ok = ok and CharacterModifiers.loadout(base) == base and CharacterModifiers.spell_row("shadow_bolt", SpellData.SPELLS["shadow_bolt"]) == SpellData.SPELLS["shadow_bolt"]
	CharacterModifiers.current = "plague_scholar"
	ok = ok and CharacterModifiers.loadout(base) == ["plague_cloud", "shadow_bolt", "bone_wall"]
	ok = ok and is_equal_approx(CharacterModifiers.cooldown_mult("plague_cloud"), 0.9 * 0.85) and is_equal_approx(CharacterModifiers.cooldown_mult("bone_wall"), 0.9)
	CharacterModifiers.current = "barrow_warden"
	ok = ok and is_equal_approx(float(CharacterModifiers.spell_row("bone_wall", SpellData.SPELLS["bone_wall"])["duration"]), 5.0 * 1.3)
	# gw2-kit: a version-1 save (no `unlocks` section) with the Graveyard cleared migrates.
	Meta.data.erase("unlocks")
	(Meta.data["maps"]["cleared"] as Array).append("graveyard")
	Meta.migrate()
	ok = ok and MetaData.SAVE_VERSION == 2 and (Meta.data["unlocks"]["towers"] as Array).has("warder") \
		and (Meta.data["unlocks"]["spells"] as Array).has("death_mark") and not (Meta.data["unlocks"]["towers"] as Array).has("fallen_seraph")
	ok = ok and is_equal_approx(MetaModifiers.ultimate_charge_mult(), 1.0)
	CharacterModifiers.current = "grave_herald"
	ok = ok and is_equal_approx(CharacterModifiers.temp_time_mult(), 1.25) and CharacterModifiers.loadout(base)[0] == "raise_dead"
	CharacterModifiers.current = "gravecaller"
	MetaModifiers.set_max()
	ok = ok and MetaModifiers.spell_slots() == 4 and MetaModifiers.masteries.size() == TowerData.TOWERS.size()
	ok = ok and is_equal_approx(MetaModifiers.ultimate_charge_mult(), 1.3)
	# w2b-int / w2c-int: the campaign unlock chain end to end (Graveyard -> ... -> the Empyrean,
	# Acts.map_order(), the one list): each map opens exactly when the one before it is cleared.
	Meta.data["maps"]["cleared"] = []
	var chain: Array[String] = []  # Every campaign map in order (Acts.map_order() without the hidden test act).
	for m: String in Acts.map_order():
		if not bool(Acts.row(Acts.act_of_map(m)).get("hidden", false)):
			chain.append(m)
	ok = ok and chain.size() >= 30 and chain[0] == "graveyard" and chain.has("empyrean")  # w2d: Part Three maps follow it
	for i in range(1, chain.size()):
		if Meta.unlock_after(chain[i]) != chain[i - 1] or Meta.map_open(chain[i]):
			push_error("meta_check: %s does not follow %s" % [chain[i], chain[i - 1]])
		ok = ok and Meta.unlock_after(chain[i]) == chain[i - 1] and not Meta.map_open(chain[i])
		(Meta.data["maps"]["cleared"] as Array).append(chain[i - 1])
		ok = ok and Meta.map_open(chain[i])
	if not ok:
		push_error("meta_check: unlock chain broken")
	# A version-2 save (unlocks present) loads through migrate() and a second load changes nothing.
	Meta.migrate()
	var before: Dictionary = (Meta.data["unlocks"] as Dictionary).duplicate(true)
	Meta.migrate()
	ok = ok and Meta.data["unlocks"] == before
	# Every act tower opens with its finale cleared; the last campaign map is not cleared yet,
	# so the tower its boss unlocks is met only once it is (w2c-int; generic since w2d-concord).
	for tw: String in ["powder_wraith", "blood_spawn", "fallen_hero", "bound_oni", "draugr_thane", "ushabti_sentinel", "myrmidon_shade", "bound_succubus", "archfiend", "bound_ophan"]:
		ok = ok and Unlocks.tower_open(tw) and (Meta.data["unlocks"]["towers"] as Array).has(tw)
	var last := chain[chain.size() - 1]  # The last campaign map.
	for tw: String in TowerData.ORDER:
		var u: Dictionary = TowerData.TOWERS[tw].get("unlock", {})
		if String(u.get("map", "")) == last:
			ok = ok and not Unlocks.met(u)
			(Meta.data["maps"]["cleared"] as Array).append(last)
			ok = ok and Unlocks.met(u)
	print("META CHECK OK" if ok else "META CHECK FAILED")
	get_tree().quit(0 if ok else 1)
