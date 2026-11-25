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
##   hint    — one short line shown in the spot menu.
const SYNERGIES: Dictionary = {
	"shatterfall": {
		"name": "Shatterfall", "icon": "syn_shatterfall", "a": "frost_wraith", "b": "corpse_catapult",
		"radius": 220.0,  # TUNING (not in GDD)
		"effects": {"b": {"damage": 1.25}},  # TUNING (not in GDD) GDD §4.4 "frozen targets take more boulder damage" (flat until a behaviour reads frozen)
		"hint": "Frost Wraith near a Catapult: heavier boulders",
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
		"effects": {"b": {"rate": 1.15}},  # TUNING (not in GDD) GDD §4.4 aim at stomped packs (later behaviour)
		"hint": "Abomination in Catapult reach: faster volleys",
	},
	"requiem": {
		"name": "Requiem", "icon": "syn_requiem", "a": "banshee", "b": "mage",
		"radius": 180.0,  # TUNING (not in GDD)
		"effects": {"a": {"range": 1.1}, "b": {"damage": 1.15}},  # TUNING (not in GDD) GDD §4.4 Dirge lasts longer
		"hint": "Banshee near a Mage: longer Dirge, harder bolts",
	},
}
