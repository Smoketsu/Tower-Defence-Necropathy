## Act V, the Shogunate of the Rising Sun (ActData "shogunate"; GDD §7.3;
## Necropathy's Act V: docs/act5/PROPOSAL.md, the stages province / kurogane /
## sun_road): its enemy kinds (KINDS, keys as TdEnemyData.KINDS), its build
## orders (ORDERS, keys as BuildOrderData.ORDERS), its three map moods (MOODS,
## keys as TdMoodData.MOODS) and the numbers of its act rule, the Sun's Course
## (RULE, read by scripts/maps/rules/shogunate/sun_course.gd). Every sprite is
## Necropathy's Act V art (assets/sprites/shogunate/, bosses/). Data only.
extends RefCounted

## Enemy kinds of the Shogunate (keys: TdEnemyData.KINDS). Traits live in
## scripts/enemies/traits/shogunate/ and scripts/bosses/shogunate/ (each script
## documents its args).
const KINDS: Dictionary = {
	# Spear levies in wide ranks (Necropathy "Ashigaru | Fodder").
	"ashigaru": {
		"name": "Ashigaru", "sprite": "shogunate/ashigaru", "rank": "fodder", "souls": 5,  # TUNING (not in GDD) Act V pays a step above Act I
		"hp": 72.0, "speed": 50.0, "armour": 1.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Katana duelist: the Draw, a first strike on the post that holds him (Necropathy "The Draw").
	"samurai": {
		"name": "Samurai", "sprite": "shogunate/samurai", "rank": "fodder", "souls": 10,  # TUNING (not in GDD) soldier tier
		"hp": 200.0, "speed": 42.0, "armour": 3.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 12.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shogunate/draw",
		"args": {"windup": 0.8, "damage": 55.0, "cooldown": 8.0},  # TUNING (not in GDD) Necropathy: the 0.8 s white line
	},
	# Arquebus line: a volley every 6 s, stopped by the first blocker on its line (Necropathy "Teppo Gunner").
	"teppo_gunner": {
		"name": "Teppo Gunner", "sprite": "shogunate/teppo_gunner", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) soldier tier
		"hp": 80.0, "speed": 44.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 5.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 190.0, "interval": 7.0, "target": "any", "damage": 18.0, "disable": 0.8, "cause": "shot", "speed": 560.0, "arc": false, "look": "teppo"},  # TUNING (not in GDD) Necropathy volley every 6 s
	},
	# From the Shadows: appears mid-road out of an ambush point at dusk and night, douses lanterns.
	"ninja": {
		"name": "Ninja", "sprite": "shogunate/ninja", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) soldier tier
		"hp": 95.0, "speed": 64.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 8.0, "attack_interval": 0.9,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shogunate/ninja",
		"args": {"douse_radius": 55.0},  # TUNING (not in GDD)
	},
	# Kunoichi: a ninja whose smoke bombs blind the towers around her.
	"kunoichi": {
		"name": "Kunoichi", "sprite": "shogunate/kunoichi", "rank": "elite",
		"hp": 300.0, "speed": 56.0, "armour": 1.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 12.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shogunate/kunoichi",
		"args": {"douse_radius": 80.0, "smoke_first": 2.0, "smoke_every": 8.0, "smoke_radius": 90.0, "blind": 2.0},  # TUNING (not in GDD) Necropathy "blind summons 2 s"
	},
	# Oni: iron kanabō, flat armour, every third blow smashes the post and stuns its bodies.
	"oni": {
		"name": "Oni", "sprite": "shogunate/oni", "rank": "elite",
		"hp": 620.0, "speed": 30.0, "armour": 6.0, "radius": 16.0,  # TUNING (not in GDD)
		"damage": 22.0, "attack_interval": 1.6,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shogunate/oni",
		"args": {"smash_every": 3, "smash_damage": 50.0, "stun": 1.6},  # TUNING (not in GDD)
	},
	# Onryō: a vengeful ghost that drifts through the blockers (a flyer: never held).
	"onryo": {
		"name": "Onryo", "sprite": "shogunate/onryo", "rank": "fodder", "souls": 5,  # TUNING (not in GDD)
		"hp": 62.0, "speed": 46.0, "armour": 0.0, "radius": 9.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": true, "trait": "", "args": {},
	},
	# Kappa: a river imp that grapples the body holding it (that body cannot strike for a while).
	"kappa": {
		"name": "Kappa", "sprite": "shogunate/kappa", "rank": "fodder", "souls": 6,  # TUNING (not in GDD)
		"hp": 110.0, "speed": 58.0, "armour": 0.0, "radius": 9.0,  # TUNING (not in GDD)
		"damage": 7.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shogunate/kappa",
		"args": {"grapple_every": 3, "grapple": 1.4},  # TUNING (not in GDD) Necropathy "grapples a summon briefly"
	},
	# Hatamoto: the banner guard; soldiers near him march faster (Act I banner_aura).
	"hatamoto": {
		"name": "Hatamoto", "sprite": "shogunate/hatamoto", "rank": "elite",
		"hp": 420.0, "speed": 40.0, "armour": 3.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 10.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "banner_aura",
		"args": {"radius": 100.0, "speed_mult": 1.25, "refresh": 0.25},  # TUNING (not in GDD)
	},
	# Kiba-musha: mounted samurai; a charge breaks free of the post and runs on.
	"kiba_musha": {
		"name": "Kiba-musha", "sprite": "shogunate/kiba_musha", "rank": "elite",
		"hp": 380.0, "speed": 54.0, "armour": 3.0, "radius": 15.0,  # TUNING (not in GDD)
		"damage": 16.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shogunate/cavalry",
		"args": {"charge_first": 3.0, "charge_every": 8.0, "charge_time": 1.3, "speed_mult": 2.0, "charge_damage": 35.0},  # TUNING (not in GDD)
	},
	# Kitsune: conjures fox-fire illusions of herself that soak the towers' shots.
	"kitsune": {
		"name": "Kitsune", "sprite": "shogunate/kitsune", "rank": "elite",
		"hp": 300.0, "speed": 42.0, "armour": 0.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shogunate/kitsune",
		"args": {"first": 3.0, "every": 9.0, "count": 2, "kind": "fox_fire", "gap": 28.0, "max": 4},  # TUNING (not in GDD) Necropathy decoy_count 2
	},
	# A fox-fire illusion: fades after a while, takes the shots meant for the real ones.
	"fox_fire": {
		"name": "Fox-fire Illusion", "sprite": "shogunate/kitsune", "rank": "fodder", "souls": 0,  # TUNING (not in GDD) an illusion pays nothing
		"hp": 70.0, "speed": 50.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 2.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shogunate/fox_fire",
		"args": {"life": 9.0},  # TUNING (not in GDD)
	},
	# Sōhei: warrior monk; the naginata strikes the post from reach (Act I halberd_reach).
	"sohei": {
		"name": "Sohei", "sprite": "shogunate/sohei", "rank": "elite",
		"hp": 300.0, "speed": 42.0, "armour": 2.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 16.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "halberd_reach",
		"args": {"reach": 60.0},  # TUNING (not in GDD)
	},
	# Province miniboss: Shuten-dōji, the Oni King: an oni's smash plus sake barrels lobbed at towers.
	"shuten_doji": {
		"name": "Shuten-doji, the Oni King", "sprite": "shogunate/shuten_doji", "rank": "miniboss",
		"hp": 2600.0, "speed": 24.0, "armour": 6.0, "radius": 26.0,  # TUNING (not in GDD)
		"damage": 24.0, "attack_interval": 1.6,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "shogunate/shuten",
		"args": {"smash_every": 3, "smash_damage": 60.0, "stun": 1.8,
			"throw_first": 4.0, "throw_every": 8.0, "throw_range": 280.0, "barrels": 2, "barrel_spread": 70.0,
			"barrel_radius": 60.0, "barrel_delay": 1.4, "barrel_disable": 1.5, "barrel_damage": 30.0},  # TUNING (not in GDD) Necropathy sake barrels
	},
	# Kurogane miniboss: the General of the Left, a cavalry charge that bowls through a post.
	"general_left": {
		"name": "The General of the Left", "sprite": "shogunate/general_left", "rank": "miniboss",
		"hp": 3800.0, "speed": 34.0, "armour": 5.0, "radius": 26.0,  # TUNING (not in GDD)
		"damage": 22.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "shogunate/cavalry",
		"args": {"charge_first": 3.0, "charge_every": 7.0, "charge_time": 1.5, "speed_mult": 2.2, "charge_damage": 70.0},  # TUNING (not in GDD)
	},
	# Road to the Sun miniboss: the Kirin, a holy beast of light that dazzles towers and wards its kin.
	"kirin": {
		"name": "The Kirin", "sprite": "shogunate/kirin", "rank": "miniboss",
		"hp": 4000.0, "speed": 36.0, "armour": 4.0, "radius": 24.0,  # TUNING (not in GDD)
		"damage": 22.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "shogunate/kirin",
		"args": {"first": 4.0, "every": 7.0, "radius": 140.0, "blind": 2.0, "ward": 0.7, "ward_radius": 110.0, "ward_time": 6.0},  # TUNING (not in GDD)
	},
	# Province boss: Kage, Mistress of the Hidden Hand: shadow clones, smoke fields; only light shows her true.
	"kage": {
		"name": "Kage, Mistress of the Hidden Hand", "sprite": "bosses/kage", "rank": "boss",
		"hp": 6000.0, "speed": 26.0, "armour": 3.0, "radius": 20.0,  # TUNING (not in GDD)
		"damage": 26.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "shogunate/kage",
		"args": {"split_first": 5.0, "split_every": 14.0, "split_every_p2": 9.0, "clones": 2, "clones_p2": 3,
			"clone_kind": "kage_clone", "clone_gap": 36.0, "hidden_mult": 0.5, "phase2_hp": 0.5,
			"smoke_first": 8.0, "smoke_every": 11.0, "smoke_radius": 110.0, "smoke_blind": 2.5, "pose_time": 0.6},  # TUNING (not in GDD)
	},
	# Kage's shadow clone: her very look; fades when she falls.
	"kage_clone": {
		"name": "Shadow of Kage", "sprite": "bosses/kage", "rank": "fodder", "souls": 0,  # TUNING (not in GDD) no bounty on a shadow
		"hp": 380.0, "speed": 34.0, "armour": 1.0, "radius": 18.0,  # TUNING (not in GDD)
		"damage": 12.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "", "args": {},
	},
	# Kurogane boss: Shogun Kurogane. His army is his health bar: he stands on his platform while his
	# regiments march; every one of them lost takes a point off him; under 10% he comes down to duel.
	"shogun": {
		"name": "Shogun Kurogane", "sprite": "bosses/shogun", "rank": "boss",
		"hp": 12000.0, "speed": 30.0, "armour": 5.0, "radius": 24.0,  # TUNING (not in GDD)
		"damage": 34.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "shogunate/shogun",
		"args": {"stand_dist": 110.0, "regiment_first": 2.0, "regiment_every": 10.0, "regiment_spacing": 0.8,
			"regiments": [["teppo_gunner", 7], ["ashigaru", 12], ["kiba_musha", 4], ["ninja", 6], ["samurai", 6], ["sohei", 5]],
			"hatamoto_kind": "hatamoto", "guard_mult": 0.1, "points_frac": 0.9, "duel_hp": 0.1,
			"cut_every": 3.0, "cut_every_min": 1.4, "cut_damage": 110.0, "cut_reach": 150.0, "triple_hp": 0.04, "pose_time": 0.7},  # TUNING (not in GDD) Necropathy: six regiments, duel under 10%
	},
	# Road to the Sun boss: Amaterasu. Her place in the sky is her phase: dawn (forced day, mirror beams),
	# noon (forced day, sun circles on the towers), sunset (the eclipse: forced night).
	"amaterasu": {
		"name": "Amaterasu, the Sun Goddess", "sprite": "bosses/amaterasu", "rank": "boss",
		"hp": 14500.0, "speed": 22.0, "armour": 4.0, "radius": 26.0,  # TUNING (not in GDD)
		"damage": 28.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "shogunate/amaterasu",
		"args": {"noon_hp": 0.66, "sunset_hp": 0.33,
			"beam_first": 3.0, "beam_every": 7.0, "beam_radius": 110.0, "beam_mult": 0.5, "beam_time": 4.0, "beam_ahead": 240.0,
			"shell_every": 6.0, "shell_count": 2, "shell_radius": 60.0, "shell_delay": 1.6, "shell_disable": 2.5, "pose_time": 0.8},  # TUNING (not in GDD)
	},
}

## Build orders of the Shogunate maps (keys: BuildOrderData.ORDERS): each map's
## default (must win on Necromancer) and weak order (must lose), and one kit
## order for every Act V map ("shogunate_kit": the Bound Oni on the posts and
## its Oni Lord, the act spells, Iron and Bone beside its Archers).
const ORDERS: Dictionary = {
	"province_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:8", "tower": "archer"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "plot:10", "tower": "archer"},
			{"do": "build", "spot": "plot:3", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "plot:11", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:11", "mode": "strongest"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "plot:4", "tower": "mage"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "build", "spot": "plot:7", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "post:1", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "build", "spot": "plot:12", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "plot:13", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:13", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "build", "spot": "plot:6", "tower": "mage"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "post:2"},
		],
	},
	"province_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:8", "tower": "archer"},
		],
	},
	"kurogane_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:7", "tower": "archer"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "plot:8", "tower": "archer"},
			{"do": "build", "spot": "plot:6", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:3", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:3", "mode": "strongest"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:15", "tower": "mage"},
			{"do": "build", "spot": "plot:10", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:5", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "build", "spot": "post:4", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:9", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:11", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:11", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:1", "tower": "mage"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "post:2"},
		],
	},
	"kurogane_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:7", "tower": "archer"},
		],
	},
	"sun_road_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "build", "spot": "plot:4", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:5", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:5", "mode": "strongest"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:12", "tower": "mage"},
			{"do": "build", "spot": "plot:13", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:8", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "build", "spot": "post:4", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:9", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "post:0"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:7", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:10", "tower": "mage"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "post:0"},
		],
	},
	"sun_road_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
		],
	},
	"shogunate_kit": {
		"spells": true,
		"loadout": ["hundred_shadows", "banner_of_the_dead", "black_sun"],
		"steps_by_map": {
			"province": [
				{"do": "build", "spot": "plot:8", "tower": "archer"},
				{"do": "build", "spot": "post:2", "tower": "bound_oni"},
				{"do": "build", "spot": "plot:10", "tower": "archer"},
				{"do": "build", "spot": "plot:3", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "build", "spot": "plot:11", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:11", "mode": "strongest"},
				{"do": "build", "spot": "post:3", "tower": "bound_oni"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "build", "spot": "plot:4", "tower": "mage"},
				{"do": "build", "spot": "plot:2", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "build", "spot": "plot:7", "tower": "banshee"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "post:1", "tower": "bound_oni"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "build", "spot": "plot:12", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "build", "spot": "plot:13", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:13", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "build", "spot": "plot:6", "tower": "mage"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "post:1"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "evolve", "spot": "post:2"},
				{"do": "evolve", "spot": "post:3"},
				{"do": "evolve", "spot": "post:1"},
			],
			"kurogane": [
				{"do": "build", "spot": "plot:7", "tower": "archer"},
				{"do": "build", "spot": "post:2", "tower": "bound_oni"},
				{"do": "build", "spot": "plot:8", "tower": "archer"},
				{"do": "build", "spot": "plot:6", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "plot:3", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:3", "mode": "strongest"},
				{"do": "build", "spot": "post:3", "tower": "bound_oni"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "plot:15", "tower": "mage"},
				{"do": "build", "spot": "plot:10", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:5", "tower": "banshee"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "build", "spot": "post:4", "tower": "bound_oni"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:9", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "plot:11", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:11", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:1", "tower": "mage"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "evolve", "spot": "post:2"},
				{"do": "evolve", "spot": "post:3"},
				{"do": "evolve", "spot": "post:4"},
			],
			"sun_road": [
				{"do": "build", "spot": "plot:1", "tower": "archer"},
				{"do": "build", "spot": "post:0", "tower": "bound_oni"},
				{"do": "build", "spot": "plot:2", "tower": "archer"},
				{"do": "build", "spot": "plot:4", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:5", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:5", "mode": "strongest"},
				{"do": "build", "spot": "post:2", "tower": "bound_oni"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:12", "tower": "mage"},
				{"do": "build", "spot": "plot:13", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:8", "tower": "banshee"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "build", "spot": "post:4", "tower": "bound_oni"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:9", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "post:0"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:7", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:10", "tower": "mage"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "post:0"},
				{"do": "evolve", "spot": "post:0"},
				{"do": "evolve", "spot": "post:2"},
				{"do": "evolve", "spot": "post:4"},
			],
		},
	},
}

## Battlefield moods of the three maps (keys: TdMoodData.MOODS).
const MOODS: Dictionary = {
	"province": {
		"props": [{"art": "mood_fire", "frames": 8, "count": 4, "scale": 1.0, "glow": Color(1.0, 0.5, 0.2, 0.65), "glow_r": 74.0,
			"glow_at": Vector2(0, -6), "flicker": 0.25, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) the burning village's fires
		"fog": 2,  # TUNING (not in GDD) smoke over the paddies
		"pools": 0,
	},
	"kurogane": {
		"props": [{"art": "mood_fire", "frames": 8, "count": 3, "scale": 1.0, "glow": Color(1.0, 0.6, 0.25, 0.55), "glow_r": 64.0,
			"glow_at": Vector2(0, -6), "flicker": 0.2, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) watch braziers
			{"sprite": "markers/rally_pennant", "frames": 1, "count": 5, "scale": 1.0, "glow": Color(0, 0, 0, 0), "glow_r": 0.0,
			"glow_at": Vector2.ZERO, "flicker": 0.0, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.14}],  # TUNING (not in GDD) the regiments' nobori
		"fog": 0,
		"pools": 0,
	},
	"sun_road": {
		"props": [{"art": "mood_candles", "frames": 1, "count": 6, "scale": 1.0, "glow": Color(1.0, 0.85, 0.5, 0.5), "glow_r": 40.0,
			"glow_at": Vector2(0, -18), "flicker": 0.15, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) pilgrims' votive candles
		"fog": 3,  # TUNING (not in GDD) clouds on the high road
		"pools": 0,
	},
}

## The Sun's Course (scripts/maps/rules/shogunate/sun_course.gd; GDD §7.3 "Day,
## dusk and night"). Numbers of the simulation first, then the look.
const RULE: Dictionary = {
	# Wave (1-based) at which dusk and night fall on each map (day before dusk).
	"phases": {
		"province": {"dusk": 9, "night": 15},  # TUNING (not in GDD) Necropathy: dusk at 13:00 left, night at 7:00 (of 20:00)
		"kurogane": {"dusk": 9, "night": 16},  # TUNING (not in GDD)
		"sun_road": {"dusk": 8, "night": 14},  # TUNING (not in GDD)
	},
	"dusk_sight": 0.85,  # TUNING (not in GDD) at dusk a tower sees this fraction of its range outside lantern light
	"night_sight": 0.0,  # TUNING (not in GDD) at night: none (GDD §7.3 "towers see only inside lantern light")
	"light_radius": 160.0,  # TUNING (not in GDD) px a lit stone lantern lights (towers target inside it at night)
	"relight_time": 16.0,  # TUNING (not in GDD) s a doused lantern stays dark before it rekindles by itself
	"relight_cost": 10,  # TUNING (not in GDD) souls to relight a doused lantern at once with a tap
	"bot_reserve": 100,  # TUNING (not in GDD) the autotest bot relights a lantern only with this many souls in hand
	"tap_radius": 28.0,  # TUNING (not in GDD) px around a lantern a tap picks it
	# --- The look (drawing only) ---
	"cell": 16.0,  # TUNING (not in GDD) map px per darkness texel (80 x 45 texels; bilinear between them)
	"dusk_dark": 0.24,  # TUNING (not in GDD) darkness alpha at dusk beyond the light pools
	"night_dark": 0.62,  # TUNING (not in GDD) darkness alpha at night beyond the light pools
	"dusk_tint": Color(0.35, 0.12, 0.05),  # TUNING (not in GDD) the orange dusk wash (colour of the darkness)
	"night_tint": Color(0.02, 0.02, 0.07),  # TUNING (not in GDD) indigo night
	"pool_soft": 0.35,  # TUNING (not in GDD) fraction of the light radius that fades from lit to dark at a pool's rim
	"glow": Color(1.0, 0.72, 0.38, 0.5),  # TUNING (not in GDD) additive warm glow on a lit lantern (alpha = strength)
	"glow_r": 70.0,  # TUNING (not in GDD) px of that glow
	"ring": Color(1.0, 0.8, 0.45, 0.35),  # TUNING (not in GDD) the light pool's real edge (range ring) at dusk and night
	"doused_tint": Color(0.55, 0.6, 0.8),  # TUNING (not in GDD) a doused lantern's sprite tint
	"dial_px": 46.0,  # TUNING (not in GDD) HUD sun dial size (px)
	"dial_margin": Vector2(10.0, 8.0),  # TUNING (not in GDD) px from the screen's left edge / below the top bar
	"sun_color": Color(1.0, 0.82, 0.3),  # TUNING (not in GDD) the dial's sun
	"dusk_color": Color(1.0, 0.45, 0.2),  # TUNING (not in GDD) the dial's setting sun
	"moon_color": Color(0.75, 0.82, 1.0),  # TUNING (not in GDD) the dial's moon
}

## The act's looks (drawing only; read by its traits, bosses and spells).
const LOOK: Dictionary = {
	"draw_tint": Color(1.0, 1.0, 1.0, 0.45),  # TUNING (not in GDD) the Draw's faint telegraph line
	"draw_w": 4.0,  # TUNING (not in GDD) px wide
	"cut_tint": Color(1.0, 1.0, 1.0, 1.0),  # TUNING (not in GDD) the cut's bright white line
	"cut_w": 12.0,  # TUNING (not in GDD) px wide
	"cut_time": 0.35,  # TUNING (not in GDD) s the cut line shows
	"draw_over": 30.0,  # TUNING (not in GDD) px the line runs past both ends
	"smoke_tint": Color(0.35, 0.33, 0.42, 0.85),  # TUNING (not in GDD) ninja smoke
	"smoke_puff": 72.0,  # TUNING (not in GDD) px of an ambush puff
	"smash_d": 120.0,  # TUNING (not in GDD) px of an oni smash burst
	"smash_shake": 3.0,  # TUNING (not in GDD) px
	"stun_d": 36.0,  # TUNING (not in GDD) px of the stun mark over a smashed post
	"stun_tint": Color(1.0, 0.9, 0.4, 0.8),  # TUNING (not in GDD) stunned (HostileData "stunned" colour)
	"grapple_d": 44.0,  # TUNING (not in GDD) px of the kappa's grapple splash
	"grapple_tint": Color(0.4, 0.85, 0.65, 0.7),  # TUNING (not in GDD) river green
	"charge_d": 110.0,  # TUNING (not in GDD) px of a cavalry charge's burst
	"fox_tint": Color(1.0, 0.55, 0.2),  # TUNING (not in GDD) fox-fire orange
	"sun_zone": Color(1.0, 0.8, 0.35, 0.6),  # TUNING (not in GDD) Amaterasu's sun zone
	# --- The act spells ---
	"clone_gap": 22.0,  # TUNING (not in GDD) px between Hundred Shadows clones across the road
	"clone_tint": Color(0.45, 0.3, 0.75, 0.85),  # TUNING (not in GDD) a shadow clone's violet-black tint
	"banner_lift": 34.0,  # TUNING (not in GDD) px the Banner of the Dead stands above its point
	"banner_scale": 2.2,  # TUNING (not in GDD) its drawn size x the pennant art
	"beam_w": 14.0,  # TUNING (not in GDD) px of a Black Sun beam
	"black_sun_d": 44.0,  # TUNING (not in GDD) px radius of the Black Sun's corona
}

