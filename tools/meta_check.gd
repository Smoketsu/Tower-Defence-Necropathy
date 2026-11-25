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
	MetaModifiers.set_max()
	ok = ok and MetaModifiers.spell_slots() == 4 and MetaModifiers.masteries.size() == TowerData.TOWERS.size()
	print("META CHECK OK" if ok else "META CHECK FAILED")
	get_tree().quit(0 if ok else 1)
