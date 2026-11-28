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
##   a_alt   — optional: a second class that also counts as side "a" (Winter's
##             Edge: the Draugr Thane is a second setter for Cold Blood and
##             Shatterfall). Read only by Synergies.side_of().
##   radius  — px; the pair is active while the two towers are this close.
##   effects — {"a"|"b": {stat: multiplier}} applied to that partner's stats
##             (damage, rate, range, hp, hold_bonus (added, not multiplied)).
##   hit     — optional conditional hit bonus, read by Synergies.hit_mult() from
##             TdCombat.damage_enemy(): {side: "a"|"b" (the partner whose hits
##             gain it), vs: enemy status "frozen"|"staggered"|"weakened"|
##             "slowed"|"swooped"|"bleeding"|"pinned"|"held" (Synergies.has_status()),
##             mult: damage multiplier}, or an Array of such dictionaries (Black
##             Ice: one bonus on frozen foes, a smaller one on chilled foes).
##             One bonus per hit, the highest.
##   pin_time — optional, s: the Iron Revenant's shells mark the
##             foes they hit "pinned" for this long (Pinned Down; read by
##             iron_revenant.gd through Synergies.value(), so only while the
##             pair is active).
##   extend_weaken — optional, s: the Mage's hits lengthen the Dirge (weaken)
##             already on an enemy by this much (Requiem; read by mage.gd).
##   aim     — optional: the partner side's boulders aim at enemies with this
##             status first (Killing Field "staggered", Anchor and Stone "held";
##             read by corpse_catapult.gd).
##   hint    — one short line shown in the spot menu.
const SYNERGIES: Dictionary = {
	"shatterfall": {
		"name": "Shatterfall", "icon": "syn_shatterfall", "a": "frost_wraith", "b": "corpse_catapult",
		"a_alt": "draugr_thane",  # Winter's Edge (Necropathy): the Draugr Thane's chill counts as a setter too
		"radius": 220.0,  # TUNING (not in GDD)
		"effects": {},
		"hit": {"side": "b", "vs": "frozen", "mult": 1.6},  # TUNING (not in GDD) GDD §4.4 "frozen targets take more boulder damage"
		"hint": "Frost Wraith or Draugr near a Catapult: boulders crush frozen foes",
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
		"a_alt": "draugr_thane",  # Winter's Edge (Necropathy): the Draugr Thane's chill counts as a setter too
		"radius": 220.0,  # TUNING (not in GDD)
		"effects": {},
		"hit": {"side": "b", "vs": "slowed", "mult": 1.4},  # Necropathy +40% rogue damage on a chilled foe
		"hint": "Frost Wraith or Draugr near a Rogue: Rogues hit chilled foes harder",
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
		"name": "Fallen Choir", "icon": "syn_fallen_choir", "a": "banshee", "b": "fallen_seraph",  # Necropathy's Fallen Choir (id kept: autotest summaries)
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
	# --- Act VII (w2c-dynasty) ---
	"answering_words": {
		"name": "Answering Words", "icon": "answering_words", "a": "ushabti_sentinel", "b": "mage",
		"radius": 230.0,  # TUNING (not in GDD)
		"effects": {"a": {"hp": 1.1}},  # TUNING (not in GDD)
		"hit": {"side": "b", "vs": "staggered", "mult": 1.35},  # TUNING (not in GDD) the mage's fire on what the sentinel's sand staggered
		"hint": "Ushabti Sentinel near a Mage: fire hits staggered foes harder",
	},
	# --- Act VIII (w2c-pantheon) ---
	"hammer_and_anvil": {
		"name": "Hammer and Anvil", "icon": "myrmidon_oath", "a": "myrmidon_shade", "b": "corpse_catapult",
		"radius": 240.0,  # TUNING (not in GDD)
		"effects": {"a": {"hp": 1.1}},  # TUNING (not in GDD)
		"hit": {"side": "b", "vs": "staggered", "mult": 1.3},  # TUNING (not in GDD) boulders crush the foes the spears pinned
		"hint": "Myrmidon Shades near a Catapult: boulders hit the foes their spears stagger harder",
	},
	# --- Act IX (w2c-inferno) ---
	"velvet_chains": {
		"name": "Velvet Chains", "icon": "velvet_chains", "a": "bound_succubus", "b": "corpse_catapult",
		"radius": 240.0,  # TUNING (not in GDD)
		"effects": {"a": {"range": 1.1}},  # TUNING (not in GDD)
		"hit": {"side": "b", "vs": "weakened", "mult": 1.3},  # TUNING (not in GDD) boulders punish the kissed
		"hint": "Bound Succubus near a Catapult: boulders hit weakened foes harder",
	},
	"pride": {
		"name": "Pride", "icon": "pride", "a": "archfiend", "b": "mage",
		"radius": 220.0,  # TUNING (not in GDD)
		"effects": {"a": {"damage": 1.15}, "b": {"range": 1.1}},  # TUNING (not in GDD)
		"hint": "Archfiend near a Mage: both burn brighter",
	},
	# --- Act X (w2c-host) ---
	"turning_wheel": {
		"name": "Turning Wheel", "icon": "turning_bones", "a": "bound_ophan", "b": "warder",
		"radius": 220.0,  # TUNING (not in GDD)
		"effects": {"a": {"rate": 1.1}},  # TUNING (not in GDD)
		"hit": {"side": "a", "vs": "staggered", "mult": 1.3},  # TUNING (not in GDD) the wheel rolls harder over what it already staggered
		"hint": "Bound Ophan near a Crypt Warder: rolls crush staggered foes",
	},
	# --- Act XI (w2d-eye) ---
	"salt_of_the_deep": {
		"name": "Salt of the Deep", "icon": "salt_of_the_deep", "a": "spawn_of_the_deep", "b": "mage",
		"radius": 220.0,  # TUNING (not in GDD)
		"effects": {"a": {"hp": 1.1}},  # TUNING (not in GDD)
		"hit": {"side": "b", "vs": "frozen", "mult": 1.3},  # TUNING (not in GDD) Necropathy Salt of the Deep: more damage to held (frozen) foes
		"hint": "Spawn of the Deep near a Mage: bolts burn seized foes harder",
	},
	# --- Act XII (w2d-empire) ---
	"overclock": {
		"name": "Overclock", "icon": "overclock", "a": "grave_drone", "b": "frost_wraith",
		"radius": 220.0,  # TUNING (not in GDD)
		"effects": {"a": {"rate": 1.15}},  # TUNING (not in GDD)
		"hit": {"side": "a", "vs": "slowed", "mult": 1.3},  # TUNING (not in GDD) darts punish what the wraith slowed
		"hint": "Grave Drone near a Frost Wraith: faster darts, harder on slowed foes",
	},
	"recoil_frame": {
		"name": "Recoil Frame", "icon": "recoil_frame", "a": "iron_revenant", "b": "warrior",
		"radius": 220.0,  # TUNING (not in GDD)
		"effects": {"a": {"damage": 1.15}, "b": {"hp": 1.2}},  # TUNING (not in GDD) the walker steadies the line
		"hint": "Iron Revenant near Warriors: harder shells, tougher Warriors",
	},
	# --- Act XIII, the Concord of Stars (w2d-concord) ---
	"crop_circles": {
		"name": "Crop Circles", "icon": "crop_circles", "a": "ghost_saucer", "b": "frost_wraith",
		"radius": 220.0,  # TUNING (not in GDD)
		"effects": {"a": {"rate": 1.1}},  # TUNING (not in GDD)
		"hit": {"side": "a", "vs": "frozen", "mult": 1.3},  # TUNING (not in GDD) the beams burn what hangs frozen (the wraith's chill, its own lifts)
		"hint": "Ghost Saucer near a Frost Wraith: beams burn frozen foes",
	},
	# --- Act XIV (w2d-titans) ---
	"thundering_herd": {
		"name": "Thundering Herd", "icon": "petrified_horns", "a": "bonehorn", "b": "abomination",
		"radius": 220.0,  # TUNING (not in GDD)
		"effects": {"a": {"rate": 1.1}},  # TUNING (not in GDD)
		"hit": {"side": "a", "vs": "staggered", "mult": 1.3},  # TUNING (not in GDD) the charge gores harder what the stomp already staggered
		"hint": "Bonehorn near an Abomination: charges gore staggered foes",
	},
	# --- Act XV (w2d-year) ---
	"heartwood": {
		"name": "Heartwood", "icon": "heartwood", "a": "ossuary_oak", "b": "warrior",
		"radius": 220.0,  # TUNING (not in GDD)
		"effects": {"a": {"rate": 1.1}},  # TUNING (not in GDD)
		"hit": {"side": "b", "vs": "frozen", "mult": 1.3},  # TUNING (not in GDD) the blade finds what the roots hold
		"hint": "Ossuary Oak near a Skeleton Warrior: warriors cut rooted foes harder",
	},
	# --- Later-class pairs from Necropathy (DECISIONS Q1-Q6; its capstones not built) ---
	"searchlight": {
		"name": "Searchlight", "icon": "syn_searchlight", "a": "gargoyle", "b": "ghost_saucer",
		"radius": 240.0,  # TUNING (not in GDD)
		"effects": {},
		"hit": {"side": "b", "vs": "swooped", "mult": 1.35},  # TUNING (not in GDD) beams find what the gargoyle knocked down
		"hint": "Gargoyle near a Ghost Saucer: beams burn swooped foes",
	},
	"carrion_swarm": {
		"name": "Carrion Swarm", "icon": "syn_carrion_swarm", "a": "abomination", "b": "grave_drone",
		"radius": 240.0,  # TUNING (not in GDD)
		"effects": {},
		"hit": {"side": "b", "vs": "staggered", "mult": 1.35},  # TUNING (not in GDD) darts on stomped packs
		"hint": "Abomination near a Grave Drone: darts hit staggered foes harder",
	},
	"black_ice": {
		"name": "Black Ice", "icon": "syn_black_ice", "a": "frost_wraith", "b": "powder_wraith",
		"radius": 240.0,  # TUNING (not in GDD)
		"effects": {},
		"hit": [
			{"side": "b", "vs": "frozen", "mult": 1.4},  # TUNING (not in GDD) kegs shatter frozen foes
			{"side": "b", "vs": "slowed", "mult": 1.2},  # TUNING (not in GDD) a smaller bonus on chilled foes
		],
		"hint": "Frost Wraith near a Powder Wraith: kegs shatter frozen foes",
	},
	"blood_in_the_water": {
		"name": "Blood in the Water", "icon": "syn_blood_in_the_water", "a": "rogue", "b": "blood_spawn",
		"radius": 240.0,  # TUNING (not in GDD)
		"effects": {},
		"hit": {"side": "b", "vs": "bleeding", "mult": 1.35},  # TUNING (not in GDD) the spawn smell the Rogue's bleed
		"hint": "Rogue near Blood Spawn: they bite bleeding foes harder",
	},
	"pinned_down": {
		"name": "Pinned Down", "icon": "syn_pinned_down", "a": "iron_revenant", "b": "archer",
		"radius": 240.0,  # TUNING (not in GDD)
		"effects": {},
		"pin_time": 4.0,  # TUNING (not in GDD) s a shell's victim stays pinned
		"hit": {"side": "b", "vs": "pinned", "mult": 1.35},  # TUNING (not in GDD)
		"hint": "Iron Revenant near Archers: arrows hit shelled foes harder",
	},
	"anchor_and_stone": {
		"name": "Anchor and Stone", "icon": "syn_anchor_and_stone", "a": "spawn_of_the_deep", "b": "corpse_catapult",
		"radius": 260.0,  # TUNING (not in GDD)
		"effects": {},
		"aim": "held",  # TUNING (not in GDD) boulders aim at foes held still
		"hit": {"side": "b", "vs": "held", "mult": 1.3},  # TUNING (not in GDD)
		"hint": "Spawn of the Deep near a Catapult: boulders crush held foes",
	},
	"broken_guard": {
		"name": "Broken Guard", "icon": "syn_broken_guard", "a": "bound_oni", "b": "warrior",
		"radius": 220.0,  # TUNING (not in GDD)
		"effects": {},
		"hit": {"side": "b", "vs": "held", "mult": 1.3},  # TUNING (not in GDD) every foe a Warrior strikes is held, so: +30% Warrior blows
		"hint": "Bound Oni near Warriors: Warriors hit held foes harder",
	},
	"aegis_of_tartarus": {
		"name": "Aegis of Tartarus", "icon": "syn_aegis_of_tartarus", "a": "warder", "b": "myrmidon_shade",
		"radius": 200.0,  # TUNING (not in GDD)
		"effects": {"a": {"rate": 1.2}, "b": {"hp": 1.15}},  # TUNING (not in GDD) as Shieldwall: faster wards on the shield wall
		"hint": "Warder near Myrmidon Shades: faster wards, sturdier shields",
	},
}
