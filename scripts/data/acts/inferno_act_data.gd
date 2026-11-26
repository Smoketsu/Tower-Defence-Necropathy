## Act IX, the Inferno (ActData "inferno"; GDD §7.3; Necropathy's Act VI,
## docs/act6/PROPOSAL.md, the stages burning_gate / silk_palace /
## pandemonium): hell comes to collect the souls the necromancer raised. Its
## enemy kinds (KINDS, keys as TdEnemyData.KINDS), its build orders (ORDERS,
## keys as BuildOrderData.ORDERS), its three map moods (MOODS, keys as
## TdMoodData.MOODS), the numbers of its act rule, the Portals (RULE, read by
## scripts/maps/rules/inferno/portals.gd: portals, Hell Pits, Temptation) and
## its looks (LOOK). Every sprite is Necropathy's Act VI art
## (assets/sprites/inferno/, bosses/, summons/, structures/demon_portal).
## Extra kind row key of this act (absent = false):
##   damned — true: a living soul that burns in the Hell Pits (RULE
##            "damned_dps"); demons, bosses and structures never burn.
## Data only.
extends RefCounted

## Enemy kinds of the Inferno (keys: TdEnemyData.KINDS). Traits live in
## scripts/enemies/traits/inferno/ and scripts/bosses/inferno/ (each script
## documents its args).
const KINDS: Dictionary = {
	# Chained wailing souls dragged to the Pit (Necropathy "The Damned"): they burn in the pits.
	"damned_soul": {
		"name": "The Damned", "sprite": "inferno/damned", "rank": "fodder", "souls": 8, "damned": true,  # TUNING (not in GDD) X2: Part Two pays above Act V (tougher kinds, the portals' extras unpaid in INCOME)
		"hp": 90.0, "speed": 46.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Fast winged imps with pitchforks: fly over the posts and the pits (Necropathy "Imp").
	"hell_imp": {
		"name": "Imp", "sprite": "inferno/imp", "rank": "fodder", "souls": 8,  # TUNING (not in GDD)
		"hp": 64.0, "speed": 70.0, "armour": 0.0, "radius": 8.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 0.9,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": true, "trait": "", "args": {},
	},
	# Lava hounds in packs: held, their burning hide opens a small pit under the post (Necropathy "Hellhound").
	"lava_hound": {
		"name": "Hellhound", "sprite": "inferno/lava_hound", "rank": "fodder", "souls": 9,  # TUNING (not in GDD)
		"hp": 100.0, "speed": 78.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 7.0, "attack_interval": 0.8,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "inferno/lava_hound",
		"args": {"pit_every": 4.0, "pit_radius": 28.0, "pit_life": 3.0, "pit_telegraph": 0.6},  # TUNING (not in GDD) Necropathy "leave a short fire trail"
	},
	# Hell Knight: ember armour and a burning greatsword; its telegraphed sweep cuts every body of its post.
	"hell_knight": {
		"name": "Hell Knight", "sprite": "inferno/hell_knight", "rank": "fodder", "souls": 14,  # TUNING (not in GDD) soldier tier
		"hp": 220.0, "speed": 42.0, "armour": 3.0, "radius": 12.0,  # TUNING (not in GDD) Necropathy "ember armour"
		"damage": 13.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "inferno/sweep",
		"args": {"every": 7.0, "windup": 0.6, "damage": 36.0},  # TUNING (not in GDD) Necropathy sweep_every 7, windup 0.6
	},
	# Pit Cultist: a living man who chants a rite on the march and tears a portal open where he stands.
	"pit_cultist": {
		"name": "Pit Cultist", "sprite": "inferno/pit_cultist", "rank": "fodder", "souls": 12, "damned": true,  # TUNING (not in GDD) a living man burns too
		"hp": 150.0, "speed": 44.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 5.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "inferno/cultist",
		"args": {"chant_after": 6.0, "chant_time": 3.0, "squad": [["damned_soul", 3], ["hell_imp", 1]], "every": 7.0, "squads": 2},  # TUNING (not in GDD) Necropathy "opens new portals; priority target"
	},
	# Succubus: flies over the posts and blows a kiss at a blocker body: it turns on its own post (Temptation).
	"succubus": {
		"name": "Succubus", "sprite": "inferno/succubus", "rank": "elite", "souls": 16,
		"hp": 330.0, "speed": 50.0, "armour": 1.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 8.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": true, "trait": "inferno/succubus",
		"args": {"first": 2.0, "every": 9.0, "range": 150.0, "time": 5.0, "hit_mult": 0.7},  # TUNING (not in GDD) Necropathy kiss every 10 s, charm 6 s
	},
	# Lilim Witch: opens a pit under the nearest post and heals the demons around a standing portal.
	"lilim_witch": {
		"name": "Lilim Witch", "sprite": "inferno/lilim_witch", "rank": "elite", "souls": 16,
		"hp": 340.0, "speed": 40.0, "armour": 0.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 7.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "inferno/lilim",
		"args": {"pit_first": 3.0, "pit_every": 10.0, "range": 210.0, "pit_radius": 42.0, "pit_life": 6.0, "pit_telegraph": 1.2,
			"heal_every": 4.0, "heal": 70.0, "heal_radius": 120.0, "portal_reach": 240.0},  # TUNING (not in GDD) Necropathy pit curse and portal rite
	},
	# Demon Brute: four arms, flat armour; every third blow a slam on every body of its post.
	"demon_brute": {
		"name": "Demon Brute", "sprite": "inferno/demon_brute", "rank": "elite", "souls": 20,
		"hp": 820.0, "speed": 30.0, "armour": 7.0, "radius": 17.0,  # TUNING (not in GDD) Necropathy "flat armour"
		"damage": 22.0, "attack_interval": 1.6,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "inferno/brute",
		"args": {"slam_every": 3, "slam_damage": 55.0, "slam_radius": 46.0},  # TUNING (not in GDD) Necropathy slam radius 46
	},
	# Fallen Angel: flies; dives from above with a burning spear on the tower or post nearest her.
	"fallen_angel": {
		"name": "Fallen Angel", "sprite": "inferno/fallen_angel", "rank": "elite", "souls": 16,
		"hp": 340.0, "speed": 48.0, "armour": 2.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 9.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": true, "trait": "inferno/dive",
		"args": {"first": 3.0, "every": 12.0, "range": 230.0, "radius": 56.0, "delay": 1.4, "disable": 1.5, "body_damage": 45.0},  # TUNING (not in GDD) Necropathy dive_rise + dive_fall
	},
	# --- Structures and summoned bodies (the act rule and the bosses raise them) ---
	# The demon portal (RULE): pours squads onto the road until broken, sealed or burnt out.
	"demon_portal": {
		"name": "Demon Portal", "sprite": "structures/demon_portal", "rank": "elite", "structure": true, "souls": 15,  # TUNING (not in GDD) a portal broken pays a little more than an elite
		"hp": 1100.0, "speed": 0.0, "armour": 3.0, "radius": 18.0,  # TUNING (not in GDD) x the wave ramp when it opens
		"damage": 0.0, "attack_interval": 1.0,
		"flying": false, "ignores_walls": true, "trait": "", "args": {},
	},
	# A body Moloch swallowed, come back burning as his for a few seconds.
	"moloch_thrall": {
		"name": "Burning Thrall", "sprite": "inferno/damned", "rank": "fodder", "souls": 0, "tint": Color(1.4, 0.65, 0.4),  # TUNING (not in GDD) no bounty on a swallowed friend
		"hp": 220.0, "speed": 52.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 12.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "inferno/thrall", "args": {"life": 8.0},  # Necropathy "as his for 6 s" (TUNING 8: it must walk to matter)
	},
	# --- Minibosses (one per map; the chest) ---
	# The Burning Gate: the Gatekeeper, a chained giant: chains fling out and bind towers; he hauls in a coffle of the damned.
	"gatekeeper": {
		"name": "The Gatekeeper", "sprite": "inferno/gatekeeper", "rank": "miniboss",
		"hp": 4800.0, "speed": 24.0, "armour": 6.0, "radius": 26.0,  # TUNING (not in GDD) X3 band 4000-6000
		"damage": 26.0, "attack_interval": 1.6,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "inferno/gatekeeper",
		"args": {"chain_first": 4.0, "chain_every": 9.0, "chain_range": 240.0, "chain_towers": 2, "chain_disable": 2.5,
			"coffle_every": 11.0, "coffle_kind": "damned_soul", "coffle_count": 3, "coffle_gap": 26.0},  # TUNING (not in GDD) Necropathy chains and coffle
	},
	# The Palace: Naamah, the elder of the Twin Succubi (the chest); her kisses charm, she rages when her sister falls.
	"twin_naamah": {
		"name": "Naamah, the Elder Twin", "sprite": "inferno/twin_naamah", "rank": "miniboss",
		"hp": 4000.0, "speed": 30.0, "armour": 3.0, "radius": 20.0,  # TUNING (not in GDD)
		"damage": 22.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "inferno/twin",
		"args": {"sister": "twin_agrat", "first": 3.0, "every": 9.0, "range": 170.0, "bodies": 1, "time": 4.0, "hit_mult": 0.8,
			"rage_haste": 1.4, "rage_every": 0.5},  # TUNING (not in GDD) Necropathy "kill one and the other rages"
	},
	# Agrat, the younger twin: her sister's kit, half her strength (no chest: one miniboss per map, X3).
	"twin_agrat": {
		"name": "Agrat, the Younger Twin", "sprite": "inferno/twin_agrat", "rank": "elite", "souls": 40,
		"hp": 1200.0, "speed": 26.0, "armour": 2.0, "radius": 20.0,  # TUNING (not in GDD)
		"damage": 18.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "inferno/twin",
		"args": {"sister": "twin_naamah", "first": 7.5, "every": 9.0, "range": 170.0, "bodies": 1, "time": 4.0, "hit_mult": 0.8,
			"rage_haste": 1.4, "rage_every": 0.5},  # TUNING (not in GDD) her kisses fall between her sister's
	},
	# Pandemonium: the Fallen Seraph General: the Judgment Cleave, the Wings of Ruin, and the Fallen Host at half health.
	"seraph_general": {
		"name": "The Fallen Seraph General", "sprite": "inferno/seraph_general", "rank": "miniboss",
		"hp": 4600.0, "speed": 26.0, "armour": 6.0, "radius": 24.0,  # TUNING (not in GDD)
		"damage": 28.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "inferno/seraph_general",
		"args": {"cleave_every": 7.0, "cleave_windup": 0.8, "cleave_damage": 80.0,
			"feather_first": 4.0, "feather_every": 8.0, "feather_range": 260.0, "feathers": 3, "feather_disable": 1.5, "feather_speed": 520.0,
			"host_hp": 0.5, "host_kind": "fallen_angel", "host_count": 3, "host_gap": 30.0, "host_lane": 14.0},  # TUNING (not in GDD) Necropathy cleave, Wings of Ruin, the Fallen Host
	},
	# --- Bosses ---
	# The Burning Gate: Moloch, the Furnace King: swallows a body (it comes back burning, his), vents fire waves, cracks the ground.
	"moloch": {
		"name": "Moloch, the Furnace King", "sprite": "bosses/moloch", "rank": "boss",
		"hp": 8000.0, "speed": 22.0, "armour": 5.0, "radius": 30.0,  # TUNING (not in GDD) a step above Kage (6000)
		"damage": 32.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "inferno/moloch",
		"args": {"swallow_every": 10.0, "thrall": "moloch_thrall",
			"wave_first": 4.0, "wave_every": 9.0, "wave_pits": 3, "wave_gap": 70.0, "wave_ahead": 90.0, "wave_radius": 40.0, "wave_life": 5.0, "wave_telegraph": 1.2,
			"crack_hp": 0.5, "crack_first": 1.0, "crack_every": 8.0, "crack_count": 2, "crack_radius": 56.0, "crack_delay": 1.5, "crack_disable": 2.5, "pose_time": 0.7},  # TUNING (not in GDD) Necropathy swallow / fire waves / cracks
	},
	# The Palace: Lilith, Queen of the Night: charm waves, the kiss of ruin, a brood from her wings, then her true demon form.
	"lilith": {
		"name": "Lilith, Queen of the Night", "sprite": "bosses/lilith", "rank": "boss",
		"hp": 9000.0, "speed": 24.0, "armour": 4.0, "radius": 24.0,  # TUNING (not in GDD)
		"damage": 28.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "inferno/lilith",
		"args": {"wave_first": 4.0, "wave_every": 11.0, "wave_radius": 190.0, "wave_time": 4.0, "wave_mult": 0.8,
			"kiss_first": 6.0, "kiss_every": 10.0, "kiss_mult": 0.5, "kiss_time": 6.0,
			"brood_every": 15.0, "brood_kind": "hell_imp", "brood_count": 3, "brood_lane": 12.0,
			"demon_hp": 0.35, "demon_armour": 4.0, "demon_haste": 1.25, "demon_rate": 0.7, "pose_time": 0.7},  # TUNING (not in GDD) Necropathy charm waves, the kiss, demon children, the true form
	},
	# Pandemonium: the Morning Star. The Angel (beams of light and dark, the burning sword), then at half health the Beast
	# (the throne-skull form: slams, the ground turns to pits, every portal opens).
	"morning_star": {
		"name": "The Morning Star", "sprite": "bosses/morning_star", "rank": "boss",
		"hp": 15000.0, "speed": 22.0, "armour": 5.0, "radius": 28.0,  # TUNING (not in GDD) Amaterasu's (14500) and a second phase
		"damage": 34.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "inferno/morning_star",
		"args": {"beam_first": 3.0, "beam_every": 8.0, "beam_ahead": 220.0, "beam_radius": 120.0, "beam_mult": 0.5, "beam_time": 5.0, "dark_disable": 2.5,
			"sword_every": 6.0, "sword_damage": 70.0,
			"beast_hp": 0.5, "beast_armour": 4.0, "beast_speed": 0.8, "beast_first": 2.0,
			"slam_every": 6.0, "slam_damage": 90.0, "slam_pits": 3, "slam_gap": 60.0, "pit_radius": 44.0, "pit_life": 6.0, "pit_telegraph": 1.0,
			"portal_every": 15.0, "portal_back": 120.0, "portal_squad": [["hell_knight", 2], ["hell_imp", 2]], "portal_squad_every": 6.0, "portal_squads": 3,
			"pose_time": 0.7},  # TUNING (not in GDD) Necropathy: the Angel, the Beast
	},
}

## Build orders of the Inferno maps (keys: BuildOrderData.ORDERS): each map's
## default (must win on Necromancer) and weak order (must lose), and one kit
## order for every Act IX map ("inferno_kit": the Archfiend on the posts and
## its Prince of Hell, the Bound Succubus and its Lilim Matriarch, the act
## spells).
const ORDERS: Dictionary = {
	"burning_gate_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:4", "tower": "archer"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "plot:7", "tower": "archer"},
			{"do": "build", "spot": "plot:3", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:6", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:6", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "build", "spot": "plot:9", "tower": "mage"},
			{"do": "build", "spot": "plot:5", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:2", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "build", "spot": "post:4", "tower": "abomination"},
			{"do": "build", "spot": "plot:8", "tower": "mender"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:13", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:11", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:11", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:10", "tower": "mage"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "post:2"},
		],
	},
	"burning_gate_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:4", "tower": "archer"},
		],
	},
	"silk_palace_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:7", "tower": "archer"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "build", "spot": "plot:3", "tower": "archer"},
			{"do": "build", "spot": "plot:6", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:8", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:8", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "plot:9", "tower": "warder"},
			{"do": "build", "spot": "plot:10", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:2", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "post:5", "tower": "abomination"},
			{"do": "build", "spot": "plot:13", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:11", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:14", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:14", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:12", "tower": "mage"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "post:5"},
			{"do": "upgrade", "spot": "post:3"},
		],
	},
	"silk_palace_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:7", "tower": "archer"},
		],
	},
	"pandemonium_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:9", "tower": "archer"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "build", "spot": "plot:11", "tower": "archer"},
			{"do": "build", "spot": "plot:8", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:12", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:12", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "plot:7", "tower": "mage"},
			{"do": "build", "spot": "plot:5", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "build", "spot": "plot:13", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "post:4", "tower": "abomination"},
			{"do": "build", "spot": "plot:3", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "build", "spot": "plot:14", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "build", "spot": "plot:10", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:10", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "build", "spot": "plot:15", "tower": "mage"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "post:3"},
		],
	},
	"pandemonium_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:7", "tower": "archer"},
		],
	},
	"inferno_kit": {
		"spells": true,
		"loadout": ["brimstone", "tempt", "fall_from_grace"],
		"steps_by_map": {
			"burning_gate": [
				{"do": "build", "spot": "plot:4", "tower": "archer"},
				{"do": "build", "spot": "post:2", "tower": "archfiend"},
				{"do": "build", "spot": "plot:7", "tower": "bound_succubus"},
				{"do": "build", "spot": "plot:3", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "post:1", "tower": "archfiend"},
				{"do": "build", "spot": "plot:6", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:6", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "post:3", "tower": "archfiend"},
				{"do": "build", "spot": "plot:9", "tower": "mage"},
				{"do": "build", "spot": "plot:5", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "evolve", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "evolve", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "build", "spot": "post:4", "tower": "archfiend"},
				{"do": "build", "spot": "plot:8", "tower": "mender"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "plot:13", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "plot:11", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:11", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "plot:10", "tower": "mage"},
				{"do": "upgrade", "spot": "post:1"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "post:4"},
			],
			"silk_palace": [
				{"do": "build", "spot": "plot:7", "tower": "archer"},
				{"do": "build", "spot": "post:3", "tower": "archfiend"},
				{"do": "build", "spot": "plot:3", "tower": "bound_succubus"},
				{"do": "build", "spot": "plot:6", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "post:1", "tower": "archfiend"},
				{"do": "build", "spot": "plot:8", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:8", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "post:2", "tower": "archfiend"},
				{"do": "build", "spot": "plot:9", "tower": "warder"},
				{"do": "build", "spot": "plot:10", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "evolve", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "evolve", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "build", "spot": "post:5", "tower": "archfiend"},
				{"do": "build", "spot": "plot:13", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "plot:11", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:14", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:14", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "plot:12", "tower": "mage"},
				{"do": "upgrade", "spot": "post:1"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "post:5"},
			],
			"pandemonium": [
				{"do": "build", "spot": "plot:7", "tower": "archer"},
				{"do": "build", "spot": "post:3", "tower": "archfiend"},
				{"do": "build", "spot": "plot:8", "tower": "bound_succubus"},
				{"do": "build", "spot": "plot:3", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "post:1", "tower": "archfiend"},
				{"do": "build", "spot": "plot:9", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:9", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "post:2", "tower": "archfiend"},
				{"do": "build", "spot": "plot:5", "tower": "mage"},
				{"do": "build", "spot": "plot:12", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "evolve", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "evolve", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "post:4", "tower": "archfiend"},
				{"do": "build", "spot": "plot:13", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "build", "spot": "plot:14", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:10", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:10", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "build", "spot": "plot:15", "tower": "mage"},
				{"do": "upgrade", "spot": "post:1"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "post:4"},
			],
		},
	},
}

## Battlefield moods of the three maps (keys: TdMoodData.MOODS).
const MOODS: Dictionary = {
	"burning_gate": {
		"props": [{"art": "mood_fire", "frames": 8, "count": 5, "scale": 1.0, "glow": Color(1.0, 0.45, 0.15, 0.7), "glow_r": 80.0,
			"glow_at": Vector2(0, -6), "flicker": 0.3, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) fires on the ash plain
		"fog": 2,  # TUNING (not in GDD) drifting ash
		"pools": 0,
	},
	"silk_palace": {
		"props": [{"sprite": "obstacles/candelabra_s", "frames": 1, "count": 6, "scale": 1.0, "glow": Color(1.0, 0.55, 0.75, 0.55), "glow_r": 56.0,
			"glow_at": Vector2(0, -26), "flicker": 0.18, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) the court's candelabra in charm pink
		"fog": 1,  # TUNING (not in GDD) perfumed haze
		"pools": 0,
	},
	"pandemonium": {
		"props": [{"art": "mood_fire", "frames": 8, "count": 4, "scale": 1.0, "glow": Color(1.0, 0.35, 0.12, 0.7), "glow_r": 84.0,
			"glow_at": Vector2(0, -6), "flicker": 0.3, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) rivers of lava
			{"sprite": "obstacles/iron_brazier_s", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(1.0, 0.5, 0.2, 0.6), "glow_r": 60.0,
			"glow_at": Vector2(0, -30), "flicker": 0.22, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) the iron city's braziers
		"fog": 2,  # TUNING (not in GDD) smoke over the cathedral city
		"pools": 0,
	},
}

## The Portals (scripts/maps/rules/inferno/portals.gd; GDD §7.3 later acts;
## Necropathy's InfernoRules: Hell Pits, Portals, Temptation). Map keys read
## by the rule: "portals" (Array of {at: map px of the mark on a road, wave:
## 1-based wave it opens (marked one wave ahead), squad: [[kind, count], ...]
## poured out each time, every: s between squads, squads: squads before it
## burns out}), "pits" (Array of map px: fixed Hell Pits on the road, opened
## in turn), "pits_from" (wave the fixed pits start). Numbers of the
## simulation first, then the look.
const RULE: Dictionary = {
	"seal_radius": 64.0,  # TUNING (not in GDD) px: a living blocker / Bone Wall body this close to a portal seals it
	"seal_souls": 20,  # TUNING (not in GDD) Necropathy "a Soul Ash bounty" for a seal: souls here
	"spell_seal_radius": 90.0,  # TUNING (not in GDD) px: a Brimstone volley this close to a portal seals it
	"squad_gap": 0.5,  # TUNING (not in GDD) s between two demons of one squad
	"squad_lane": 9.0,  # TUNING (not in GDD) px a squad's demons fan out across the road
	"first_squad": 2.0,  # TUNING (not in GDD) s after it opens to its first squad
	"pit_every": 15.0,  # TUNING (not in GDD) s between two fixed pits opening (round robin)
	"pit_radius": 44.0,  # TUNING (not in GDD) px of a fixed pit
	"pit_life": 6.0,  # TUNING (not in GDD) s a pit burns
	"pit_telegraph": 1.5,  # Necropathy "a glowing rim for 1.5 s"
	"pit_dps": 14.0,  # TUNING (not in GDD) damage per s to a blocker body standing in a pit
	"damned_dps": 40.0,  # TUNING (not in GDD) damage per s to a burning damned soul (they burn faster)
	"pit_max": 12,  # TUNING (not in GDD) most pits at once (traits' pits beyond it are not opened)
	"bot_reserve": 0,  # TUNING (not in GDD) the autotest bot seals with a spell whenever one is ready
	# --- The look (drawing only) ---
	"mark_tint": Color(1.0, 0.35, 0.8, 0.9),  # TUNING (not in GDD) a portal's warning mark (charm pink)
	"mark_r": 40.0,  # TUNING (not in GDD) px of the warning ring
	"seal_ring": Color(1.0, 0.5, 0.85, 0.35),  # TUNING (not in GDD) the seal radius drawn around a mark / portal
	"portal_glow": Color(1.0, 0.3, 0.75, 0.6),  # TUNING (not in GDD) additive swirl under a standing portal
	"portal_glow_r": 70.0,  # TUNING (not in GDD) px
	"pit_glow": Color(1.0, 0.45, 0.1, 0.75),  # TUNING (not in GDD) additive lava glow of a burning pit
	"pit_core": Color(0.25, 0.05, 0.02, 0.85),  # TUNING (not in GDD) the pit's dark burning core
	"pit_rim": Color(1.0, 0.6, 0.2, 0.9),  # TUNING (not in GDD) the opening pit's telegraph rim
	"cue_pos": Vector2(8, 6),  # TUNING (not in GDD) px of the HUD cue under the top bar (left edge)
	"cue_tint": Color(1.0, 0.55, 0.8),  # TUNING (not in GDD) the cue's text colour
}

## The act's looks (drawing only; read by its traits, bosses, towers and spells).
const LOOK: Dictionary = {
	"charm_tint": Color(1.0, 0.45, 0.8),  # TUNING (not in GDD) every kiss and charm (charm pink)
	"kiss_d": 64.0,  # TUNING (not in GDD) px of a kiss burst
	"chant_r": 34.0,  # TUNING (not in GDD) px of a cultist's rite circle
	"thread_w": 5.0,  # TUNING (not in GDD) px of a kiss thread from the charmer to the body
	"fire_tint": Color(1.0, 0.55, 0.2),  # TUNING (not in GDD) hellfire
	"sweep_d": 90.0,  # TUNING (not in GDD) px of a knight's sweep
	"slam_d": 110.0,  # TUNING (not in GDD) px of a brute's slam
	"chain_tint": Color(0.75, 0.6, 0.45),  # TUNING (not in GDD) the Gatekeeper's chains
	"chain_w": 6.0,  # TUNING (not in GDD) px wide
	"beam_light": Color(1.0, 0.92, 0.6, 0.6),  # TUNING (not in GDD) the Morning Star's light beam zone
	"beam_w": 16.0,  # TUNING (not in GDD) px of a beam streak
	"star_d": 120.0,  # TUNING (not in GDD) px of a Fall from Grace impact
	"stone_d": 90.0,  # TUNING (not in GDD) px of a Brimstone impact
	"star_glow": 22.0,  # TUNING (not in GDD) px radius of a falling star's glow
	"star_core": 6.0,  # TUNING (not in GDD) px radius of its white core
	"fall_lift": 260.0,  # TUNING (not in GDD) px above its target a falling stone / star starts (drawn only)
}
