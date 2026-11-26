## Act VIII, the Olympian Republic (ActData "pantheon"; GDD §7.3 "Phalanx";
## Necropathy's Act IV, built under that number: docs/act4/PROPOSAL.md, the
## stages ilion / olympus / underworld): its enemy kinds (KINDS, keys as
## TdEnemyData.KINDS), its build orders (ORDERS, keys as
## BuildOrderData.ORDERS), its three map moods (MOODS, keys as
## TdMoodData.MOODS), the numbers of its act rule (RULE: the Wrath of the Gods,
## the HUD meter; read by scripts/maps/rules/pantheon/pantheon_rules.gd) and its
## looks (LOOK, drawing only). Every sprite is Necropathy's Act IV art
## (assets/sprites/pantheon/, bosses/). Data only.
extends RefCounted

## Hit sources the shield fronts never stop (undirected: from above). Shared by
## every phalanx kind's "ignore" (scripts/enemies/traits/pantheon/phalanx.gd).
const FROM_ABOVE: Array = ["corpse_catapult", "wrath", "stolen_thunder"]  # TUNING (not in GDD) Necropathy: arcing hits from above go around the shield

## Enemy kinds of the Olympian Republic (keys: TdEnemyData.KINDS). Traits live
## in scripts/enemies/traits/pantheon/ and scripts/bosses/pantheon/ (each
## script documents its args).
const KINDS: Dictionary = {
	# Shade of the Dead: a hooded ghost of Troy's dead drifting over the road (a flyer: never held).
	"shade_of_dead": {
		"name": "Shade of the Dead", "sprite": "pantheon/shade_of_dead", "rank": "fodder", "souls": 5,  # TUNING (not in GDD) X2
		"hp": 70.0, "speed": 48.0, "armour": 0.0, "radius": 9.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": true, "trait": "", "args": {},
	},
	# Wolf of Rome: bronze wolves running in packs, fast to the posts.
	"wolf_of_rome": {
		"name": "Wolf of Rome", "sprite": "pantheon/wolf_of_rome", "rank": "fodder", "souls": 5,  # TUNING (not in GDD) X2
		"hp": 90.0, "speed": 72.0, "armour": 0.0, "radius": 9.0,  # TUNING (not in GDD) Necropathy "fast lunges"
		"damage": 7.0, "attack_interval": 0.9,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Moon Hound: Artemis's lean hounds on Olympus.
	"moon_hound": {
		"name": "Moon Hound", "sprite": "pantheon/moon_hound", "rank": "fodder", "souls": 5,  # TUNING (not in GDD) X2
		"hp": 80.0, "speed": 76.0, "armour": 0.0, "radius": 8.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 0.9,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Hoplite: the Phalanx: its shield front takes a fraction of every hit from ahead.
	"hoplite": {
		"name": "Hoplite", "sprite": "pantheon/hoplite", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) soldier tier
		"hp": 170.0, "speed": 40.0, "armour": 2.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 10.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "pantheon/phalanx",
		"args": {"front_mult": 0.35, "front_cos": 0.35, "ignore": FROM_ABOVE, "roof_mult": 1.0, "roof_n": 0, "roof_radius": 0.0},  # TUNING (not in GDD) GDD §7.3 "heavily reduced damage from the front"
	},
	# Legionary: the Phalanx plus the testudo: two shield mates near and it roofs its line against hits from above.
	"legionary": {
		"name": "Legionary", "sprite": "pantheon/legionary", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) soldier tier
		"hp": 180.0, "speed": 38.0, "armour": 3.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 11.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "pantheon/phalanx",
		"args": {"front_mult": 0.35, "front_cos": 0.35, "ignore": FROM_ABOVE, "roof_mult": 0.55, "roof_n": 2, "roof_radius": 56.0},  # TUNING (not in GDD) Necropathy "locks the testudo against arrows and volleys from above"
	},
	# Shade Hoplite: a hoplite of the dead in the Underworld, pale and quicker (the Hoplite's look, tinted).
	"shade_hoplite": {
		"name": "Shade Hoplite", "sprite": "pantheon/hoplite", "rank": "fodder", "souls": 7, "tint": Color(0.6, 0.8, 1.0, 0.85),  # TUNING (not in GDD) a ghost's pale tint
		"hp": 150.0, "speed": 44.0, "armour": 1.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 9.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "pantheon/phalanx",
		"args": {"front_mult": 0.4, "front_cos": 0.35, "ignore": FROM_ABOVE, "roof_mult": 1.0, "roof_n": 0, "roof_radius": 0.0},  # TUNING (not in GDD)
	},
	# Centaur Archer: fires while it gallops (straight arrows, stopped by the first blocker on their line).
	"centaur_archer": {
		"name": "Centaur Archer", "sprite": "pantheon/centaur_archer", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) soldier tier
		"hp": 150.0, "speed": 52.0, "armour": 1.0, "radius": 13.0,  # TUNING (not in GDD)
		"damage": 7.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 190.0, "interval": 8.0, "target": "any", "damage": 16.0, "disable": 0.6, "cause": "shot", "speed": 520.0, "arc": false, "look": "arrow"},  # TUNING (not in GDD) Necropathy "fires while galloping"
	},
	# Shade Archer: the archers of Troy's dead (the Underworld's ranged kind).
	"shade_archer": {
		"name": "Shade Archer", "sprite": "pantheon/shade_archer", "rank": "fodder", "souls": 6,  # TUNING (not in GDD)
		"hp": 95.0, "speed": 46.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 200.0, "interval": 6.5, "target": "body", "damage": 14.0, "disable": 0.7, "cause": "shot", "speed": 480.0, "arc": false, "look": "ghost_arrow"},  # TUNING (not in GDD)
	},
	# Hero: a demigod; Glory: every blocker body it fells makes it bigger and harder.
	"pan_hero": {
		"name": "Hero", "sprite": "pantheon/hero", "rank": "elite",
		"hp": 540.0, "speed": 40.0, "armour": 3.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 18.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "pantheon/hero",
		"args": {"hp_gain": 0.2, "armour_gain": 1.0, "max_stacks": 5},  # TUNING (not in GDD) Necropathy Glory stacks
	},
	# Cyclops: throws boulders at the towers (telegraphed landing circles); flat armour.
	"cyclops": {
		"name": "Cyclops", "sprite": "pantheon/cyclops", "rank": "elite",
		"hp": 720.0, "speed": 28.0, "armour": 5.0, "radius": 16.0,  # TUNING (not in GDD)
		"damage": 22.0, "attack_interval": 1.5,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "pantheon/cyclops",
		"args": {"throw_first": 3.0, "throw_every": 9.0, "throw_range": 240.0, "boulders": 1, "radius": 50.0, "delay": 1.4,
			"disable": 1.6, "body_damage": 30.0, "rage_hp": 0.0, "rage_mult": 1.0},  # TUNING (not in GDD) Necropathy "boulders with a landing circle"
	},
	# Amazon: leaps over the first post in her way; a heavy blocker catches her.
	"amazon": {
		"name": "Amazon", "sprite": "pantheon/amazon", "rank": "elite",
		"hp": 440.0, "speed": 50.0, "armour": 2.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 16.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "pantheon/amazon",
		"args": {"leap_first": 1.0, "leap_every": 10.0, "leap_time": 1.0, "leap_reach": 50.0, "leap_speed": 2.2, "catch_hp": 400.0},  # TUNING (not in GDD) Necropathy "Warriors, the Golem catch her"
	},
	# Gorgon: her gaze flies at a tower and turns it to stone; a blocker on its line stops it.
	"gorgon": {
		"name": "Gorgon", "sprite": "pantheon/gorgon", "rank": "elite",
		"hp": 400.0, "speed": 36.0, "armour": 1.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 10.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "pantheon/gorgon",
		"args": {"gaze_first": 3.0, "gaze_every": 11.0, "gaze_range": 210.0, "petrify": 2.5, "body_damage": 20.0, "speed": 420.0},  # TUNING (not in GDD) Necropathy "turn to stone for 3 s"
	},
	# Bronze Titan: the Twilight of the Gods' colossus; flat armour, stomps the whole post.
	"bronze_titan": {
		"name": "Bronze Titan", "sprite": "pantheon/bronze_titan", "rank": "elite",
		"hp": 1150.0, "speed": 24.0, "armour": 8.0, "radius": 20.0,  # TUNING (not in GDD)
		"damage": 28.0, "attack_interval": 1.6,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "pantheon/titan",
		"args": {"stomp_every": 3, "stomp_damage": 45.0, "stun": 1.4},  # TUNING (not in GDD)
	},
	# Achilles' Myrmidon guard: hoplites he calls into a shield wall (no bounty: his own summons).
	"myrmidon_guard": {
		"name": "Myrmidon of Achilles", "sprite": "pantheon/hoplite", "rank": "fodder", "souls": 0,  # TUNING (not in GDD) a boss's summons pay nothing
		"hp": 260.0, "speed": 40.0, "armour": 3.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 12.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "pantheon/phalanx",
		"args": {"front_mult": 0.3, "front_cos": 0.35, "ignore": FROM_ABOVE, "roof_mult": 1.0, "roof_n": 0, "roof_radius": 0.0},  # TUNING (not in GDD)
	},
	# A blocker Hades claimed: it rises where it fell as his shade (no bounty).
	"claimed_shade": {
		"name": "Claimed Shade", "sprite": "pantheon/shade_of_dead", "rank": "fodder", "souls": 0, "tint": Color(0.55, 1.0, 0.8, 0.9),  # TUNING (not in GDD) soul-teal: one of yours, stolen
		"hp": 160.0, "speed": 46.0, "armour": 0.0, "radius": 9.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Tartarus Warden: Hades' ring of the dead (a dark shield bearer; no bounty).
	"tartarus_warden": {
		"name": "Tartarus Warden", "sprite": "pantheon/legionary", "rank": "fodder", "souls": 0, "tint": Color(0.5, 0.45, 0.7),  # TUNING (not in GDD) Tartarus dark
		"hp": 650.0, "speed": 30.0, "armour": 4.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 14.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "pantheon/phalanx",
		"args": {"front_mult": 0.35, "front_cos": 0.35, "ignore": FROM_ABOVE, "roof_mult": 1.0, "roof_n": 0, "roof_radius": 0.0},  # TUNING (not in GDD)
	},
	# --- Minibosses (row HP is their real HP, X3) ---
	# Ilion: Polyphemus the Cyclops: boulder volleys at three towers, faster in his rage.
	"polyphemus": {
		"name": "Polyphemus the Cyclops", "sprite": "pantheon/polyphemus", "rank": "miniboss",
		"hp": 4500.0, "speed": 22.0, "armour": 6.0, "radius": 26.0,  # TUNING (not in GDD) X3 4000-6000
		"damage": 26.0, "attack_interval": 1.6,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "pantheon/cyclops",
		"args": {"throw_first": 3.0, "throw_every": 10.0, "throw_range": 300.0, "boulders": 2, "radius": 60.0, "delay": 1.5,
			"disable": 2.0, "body_damage": 45.0, "rage_hp": 0.5, "rage_mult": 0.6},  # TUNING (not in GDD) Necropathy boulder volley
	},
	# Olympus: Ares, God of War: the war-cry hastes and wards the column; his spear charges through posts.
	"ares": {
		"name": "Ares, God of War", "sprite": "pantheon/ares", "rank": "miniboss",
		"hp": 4000.0, "speed": 26.0, "armour": 5.0, "radius": 24.0,  # TUNING (not in GDD) X3; a charger, held less
		"damage": 26.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "pantheon/ares",
		"args": {"cry_first": 3.0, "cry_every": 10.0, "cry_radius": 170.0, "cry_speed": 1.3, "cry_ward": 0.8, "cry_time": 5.0,
			"charge_first": 3.0, "charge_every": 8.0, "charge_time": 1.2, "charge_speed": 2.0, "charge_damage": 60.0, "charges": 1},  # TUNING (not in GDD) Necropathy "dies to blockers"
	},
	# Underworld: Cerberus: three bites a blow, fire breath on as many towers as he has heads.
	"cerberus": {
		"name": "Cerberus, Hound of the Gates", "sprite": "pantheon/cerberus", "rank": "miniboss",
		"hp": 3800.0, "speed": 26.0, "armour": 4.0, "radius": 24.0,  # TUNING (not in GDD) X3: his three bites break posts fast, so less HP
		"damage": 16.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "pantheon/cerberus",
		"args": {"breath_first": 4.0, "breath_every": 9.0, "breath_range": 260.0, "breath_radius": 55.0, "breath_delay": 1.3,
			"breath_disable": 2.0, "breath_damage": 30.0},  # TUNING (not in GDD) Necropathy "three heads, three attacks"
	},
	# --- Bosses ---
	# Ilion: Achilles, the Unkillable: his front takes almost nothing, his heel everything.
	"achilles": {
		"name": "Achilles, the Unkillable", "sprite": "bosses/achilles", "rank": "boss",
		"hp": 7000.0, "speed": 26.0, "armour": 4.0, "radius": 22.0,  # TUNING (not in GDD)
		"damage": 34.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "pantheon/achilles",
		"args": {"front_mult": 0.2, "front_cos": 0.35, "ignore": FROM_ABOVE, "roof_mult": 1.0, "roof_n": 0, "roof_radius": 0.0,
			"heel_mult": 1.3, "stagger": 1.0, "stagger_cd": 6.0, "guard_hp": 0.66, "rage_hp": 0.33,
			"lunge_first": 4.0, "lunge_every": 10.0, "rage_lunge_every": 6.0, "lunge_time": 1.0, "lunge_speed": 2.2, "lunge_damage": 70.0,
			"guard_every": 16.0, "guard_count": 3, "guard_max": 5, "guard_kind": "myrmidon_guard", "guard_ahead": 70.0, "guard_gap": 16.0,
			"rage_front_mult": 0.5, "rage_speed": 1.4},  # TUNING (not in GDD) Necropathy: front 10%, the heel full and a stagger
	},
	# Olympus: Zeus, King of the Gods: storms on the towers, the thunderbolt down the road, his true form.
	"zeus": {
		"name": "Zeus, King of the Gods", "sprite": "bosses/zeus", "rank": "boss",
		"hp": 13000.0, "speed": 22.0, "armour": 4.0, "radius": 26.0,  # TUNING (not in GDD)
		"damage": 34.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "pantheon/zeus",
		"args": {"throne_hp": 0.6, "form_hp": 0.3, "storm_first": 3.0, "storm_every": 10.0, "storm_count": 1, "storm_extra": 1, "throne_mult": 0.75,
			"bolt_radius": 55.0, "bolt_delay": 1.3, "bolt_disable": 1.6, "bolt_damage": 40.0,
			"beam_every": 13.0, "beam_count": 5, "beam_gap": 60.0,
			"form_armour": 4.0, "form_speed": 0.8, "stomp_every": 6.0, "stomp_radius": 110.0, "stomp_delay": 1.2, "stomp_damage": 60.0, "pose_time": 0.8},  # TUNING (not in GDD)
	},
	# Underworld: Hades, Lord of the Dead: the Helm of Darkness, the Reclaiming, his ring of wardens.
	"hades": {
		"name": "Hades, Lord of the Dead", "sprite": "bosses/hades", "rank": "boss",
		"hp": 9000.0, "speed": 22.0, "armour": 4.0, "radius": 24.0,  # TUNING (not in GDD)
		"damage": 32.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "pantheon/hades",
		"args": {"reclaim_hp": 0.66, "lord_hp": 0.33, "cloak_first": 4.0, "cloak_every": 13.0, "cloak_time": 2.5, "claim_kind": "claimed_shade",
			"ring_kind": "tartarus_warden", "ring_count": 3, "ring_every": 14.0, "ring_hold": 2, "ring_mult": 0.6, "ring_refresh": 0.3,
			"ring_back": 60.0, "ring_ahead": 90.0, "ring_gap": 18.0,
			"fissure_every": 10.0, "fissure_ahead": 120.0, "fissure_count": 3, "fissure_gap": 40.0, "fissure_radius": 40.0, "fissure_delay": 1.4,
			"fissure_disable": 2.0, "fissure_damage": 50.0, "pose_time": 0.7},  # TUNING (not in GDD) Necropathy: three phases, claims, the ring of the dead
	},
}

## Build orders of the Olympian maps (keys: BuildOrderData.ORDERS): each map's
## default (must win on Necromancer) and weak order (must lose), and one kit
## order for every Act VIII map ("pantheon_kit": Myrmidon Shades on the posts
## and their Legion of Tartarus, the three act spells).
const ORDERS: Dictionary = {
	"ilion_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:6", "tower": "archer"},
			{"do": "build", "spot": "post:4", "tower": "warrior"},
			{"do": "build", "spot": "plot:10", "tower": "archer"},
			{"do": "build", "spot": "plot:5", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:7", "mode": "strongest"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "plot:11", "tower": "mage"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:9", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "build", "spot": "post:3", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:12", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "plot:3", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:3", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:8", "tower": "mage"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "post:4"},
		],
	},
	"ilion_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:6", "tower": "archer"},
		],
	},
	"olympus_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "plot:5", "tower": "archer"},
			{"do": "build", "spot": "plot:2", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:6", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:6", "mode": "strongest"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:0", "tower": "mage"},
			{"do": "build", "spot": "plot:7", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:4", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "build", "spot": "post:4", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:3", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:8", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:8", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:13", "tower": "mage"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "post:2"},
		],
	},
	"olympus_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
		],
	},
	"underworld_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:7", "tower": "archer"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "build", "spot": "plot:5", "tower": "archer"},
			{"do": "build", "spot": "plot:11", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:4", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:4", "mode": "strongest"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:10", "tower": "mage"},
			{"do": "build", "spot": "plot:0", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "plot:3", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "post:0", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "plot:15", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:1", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:1", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "plot:2", "tower": "mage"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "post:0"},
			{"do": "upgrade", "spot": "post:3"},
		],
	},
	"underworld_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:7", "tower": "archer"},
		],
	},
	"pantheon_kit": {
		"spells": true,
		"loadout": ["paris_arrow", "stolen_thunder", "river_styx"],
		"steps_by_map": {
			"ilion": [
				{"do": "build", "spot": "plot:6", "tower": "archer"},
				{"do": "build", "spot": "post:4", "tower": "myrmidon_shade"},
				{"do": "build", "spot": "plot:10", "tower": "archer"},
				{"do": "build", "spot": "plot:5", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:7", "mode": "strongest"},
				{"do": "build", "spot": "post:2", "tower": "myrmidon_shade"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "evolve", "spot": "post:4"},
				{"do": "evolve", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "build", "spot": "plot:11", "tower": "mage"},
				{"do": "build", "spot": "plot:2", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:9", "tower": "banshee"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "build", "spot": "post:3", "tower": "abomination"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:12", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "build", "spot": "plot:3", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:3", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:8", "tower": "mage"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:4"},
			],
			"olympus": [
				{"do": "build", "spot": "plot:1", "tower": "archer"},
				{"do": "build", "spot": "post:2", "tower": "myrmidon_shade"},
				{"do": "build", "spot": "plot:5", "tower": "archer"},
				{"do": "build", "spot": "plot:2", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:6", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:6", "mode": "strongest"},
				{"do": "build", "spot": "post:3", "tower": "myrmidon_shade"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "evolve", "spot": "post:2"},
				{"do": "evolve", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:0", "tower": "mage"},
				{"do": "build", "spot": "plot:7", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "plot:4", "tower": "banshee"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "build", "spot": "post:4", "tower": "abomination"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "plot:3", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:8", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:8", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "plot:13", "tower": "mage"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "post:2"},
			],
			"underworld": [
				{"do": "build", "spot": "plot:7", "tower": "archer"},
				{"do": "build", "spot": "post:3", "tower": "myrmidon_shade"},
				{"do": "build", "spot": "plot:5", "tower": "archer"},
				{"do": "build", "spot": "plot:11", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:4", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:4", "mode": "strongest"},
				{"do": "build", "spot": "post:2", "tower": "myrmidon_shade"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "evolve", "spot": "post:3"},
				{"do": "evolve", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:10", "tower": "mage"},
				{"do": "build", "spot": "plot:0", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "plot:3", "tower": "banshee"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "build", "spot": "post:0", "tower": "abomination"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "plot:15", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:1", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:1", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "plot:2", "tower": "mage"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "post:0"},
				{"do": "upgrade", "spot": "post:3"},
			],
		},
	},
}

## Battlefield moods of the three maps (keys: TdMoodData.MOODS).
const MOODS: Dictionary = {
	"ilion": {
		"props": [{"sprite": "obstacles/bronze_brazier_s", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(1.0, 0.6, 0.25, 0.6), "glow_r": 70.0,
			"glow_at": Vector2(0, -10), "flicker": 0.25, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) the Achaean camp's braziers
		"fog": 2,  # TUNING (not in GDD) sea mist off the beach
		"pools": 0,
	},
	"olympus": {
		"props": [{"art": "mood_candles", "frames": 1, "count": 5, "scale": 1.0, "glow": Color(1.0, 0.9, 0.6, 0.5), "glow_r": 44.0,
			"glow_at": Vector2(0, -18), "flicker": 0.15, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) votive candles of the temples
			{"sprite": "obstacles/bronze_brazier_s", "frames": 1, "count": 2, "scale": 1.0, "glow": Color(0.75, 0.85, 1.0, 0.5), "glow_r": 64.0,
			"glow_at": Vector2(0, -10), "flicker": 0.3, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) storm-lit braziers of the summit
		"fog": 3,  # TUNING (not in GDD) clouds over the mountain
		"pools": 0,
	},
	"underworld": {
		"props": [{"sprite": "obstacles/soul_brazier_s", "frames": 1, "count": 5, "scale": 1.0, "glow": Color(0.35, 0.9, 1.0, 0.6), "glow_r": 72.0,
			"glow_at": Vector2(0, -10), "flicker": 0.3, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) the Underworld's blue soul fires
		"fog": 2,  # TUNING (not in GDD) the mist of the Styx
		"pools": 0,
	},
}

## The act rule's numbers (scripts/maps/rules/pantheon/pantheon_rules.gd; GDD
## §7.3 and Necropathy's Wrath of the Gods: Poseidon's waves on Ilion, Zeus's
## lightning on Olympus, Hades' fissures in the Underworld).
const RULE: Dictionary = {
	# Map id -> its wrath row. Keys: kind ("wave" | "lightning" | "fissure"),
	# name (HUD), icon (icons/<id>, HUD), banner (the first strike's line),
	# sound (Sfx id on landing), from_wave (1-based wave the god first stirs),
	# first (s after that wave starts to the first strike), every (s between
	# strikes), count (circles a strike), gap (px between circles), radius (px),
	# delay (s from telegraph to landing), disable (s a tower inside is
	# stopped), cause (HostileData.CAUSE_TINT key), body_damage (to each blocker
	# body inside), enemy_damage (to each foe inside), boss_mult (x on bosses /
	# minibosses), road_from / road_to (0..1 of a road's length a wave or fissure
	# may fall on).
	"wrath": {
		"ilion": {"kind": "wave", "name": "Poseidon's Wave", "icon": "lethes_flood",
			"banner": "Wrath of the Gods: Poseidon's wave breaks over the shore, on both armies!", "sound": "wrath_wave",
			"from_wave": 4, "first": 8.0, "every": 24.0, "count": 4, "gap": 52.0, "radius": 44.0, "delay": 2.0,
			"disable": 2.5, "cause": "shelled", "body_damage": 35.0, "enemy_damage": 70.0, "boss_mult": 0.25,
			"road_from": 0.15, "road_to": 0.85},  # TUNING (not in GDD) Necropathy: a wave every few minutes
		"olympus": {"kind": "lightning", "name": "Zeus' Lightning", "icon": "stolen_thunder",
			"banner": "Wrath of the Gods: Zeus hurls lightning at towers and soldiers alike!", "sound": "wrath_thunder",
			"from_wave": 3, "first": 6.0, "every": 20.0, "count": 4, "gap": 0.0, "radius": 40.0, "delay": 1.6,
			"disable": 1.5, "cause": "stunned", "body_damage": 30.0, "enemy_damage": 80.0, "boss_mult": 0.25,
			"road_from": 0.0, "road_to": 1.0},  # TUNING (not in GDD)
		"underworld": {"kind": "fissure", "name": "Hades' Fissures", "icon": "gigantomachy",
			"banner": "Wrath of the Gods: the earth splits open under both armies!", "sound": "wrath_fissure",
			"from_wave": 3, "first": 8.0, "every": 20.0, "count": 4, "gap": 44.0, "radius": 40.0, "delay": 1.8,
			"disable": 2.5, "cause": "shelled", "body_damage": 40.0, "enemy_damage": 80.0, "boss_mult": 0.25,
			"road_from": 0.2, "road_to": 0.8},  # TUNING (not in GDD)
	},
	"origin_min": 6.0,  # TUNING (not in GDD) px: a hit origin closer than this to the struck body is its own spot (direct shots): the facing test reads the tower's spot instead
	# --- The HUD meter (drawing only) ---
	"meter_pos": Vector2(8, 6),  # TUNING (not in GDD) px under the HUD's top bar, left edge (the maps keep that corner free)
	"meter_icon_px": 24.0,  # TUNING (not in GDD) px of the god's icon
	"meter_warn": 3.0,  # TUNING (not in GDD) s before a strike the countdown turns hot
	"meter_hot": Color(1.0, 0.45, 0.3),  # TUNING (not in GDD) countdown colour when a strike is close or in the air
	"meter_cold": Color(0.95, 0.85, 0.55),  # TUNING (not in GDD) countdown colour otherwise (bronze gold)
}

## The act's looks (drawing only; read by its traits, bosses, rule and layer).
const LOOK: Dictionary = {
	# Phalanx shields.
	"arc_tint": Color(1.0, 1.0, 1.0, 0.95),  # TUNING (not in GDD) shield arc modulate (the art is bronze)
	"arc_scale": 1.0,  # TUNING (not in GDD) shield arc drawn size x its art (12 x 30)
	"arc_boss_scale": 1.6,  # TUNING (not in GDD) Achilles' bigger shield
	"arc_gap": 3.0,  # TUNING (not in GDD) px between the body's edge and its shield
	"arc_lift": 10.0,  # TUNING (not in GDD) px the shield stands above the feet (at chest height)
	"spark_every": 0.25,  # TUNING (not in GDD) s between two deflect sparks on one body
	"spark_d": 34.0,  # TUNING (not in GDD) px of a deflect spark
	"spark_tint": Color(1.0, 0.82, 0.45),  # TUNING (not in GDD) bronze-gold spark
	# Glory.
	"glory_r": 20.0,  # TUNING (not in GDD) px of a Hero's aura at one stack
	"glory_grow": 0.25,  # TUNING (not in GDD) aura radius +x per stack
	"glory_alpha": 0.55,  # TUNING (not in GDD) aura strength
	"glory_tint": Color(1.0, 0.8, 0.3),  # TUNING (not in GDD) gold
	"glory_burst": 70.0,  # TUNING (not in GDD) px of the burst when a stack is won
	# Kinds and bosses.
	"leap_d": 80.0,  # TUNING (not in GDD) px of an Amazon's leap burst
	"leap_tint": Color(1.0, 0.85, 0.6),  # TUNING (not in GDD)
	"stomp_d": 120.0,  # TUNING (not in GDD) px of a Titan's stomp burst
	"stomp_tint": Color(1.0, 0.75, 0.45),  # TUNING (not in GDD) bronze dust
	"stomp_shake": 3.0,  # TUNING (not in GDD) px
	"rise_d": 96.0,  # TUNING (not in GDD) px of a rising burst (Titan, guards, wardens)
	"cry_tint": Color(1.0, 0.3, 0.25, 0.9),  # TUNING (not in GDD) Ares' war-cry ring
	"ring_start": 20.0,  # TUNING (not in GDD) px a war-cry ring starts from
	"charge_d": 110.0,  # TUNING (not in GDD) px of a charge / lunge burst
	"head_d": 90.0,  # TUNING (not in GDD) px of the burst when a head of Cerberus falls
	"heel_d": 70.0,  # TUNING (not in GDD) px of the gold burst when Achilles' heel is struck
	"form_d": 220.0,  # TUNING (not in GDD) px of Zeus's true-form burst
	"cloak_d": 110.0,  # TUNING (not in GDD) px of Hades' cloak puff
	"cloak_alpha": 0.25,  # TUNING (not in GDD) Hades' drawn alpha while cloaked
	"bolt_d": 90.0,  # TUNING (not in GDD) px of a lightning bolt's strip
	"bolt_lift": 20.0,  # TUNING (not in GDD) px a bolt strip stands above its circle
	"bolt_tint": Color(0.85, 0.9, 1.0),  # TUNING (not in GDD) white-blue lightning
	# Wrath landings (on top of the hostile shell's own burst).
	"wrath_anim_mult": 2.4,  # TUNING (not in GDD) landing strip diameter x the circle radius
	"wrath_anim": {"wave": "tide_splash", "lightning": "soul_lightning", "fissure": "golem_slam"},  # TUNING (not in GDD) effect strip per kind
	"wrath_tint": {"wave": Color(0.55, 0.85, 1.0), "lightning": Color(0.9, 0.92, 1.0), "fissure": Color(1.0, 0.5, 0.3)},  # TUNING (not in GDD)
}
