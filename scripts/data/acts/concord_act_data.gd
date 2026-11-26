## Act XIII, the Concord of Stars (ActData "concord"; GDD §7.3; Necropathy's
## Concord of Stars, built there as Act IX: docs/act9/, the stages crash_site /
## proving_moon / ark, ConcordRules): its enemy kinds (KINDS, keys as
## TdEnemyData.KINDS), its build orders (ORDERS, keys as BuildOrderData.ORDERS),
## its three map moods (MOODS, keys as TdMoodData.MOODS), the numbers of its
## act rule, ABDUCTION (RULE, read by scripts/maps/rules/concord/abduction.gd)
## and the act's looks (LOOK). Every sprite is Necropathy's Concord art
## (assets/sprites/concord/, bosses/, summons/, player/, structures/). The
## Concord is one alien coalition: the Brood (insects, green-black chitin), the
## Vrask (reptile hunters), the Harvesters (greys and their saucers) and the
## Luminous (white-gold light). Its colour is plasma green; the tractor beams
## are pale green-white. The ids carry a "concord_" prefix (unique across
## acts). Data only.
extends RefCounted

## Enemy kinds of the Concord of Stars (keys: TdEnemyData.KINDS). Traits live in
## scripts/enemies/traits/concord/ and scripts/bosses/concord/ (each script
## documents its args). The saucers are spawned by the act rule (RULE "maps"),
## never by a wave group.
const KINDS: Dictionary = {
	# --- Act XIII (w2d-concord): the shared kinds ---
	# The Brood, fodder: small, fast insects in swarms (Necropathy "Fast swarms of 12").
	"concord_broodling": {
		"name": "Broodling", "sprite": "concord/broodling", "rank": "fodder", "souls": 3,  # TUNING (not in GDD) a swarm pays under the soldiers' 5 (X2)
		"hp": 34.0, "speed": 72.0, "armour": 0.0, "radius": 7.0,  # TUNING (not in GDD) frail and fast
		"damage": 3.0, "attack_interval": 0.9,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# The Harvesters, fodder: a small grey whose probe fires a short beam that stuns a tower (generic shooter).
	"concord_grey_drone": {
		"name": "Grey Drone", "sprite": "concord/grey_drone", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) a ranged soldier
		"hp": 95.0, "speed": 46.0, "armour": 1.0, "radius": 9.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 150.0, "interval": 8.0, "target": "tower", "disable": 1.0, "cause": "shot", "speed": 420.0, "arc": false, "look": "plasma"},  # TUNING (not in GDD) Necropathy "probe": a short beam
	},
	# The Brood, soldier: an armoured digger; every so often it BURROWS (unseen, unheld) and surfaces further on.
	"concord_burrower": {
		"name": "Burrower", "sprite": "concord/burrower", "rank": "fodder", "souls": 10,  # TUNING (not in GDD) soldier tier
		"hp": 150.0, "speed": 42.0, "armour": 3.0, "radius": 11.0,  # TUNING (not in GDD) armoured: the Mage's armour pierce counts
		"damage": 9.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "concord/burrower",
		"args": {"first": 2.5, "digs": 1, "under": 1.6, "speed_mult": 1.6},  # TUNING (not in GDD) Necropathy BurrowerKit: it tunnels in (here: once, under the post holding it)
	},
	# The Brood, ranged: an insect with an acid sac; its globs arc over the posts onto a blocker body (generic shooter).
	"concord_acid_spitter": {
		"name": "Acid Spitter", "sprite": "concord/acid_spitter", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) a ranged soldier
		"hp": 80.0, "speed": 44.0, "armour": 0.0, "radius": 9.0,  # TUNING (not in GDD)
		"damage": 5.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 140.0, "interval": 4.5, "target": "body", "damage": 12.0, "speed": 260.0, "arc": true, "look": "acid"},  # TUNING (not in GDD) Necropathy AcidPools.lob()
	},
	# The Ark's freed beasts: six-legged runners loosed from the specimen tanks.
	"concord_vault_beast": {
		"name": "Vault Beast", "sprite": "concord/vault_beast", "rank": "fodder", "souls": 6,  # TUNING (not in GDD) a runner
		"hp": 115.0, "speed": 44.0, "armour": 1.0, "radius": 10.0,  # TUNING (not in GDD) fast; DECISIONS Z4: 56 -> 44 (swarms of 12-14 leaked on every seed)
		"damage": 8.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# The Harvesters' saucer: the act rule flies it over the map on a sky lane; it stops over a post or a plot
	# and LIFTS it after a growing light cone (ABDUCTION). Every tower that can hit flyers, and every spell, answers it.
	"concord_saucer": {
		"name": "Saucer", "sprite": "concord/saucer", "rank": "elite", "souls": 10,  # TUNING (not in GDD) a little under an elite: the act rule sends many
		"hp": 120.0, "speed": 52.0, "armour": 0.0, "radius": 14.0,  # TUNING (not in GDD) brought down by two or three towers while it hovers
		"damage": 0.0, "attack_interval": 1.0,
		"flying": true, "ignores_walls": true, "trait": "concord/saucer",
		"args": {"reach": 130.0, "windup": 3.0, "hold": 1.0, "lift_time": 7.0, "lifts": 1, "moves": true, "scan": 0.25},  # TUNING (not in GDD) Necropathy Abduction.lift(): a ~2 s cone
	},
	# The Vrask, elite hunter: CLOAKED while it walks (a shimmer the towers cannot see); a post that holds it, or a spell, reveals it.
	"concord_vrask_hunter": {
		"name": "Vrask Hunter", "sprite": "concord/vrask_hunter", "rank": "elite",
		"hp": 430.0, "speed": 50.0, "armour": 3.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 18.0, "attack_interval": 1.1,  # TUNING (not in GDD) a glaive
		"flying": false, "ignores_walls": false, "trait": "concord/cloak",
		"args": {"alpha": 0.28, "reveal": 2.5},  # TUNING (not in GDD) Necropathy VraskHunterKit: shimmer alpha, s a spell hit reveals it
	},
	# The Luminous, ranged elite: a shield of light soaks its first hits; its beam staff blinds a tower.
	"concord_lumen_sentinel": {
		"name": "Lumen Sentinel", "sprite": "concord/lumen_sentinel", "rank": "elite",
		"hp": 480.0, "speed": 38.0, "armour": 3.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 12.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "concord/lumen",
		"args": {"shield": 0.35, "range": 170.0, "interval": 6.5, "target": "tower", "disable": 1.6, "cause": "blinded", "speed": 520.0, "arc": false, "look": "lumen"},  # TUNING (not in GDD) Necropathy lumen_shield 0.35
	},
	# The Luminous, support: the Star-Seer; her prism bends the light round the Concord near her (a ward: they take less damage).
	"concord_prism": {
		"name": "Star-Seer", "sprite": "concord/prism", "rank": "elite",
		"hp": 360.0, "speed": 40.0, "armour": 1.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "concord/prism",
		"args": {"radius": 120.0, "mult": 0.72, "refresh": 0.25},  # TUNING (not in GDD) a priority target: her ward softens every hit near her
	},
	# The Harvesters, support: a tall grey whose plasma crown mends the Concord near it (Act I healer).
	"concord_grey_overseer": {
		"name": "Grey Overseer", "sprite": "concord/grey_overseer", "rank": "elite",
		"hp": 400.0, "speed": 40.0, "armour": 2.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 8.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "healer",
		"args": {"heal": 26.0, "interval": 2.4, "radius": 140.0},  # TUNING (not in GDD)
	},
	# The Harvester's reap emitter: a pylon landed on the road during the Reaping; it lifts the post or tower nearest it
	# (the saucer's beam, standing still). A structure: towers shoot it last; the Reaping ends when all fall.
	"concord_reap_emitter": {
		"name": "Reap Emitter", "sprite": "structures/reap_emitter", "rank": "elite", "souls": 0,  # TUNING (not in GDD) the boss's, not a kill
		"hp": 900.0, "speed": 0.0, "armour": 2.0, "radius": 14.0, "structure": true,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": false, "ignores_walls": true, "trait": "concord/saucer",
		"args": {"reach": 170.0, "windup": 2.0, "hold": 1.0, "lift_time": 6.0, "lifts": 99, "moves": false, "scan": 0.25, "every": 7.0},  # TUNING (not in GDD) Necropathy ReapEmitterKit
	},
	# --- Act XIII: the minibosses (X3: real HP, one spawn per map) ---
	# Crash Site miniboss: the Brood Matriarch, a winged queen-guard (a FLIER: no post holds her); she spits egg sacs
	# onto the road ahead that hatch broodlings after a telegraph.
	"concord_brood_matriarch": {
		"name": "The Brood Matriarch", "sprite": "concord/brood_matriarch", "rank": "miniboss",
		"hp": 3600.0, "speed": 24.0, "armour": 4.0, "radius": 22.0,  # TUNING (not in GDD) X3: never held, so under 4000
		"damage": 20.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": true, "trait": "concord/matriarch",
		"args": {"first": 4.0, "every": 8.0, "windup": 1.4, "sacs": 2, "ahead": [120.0, 200.0], "hatch": 3, "kind": "concord_broodling", "radius": 34.0},  # TUNING (not in GDD) Necropathy BroodMatriarchKit: egg sacs over the ring
	},
	# Proving Moon miniboss: the Warbeast, the Vrask's war-hound; it CHARGES through the posts, striking every body it passes.
	"concord_warbeast": {
		"name": "The Warbeast", "sprite": "concord/warbeast", "rank": "miniboss",
		"hp": 3400.0, "speed": 30.0, "armour": 5.0, "radius": 20.0,  # TUNING (not in GDD) X3: held only between its charges, so under 4000
		"damage": 26.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "concord/warbeast",
		"args": {"first": 6.0, "every": 13.0, "windup": 0.9, "charge_time": 1.2, "speed_mult": 2.6, "roll_damage": 46.0},  # TUNING (not in GDD) Necropathy WarbeastKit: the charge
	},
	# Ark miniboss: the Luminous Archon, a being of white-gold light; his shield soaks his first hits and his sweeping
	# beam blinds every tower along its line.
	"concord_luminous_archon": {
		"name": "The Luminous Archon", "sprite": "concord/luminous_archon", "rank": "miniboss",
		"hp": 3400.0, "speed": 24.0, "armour": 6.0, "radius": 22.0,  # TUNING (not in GDD) DECISIONS Z4: 4000 -> 3400; X3 (its shield adds a quarter)
		"damage": 24.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "concord/archon",
		"args": {"shield": 0.25, "first": 4.0, "every": 8.0, "windup": 1.2, "range": 240.0, "width": 34.0, "disable": 2.0},  # TUNING (not in GDD) Necropathy LuminousArchonKit: the sweep
	},
	# --- Act XIII: the bosses ---
	# Crash Site boss: the Hive Mother. The Brood (eggs hatch round her), the Burrow (she dives unseen and erupts
	# under a post), the Flight (she takes to the air: no post holds her, acid rains on the towers).
	"concord_hive_mother": {
		"name": "The Hive Mother", "sprite": "bosses/hive_mother", "rank": "boss",
		"hp": 9000.0, "speed": 20.0, "armour": 5.0, "radius": 28.0,  # TUNING (not in GDD) DECISIONS Z4: 11000 -> 9000 (leaked in 2 of 4 seeds); a step over the Voice's act
		"damage": 30.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "concord/hive_mother",
		"args": {"phase_hp": [0.66, 0.3], "egg_first": 4.0, "egg_every": 9.0, "eggs": 5, "egg_spread": [50.0, 170.0], "egg_kind": "concord_broodling",
			"egg_windup": 1.0, "dive_first": 3.0, "dive_every": 12.0, "under": 2.6, "under_mult": 2.4, "mound": 1.0, "erupt_radius": 90.0,
			"erupt_damage": 70.0, "erupt_disable": 1.5, "acid_every": 5.0, "acid_targets": 2, "acid_radius": 48.0, "acid_delay": 1.3,
			"acid_disable": 2.4, "acid_damage": 30.0, "flight_sprite": "bosses/hive_mother_flight", "pose_time": 0.8},  # TUNING (not in GDD) Necropathy BossHiveMother
	},
	# Proving Moon boss: Vrask'Tal, the Hunt-Lord. The Stalk (cloaked, each body he fells hangs a skull: more damage),
	# the Duel (he leaps over the posts), the Last Trophy (a wrist bomb: kill him before it counts down).
	"concord_vrask_tal": {
		"name": "Vrask'Tal, the Hunt-Lord", "sprite": "bosses/vrask_tal", "rank": "boss",
		"hp": 8000.0, "speed": 22.0, "armour": 5.0, "radius": 26.0,  # TUNING (not in GDD) DECISIONS Z4: 9000 -> 8000 (leaked on seed 1)
		"damage": 34.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "concord/vrask_tal",
		"args": {"phase_hp": [0.6, 0.25], "alpha": 0.3, "reveal": 3.0, "skull_step": 0.08, "skull_cap": 8,
			"leap_first": 3.0, "leap_every": 9.0, "leap_windup": 1.1, "leap_dist": 170.0, "leap_radius": 70.0, "leap_damage": 60.0, "leap_disable": 1.2,
			"trophy_time": 22.0, "bomb_radius": 240.0, "bomb_disable": 7.0, "bomb_damage": 160.0, "trophy_speed": 1.25},  # TUNING (not in GDD) Necropathy BossVraskTal / VraskTalData
	},
	# Ark boss: the Harvester. The Council (the Concord's powers in turn: swarms, the Vrask cloak, Luminous beams),
	# the Reaping (immune while its reap emitters lift the posts and towers round them), the Gardener (its true form).
	"concord_harvester": {
		"name": "The Harvester", "sprite": "bosses/harvester", "rank": "boss",
		"hp": 8000.0, "speed": 18.0, "armour": 6.0, "radius": 28.0,  # TUNING (not in GDD) DECISIONS Z4: 10500 -> 8000 (leaked in 3 of 4 seeds); the act's last boss (immune through the Reaping)
		"damage": 36.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "concord/harvester",
		"args": {"reaping_hp": 0.5, "council_first": 4.0, "council_turn": 8.0, "swarm": 6, "swarm_kind": "concord_broodling",
			"cloak_time": 4.0, "cloak_alpha": 0.3, "cloak_speed": 1.5, "beams": 3, "beam_range": 230.0, "beam_disable": 2.0,
			"emitters": 3, "emitter_ahead": [70.0, 150.0, 230.0], "emitter_lane": 46.0, "reaping_max": 30.0,
			"true_sprite": "bosses/harvester_true", "gardener_speed": 1.1, "gardener_saucers": 2, "gardener_every": 18.0, "pose_time": 0.8},  # TUNING (not in GDD) Necropathy BossHarvester / HarvesterData
	},
}

## Build orders of the Concord maps (keys: BuildOrderData.ORDERS): each map's
## default (must win on Necromancer) and weak order (must lose), and one kit
## order for every Act XIII map ("concord_kit": the default with one Mage a
## Ghost Saucer, raised early to its Black Mothership, and the act spells).
const ORDERS: Dictionary = {
	# --- Act XIII, the Concord of Stars (w2d-concord) ---
	"crash_site_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:3", "tower": "archer"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:4", "tower": "archer"},
			{"do": "build", "spot": "plot:13", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "plot:6", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:6", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "build", "spot": "plot:5", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "post:3", "tower": "abomination"},
			{"do": "build", "spot": "plot:8", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:1", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:2", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:7", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:10", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:10"},
		],
	},
	"crash_site_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:3", "tower": "archer"},
		],
	},
	"proving_moon_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:0", "tower": "archer"},
			{"do": "build", "spot": "plot:5", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "plot:4", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:4", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:7", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "build", "spot": "post:3", "tower": "abomination"},
			{"do": "build", "spot": "plot:3", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:6", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "post:4", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:9", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:9", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:14", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:14"},
		],
	},
	"proving_moon_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
		],
	},
	"ark_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:14", "tower": "archer"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:15", "tower": "archer"},
			{"do": "build", "spot": "plot:3", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "build", "spot": "plot:5", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:5", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:2", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "build", "spot": "post:4", "tower": "abomination"},
			{"do": "build", "spot": "plot:4", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:1", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "plot:12", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "post:5", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:7", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "plot:6", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:6"},
		],
	},
	"ark_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:14", "tower": "archer"},
		],
	},
	"concord_kit": {
		"spells": true,
		"loadout": ["bone_beetles", "soul_caster", "tractor_lift"],
		"steps_by_map": {
			"crash_site": [
				{"do": "build", "spot": "plot:3", "tower": "archer"},
				{"do": "build", "spot": "post:1", "tower": "warrior"},
				{"do": "build", "spot": "plot:4", "tower": "archer"},
				{"do": "build", "spot": "plot:13", "tower": "ghost_saucer"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "post:2", "tower": "warrior"},
				{"do": "build", "spot": "plot:6", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:6", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "build", "spot": "plot:5", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "post:3", "tower": "abomination"},
				{"do": "build", "spot": "plot:8", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "plot:1", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "plot:2", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "build", "spot": "post:0", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:7", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "post:1"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "evolve", "spot": "plot:13"},
				{"do": "build", "spot": "plot:10", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:10"},
			],
			"proving_moon": [
				{"do": "build", "spot": "plot:1", "tower": "archer"},
				{"do": "build", "spot": "post:1", "tower": "warrior"},
				{"do": "build", "spot": "plot:0", "tower": "archer"},
				{"do": "build", "spot": "plot:5", "tower": "ghost_saucer"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "build", "spot": "post:2", "tower": "warrior"},
				{"do": "build", "spot": "plot:4", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:4", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:7", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "build", "spot": "post:3", "tower": "abomination"},
				{"do": "build", "spot": "plot:3", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "plot:2", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:6", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "post:4", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:9", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:9", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "post:1"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "evolve", "spot": "plot:5"},
				{"do": "build", "spot": "plot:14", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:14"},
			],
			"ark": [
				{"do": "build", "spot": "plot:14", "tower": "archer"},
				{"do": "build", "spot": "post:1", "tower": "warrior"},
				{"do": "build", "spot": "plot:15", "tower": "archer"},
				{"do": "build", "spot": "plot:3", "tower": "ghost_saucer"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "build", "spot": "post:3", "tower": "warrior"},
				{"do": "build", "spot": "plot:5", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:5", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:2", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "build", "spot": "post:4", "tower": "abomination"},
				{"do": "build", "spot": "plot:4", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:1", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "plot:12", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "post:5", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:7", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "post:1"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "evolve", "spot": "plot:3"},
				{"do": "build", "spot": "plot:6", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:6"},
			],
		},
	},
}

## Battlefield moods of the three maps (keys: TdMoodData.MOODS; DECISIONS Z3:
## the act shipped without any). Plasma green and lumen violet over dark hulls.
const MOODS: Dictionary = {
	"crash_site": {
		"props": [{"sprite": "obstacles/crash_hull_shard_s", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(0.45, 1.0, 0.55, 0.45), "glow_r": 44.0,
			"glow_at": Vector2(0, -14), "flicker": 0.3, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) burning hull shards
			{"sprite": "obstacles/wreck_plate_s", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(1.0, 0.55, 0.2, 0.35), "glow_r": 36.0,
			"glow_at": Vector2(0, -10), "flicker": 0.2, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) smouldering plates
		"fog": 2,  # TUNING (not in GDD) crash smoke
		"pools": 0,  # no stained glass
	},
	"proving_moon": {
		"props": [{"sprite": "obstacles/moon_shrine_s", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(0.75, 0.55, 1.0, 0.45), "glow_r": 46.0,
			"glow_at": Vector2(0, -24), "flicker": 0.15, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) hunters' trophy shrines
			{"sprite": "obstacles/moon_boulder_s", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(0.6, 0.8, 1.0, 0.2), "glow_r": 30.0,
			"glow_at": Vector2(0, -8), "flicker": 0.0, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) moonlit rocks
		"fog": 0,  # no air on the moon
		"pools": 0,  # no stained glass
	},
	"ark": {
		"props": [{"sprite": "obstacles/ark_pillar_s", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(0.45, 1.0, 0.65, 0.5), "glow_r": 46.0,
			"glow_at": Vector2(0, -40), "flicker": 0.1, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) humming ark pillars
			{"sprite": "obstacles/ark_console_s", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(0.75, 0.55, 1.0, 0.45), "glow_r": 38.0,
			"glow_at": Vector2(0, -16), "flicker": 0.25, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) lumen consoles
		"fog": 0,
		"pools": 0,  # no stained glass
	},
}

## Abduction (scripts/maps/rules/concord/abduction.gd; Necropathy's Abduction):
## saucers cross the map on its sky lanes and lift what they stop over.
## Numbers of the simulation first, then the look.
const RULE: Dictionary = {
	# Per map: the flights. first (wave the first flight comes), every (s between two
	# flights), per ([[from wave, saucers a flight], ...]: the last row reached counts),
	# gap (s between the saucers of one flight), lanes (the map's sky-lane road ids,
	# cycled flight by flight).
	"maps": {
		"crash_site": {"first": 3, "every": 30.0, "per": [[3, 1], [9, 2], [17, 3]], "gap": 3.0, "lanes": ["sky_a", "sky_b"]},  # TUNING (not in GDD)
		"proving_moon": {"first": 2, "every": 28.0, "per": [[2, 1], [8, 2], [15, 3]], "gap": 3.0, "lanes": ["sky_a", "sky_b"]},  # TUNING (not in GDD)
		"ark": {"first": 2, "every": 26.0, "per": [[2, 1], [7, 2], [14, 3]], "gap": 2.6, "lanes": ["sky_a", "sky_b"]},  # TUNING (not in GDD)
	},
	"kind": "concord_saucer",  # TUNING (not in GDD) the kind a flight sends
	"warn": 5.0,  # TUNING (not in GDD) s the HUD cue counts down before a flight (and a banner the first time)
	# --- The look (drawing only) ---
	"cone_tint": Color(0.7, 1.0, 0.75, 0.9),  # TUNING (not in GDD) the tractor cone while it grows (additive)
	"cone_hot": Color(0.9, 1.0, 0.9, 1.0),  # TUNING (not in GDD) the cone once it lifts
	"cone_w0": 14.0,  # TUNING (not in GDD) px of the cone at the start of the telegraph
	"cone_w1": 84.0,  # TUNING (not in GDD) px of the cone when it lifts
	"spot_tint": Color(0.6, 1.0, 0.65, 0.8),  # TUNING (not in GDD) the light disc on the ground under the target
	"lifted_tint": Color(0.7, 1.0, 0.75, 0.45),  # TUNING (not in GDD) the column over a tower lifted out of the fight
	"lifted_w": 46.0,  # TUNING (not in GDD) px of that column
	"lane_tint": Color(0.55, 1.0, 0.6, 0.6),  # TUNING (not in GDD) the flight lane drawn over the map (DECISIONS Z6: alpha 0.3 -> 0.6, it did not read)
	"lane_dash": 26.0,  # TUNING (not in GDD) px of one dash of the lane (gaps as long)
	"lane_w": 10.0,  # TUNING (not in GDD) px thickness of a lane dash (DECISIONS Z6: was 6)
	"mound_px": 28.0,  # TUNING (not in GDD) px of a burrow mound drawn over a burrowed enemy
	"cue_px": 30.0,  # TUNING (not in GDD) HUD cue icon size (px)
	"cue_margin": Vector2(10.0, 10.0),  # TUNING (not in GDD) px from the screen's right edge / under the top bar
	"cue_color": Color(0.75, 1.0, 0.78),  # TUNING (not in GDD) the label: plasma green
	"cue_hot": Color(1.0, 0.6, 0.55),  # TUNING (not in GDD) while a saucer is beaming or a trophy bomb counts down
}

## The act's looks (drawing only; read by its traits, bosses, spells and tower).
const LOOK: Dictionary = {
	"plasma": Color(0.45, 1.0, 0.55),  # TUNING (not in GDD) the Concord's plasma green (bursts, telegraphs)
	"light": Color(1.0, 0.95, 0.75),  # TUNING (not in GDD) the Luminous white-gold
	"warn_tint": Color(0.55, 1.0, 0.6, 0.65),  # TUNING (not in GDD) a telegraph ring (eggs, eruptions, leaps)
	"line_tint": Color(1.0, 0.95, 0.75, 0.5),  # TUNING (not in GDD) the Archon's beam telegraph
	"line_w": 5.0,  # TUNING (not in GDD) px
	"beam_tint": Color(1.0, 0.97, 0.85, 1.0),  # TUNING (not in GDD) the Archon's beam
	"beam_w": 16.0,  # TUNING (not in GDD) px
	"beam_time": 0.35,  # TUNING (not in GDD) s the beam shows
	"burst_d": 96.0,  # TUNING (not in GDD) px of an eruption / landing burst
	"bomb_tint": Color(1.0, 0.45, 0.35, 0.8),  # TUNING (not in GDD) the trophy bomb's ring
	# --- The act spells and tower ---
	"beetle_px": 14.0,  # TUNING (not in GDD) px of a Bone Beetle drawn
	"lock_tint": Color(0.45, 1.0, 0.9),  # TUNING (not in GDD) Soul Caster's lock dots and shots (soul-teal: the spell's own colour)
	"lock_px": 10.0,  # TUNING (not in GDD) px of a lock dot
	"tractor_tint": Color(0.75, 1.0, 0.85),  # TUNING (not in GDD) Tractor Beam's column
	"saucer_beam_w": 20.0,  # TUNING (not in GDD) px of the Ghost Saucer's beam (DECISIONS Z6: was 10, too thin)
	"saucer_beam_time": 0.4,  # TUNING (not in GDD) s it shows (DECISIONS Z6: was 0.25)
}
