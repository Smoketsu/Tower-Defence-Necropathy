## SynergyData: Necropathy's setter / finisher pairs as adjacency bonuses
## (GDD §4.4). Hinted, never secret: the spot menu lists the synergies a class
## can join, and the range ring draws a link to each active partner. Evaluated
## only by Synergies.evaluate(); their stat effects reach towers only through
## Tower.recompute(). Data only, no logic.
class_name SynergyData
extends RefCounted

## Row keys:
##   name    — UI name; icon — icons/<id> key.
##   a, b    — the two TowerData classes (an evolved tower counts as its base).
##   radius  — px; the pair is active while the two towers are this close.
##   effects — {"a"|"b": {stat: multiplier}} applied to that partner's stats
##             (damage, rate, range, hp, hold_bonus (added, not multiplied)).
##   hit     — optional conditional hit bonus, read by Synergies.hit_mult() from
##             TdCombat.damage_enemy(): {side: "a"|"b" (the partner whose hits
##             gain it), vs: enemy status "frozen"|"staggered"|"weakened",
##             mult: damage multiplier}. One bonus per hit, the highest.
##   extend_weaken — optional, s: the Mage's hits lengthen the Dirge (weaken)
##             already on an enemy by this much (Requiem; read by mage.gd).
##   aim     — optional: the partner side's boulders aim at enemies with this
##             status first (Killing Field "staggered"; read by corpse_catapult.gd).
##   hint    — one short line shown in the spot menu.
const SYNERGIES: Dictionary = {
	"shatterfall": {
		"name": "Shatterfall", "icon": "syn_shatterfall", "a": "frost_wraith", "b": "corpse_catapult",
		"radius": 220.0,  # TUNING (not in GDD)
		"effects": {},
		"hit": {"side": "b", "vs": "frozen", "mult": 1.6},  # TUNING (not in GDD) GDD §4.4 "frozen targets take more boulder damage"
		"hint": "Frost Wraith near a Catapult: boulders crush frozen foes",
	},
	"flesh_rampart": {
		"name": "Flesh Rampart", "icon": "syn_flesh_rampart", "a": "abomination", "b": "warrior",
		"radius": 200.0,  # TUNING (not in GDD)
		"effects": {"a": {"hold_bonus": 1.0}, "b": {"hold_bonus": 1.0}},  # GDD §4.4 "the blockers hold more"
		"hint": "Abomination near Warriors: blockers hold one more",
	},
	"killing_field": {
		"name": "Killing Field", "icon": "syn_killing_field", "a": "abomination", "b": "corpse_catapult",
		"radius": 300.0,  # TUNING (not in GDD)
		"effects": {},
		"aim": "staggered",  # GDD §4.4 "boulders aim at stomped packs"
		"hit": {"side": "b", "vs": "staggered", "mult": 1.3},  # TUNING (not in GDD)
		"hint": "Abomination in Catapult reach: boulders aim at stomped packs",
	},
	"requiem": {
		"name": "Requiem", "icon": "syn_requiem", "a": "banshee", "b": "mage",
		"radius": 210.0,  # TUNING (not in GDD)
		"effects": {"a": {"range": 1.1}},  # TUNING (not in GDD)
		"extend_weaken": 1.5,  # TUNING (not in GDD) GDD §4.4 "the Dirge lasts longer on enemies the Mage hits"
		"hit": {"side": "b", "vs": "weakened", "mult": 1.15},  # TUNING (not in GDD)
		"hint": "Banshee near a Mage: Mage hits stretch the Dirge",
	},
	# --- Later towers (gw2-kit; names from Necropathy's SynergyData where they exist) ---
	"shieldwall": {
		"name": "Shieldwall", "icon": "syn_shieldwall", "a": "warder", "b": "warrior",
		"radius": 200.0,  # TUNING (not in GDD)
		"effects": {"a": {"rate": 1.2}, "b": {"hp": 1.15}},  # TUNING (not in GDD) Necropathy "Warders raise bone barriers on your frontline warriors"
		"hint": "Warder near Warriors: faster wards, sturdier Warriors",
	},
	"death_from_above": {
		"name": "Death from Above", "icon": "syn_death_from_above", "a": "gargoyle", "b": "rogue",
		"radius": 240.0,  # TUNING (not in GDD)
		"effects": {},
		"hit": {"side": "b", "vs": "swooped", "mult": 1.4},  # Necropathy +40% rogue damage on a swooped foe
		"hint": "Gargoyle near a Rogue: Rogues hit swooped foes harder",
	},
	"cold_blood": {
		"name": "Cold Blood", "icon": "syn_cold_blood", "a": "frost_wraith", "b": "rogue",
		"radius": 220.0,  # TUNING (not in GDD)
		"effects": {},
		"hit": {"side": "b", "vs": "slowed", "mult": 1.4},  # Necropathy +40% rogue damage on a chilled foe
		"hint": "Frost Wraith near a Rogue: Rogues hit chilled foes harder",
	},
	"wild_hunt": {
		"name": "The Wild Hunt", "icon": "syn_wild_hunt", "a": "gargoyle", "b": "bone_hound",
		"radius": 260.0,  # TUNING (not in GDD)
		"effects": {},
		"hit": {"side": "b", "vs": "swooped", "mult": 1.35},  # Necropathy +35% hound damage on a swooped foe
		"hint": "Gargoyle near Hounds: bites on swooped foes hit harder",
	},
	"baying": {
		"name": "Baying of the Damned", "icon": "syn_baying", "a": "banshee", "b": "bone_hound",
		"radius": 230.0,  # TUNING (not in GDD)
		"effects": {"b": {"rate": 1.15}},  # Necropathy +15% hound attack speed (the frenzy, kept on)
		"hit": {"side": "b", "vs": "weakened", "mult": 1.15},  # TUNING (not in GDD)
		"hint": "Banshee near Hounds: the pack bites faster",
	},
	"bone_bastion": {
		"name": "Bone Bastion", "icon": "syn_bone_bastion", "a": "bone_golem", "b": "warrior",
		"radius": 200.0,  # TUNING (not in GDD)
		"effects": {"a": {"hold_bonus": 1.0}, "b": {"hp": 1.2}},  # TUNING (not in GDD) Necropathy: summons near a Golem take less damage
		"hint": "Golem near Warriors: Warriors sturdier, the Golem holds one more",
	},
	"hymn_of_ruin": {
		"name": "Hymn of Ruin", "icon": "syn_requiem", "a": "banshee", "b": "fallen_seraph",
		"radius": 220.0,  # TUNING (not in GDD) new pair (no Necropathy synergy for the Seraph)
		"effects": {"a": {"range": 1.1}},  # TUNING (not in GDD)
		"hit": {"side": "b", "vs": "weakened", "mult": 1.25},  # TUNING (not in GDD)
		"hint": "Banshee near a Seraph: feathers hit weakened foes harder",
	},
	# --- Act II, the Black Tide (w2b-tide) ---
	"boarding_party": {
		"name": "Boarding Party", "icon": "syn_boarding_party", "a": "abomination", "b": "powder_wraith",
		"radius": 240.0,  # TUNING (not in GDD) new pair (Necropathy has no synergy for the Wraith)
		"effects": {"a": {"hp": 1.1}},  # TUNING (not in GDD)
		"hit": {"side": "b", "vs": "staggered", "mult": 1.4},  # TUNING (not in GDD) kegs blast stomped packs harder
		"hint": "Abomination near a Powder Wraith: kegs blast staggered foes harder",
	},
	# --- Act III: the Sanguine Court (w2b-court) ---
	"red_waltz": {
		"name": "The Red Waltz", "icon": "pack_blood", "a": "banshee", "b": "blood_spawn",
		"radius": 220.0,  # TUNING (not in GDD) new pair (no Necropathy synergy for the Blood Spawn)
		"effects": {"b": {"rate": 1.1}},  # TUNING (not in GDD)
		"hit": {"side": "b", "vs": "weakened", "mult": 1.3},  # TUNING (not in GDD) the Dirge's victims bleed easier
		"hint": "Banshee near Blood Spawn: they bite weakened foes harder",
	},
	# --- Act IV (w2b-city) ---
	"origin_story": {
		"name": "Origin Story", "icon": "origin_story", "a": "abomination", "b": "fallen_hero",
		"radius": 240.0,  # TUNING (not in GDD) new pair (Necropathy's Origin Story is the hero's passive)
		"effects": {"a": {"hp": 1.1}},  # TUNING (not in GDD)
		"hit": {"side": "b", "vs": "staggered", "mult": 1.4},  # TUNING (not in GDD) the hero lands on what the Abomination stomped
		"hint": "Abomination near a Fallen Hero: slams crush staggered foes",
	},
	# --- Act V (w2b-shogun) ---
	"iron_and_bone": {
		"name": "Iron and Bone", "icon": "onis_resolve", "a": "bound_oni", "b": "archer",
		"radius": 220.0,  # TUNING (not in GDD)
		"effects": {"a": {"hp": 1.1}},  # TUNING (not in GDD)
		"hit": {"side": "b", "vs": "frozen", "mult": 1.35},  # TUNING (not in GDD) arrows punish the oni's stunned foes
		"hint": "Bound Oni near Archers: arrows hit stunned foes harder",
	},
	# --- Act VI (w2c-norse) ---
	"cold_iron": {
		"name": "Cold Iron", "icon": "grave_frost", "a": "draugr_thane", "b": "frost_wraith",
		"radius": 220.0,  # TUNING (not in GDD)
		"effects": {"a": {"hp": 1.1}},  # TUNING (not in GDD)
		"hit": {"side": "a", "vs": "slowed", "mult": 1.3},  # TUNING (not in GDD) Necropathy Cold Iron: blows on slowed foes hit harder
		"hint": "Draugr Thane near a Frost Wraith: its axe bites slowed foes harder",
	},
}
