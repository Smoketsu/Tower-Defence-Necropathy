## BuildOrderData: the fixed build orders the TdAutotest bot plays (GDD §10.2).
## The bot runs the steps in order, each as soon as it is affordable (and not
## before its wave), so a build order plus a seed always gives the same run.
## Data only, no logic.
class_name BuildOrderData
extends RefCounted

## Order keys:
##   spells — true: the bot casts its spells and the ultimate (TdAutotest policy).
##   steps  — step rows. Keys:
##     do    — "build" | "upgrade" | "evolve" | "target" | "sell".
##     spot  — "plot:N" or "post:N" (index into the map's plots / posts).
##     tower — TowerData id ("build" only).
##     mode  — TowerData.TARGET_MODES value ("target" only).
##     wave  — optional: not before this wave number has started (1-based; 0 = before wave 1).
const ORDERS: Dictionary = {
	# Clears the Graveyard on Necromancer: towers on the strong middle plots
	# that reach two road runs, blockers in front of them, then upgrades.
	"graveyard_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:4", "tower": "archer"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "plot:5", "tower": "archer"},
			{"do": "build", "spot": "plot:3", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:9", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:10", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:10", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "post:2", "tower": "abomination"},
			{"do": "build", "spot": "plot:8", "tower": "mender"},
			{"do": "upgrade", "spot": "post:0"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "build", "spot": "plot:6", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:11", "tower": "mage"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "evolve", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:2", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "evolve", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:6"},
		],
	},
	# Deliberately weak: the default order's towers and upgrades moved to edge
	# plots that each see one short stretch of road, no blockers, no spells.
	# It should lose (placement matters).
	"weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:0", "tower": "archer"},
			{"do": "build", "spot": "plot:13", "tower": "archer"},
			{"do": "build", "spot": "plot:7", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "build", "spot": "plot:12", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:1", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:1", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "build", "spot": "plot:11", "tower": "mender"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "evolve", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:2", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "evolve", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:2"},
		],
	},
}
