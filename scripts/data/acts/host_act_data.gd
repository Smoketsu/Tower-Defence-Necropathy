## Act X, the Celestial Host (ActData "host"; GDD §7.3; Necropathy's Celestial
## Host, docs/host/ and docs/proposals/LAST_SIX_ACTS.md section X, the stages
## silver_stair / wheel_of_thrones / empyrean): its enemy kinds (KINDS, keys as
## TdEnemyData.KINDS), its build orders (ORDERS, keys as BuildOrderData.ORDERS),
## its three map moods (MOODS, keys as TdMoodData.MOODS), the numbers of its act
## rule, the Hallowed Light and Judgment (RULE, read by
## scripts/maps/rules/host/hallowed_light.gd) and the act's looks (LOOK). Every
## sprite is Necropathy's Host art (assets/sprites/host/, summons/, player/,
## markers/host_*, fx/host_*). Heaven's colours: silver, cerulean and white,
## never crimson or warm gold. The ids carry a "host_" prefix (unique across
## acts). Data only.
extends RefCounted

## Enemy kinds of the Celestial Host (keys: TdEnemyData.KINDS). Traits live in
## scripts/enemies/traits/host/ and scripts/bosses/host/ (each script documents
## its args). Every angel is GRACED by the Hallowed Light (the act rule: hasted
## and regenerating inside a shaft); no kind needs a key for it.
const KINDS: Dictionary = {
	# The lesser lights: small winged orbs of light in swarms (Necropathy "Fodder swarm"); they float over the posts.
	"host_lesser_light": {
		"name": "Lesser Light", "sprite": "host/lesser_light", "rank": "fodder", "souls": 4,  # TUNING (not in GDD) a swarm pays a little under the soldiers' 5 (X2)
		"hp": 26.0, "speed": 56.0, "armour": 0.0, "radius": 8.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": true, "trait": "", "args": {},
	},
	# A soldier: a silver spearman with a mirror mask and four wings (Necropathy "Virtue | Blockers").
	"host_virtue": {
		"name": "Virtue", "sprite": "host/virtue", "rank": "fodder", "souls": 10,  # TUNING (not in GDD) soldier tier, the top of X2 (Part Two)
		"hp": 115.0, "speed": 48.0, "armour": 2.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 7.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# A soldier: a blade of white flame; a telegraphed lunge cuts the first two bodies of the post holding her.
	"host_power": {
		"name": "Power", "sprite": "host/power", "rank": "fodder", "souls": 10,  # TUNING (not in GDD) soldier tier, the top of X2 (Part Two)
		"hp": 100.0, "speed": 54.0, "armour": 1.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 7.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "host/lunge",
		"args": {"windup": 0.6, "damage": 30.0, "cooldown": 5.5, "targets": 2},  # TUNING (not in GDD) Necropathy: 0.6 s white line, "cuts two summons in a line", every 5.5 s
	},
	# The choir: her hymn heals the angels around her (Act I healer; Necropathy "heals angels within 200 px"; a priority target).
	"host_choir_angel": {
		"name": "Choir Angel", "sprite": "host/choir_angel", "rank": "elite",
		"hp": 300.0, "speed": 42.0, "armour": 1.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 5.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "healer",
		"args": {"heal": 26.0, "interval": 2.4, "radius": 150.0},  # TUNING (not in GDD) Necropathy heal interval 2.4 s; 200 px reads too wide on a road
	},
	# The choir: a trumpet blast calls a squad of lights and shakes the posts near him (Necropathy "Herald | Kill on arrival").
	"host_herald": {
		"name": "Herald", "sprite": "host/herald", "rank": "elite",
		"hp": 360.0, "speed": 44.0, "armour": 2.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 8.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "host/herald",
		"args": {"first": 3.0, "every": 9.0, "windup": 0.8, "calls": 2, "squads": [[["host_lesser_light", 4]]],
			"radius": 100.0, "stun": 1.0, "gap": 16.0},  # TUNING (not in GDD) Necropathy: calls 2 squads, a 1.0 s push
	},
	# The high orders: a sceptre of light rings; the angels near him march faster (Act I banner_aura; Necropathy "Dominion").
	"host_dominion": {
		"name": "Dominion", "sprite": "host/dominion", "rank": "elite",
		"hp": 620.0, "speed": 38.0, "armour": 5.0, "radius": 13.0,  # TUNING (not in GDD)
		"damage": 16.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "banner_aura",
		"args": {"radius": 110.0, "speed_mult": 1.25, "refresh": 0.25},  # TUNING (not in GDD)
	},
	# Judgment's elite: the run's sins return as Judges in the boss fights (RULE "judgment"); his blade cuts a post hard.
	"host_judge": {
		"name": "Judge", "sprite": "host/judge", "rank": "elite", "souls": 6,  # TUNING (not in GDD) a sin returned pays half an elite
		"hp": 820.0, "speed": 46.0, "armour": 4.0, "radius": 13.0,  # TUNING (not in GDD)
		"damage": 26.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "host/judge", "args": {},
	},
	# The guardians: four faces, four wings of eyes and a flaming sword that SWEEPS ALL AROUND IT (Necropathy "Cherub").
	"host_cherub": {
		"name": "Cherub", "sprite": "host/cherub", "rank": "elite",
		"hp": 540.0, "speed": 34.0, "armour": 4.0, "radius": 15.0,  # TUNING (not in GDD)
		"damage": 14.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "host/cherub",
		"args": {"first": 3.0, "every": 7.0, "windup": 1.0, "reach": 72.0, "body_damage": 36.0, "disable": 0.8},  # TUNING (not in GDD)
	},
	# The guardians: a burning wheel within a wheel; it ROLLS down the road and no post holds it unless it is staggered or frozen.
	"host_ophan": {
		"name": "Ophan", "sprite": "host/ophan", "rank": "elite",
		"hp": 560.0, "speed": 46.0, "armour": 6.0, "radius": 15.0,  # TUNING (not in GDD)
		"damage": 18.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "host/ophan",
		"args": {"roll_damage": 34.0, "roll_first": 4.0, "roll_every": 9.0, "roll_time": 1.6, "speed_mult": 1.8},  # TUNING (not in GDD) Necropathy "rolls straight through the ring, then turns"
	},
	# Silver Stair miniboss: the Cherub of the Gate, its sword turning a full circle every 6 s.
	"host_cherub_of_the_gate": {
		"name": "The Cherub of the Gate", "sprite": "host/cherub_of_the_gate", "rank": "miniboss",
		"hp": 4600.0, "speed": 26.0, "armour": 6.0, "radius": 24.0,  # TUNING (not in GDD) X3: 4000-6000
		"damage": 22.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "host/cherub",
		"args": {"first": 3.0, "every": 6.0, "windup": 1.0, "reach": 110.0, "body_damage": 50.0, "disable": 1.4},  # TUNING (not in GDD) Necropathy: a full circle every 6 s
	},
	# Wheel of Thrones miniboss: the Dominion of the Spheres keeps every angel near him quick and whole.
	"host_dominion_of_the_spheres": {
		"name": "The Dominion of the Spheres", "sprite": "host/dominion_of_the_spheres", "rank": "miniboss",
		"hp": 5400.0, "speed": 28.0, "armour": 6.0, "radius": 24.0,  # TUNING (not in GDD) X3
		"damage": 24.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "host/spheres",
		"args": {"radius": 170.0, "speed_mult": 1.3, "regen": 0.025, "refresh": 0.25, "tick": 0.25},  # TUNING (not in GDD) Necropathy "keeps halos returning across the whole zone"
	},
	# Empyrean miniboss: the Herald of the Seventh Trumpet; each blast calls the squad of an earlier zone, seven in all.
	"host_seventh_herald": {
		"name": "The Herald of the Seventh Trumpet", "sprite": "host/herald_of_the_seventh_trumpet", "rank": "miniboss",
		"hp": 5600.0, "speed": 28.0, "armour": 5.0, "radius": 24.0,  # TUNING (not in GDD) X3
		"damage": 22.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "host/herald",
		"args": {"first": 3.0, "every": 7.0, "windup": 1.0, "calls": 7, "radius": 150.0, "stun": 1.6, "gap": 18.0,
			"squads": [[["host_lesser_light", 6]], [["host_virtue", 2]], [["host_power", 2]], [["host_lesser_light", 6]],
				[["host_virtue", 2], ["host_power", 1]], [["host_cherub", 1]], [["host_ophan", 1]]]},  # TUNING (not in GDD) Necropathy: seven blasts, each zone's squad
	},
	# Silver Stair boss: Seraiel, Warden of the Gate. The Sword sweeps his post; the Gate closes lanes of plots
	# with still shafts of light; the Trial fills the scales with each phase he survives (Judges come).
	"host_seraiel": {
		"name": "Seraiel, Warden of the Gate", "sprite": "host/seraiel", "rank": "boss",
		"hp": 9500.0, "speed": 22.0, "armour": 5.0, "radius": 26.0,  # TUNING (not in GDD) under Amaterasu (14500): the Gate and the Trial weigh more
		"damage": 30.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "host/seraiel",
		"args": {"phase_hp": [0.66, 0.33], "sword_first": 3.0, "sword_every": 7.0, "sword_every_p3": 4.5, "windup": 0.9,
			"reach": 120.0, "body_damage": 70.0, "disable": 1.0,
			"gate_first": 6.0, "gate_every": 14.0, "gate_life": 9.0, "gate_width": 120.0, "gate_ahead": 220.0, "gates_p3": 2,
			"trial_judges": 2, "pose_time": 0.7},  # TUNING (not in GDD) Necropathy BossSeraiel: the Sword, the Gate, the Trial
	},
	# Wheel of Thrones boss: the Throne. Its rims take a fifth of every hit; every so often the wheels part and
	# the burning Core can be hurt; it rolls through the posts and its Gaze lays shafts over the towers near it.
	"host_throne": {
		"name": "The Throne", "sprite": "host/throne", "rank": "boss",
		"hp": 9000.0, "speed": 22.0, "armour": 6.0, "radius": 30.0,  # TUNING (not in GDD) its rims (x0.2) make it the act's toughest wall
		"damage": 32.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "host/throne",
		"args": {"rim_mult": 0.2, "core_first": 8.0, "core_every": 18.0, "core_time": 8.0,
			"roll_first": 5.0, "roll_every": 12.0, "roll_time": 2.0, "speed_mult": 2.0, "roll_damage": 60.0,
			"gaze_every": 10.0, "gaze_width": 110.0, "gaze_life": 7.0, "gazes": 2, "pose_time": 0.6},  # TUNING (not in GDD) Necropathy BossThrone: Core 10 s at a time
	},
	# Empyrean boss: the Voice. It never moves: it stands at the heart of the rose while the Holy widens the Light,
	# Be Not Afraid stops every tower in the open, and the Last Word sends the run's sins back as Judges.
	"host_voice": {
		"name": "The Voice", "sprite": "host/voice", "rank": "boss",
		"hp": 21000.0, "speed": 0.0, "armour": 5.0, "radius": 30.0,  # TUNING (not in GDD) the act's (and Part Two's) last boss
		"damage": 40.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "host/voice",
		"args": {"stand_dist": 1440.0, "holy_width": 1.35, "holy_live": 1,
			"fear_first": 8.0, "fear_every": 16.0, "fear_warn": 2.0, "fear_stun": 2.0,
			"word_first": 4.0, "word_every": 20.0, "word_cap": 3, "word_min": 1, "word_waves": 6,
			"choir_every": 12.0, "choir": [["host_lesser_light", 6], ["host_choir_angel", 1]], "choir_gap": 16.0,
			"pose_time": 1.0},  # TUNING (not in GDD) Necropathy BossVoice: the Holy, Be Not Afraid (2 s), the Last Word (capped waves)
	},
}

## Build orders of the Host maps (keys: BuildOrderData.ORDERS): each map's
## default (must win on Necromancer) and weak order (must lose), and one kit
## order for every Act X map ("host_kit": the Bound Ophan on the plots and its
## Throne of Bones, the act spells, Turning Wheel beside a Crypt Warder).
const ORDERS: Dictionary = {
	"silver_stair_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "build", "spot": "plot:4", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:6", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:6", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "plot:5", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "post:3", "tower": "abomination"},
			{"do": "build", "spot": "plot:9", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:10", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "build", "spot": "plot:3", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "build", "spot": "plot:8", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:8", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "post:0"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "build", "spot": "plot:0", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:0"},
		],
	},
	"silver_stair_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
		],
	},
	"wheel_of_thrones_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:0", "tower": "archer"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "plot:1", "tower": "archer"},
			{"do": "build", "spot": "plot:2", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "build", "spot": "post:5", "tower": "warrior"},
			{"do": "build", "spot": "plot:9", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:9", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:10", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "build", "spot": "post:4", "tower": "abomination"},
			{"do": "build", "spot": "plot:3", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "build", "spot": "plot:8", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:4", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:7", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "post:0"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:5", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "post:5"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:5"},
		],
	},
	"wheel_of_thrones_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:0", "tower": "archer"},
		],
	},
	"empyrean_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:6", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:4", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:4", "mode": "strongest"},
			{"do": "build", "spot": "plot:7", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:9", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "post:4", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:0", "tower": "archer"},
			{"do": "build", "spot": "plot:3", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:11", "tower": "mage"},
			{"do": "build", "spot": "plot:14", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:12", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:12", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:5", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "post:0"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:5"},
		],
	},
	"empyrean_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
		],
	},
	"host_kit": {
		"spells": true,
		"loadout": ["flaming_sword", "wheel_of_eyes", "revelation"],
		"steps_by_map": {
			"silver_stair": [
					{"do": "build", "spot": "plot:1", "tower": "archer"},
					{"do": "build", "spot": "post:0", "tower": "warrior"},
					{"do": "build", "spot": "plot:2", "tower": "archer"},
					{"do": "build", "spot": "plot:4", "tower": "mage"},
					{"do": "upgrade", "spot": "plot:1"},
					{"do": "upgrade", "spot": "plot:2"},
					{"do": "build", "spot": "post:1", "tower": "warrior"},
					{"do": "build", "spot": "plot:6", "tower": "bound_ophan"},
					{"do": "target", "spot": "plot:6", "mode": "strongest"},
					{"do": "upgrade", "spot": "plot:4"},
					{"do": "build", "spot": "plot:5", "tower": "warder"},
					{"do": "upgrade", "spot": "plot:1"},
					{"do": "upgrade", "spot": "plot:2"},
					{"do": "build", "spot": "post:3", "tower": "abomination"},
					{"do": "build", "spot": "plot:9", "tower": "mage"},
					{"do": "upgrade", "spot": "plot:6"},
					{"do": "build", "spot": "plot:10", "tower": "archer"},
					{"do": "upgrade", "spot": "plot:4"},
					{"do": "upgrade", "spot": "plot:9"},
					{"do": "build", "spot": "plot:3", "tower": "frost_wraith"},
					{"do": "upgrade", "spot": "plot:1"},
					{"do": "upgrade", "spot": "plot:2"},
					{"do": "upgrade", "spot": "plot:10"},
					{"do": "upgrade", "spot": "plot:6"},
					{"do": "upgrade", "spot": "plot:6"},
					{"do": "upgrade", "spot": "plot:6"},
					{"do": "upgrade", "spot": "plot:6"},
					{"do": "evolve", "spot": "plot:6"},
					{"do": "upgrade", "spot": "plot:6"},
					{"do": "build", "spot": "post:2", "tower": "warrior"},
					{"do": "upgrade", "spot": "plot:5"},
					{"do": "upgrade", "spot": "plot:4"},
					{"do": "upgrade", "spot": "plot:9"},
					{"do": "build", "spot": "plot:8", "tower": "bound_ophan"},
					{"do": "target", "spot": "plot:8", "mode": "strongest"},
					{"do": "upgrade", "spot": "plot:3"},
					{"do": "upgrade", "spot": "plot:1"},
					{"do": "upgrade", "spot": "plot:2"},
					{"do": "upgrade", "spot": "plot:10"},
					{"do": "upgrade", "spot": "plot:6"},
					{"do": "upgrade", "spot": "post:0"},
					{"do": "upgrade", "spot": "plot:8"},
					{"do": "upgrade", "spot": "plot:4"},
					{"do": "upgrade", "spot": "plot:9"},
					{"do": "build", "spot": "plot:0", "tower": "mage"},
					{"do": "upgrade", "spot": "plot:3"},
					{"do": "upgrade", "spot": "plot:10"},
					{"do": "upgrade", "spot": "plot:6"},
					{"do": "upgrade", "spot": "plot:8"},
					{"do": "upgrade", "spot": "plot:0"},
					{"do": "upgrade", "spot": "plot:1"},
					{"do": "upgrade", "spot": "plot:2"},
					{"do": "upgrade", "spot": "plot:4"},
					{"do": "upgrade", "spot": "plot:9"},
					{"do": "upgrade", "spot": "plot:5"},
					{"do": "upgrade", "spot": "plot:3"},
					{"do": "upgrade", "spot": "plot:8"},
					{"do": "upgrade", "spot": "plot:0"},
					{"do": "upgrade", "spot": "plot:10"},
					{"do": "upgrade", "spot": "plot:0"},
					{"do": "upgrade", "spot": "post:1"},
					{"do": "upgrade", "spot": "post:3"},
					{"do": "upgrade", "spot": "plot:3"},
					{"do": "upgrade", "spot": "plot:0"},
			],
			"wheel_of_thrones": [
					{"do": "build", "spot": "plot:0", "tower": "archer"},
					{"do": "build", "spot": "post:0", "tower": "warrior"},
					{"do": "build", "spot": "plot:1", "tower": "archer"},
					{"do": "build", "spot": "plot:2", "tower": "mage"},
					{"do": "upgrade", "spot": "plot:0"},
					{"do": "upgrade", "spot": "plot:1"},
					{"do": "build", "spot": "post:5", "tower": "warrior"},
					{"do": "build", "spot": "plot:9", "tower": "bound_ophan"},
					{"do": "target", "spot": "plot:9", "mode": "strongest"},
					{"do": "upgrade", "spot": "plot:2"},
					{"do": "build", "spot": "plot:10", "tower": "warder"},
					{"do": "upgrade", "spot": "plot:0"},
					{"do": "upgrade", "spot": "plot:1"},
					{"do": "build", "spot": "post:4", "tower": "abomination"},
					{"do": "build", "spot": "plot:3", "tower": "mage"},
					{"do": "upgrade", "spot": "plot:9"},
					{"do": "build", "spot": "plot:8", "tower": "archer"},
					{"do": "upgrade", "spot": "plot:2"},
					{"do": "upgrade", "spot": "plot:3"},
					{"do": "build", "spot": "plot:4", "tower": "frost_wraith"},
					{"do": "upgrade", "spot": "plot:0"},
					{"do": "upgrade", "spot": "plot:1"},
					{"do": "upgrade", "spot": "plot:8"},
					{"do": "upgrade", "spot": "plot:9"},
					{"do": "upgrade", "spot": "plot:9"},
					{"do": "upgrade", "spot": "plot:9"},
					{"do": "upgrade", "spot": "plot:9"},
					{"do": "evolve", "spot": "plot:9"},
					{"do": "upgrade", "spot": "plot:9"},
					{"do": "build", "spot": "post:3", "tower": "warrior"},
					{"do": "upgrade", "spot": "plot:10"},
					{"do": "upgrade", "spot": "plot:2"},
					{"do": "upgrade", "spot": "plot:3"},
					{"do": "build", "spot": "plot:7", "tower": "bound_ophan"},
					{"do": "target", "spot": "plot:7", "mode": "strongest"},
					{"do": "upgrade", "spot": "plot:4"},
					{"do": "upgrade", "spot": "plot:0"},
					{"do": "upgrade", "spot": "plot:1"},
					{"do": "upgrade", "spot": "plot:8"},
					{"do": "upgrade", "spot": "plot:9"},
					{"do": "upgrade", "spot": "post:0"},
					{"do": "upgrade", "spot": "plot:7"},
					{"do": "upgrade", "spot": "plot:2"},
					{"do": "upgrade", "spot": "plot:3"},
					{"do": "build", "spot": "plot:5", "tower": "mage"},
					{"do": "upgrade", "spot": "plot:4"},
					{"do": "upgrade", "spot": "plot:8"},
					{"do": "upgrade", "spot": "plot:9"},
					{"do": "upgrade", "spot": "plot:7"},
					{"do": "upgrade", "spot": "plot:5"},
					{"do": "upgrade", "spot": "plot:0"},
					{"do": "upgrade", "spot": "plot:1"},
					{"do": "upgrade", "spot": "plot:2"},
					{"do": "upgrade", "spot": "plot:3"},
					{"do": "upgrade", "spot": "plot:10"},
					{"do": "upgrade", "spot": "plot:4"},
					{"do": "upgrade", "spot": "plot:7"},
					{"do": "upgrade", "spot": "plot:5"},
					{"do": "upgrade", "spot": "plot:8"},
					{"do": "upgrade", "spot": "plot:5"},
					{"do": "upgrade", "spot": "post:5"},
					{"do": "upgrade", "spot": "post:4"},
					{"do": "upgrade", "spot": "plot:4"},
					{"do": "upgrade", "spot": "plot:5"},
			],
			"empyrean": [
					{"do": "build", "spot": "plot:1", "tower": "archer"},
					{"do": "build", "spot": "post:0", "tower": "warrior"},
					{"do": "build", "spot": "plot:2", "tower": "archer"},
					{"do": "build", "spot": "post:1", "tower": "warrior"},
					{"do": "build", "spot": "plot:6", "tower": "mage"},
					{"do": "upgrade", "spot": "plot:1"},
					{"do": "upgrade", "spot": "plot:2"},
					{"do": "build", "spot": "plot:4", "tower": "bound_ophan"},
					{"do": "target", "spot": "plot:4", "mode": "strongest"},
					{"do": "build", "spot": "plot:7", "tower": "mage"},
					{"do": "upgrade", "spot": "plot:6"},
					{"do": "build", "spot": "plot:9", "tower": "warder"},
					{"do": "upgrade", "spot": "plot:1"},
					{"do": "upgrade", "spot": "plot:2"},
					{"do": "build", "spot": "post:4", "tower": "abomination"},
					{"do": "upgrade", "spot": "plot:4"},
					{"do": "upgrade", "spot": "plot:7"},
					{"do": "build", "spot": "plot:0", "tower": "archer"},
					{"do": "build", "spot": "plot:3", "tower": "archer"},
					{"do": "upgrade", "spot": "plot:6"},
					{"do": "build", "spot": "plot:11", "tower": "mage"},
					{"do": "build", "spot": "plot:14", "tower": "frost_wraith"},
					{"do": "upgrade", "spot": "plot:1"},
					{"do": "upgrade", "spot": "plot:2"},
					{"do": "upgrade", "spot": "plot:0"},
					{"do": "upgrade", "spot": "plot:3"},
					{"do": "upgrade", "spot": "plot:4"},
					{"do": "upgrade", "spot": "plot:4"},
					{"do": "upgrade", "spot": "plot:4"},
					{"do": "upgrade", "spot": "plot:4"},
					{"do": "upgrade", "spot": "plot:4"},
					{"do": "evolve", "spot": "plot:4"},
					{"do": "build", "spot": "post:2", "tower": "warrior"},
					{"do": "build", "spot": "post:3", "tower": "warrior"},
					{"do": "upgrade", "spot": "plot:9"},
					{"do": "upgrade", "spot": "plot:7"},
					{"do": "upgrade", "spot": "plot:6"},
					{"do": "build", "spot": "plot:12", "tower": "bound_ophan"},
					{"do": "target", "spot": "plot:12", "mode": "strongest"},
					{"do": "upgrade", "spot": "plot:11"},
					{"do": "upgrade", "spot": "plot:14"},
					{"do": "upgrade", "spot": "plot:1"},
					{"do": "upgrade", "spot": "plot:2"},
					{"do": "upgrade", "spot": "plot:0"},
					{"do": "upgrade", "spot": "plot:3"},
					{"do": "upgrade", "spot": "plot:4"},
					{"do": "upgrade", "spot": "plot:12"},
					{"do": "upgrade", "spot": "post:4"},
					{"do": "upgrade", "spot": "plot:7"},
					{"do": "upgrade", "spot": "plot:6"},
					{"do": "build", "spot": "plot:5", "tower": "mage"},
					{"do": "upgrade", "spot": "plot:11"},
					{"do": "upgrade", "spot": "plot:14"},
					{"do": "upgrade", "spot": "plot:1"},
					{"do": "upgrade", "spot": "plot:2"},
					{"do": "upgrade", "spot": "plot:4"},
					{"do": "upgrade", "spot": "plot:12"},
					{"do": "upgrade", "spot": "plot:5"},
					{"do": "upgrade", "spot": "plot:0"},
					{"do": "upgrade", "spot": "plot:3"},
					{"do": "upgrade", "spot": "plot:7"},
					{"do": "upgrade", "spot": "plot:6"},
					{"do": "upgrade", "spot": "plot:9"},
					{"do": "upgrade", "spot": "plot:11"},
					{"do": "upgrade", "spot": "plot:12"},
					{"do": "upgrade", "spot": "plot:5"},
					{"do": "upgrade", "spot": "plot:0"},
					{"do": "upgrade", "spot": "plot:3"},
					{"do": "upgrade", "spot": "plot:5"},
					{"do": "upgrade", "spot": "post:0"},
					{"do": "upgrade", "spot": "post:1"},
					{"do": "upgrade", "spot": "plot:14"},
					{"do": "upgrade", "spot": "plot:5"},
			],
		},
	},
}

## Battlefield moods of the three maps (keys: TdMoodData.MOODS). Cool silver
## and cerulean light; no warm fires anywhere in heaven.
const MOODS: Dictionary = {
	"silver_stair": {
		"props": [{"art": "mood_candles", "frames": 1, "count": 6, "scale": 1.0, "glow": Color(0.75, 0.85, 1.0, 0.5), "glow_r": 44.0,
			"glow_at": Vector2(0, -18), "flicker": 0.1, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) votive lights on the steps, pale blue
			{"sprite": "obstacles/host_pillar_m", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(0.7, 0.85, 1.0, 0.45), "glow_r": 52.0,
			"glow_at": Vector2(0, -30), "flicker": 0.05, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) pillars with a band of light
		"fog": 3,  # TUNING (not in GDD) cloud drifting over the stair
		"pools": 0,
	},
	"wheel_of_thrones": {
		"props": [{"sprite": "obstacles/host_crystal_m", "frames": 1, "count": 6, "scale": 1.0, "glow": Color(0.45, 0.7, 1.0, 0.55), "glow_r": 56.0,
			"glow_at": Vector2(0, -10), "flicker": 0.12, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) crystals of the turning spheres
		"fog": 0,
		"pools": 4,  # TUNING (not in GDD) pools of starlight
	},
	"empyrean": {
		"props": [{"sprite": "obstacles/host_petal_m", "frames": 1, "count": 7, "scale": 1.0, "glow": Color(0.95, 0.95, 1.0, 0.5), "glow_r": 48.0,
			"glow_at": Vector2(0, -8), "flicker": 0.08, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) petals of the white rose
			{"art": "mood_candles", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(0.8, 0.9, 1.0, 0.45), "glow_r": 40.0,
			"glow_at": Vector2(0, -18), "flicker": 0.1, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD)
		"fog": 2,  # TUNING (not in GDD) the silence of the rose
		"pools": 3,  # TUNING (not in GDD)
	},
}

## The Hallowed Light and Judgment (scripts/maps/rules/host/hallowed_light.gd;
## Necropathy's HallowedLight, Grace and Judgment). Numbers of the simulation
## first, then the look.
const RULE: Dictionary = {
	# Per map: the shafts' schedule. first / every (s between two new shafts), speed (px/s
	# a shaft sweeps), width (px at wave 1), widen (width x (1 + widen x (wave - 1))),
	# angles (degrees of each new shaft's sweep direction, cycled; 0 = left to right,
	# 180 = right to left, 90 = top to bottom), live (most shafts at once from wave
	# live_at[i]: index i + 1 shafts), choir (extra width share per live Choir Angel).
	"maps": {
		"silver_stair": {"first": 40.0, "every": 24.0, "speed": 30.0, "width": 80.0, "widen": 0.02, "angles": [0.0, 180.0],
			"live_at": [1, 9, 18], "choir": 0.0},  # TUNING (not in GDD) the Stair: each step a wider shaft
		"wheel_of_thrones": {"first": 10.0, "every": 22.0, "speed": 32.0, "width": 84.0, "widen": 0.022, "angles": [0.0, 90.0, 180.0, 270.0],
			"live_at": [1, 7, 15], "choir": 0.0},  # TUNING (not in GDD) the turning spheres: shafts from every side
		"empyrean": {"first": 8.0, "every": 20.0, "speed": 32.0, "width": 86.0, "widen": 0.022, "angles": [45.0, 225.0, 135.0, 315.0],
			"live_at": [1, 6, 14], "choir": 0.12},  # TUNING (not in GDD) the Choir: every live Choir Angel widens the Light
	},
	"warn": 3.0,  # TUNING (not in GDD) s a new shaft shows its telegraph (a thin line where it enters) before it burns
	"tick": 0.25,  # TUNING (not in GDD) s between two applications of the Light (haste, Grace, weakening)
	"haste": 1.3,  # TUNING (not in GDD) speed x of an angel inside a shaft
	"grace": 0.02,  # TUNING (not in GDD) share of its max HP an angel inside a shaft regains per s (Grace)
	"weaken": 0.7,  # TUNING (not in GDD) damage x of a tower inside a shaft and out of the shade
	"shade_towers": {"warder": 100.0, "bound_ophan": 80.0},  # TUNING (not in GDD) tower class -> px of shade it casts round its spot
	"cloud_drift": 26.0,  # TUNING (not in GDD) px a cloud bank drifts to either side of its place
	"cloud_period": 40.0,  # TUNING (not in GDD) s of one drift there and back
	# Judgment: the sins are the blocker bodies lost (not Risen, not walls); every
	# `per_judge` sins return as one Judge when the stage boss arrives (at most `boss_cap`),
	# and the bosses send more (Seraiel's Trial, the Voice's Last Word).
	"judgment": {"per_judge": 10, "boss_cap": 3, "gap": 3.0, "kind": "host_judge"},  # TUNING (not in GDD)
	# --- The look (drawing only) ---
	"shaft_tint": Color(0.85, 0.92, 1.0, 0.55),  # TUNING (not in GDD) additive white-cerulean light of a burning shaft
	"shaft_core": Color(1.0, 1.0, 1.0, 0.35),  # TUNING (not in GDD) its brighter centre line
	"warn_tint": Color(0.75, 0.88, 1.0, 0.8),  # TUNING (not in GDD) the telegraph line (pulses)
	"warn_band": 0.16,  # TUNING (not in GDD) alpha of the faint band under the telegraph line
	"path_tint": Color(0.75, 0.88, 1.0, 0.18),  # TUNING (not in GDD) the faint band showing where a burning shaft goes next
	"path_ahead": 90.0,  # TUNING (not in GDD) px of that band ahead of the shaft
	"cloud_tint": Color(0.1, 0.12, 0.22, 0.55),  # TUNING (not in GDD) a cloud bank's shadow on the floor
	"shade_tint": Color(0.12, 0.1, 0.25, 0.35),  # TUNING (not in GDD) the shade a Warder / Bound Ophan casts
	"lit_tint": Color(1.0, 0.98, 0.85, 0.7),  # TUNING (not in GDD) the white glare ring under a tower weakened by the Light
	"lit_r": 30.0,  # TUNING (not in GDD) px of that glare
	"shaded_tint": Color(0.55, 0.65, 1.0, 0.8),  # TUNING (not in GDD) the cool ring under a tower inside a shaft but saved by shade
	"dial_px": 34.0,  # TUNING (not in GDD) HUD scales icon size (px)
	"dial_margin": Vector2(10.0, 54.0),  # TUNING (not in GDD) px from the screen's left / top edges (under the top bar)
	"dial_color": Color(0.8, 0.88, 1.0),  # TUNING (not in GDD) the label: pale silver
	"dial_hot": Color(1.0, 0.6, 0.6),  # TUNING (not in GDD) the label once a Judge is due (sins >= per_judge)
}

## The act's looks (drawing only; read by its traits, bosses, spells and tower).
const LOOK: Dictionary = {
	"line_tint": Color(0.85, 0.92, 1.0, 0.5),  # TUNING (not in GDD) a telegraph line (lunge, sword)
	"line_w": 4.0,  # TUNING (not in GDD) px
	"cut_tint": Color(1.0, 1.0, 1.0, 1.0),  # TUNING (not in GDD) the bright cut
	"cut_w": 12.0,  # TUNING (not in GDD) px
	"cut_time": 0.35,  # TUNING (not in GDD) s the cut shows
	"line_over": 26.0,  # TUNING (not in GDD) px a line runs past both ends
	"sword_tint": Color(0.95, 0.97, 1.0, 0.9),  # TUNING (not in GDD) a flaming white sword's sweep ring
	"warn_tint": Color(0.75, 0.85, 1.0, 0.6),  # TUNING (not in GDD) a sweep's telegraph ring
	"trumpet_tint": Color(0.8, 0.9, 1.0, 0.9),  # TUNING (not in GDD) a trumpet blast ring
	"roll_tint": Color(0.6, 0.85, 1.0),  # TUNING (not in GDD) an Ophan's / the Throne's rolling burst
	"roll_d": 100.0,  # TUNING (not in GDD) px of that burst
	"core_tint": Color(0.55, 0.85, 1.0, 0.9),  # TUNING (not in GDD) the Throne's open Core glow
	"core_d": 80.0,  # TUNING (not in GDD) px of that glow
	"fear_tint": Color(1.0, 1.0, 1.0, 0.5),  # TUNING (not in GDD) Be Not Afraid's flash (an edge band, never full screen)
	"judge_tint": Color(0.9, 0.95, 1.0),  # TUNING (not in GDD) a Judge's descent pillar
	# --- The act spells and tower ---
	"sword_arc": 2.4,  # TUNING (not in GDD) radians of Flaming Sword's drawn arc
	"sword_time": 0.4,  # TUNING (not in GDD) s the sweep takes on screen
	"wheel_px": 30.0,  # TUNING (not in GDD) px of the Wheel of Eyes drawn
	"reveal_band": 26.0,  # TUNING (not in GDD) px of Revelation's white edge band
	"ophan_roll_w": 16.0,  # TUNING (not in GDD) px of the Bound Ophan's roll streak
}
