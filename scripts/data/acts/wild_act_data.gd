## Act XV, the Turning Year (ActData "wild"; GDD §7.3; Necropathy's Turning
## Year, docs/year/ and docs/proposals/LAST_SIX_ACTS.md section XV, the stages
## greenwood / fae_court / world_tree): the campaign's last act, the world
## itself rising to take its dead back. Its enemy kinds (KINDS, keys as
## TdEnemyData.KINDS), its build orders (ORDERS, keys as BuildOrderData.ORDERS),
## its three map moods (MOODS, keys as TdMoodData.MOODS), the numbers of its act
## rule, the Turning Year (RULE, read by scripts/maps/rules/wild/turning_year.gd)
## and the act's looks (LOOK). Every sprite is Necropathy's Turning Year art
## (assets/sprites/wild/, summons/, player/, markers/wild_*, effects/wild_*).
## Colours: moss, bark, blossom pink, gold leaves and frost white. The ids carry
## a "wild_" prefix (unique across acts). Data only.
extends RefCounted

## Enemy kinds of the Turning Year (keys: TdEnemyData.KINDS). Traits live in
## scripts/enemies/traits/wild/ and scripts/bosses/wild/ (each script documents
## its args). The seasons of the act rule touch every kind (Summer: faster;
## Autumn: fodder sprouts again); no kind needs a key for it.
const KINDS: Dictionary = {
	# Growth: twig creatures in swarms (Necropathy "Thornling | Fodder swarm").
	"wild_thornling": {
		"name": "Thornling", "sprite": "wild/thornling", "rank": "fodder", "souls": 5,  # TUNING (not in GDD) X2: wave-roster fodder pays 5
		"hp": 36.0, "speed": 60.0, "armour": 0.0, "radius": 7.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 0.9,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Autumn's sprout: a fallen fodder rises once as a weak, gold-leaved Thornling (the act rule; pays nothing).
	"wild_sprout": {
		"name": "Autumn Sprout", "sprite": "wild/thornling", "rank": "fodder", "souls": 0,  # TUNING (not in GDD) a second life pays nothing (X2)
		"hp": 34.0, "speed": 54.0, "armour": 0.0, "radius": 7.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
		"tint": Color(1.0, 0.75, 0.4),  # TUNING (not in GDD) gold autumn leaves (drawn only)
	},
	# The hunt: spectral hounds of the Wild Hunt, fast and light (Necropathy "Hound of the Wild Hunt").
	"wild_hunt_hound": {
		"name": "Hound of the Hunt", "sprite": "wild/hunt_hound", "rank": "fodder", "souls": 5,  # TUNING (not in GDD) X2
		"hp": 70.0, "speed": 76.0, "armour": 0.0, "radius": 9.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 0.8,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# The fae: leaf-plate armour and a thorn sword; a short blink takes him through the body holding him
	# (Necropathy FaeKnightKit; the Black Tide's lunge, corsair/lunge.gd).
	"wild_fae_knight": {
		"name": "Fae Knight", "sprite": "wild/fae_knight", "rank": "fodder", "souls": 10,  # TUNING (not in GDD) soldier tier, the top of X2
		"hp": 125.0, "speed": 48.0, "armour": 3.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 8.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "corsair/lunge",
		"args": {"every": 10.0, "windup": 0.6, "damage": 16.0, "time": 0.8, "speed_mult": 1.4},  # TUNING (not in GDD) Necropathy "short blinks through the ring"
	},
	# Growth: a tree spirit in a leaf gown whose song heals the Wild round her (Act I healer; Necropathy "heals the Wild").
	"wild_dryad": {
		"name": "Dryad", "sprite": "wild/dryad", "rank": "elite",
		"hp": 320.0, "speed": 42.0, "armour": 1.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 5.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "healer",
		"args": {"heal": 28.0, "interval": 2.4, "radius": 150.0},  # TUNING (not in GDD)
	},
	# Growth: a walking oak; every few blows its roots seize the post holding it (Necropathy TreantKit "roots the summon it hits").
	"wild_treant": {
		"name": "Treant", "sprite": "wild/treant", "rank": "elite",
		"hp": 860.0, "speed": 30.0, "armour": 6.0, "radius": 16.0,  # TUNING (not in GDD)
		"damage": 18.0, "attack_interval": 1.5,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "wild/root_blow",
		"args": {"every": 3, "root": 1.6, "body_damage": 20.0},  # TUNING (not in GDD) every 3rd blow: the post rooted 1.6 s
	},
	# Growth: a huge flower on bones that buds Thornlings behind it as it creeps (Necropathy CorpseBloomKit).
	"wild_corpse_bloom": {
		"name": "Corpse-Bloom", "sprite": "wild/corpse_bloom", "rank": "elite",
		"hp": 560.0, "speed": 26.0, "armour": 2.0, "radius": 15.0,  # TUNING (not in GDD)
		"damage": 8.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "wild/call",
		"args": {"first": 4.0, "every": 9.0, "windup": 0.8, "calls": 3, "squads": [[["wild_thornling", 3]]],
			"radius": 0.0, "stun": 0.0, "gap": 14.0, "look": "bud"},  # TUNING (not in GDD) three buds of 3 Thornlings
	},
	# The fae: a frost-lace gown and frost wings; her bolts freeze a tower from range (generic shooter).
	"wild_winter_fae": {
		"name": "Winter Fae", "sprite": "wild/winter_fae", "rank": "elite",
		"hp": 280.0, "speed": 44.0, "armour": 1.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 170.0, "interval": 7.0, "target": "tower", "damage": 0.0, "disable": 1.4, "cause": "frozen", "speed": 300.0, "arc": false, "look": "wild_frost"},  # TUNING (not in GDD) Necropathy "frost bolts that chill"
	},
	# The hunt: a huge stag with moss antlers; a telegraphed antler charge carries it through the posts (Necropathy GreatStagKit).
	"wild_great_stag": {
		"name": "Great Stag", "sprite": "wild/great_stag", "rank": "elite",
		"hp": 660.0, "speed": 40.0, "armour": 4.0, "radius": 15.0,  # TUNING (not in GDD)
		"damage": 16.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "wild/charge",
		"args": {"first": 4.0, "every": 10.0, "windup": 0.9, "time": 1.4, "speed_mult": 2.2, "body_damage": 30.0, "posts": 1},  # TUNING (not in GDD)
	},
	# The hunt: a spectral horseman; his horn calls hounds behind him (Necropathy WildRiderKit, "two hounds").
	"wild_wild_rider": {
		"name": "Rider of the Wild Hunt", "sprite": "wild/wild_rider", "rank": "elite",
		"hp": 540.0, "speed": 54.0, "armour": 3.0, "radius": 14.0,  # TUNING (not in GDD)
		"damage": 14.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "wild/call",
		"args": {"first": 3.0, "every": 10.0, "windup": 0.7, "calls": 2, "squads": [[["wild_hunt_hound", 2]]],
			"radius": 0.0, "stun": 0.0, "gap": 16.0, "look": "horn"},  # TUNING (not in GDD)
	},
	# Spirits: a drifting cold light over the posts that gutters out of sight for a moment (Necropathy "Will-o'-Wisp").
	"wild_will_o_wisp": {
		"name": "Will-o'-Wisp", "sprite": "wild/will_o_wisp", "rank": "fodder", "souls": 6,  # TUNING (not in GDD)
		"hp": 95.0, "speed": 52.0, "armour": 0.0, "radius": 9.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": true, "trait": "wild/flicker",
		"args": {"first": 3.0, "every": 6.0, "hide": 1.8, "alpha": 0.2},  # TUNING (not in GDD)
	},
	# Spirits: a mushroom matron; her spore clouds rot the bodies and smother the towers round her (Necropathy SporeMotherKit).
	"wild_spore_mother": {
		"name": "Spore Mother", "sprite": "wild/spore_mother", "rank": "elite",
		"hp": 400.0, "speed": 38.0, "armour": 2.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 8.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "wild/spores",
		"args": {"first": 3.0, "every": 8.0, "windup": 0.8, "radius": 95.0, "body_damage": 22.0, "weaken": 0.7, "weaken_time": 4.0},  # TUNING (not in GDD)
	},
	# The Masque's courtiers: a gown of roses and a thorn rapier, each wearing the Summer Queen's face.
	"wild_masked_courtier": {
		"name": "Masked Courtier", "sprite": "wild/masked_courtier", "rank": "fodder", "souls": 5,  # TUNING (not in GDD)
		"hp": 190.0, "speed": 44.0, "armour": 2.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 9.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Greenwood miniboss: the Huntsman of the Wild Hunt; his horn shakes the posts near him and calls the pack.
	"wild_huntsman": {
		"name": "The Huntsman of the Wild Hunt", "sprite": "wild/huntsman", "rank": "miniboss",
		"hp": 4800.0, "speed": 30.0, "armour": 5.0, "radius": 24.0,  # TUNING (not in GDD) X3: 4000-6000
		"damage": 24.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "wild/call",
		"args": {"first": 3.0, "every": 8.0, "windup": 1.0, "calls": 6, "squads": [[["wild_hunt_hound", 3]], [["wild_hunt_hound", 2], ["wild_wild_rider", 1]]],
			"radius": 120.0, "stun": 1.4, "gap": 16.0, "look": "horn"},  # TUNING (not in GDD) Necropathy HuntsmanKit: the horn calls the pack
	},
	# Fae Court miniboss: the Winter Prince. His arrival brings a minute of winter to the endless summer;
	# his frost breath freezes the towers round him.
	"wild_winter_prince": {
		"name": "The Winter Prince", "sprite": "wild/winter_prince", "rank": "miniboss",
		"hp": 4400.0, "speed": 28.0, "armour": 5.0, "radius": 22.0,  # TUNING (not in GDD) X3
		"damage": 24.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "wild/winter_prince",
		"args": {"winter": 60.0, "first": 4.0, "every": 9.0, "windup": 1.0, "radius": 120.0, "freeze": 1.6},  # TUNING (not in GDD) Necropathy WinterPrinceKit: "a minute of winter"
	},
	# World-Tree miniboss: the Gardener of Roots. His roots seize the towers round him and plant
	# thickets on their spots in any season.
	"wild_gardener": {
		"name": "The Gardener of Roots", "sprite": "wild/gardener_of_roots", "rank": "miniboss",
		"hp": 4500.0, "speed": 24.0, "armour": 6.0, "radius": 26.0,  # TUNING (not in GDD) X3
		"damage": 28.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "wild/gardener",
		"args": {"first": 4.0, "every": 11.0, "windup": 1.2, "radius": 100.0, "root": 1.4, "seeds": 1, "plant_radius": 200.0},  # TUNING (not in GDD) Necropathy GardenerOfRootsKit
	},
	# Greenwood boss: the Stag King. The Hunt calls riders and hounds; from two thirds the Rut carries him
	# through the posts; from a third the Antler Crown chokes the towers round him with thickets.
	"wild_stag_king": {
		"name": "The Stag King", "sprite": "wild/stag_king", "rank": "boss",
		"hp": 11000.0, "speed": 22.0, "armour": 6.0, "radius": 28.0,  # TUNING (not in GDD) above Seraiel (9500): Part Three
		"damage": 34.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "wild/stag_king",
		"args": {"phase_hp": [0.66, 0.33],
			"hunt_first": 4.0, "hunt_every": 14.0, "hunt": [["wild_hunt_hound", 3], ["wild_wild_rider", 1]], "gap": 16.0,
			"rut_first": 3.0, "rut_every": 11.0, "rut_windup": 1.0, "rut_time": 1.6, "rut_speed": 2.4, "rut_damage": 50.0, "rut_posts": 2,
			"crown_first": 2.0, "crown_every": 13.0, "crown_windup": 1.2, "crown_radius": 150.0, "crown_choke": 2.0, "crown_seeds": 1,
			"pose_time": 0.8},  # TUNING (not in GDD) Necropathy BossStagKing: the Hunt, the Rut, the Antler Crown
	},
	# Fae Court boss: the Summer Queen. Petals smother the towers round her; at two thirds and one third
	# the Masque hides her among courtiers wearing her face until they fall.
	"wild_summer_queen": {
		"name": "The Summer Queen", "sprite": "wild/summer_queen", "rank": "boss",
		"hp": 11000.0, "speed": 16.0, "armour": 5.0, "radius": 26.0,  # TUNING (not in GDD)
		"damage": 34.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "wild/summer_queen",
		"args": {"phase_hp": [0.66, 0.33],
			"petal_first": 4.0, "petal_every": 9.0, "petal_windup": 1.0, "petal_radius": 140.0, "petal_mult": 0.7, "petal_time": 4.0,
			"masque_time": 10.0, "masks": 4, "masks_p3": 5, "mask_gap": 34.0, "heal": 0.02,
			"pose_time": 0.8},  # TUNING (not in GDD) Necropathy BossSummerQueen: petals and the Masque (the Bargain is left out, DECISIONS T15)
	},
	# World-Tree boss, the last boss of the campaign: the Green Mother. The Turning casts a season at each
	# third of her HP; the Burial holds the post before her in the earth; below a third, the Last Claim borrows
	# three earlier acts' claims in turn (the Black Tide's broadside, the Inferno's temptation, the Underworld's
	# claimed dead), each for a few seconds, while she takes half damage.
	"wild_green_mother": {
		"name": "The Green Mother", "sprite": "wild/green_mother", "rank": "boss",
		"hp": 14500.0, "speed": 16.0, "armour": 6.0, "radius": 34.0,  # TUNING (not in GDD) the campaign's last and hardest boss (the Voice 12000)
		"damage": 44.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "wild/green_mother",
		"args": {"phase_hp": [0.66, 0.33], "turn_time": 30.0,
			"burial_first": 5.0, "burial_every": 12.0, "burial_windup": 1.2, "burial_radius": 130.0, "burial_time": 3.0, "burial_damage": 40.0,
			"call_every": 15.0, "call": [["wild_treant", 1], ["wild_thornling", 5]], "gap": 14.0,
			"claim_every": 13.0, "claim_time": 8.0, "claim_mult": 0.5,
			"shells": 3, "shell_radius": 70.0, "shell_delay": 1.4, "shell_disable": 2.0, "shell_damage": 30.0,
			"charms": 3, "charm_time": 6.0, "charm_mult": 1.0, "claim_kind": "claimed_shade",
			"pose_time": 0.9},  # TUNING (not in GDD) Necropathy BossGreenMother: the Turning, the Burial, the Last Claim
	},
}

## Build orders of the Turning Year maps (keys: BuildOrderData.ORDERS): each
## map's default (must win on Necromancer) and weak order (must lose), and one
## kit order for every Act XV map ("year_kit": each map's default order with its
## first Corpse Catapult an Ossuary Oak, evolved to the World-Root Warden after
## its fifth level, and the act spells; DECISIONS Y5).
const ORDERS: Dictionary = {
	"greenwood_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:0", "tower": "archer"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "build", "spot": "plot:4", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:6", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:6", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "plot:5", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "post:3", "tower": "abomination"},
			{"do": "build", "spot": "plot:7", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:8", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:3", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:9", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:9", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "post:0"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:10", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:10"},
		],
	},
	"greenwood_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:0", "tower": "archer"},
		],
	},
	"fae_court_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:5", "tower": "archer"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "plot:6", "tower": "archer"},
			{"do": "build", "spot": "plot:4", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:7", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "plot:8", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "post:4", "tower": "abomination"},
			{"do": "build", "spot": "plot:11", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:12", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "build", "spot": "plot:9", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "build", "spot": "plot:10", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:10", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "build", "spot": "plot:2", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:2"},
		],
	},
	"fae_court_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:5", "tower": "archer"},
		],
	},
	"world_tree_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:0", "tower": "archer"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "plot:4", "tower": "archer"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "build", "spot": "plot:1", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "plot:5", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:5", "mode": "strongest"},
			{"do": "build", "spot": "plot:2", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "build", "spot": "plot:3", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "post:5", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:6", "tower": "archer"},
			{"do": "build", "spot": "plot:7", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "build", "spot": "plot:8", "tower": "mage"},
			{"do": "build", "spot": "plot:9", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "post:4", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "build", "spot": "plot:10", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:10", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "post:5"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "build", "spot": "plot:11", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:11"},
		],
	},
	"world_tree_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:0", "tower": "archer"},
		],
	},
	"year_kit": {
		"spells": true,
		"loadout": ["wild_hunt", "root_and_rot", "glamour"],  # the Gravecaller keeps Shadow Bolt in slot 1: Glamour drops out (towers_check casts it)
		"steps_by_map": {
			"greenwood": [  # the default order with its first Catapult an Ossuary Oak, evolved after its fifth level (DECISIONS Y5)
				{"do": "build", "spot": "plot:0", "tower": "archer"},
				{"do": "build", "spot": "post:0", "tower": "warrior"},
				{"do": "build", "spot": "plot:2", "tower": "archer"},
				{"do": "build", "spot": "plot:4", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "post:1", "tower": "warrior"},
				{"do": "build", "spot": "plot:6", "tower": "ossuary_oak"},
				{"do": "target", "spot": "plot:6", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "plot:5", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "post:3", "tower": "abomination"},
				{"do": "build", "spot": "plot:7", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "plot:8", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:3", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "post:2", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:9", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:9", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "post:0"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:10", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "evolve", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "post:1"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:10"},
			],
			"fae_court": [  # the default order with its first Catapult an Ossuary Oak, evolved after its fifth level (DECISIONS Y5)
				{"do": "build", "spot": "plot:5", "tower": "archer"},
				{"do": "build", "spot": "post:2", "tower": "warrior"},
				{"do": "build", "spot": "plot:6", "tower": "archer"},
				{"do": "build", "spot": "plot:4", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "post:3", "tower": "warrior"},
				{"do": "build", "spot": "plot:7", "tower": "ossuary_oak"},
				{"do": "target", "spot": "plot:7", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "plot:8", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "post:4", "tower": "abomination"},
				{"do": "build", "spot": "plot:11", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:12", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "build", "spot": "plot:9", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "post:0", "tower": "warrior"},
				{"do": "build", "spot": "post:1", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "build", "spot": "plot:10", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:10", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "build", "spot": "plot:2", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "evolve", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:2"},
			],
			"world_tree": [  # the default order with its first Catapult an Ossuary Oak, evolved after its fifth level (DECISIONS Y5)
				{"do": "build", "spot": "plot:0", "tower": "archer"},
				{"do": "build", "spot": "post:2", "tower": "warrior"},
				{"do": "build", "spot": "plot:4", "tower": "archer"},
				{"do": "build", "spot": "post:3", "tower": "warrior"},
				{"do": "build", "spot": "plot:1", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "plot:5", "tower": "ossuary_oak"},
				{"do": "target", "spot": "plot:5", "mode": "strongest"},
				{"do": "build", "spot": "plot:2", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "build", "spot": "plot:3", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "post:5", "tower": "abomination"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:6", "tower": "archer"},
				{"do": "build", "spot": "plot:7", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "build", "spot": "plot:8", "tower": "mage"},
				{"do": "build", "spot": "plot:9", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "post:0", "tower": "warrior"},
				{"do": "build", "spot": "post:4", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "build", "spot": "plot:10", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:10", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "post:5"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "build", "spot": "plot:11", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "evolve", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:11"},
			],
		},

	},
}

## Battlefield moods of the three maps (keys: TdMoodData.MOODS). Moss and
## gold-green light in the Greenwood, blossom pink at the Court, the cold
## white-green glow of the World-Tree.
const MOODS: Dictionary = {
	"greenwood": {
		"props": [{"sprite": "obstacles/wild_grove_tree", "frames": 1, "count": 5, "scale": 1.0, "glow": Color(0.6, 1.0, 0.45, 0.4), "glow_r": 46.0,
			"glow_at": Vector2(0, -24), "flicker": 0.08, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.04},  # TUNING (not in GDD) sacred grove trees with a moss-green glow
			{"art": "mood_candles", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(1.0, 0.85, 0.45, 0.45), "glow_r": 38.0,
			"glow_at": Vector2(0, -18), "flicker": 0.15, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) hunters' lights, warm gold
		"fog": 2,  # TUNING (not in GDD) mist between the trees
		"pools": 2,  # TUNING (not in GDD) shafts of green light through the canopy
	},
	"fae_court": {
		"props": [{"sprite": "obstacles/wild_rose_hedge_m", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(1.0, 0.55, 0.75, 0.45), "glow_r": 52.0,
			"glow_at": Vector2(0, -10), "flicker": 0.1, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.03},  # TUNING (not in GDD) rose hedges in blossom pink light
			{"art": "mood_candles", "frames": 1, "count": 5, "scale": 1.0, "glow": Color(1.0, 0.8, 0.6, 0.45), "glow_r": 40.0,
			"glow_at": Vector2(0, -18), "flicker": 0.12, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) the revel's lanterns
		"fog": 1,  # TUNING (not in GDD) summer haze
		"pools": 4,  # TUNING (not in GDD) pools of warm summer light
	},
	"world_tree": {
		"props": [{"sprite": "obstacles/wild_oak_l", "frames": 1, "count": 5, "scale": 1.0, "glow": Color(0.75, 1.0, 0.8, 0.45), "glow_r": 48.0,
			"glow_at": Vector2(0, -22), "flicker": 0.06, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.03},  # TUNING (not in GDD) saplings of the World-Tree, a pale green-white glow
			{"sprite": "obstacles/wild_great_root_m", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(0.55, 0.9, 0.6, 0.35), "glow_r": 56.0,
			"glow_at": Vector2(0, -6), "flicker": 0.05, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) great roots lit from below
		"fog": 3,  # TUNING (not in GDD) the breath of the tree
		"pools": 3,  # TUNING (not in GDD)
	},
}

## The Turning Year (scripts/maps/rules/wild/turning_year.gd; Necropathy's
## SeasonCycle, Thickets and WildRules). Numbers of the simulation first, then
## the look. Seasons: 0 Spring, 1 Summer, 2 Autumn, 3 Winter.
const RULE: Dictionary = {
	# Per map: per = waves per season; start = the season of wave 1 (Autumn: the first Spring
	# comes once a map has towers to choke); hold = a season the map keeps all run (-1 = none;
	# the Fae Court's endless Summer); thickets = spots choked when Spring comes.
	"maps": {
		"greenwood": {"per": 4, "start": 2, "hold": -1, "thickets": 2},  # TUNING (not in GDD) the year turns every 4 waves
		"fae_court": {"per": 4, "start": 2, "hold": 1, "thickets": 2},  # TUNING (not in GDD) Necropathy: the endless summer (the Winter Prince brings a minute of winter)
		"world_tree": {"per": 2, "start": 2, "hold": -1, "thickets": 3},  # TUNING (not in GDD) the owner's brief: the year turns twice as fast
	},
	"names": ["Spring", "Summer", "Autumn", "Winter"],  # TUNING (not in GDD) the season names (banners, dial)
	"rules": ["thickets choke towers: tap a thicket to burn it", "the Wild runs faster",
		"the fallen sprout again", "the cold slows every tower"],  # TUNING (not in GDD) one line of rule each (banners, dial)
	# Spring: a thicket sprouts on a tower's spot (a telegraph of `sprout` s), then chokes it: the tower is
	# disabled (TdCombat.disable_tower, cause "choked") until a tap burns the thicket for `burn_cost` souls.
	"sprout": 4.0,  # TUNING (not in GDD) s a thicket shows its sprout before it chokes
	"choke_tick": 0.5,  # TUNING (not in GDD) s between two re-applications of the choke (each disables this long + a margin)
	"burn_cost": 20,  # TUNING (not in GDD) souls a burn costs (a tap; the bot's autotest_tap)
	"tap_radius": 30.0,  # TUNING (not in GDD) px a tap reaches a thicket
	"bot_delay": 6.0,  # TUNING (not in GDD) s the bot waits after a thicket grows before it burns it (a player's reaction)
	"bot_reserve": 60,  # TUNING (not in GDD) souls the bot keeps before it pays a burn
	# Summer: every enemy spawned is faster (TdCombat.empower_enemy, the one per-spawn path).
	"summer_speed": 1.15,  # TUNING (not in GDD) speed x
	# Autumn: every `sprout_every`-th fodder kill rises once as a wild_sprout where it fell.
	"sprout_every": 3,  # TUNING (not in GDD)
	"sprout_kind": "wild_sprout",
	# Winter: every tower attacks slower (TdCombat.chill_tower, the one attack-speed chill).
	"winter_rate": 0.8,  # TUNING (not in GDD) attack speed x
	"check_every": 0.5,  # TUNING (not in GDD) s between two winter checks
	# --- The look (drawing only) ---
	"tints": [Color(0.55, 1.0, 0.45, 0.32), Color(1.0, 0.8, 0.35, 0.3), Color(1.0, 0.5, 0.2, 0.32), Color(0.75, 0.9, 1.0, 0.38)],  # TUNING (not in GDD) edge band colour per season
	"band_depth": 0.12,  # TUNING (not in GDD) edge band depth as a share of the map's height
	"ambient": ["", "", "wild_leaves", "wild_snowfall"],  # TUNING (not in GDD) effects/ strip drifting over the map per season ("" = none)
	"ambient_n": 6,  # TUNING (not in GDD) ambient pieces drawn at once (Full effects only)
	"ambient_d": 150.0,  # TUNING (not in GDD) px of one piece
	"ambient_period": 4.0,  # TUNING (not in GDD) s of one piece's loop
	"thicket_px": 52.0,  # TUNING (not in GDD) px of a grown thicket drawn on its spot
	"sprout_px": 32.0,  # TUNING (not in GDD) px of the sprout telegraph at full size
	"chill_tint": Color(0.7, 0.88, 1.0, 0.5),  # TUNING (not in GDD) the frost disc under a chilled tower
	"chill_r": 26.0,  # TUNING (not in GDD) px of that disc
	"dial_px": 34.0,  # TUNING (not in GDD) HUD season wheel size (px)
	"dial_margin": Vector2(10.0, 10.0),  # TUNING (not in GDD) px from the screen's left edge / under the top bar
}

## The act's looks (drawing only; read by its traits, bosses, spells and tower).
const LOOK: Dictionary = {
	"warn_tint": Color(0.7, 1.0, 0.55, 0.65),  # TUNING (not in GDD) a telegraph ring (moss green)
	"horn_tint": Color(1.0, 0.85, 0.45, 0.9),  # TUNING (not in GDD) a hunting horn's blast ring (gold)
	"bud_tint": Color(1.0, 0.55, 0.75, 0.9),  # TUNING (not in GDD) a Corpse-Bloom's budding (blossom pink)
	"root_tint": Color(0.65, 0.45, 0.25, 0.95),  # TUNING (not in GDD) roots seizing a post (bark)
	"charge_tint": Color(0.75, 1.0, 0.6, 0.6),  # TUNING (not in GDD) a charge's telegraph line
	"charge_w": 6.0,  # TUNING (not in GDD) px of that line
	"charge_len": 160.0,  # TUNING (not in GDD) px the telegraph runs ahead on the road
	"spore_tint": Color(0.85, 0.75, 1.0, 0.85),  # TUNING (not in GDD) a spore cloud (pale violet)
	"frost_tint": Color(0.75, 0.92, 1.0, 0.9),  # TUNING (not in GDD) the Winter Prince's frost breath
	"petal_tint": Color(1.0, 0.6, 0.8, 0.85),  # TUNING (not in GDD) the Summer Queen's petals
	"mask_tint": Color(1.0, 0.85, 0.95, 0.9),  # TUNING (not in GDD) the Masque's burst
	"queen_alpha": 0.3,  # TUNING (not in GDD) the Summer Queen drawn faded while masked
	"burial_tint": Color(0.55, 0.4, 0.25, 0.9),  # TUNING (not in GDD) the Burial's earth
	"turn_tint": Color(0.85, 1.0, 0.7, 0.9),  # TUNING (not in GDD) the Turning's burst
	"claim_tints": [Color(1.0, 0.5, 0.25, 0.9), Color(1.0, 0.45, 0.8, 0.9), Color(0.45, 0.8, 0.85, 0.9)],  # TUNING (not in GDD) the Last Claim's three borrowed claims
	"burn_tint": Color(1.0, 0.6, 0.25),  # TUNING (not in GDD) a thicket burning
	# --- The act spells and tower ---
	"rider_px": 46.0,  # TUNING (not in GDD) px of a Wild Hunt rider drawn
	"root_d": 120.0,  # TUNING (not in GDD) px of Root and Rot's burst at its real radius x2 (set by the spell)
}
