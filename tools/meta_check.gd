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
	# w2b-int: the campaign unlock chain end to end (Sanctum -> Cutter -> ... -> Road to the Sun):
	# each map opens exactly when the one before it is cleared.
	Meta.data["maps"]["cleared"] = []
	var chain: Array[String] = ["graveyard", "crimson_march", "sanctum", "cutter", "galleon", "maelstrom", "ravensmoor", "witchwood",
		"castle_sanguis", "skid_row", "fort_kessler", "liberty_heights", "province", "kurogane", "sun_road"]
	for i in range(1, chain.size()):
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
	for tw: String in ["powder_wraith", "blood_spawn", "fallen_hero"]:  # Act towers open with their finale cleared (Road to the Sun's not cleared yet).
		ok = ok and (Meta.data["unlocks"]["towers"] as Array).has(tw)
	ok = ok and not (Meta.data["unlocks"]["towers"] as Array).has("bound_oni")
	# w2c-dynasty: Act VII's own chain (its first map's predecessor belongs to the act order) and its tower locked.
	ok = ok and Meta.unlock_after("lioness_temple") == "necropolis" and Meta.unlock_after("two_truths") == "lioness_temple"
	ok = ok and not (Meta.data["unlocks"]["towers"] as Array).has("ushabti_sentinel")
	print("META CHECK OK" if ok else "META CHECK FAILED")
	get_tree().quit(0 if ok else 1)
