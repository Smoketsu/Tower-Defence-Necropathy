## Act XII, the Electronic Empire (ActData "empire"; GDD §7.3 "Line of Fire:
## ranged enemies shoot towers; blockers and Bone Walls stop the shots";
## Necropathy's Act III, docs/act3/, the stages wastes / assembly / citadel):
## its enemy kinds (KINDS, keys as TdEnemyData.KINDS), its build orders
## (ORDERS, keys as BuildOrderData.ORDERS), its three map moods (MOODS, keys as
## TdMoodData.MOODS), the numbers of its act rule, the Line of Fire and the
## Lock-On (RULE, read by scripts/maps/rules/empire/line_of_fire.gd) and the
## act's looks (LOOK). Every sprite is Necropathy's Empire art
## (assets/sprites/empire/, bosses/, summons/, player/). The Empire's colours:
## chrome, gunmetal and signal amber, with red for a painted target. The ids
## carry an "empire_" prefix (unique across acts). Data only.
extends RefCounted

## Enemy kinds of the Electronic Empire (keys: TdEnemyData.KINDS). Traits live
## in scripts/enemies/traits/empire/ and scripts/bosses/empire/ (each script
## documents its args); empire/rifle.gd (marching fire at the nearest tower)
## arms the riflemen and drones. About 60% of the roster shoots towers (GDD
## §7.3): Line Trooper, Scout Drone, Kill-Drone, Spotter, Mortar Walker, Sentry
## Turret (and the Arc Engineer's jam).
const KINDS: Dictionary = {
	# Fodder: a palm-sized chrome drone with one amber eye; swarms, flies over the posts, zaps towers close by.
	"empire_scout_drone": {
		"name": "Scout Drone", "sprite": "empire/scout_drone", "rank": "fodder", "souls": 4,  # TUNING (not in GDD) a swarm pays a little under the soldiers (X2)
		"hp": 34.0, "speed": 60.0, "armour": 0.0, "radius": 8.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": true, "trait": "empire/rifle",
		"args": {"range": 90.0, "interval": 5.0, "target": "tower", "damage": 4.0, "disable": 0.4, "cause": "shot", "speed": 420.0, "look": "zap"},  # TUNING (not in GDD) Necropathy "short-range zaps"
	},
	# Soldier: the Empire's rifleman; it keeps marching and firing at the towers ("marching fire").
	"empire_line_trooper": {
		"name": "Line Trooper", "sprite": "empire/line_trooper", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) soldier tier (X2: up to 10)
		"hp": 110.0, "speed": 46.0, "armour": 2.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 7.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "empire/rifle",
		"args": {"range": 170.0, "interval": 5.0, "target": "tower", "damage": 8.0, "disable": 0.7, "cause": "shot", "speed": 380.0, "look": "rifle"},  # TUNING (not in GDD) Necropathy rifle bursts from 400 px (a TD map is one screen)
	},
	# Soldier: a squat walker behind a tower shield; frontal hits barely scratch it (Act I shield_front).
	"empire_aegis_bot": {
		"name": "Aegis Bot", "sprite": "empire/aegis_bot", "rank": "fodder", "souls": 8,  # TUNING (not in GDD)
		"hp": 135.0, "speed": 40.0, "armour": 3.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 8.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shield_front",
		"args": {"front_mult": 0.5, "ignore": ["corpse_catapult", "iron_revenant"]},  # TUNING (not in GDD) arcing boulders and shells go over the shield
	},
	# Elite: a tall coated marksman; he PAINTS a tower for 1.5 s (Lock-On), then a rail slug flies down the line.
	"empire_spotter": {
		"name": "Spotter", "sprite": "empire/spotter", "rank": "elite",
		"hp": 330.0, "speed": 40.0, "armour": 2.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 8.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "empire/spotter",
		"args": {"first": 2.0, "every": 9.0, "range": 260.0,
			"shot": {"disable": 2.5, "damage": 40.0, "speed": 900.0, "cause": "shot", "look": "rail"}},  # TUNING (not in GDD) Necropathy "heavy rail shot"
	},
	# Elite: a low four-legged walker with a mortar tube; its shells fly OVER the posts onto a telegraphed circle.
	"empire_mortar_walker": {
		"name": "Mortar Walker", "sprite": "empire/mortar_walker", "rank": "elite",
		"hp": 420.0, "speed": 34.0, "armour": 4.0, "radius": 13.0,  # TUNING (not in GDD)
		"damage": 10.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "empire/mortar",
		"args": {"first": 3.0, "every": 11.0, "range": 290.0, "radius": 44.0, "delay": 1.6, "disable": 1.6, "body_damage": 24.0},  # TUNING (not in GDD)
	},
	# Support: a cyborg with a toolkit drum; it repairs the machines round it and jams the nearest tower.
	"empire_arc_engineer": {
		"name": "Arc Engineer", "sprite": "empire/arc_engineer", "rank": "elite",
		"hp": 300.0, "speed": 42.0, "armour": 1.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "empire/arc_engineer",
		"args": {"heal": 14.0, "heal_every": 3.0, "heal_radius": 120.0, "jam_first": 3.0, "jam_every": 10.0, "jam_range": 140.0, "jam_time": 1.5},  # TUNING (not in GDD) Necropathy: repairs, jams 2 s
	},
	# Heavy: an armoured flamethrower walker; held at a post its flame washes over every body there.
	"empire_juggernaut": {
		"name": "Juggernaut", "sprite": "empire/juggernaut", "rank": "elite",
		"hp": 820.0, "speed": 28.0, "armour": 8.0, "radius": 15.0,  # TUNING (not in GDD) flat armour like the Sanctified Sentinel's
		"damage": 14.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "empire/juggernaut",
		"args": {"windup": 0.9, "every": 6.0, "damage": 34.0},  # TUNING (not in GDD) Necropathy "a telegraphed flame cone"
	},
	# Elite (female): a chrome duellist with jet thrusters; held at a post she LUNGES through it.
	"empire_valkyrie_duelist": {
		"name": "Valkyrie Duelist", "sprite": "empire/valkyrie_duelist", "rank": "elite",
		"hp": 360.0, "speed": 50.0, "armour": 3.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 10.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "empire/duelist",
		"args": {"windup": 0.7, "damage": 26.0, "targets": 2, "cooldown": 11.0, "dash_time": 0.6, "dash_mult": 2.0},  # TUNING (not in GDD) Necropathy "a blocker in the lane stops it": here a freeze or stagger does
	},
	# Structure-like: a domed gun emplacement carried down the road; it PLANTS at its stand point and keeps firing.
	"empire_sentry_turret": {
		"name": "Sentry Turret", "sprite": "empire/sentry_turret", "rank": "elite",
		"hp": 520.0, "speed": 30.0, "armour": 5.0, "radius": 13.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.5,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "empire/sentry",
		"args": {"stand": 900.0, "range": 210.0, "interval": 2.6, "target": "tower", "damage": 10.0, "disable": 1.2, "cause": "shot", "speed": 520.0, "look": "bolt_amber"},  # TUNING (not in GDD) stand px along its road
	},
	# Elite flyer: the armoured kill-drone; fires at towers as it passes over the posts.
	"empire_kill_drone": {
		"name": "Kill-Drone", "sprite": "empire/kill_drone", "rank": "elite",
		"hp": 260.0, "speed": 48.0, "armour": 3.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": true, "trait": "empire/rifle",
		"args": {"range": 150.0, "interval": 4.0, "target": "tower", "damage": 8.0, "disable": 1.0, "cause": "shot", "speed": 460.0, "look": "zap"},  # TUNING (not in GDD)
	},
	# A crawling factory: it builds Scout Drones ahead of itself until smashed (the Beta Build patches from it).
	"empire_fabricator": {
		"name": "Fabricator", "sprite": "empire/fabricator", "rank": "elite",
		"hp": 480.0, "speed": 22.0, "armour": 4.0, "radius": 14.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.6,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "empire/fabricator",
		"args": {"first": 4.0, "every": 8.0, "kind": "empire_scout_drone", "max": 3, "ahead": 26.0},  # TUNING (not in GDD) Necropathy "builds a new enemy every few seconds"
	},
	# Kestrel's hologram decoy: walks ahead of her and draws the towers' fire.
	"empire_kestrel_decoy": {
		"name": "Decoy Drone", "sprite": "bosses/kestrel", "rank": "fodder", "souls": 0,  # TUNING (not in GDD) a summoned hologram pays nothing (X2)
		"hp": 260.0, "speed": 30.0, "armour": 0.0, "radius": 14.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
		"tint": Color(0.55, 0.9, 1.0, 0.6),  # TUNING (not in GDD) a flickering cyan hologram of her
	},
	# The Motherboard's own small tripod turret: built beside it, plants at once and fires.
	"empire_motherboard_turret": {
		"name": "Motherboard Turret", "sprite": "empire/motherboard_turret", "rank": "fodder", "souls": 0,  # TUNING (not in GDD) built by the boss: pays nothing
		"hp": 300.0, "speed": 0.0, "armour": 3.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 1.5,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "empire/sentry",
		"args": {"stand": 0.0, "range": 220.0, "interval": 2.4, "target": "tower", "damage": 8.0, "disable": 1.0, "cause": "shot", "speed": 520.0, "look": "bolt_amber"},  # TUNING (not in GDD)
	},
	# Deus Ex Machina's Shield Drone: it hovers by the planted Siege Core; while one flies the core is immune.
	"empire_deus_shield_drone": {
		"name": "Shield Drone", "sprite": "empire/deus_shield_drone", "rank": "fodder", "souls": 0,  # TUNING (not in GDD) part of the boss: pays nothing
		"hp": 420.0, "speed": 0.0, "armour": 2.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 2.0,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": true, "trait": "", "args": {},
	},
	# Scrap Wastes miniboss: the Trojan Horse, a horse-shaped drone tank.
	"empire_trojan_horse": {
		"name": "The Trojan Horse", "sprite": "empire/trojan_horse", "rank": "miniboss",
		"hp": 4600.0, "speed": 24.0, "armour": 6.0, "radius": 26.0,  # TUNING (not in GDD) X3: 4000-6000
		"damage": 22.0, "attack_interval": 1.6,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "empire/trojan",
		"args": {"volley_first": 3.0, "volley_every": 8.0, "volley_count": 4, "volley_range": 280.0,
			"rocket": {"disable": 2.0, "damage": 22.0, "speed": 260.0, "cause": "shelled", "look": "rocket"},
			"stomp_every": 6.0, "stomp_damage": 30.0,
			"split_hp": 0.4, "split_kind": "empire_scout_drone", "split_count": 10, "split_mult": 0.6, "split_volley": 6},  # TUNING (not in GDD) Necropathy TrojanKit
	},
	# Assembly Halls miniboss: the Beta Build, an unfinished mech patching itself from the fabricators.
	"empire_beta_build": {
		"name": "The Beta Build", "sprite": "empire/beta_build", "rank": "miniboss",
		"hp": 4000.0, "speed": 20.0, "armour": 4.0, "radius": 26.0,  # TUNING (not in GDD) X3
		"damage": 22.0, "attack_interval": 1.5,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "empire/beta_build",
		"args": {"patch_tick": 0.5, "patch_rate": 0.0025, "patch_max": 2, "patch_kind": "empire_fabricator",
			"rivets_first": 3.0, "rivets_every": 8.0, "rivets_windup": 0.7, "rivets_count": 5, "rivets_range": 260.0,
			"rivet": {"disable": 1.4, "damage": 16.0, "speed": 520.0, "cause": "shot", "look": "rivet"},
			"swipe_every": 6.0, "swipe_damage": 36.0},  # TUNING (not in GDD) Necropathy BetaBuildKit
	},
	# Iron Citadel miniboss: Valkyrie 2.0, jet pack, tower shield and arm blade.
	"empire_valkyrie_prime": {
		"name": "Valkyrie 2.0", "sprite": "empire/valkyrie_prime", "rank": "miniboss",
		"hp": 3400.0, "speed": 28.0, "armour": 4.0, "radius": 22.0,  # TUNING (not in GDD) X3: her shield and dash make her tougher than her HP
		"damage": 24.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "empire/valkyrie",
		"args": {"dash_every": 12.0, "dash_windup": 0.8, "dash_targets": 2, "dash_damage": 50.0, "dash_time": 0.6, "dash_mult": 2.2,
			"front_mult": 0.85, "ignore": ["corpse_catapult", "iron_revenant"],
			"storm_first": 4.0, "storm_every": 8.0, "storm_radius": 60.0, "storm_damage": 26.0},  # TUNING (not in GDD) Necropathy ValkyrieKit
	},
	# Scrap Wastes boss: Kestrel, the Dead Pixel. Triple Lock-On, decoys, then twin blades and a charge.
	"empire_kestrel": {
		"name": "Kestrel, the Dead Pixel", "sprite": "bosses/kestrel", "rank": "boss",
		"hp": 10500.0, "speed": 24.0, "armour": 5.0, "radius": 26.0,  # TUNING (not in GDD) above Seraiel (9500): Part Three
		"damage": 30.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "empire/kestrel",
		"args": {"phase_hp": [0.66, 0.33], "lock_first": 3.0, "lock_every": 9.0, "lock_range": 320.0, "locks": 3, "pose_time": 1.6,
			"rail": {"disable": 3.5, "damage": 50.0, "speed": 1000.0, "cause": "shot", "look": "rail"},
			"decoy_every": 12.0, "decoy_count": 3, "decoy_kind": "empire_kestrel_decoy",
			"blade_haste": 1.5, "slash_every": 2.0, "slash_damage": 36.0,
			"charge_every": 7.0, "heavy_hp": 300.0, "charge_stun": 2.0, "charge_damage": 60.0, "charge_time": 1.2},  # TUNING (not in GDD) Necropathy BossKestrel
	},
	# Assembly Halls boss: the Motherboard, the construction titan with two crane arms.
	"empire_motherboard": {
		"name": "The Motherboard", "sprite": "bosses/motherboard", "rank": "boss",
		"hp": 12000.0, "speed": 20.0, "armour": 7.0, "radius": 32.0,  # TUNING (not in GDD)
		"damage": 34.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "empire/motherboard",
		"args": {"load_hp": 0.6, "overclock_hp": 0.3, "overclock_mult": 0.65, "pose_time": 0.7,
			"grab_first": 4.0, "grab_every": 10.0, "grab_range": 160.0, "grab_damage": 120.0,
			"hurl_range": 320.0, "hurl_radius": 46.0, "hurl_delay": 0.9, "hurl_disable": 2.5,
			"stamp_first": 6.0, "stamp_every": 11.0, "stamp_range": 300.0, "stamps": 2,
			"stamp_radius": 46.0, "stamp_delay": 1.5, "stamp_disable": 3.0, "stamp_body": 40.0,
			"turret_every": 9.0, "turret_cap": 3, "turret_kind": "empire_motherboard_turret"},  # TUNING (not in GDD) Necropathy BossMotherboard
	},
	# Iron Citadel boss: Deus Ex Machina with Varn wired into its core. Walker, Siege Core, the Founder.
	"empire_deus": {
		"name": "Deus Ex Machina", "sprite": "bosses/deus_ex_machina", "rank": "boss",
		"hp": 13000.0, "speed": 18.0, "armour": 7.0, "radius": 34.0,  # TUNING (not in GDD) the act's last boss
		"damage": 40.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "empire/deus",
		"args": {"siege_hp": 0.6, "founder_hp": 0.3, "pose_time": 0.6,
			"chain_first": 3.0, "chain_every": 7.0, "chain_count": 6, "chain_range": 260.0,
			"chain_shot": {"disable": 1.2, "damage": 14.0, "speed": 560.0, "cause": "shot", "look": "rifle"},
			"salvo_first": 6.0, "salvo_every": 13.0, "salvo_locks": 4, "salvo_range": 320.0,
			"missile": {"disable": 3.0, "damage": 45.0, "speed": 420.0, "cause": "shelled", "look": "missile"},
			"stomp_every": 5.0, "stomp_damage": 40.0,
			"drones": 3, "drone_kind": "empire_deus_shield_drone", "exposed_time": 9.0,
			"lance_every": 10.0, "lance_range": 380.0,
			"lance": {"disable": 5.0, "damage": 90.0, "speed": 1400.0, "cause": "shot", "look": "lance"},
			"hangar_every": 16.0, "hangar": ["empire_line_trooper", "empire_line_trooper", "empire_valkyrie_duelist"],
			"founder_speed": 1.6, "pulse_every": 7.0, "pulse_r0": 120.0, "pulse_grow": 30.0, "pulse_max": 240.0, "pulse_disable": 1.5,
			"tp_every": 11.0, "tp_dist": 90.0, "tp_keep": 200.0},  # TUNING (not in GDD) Necropathy BossDeusExMachina
	},
}

## Build orders of the Empire maps (keys: BuildOrderData.ORDERS): each map's
## default (must win on Necromancer) and weak order (must lose), and one kit
## order for every Act XII map ("empire_kit": each map's default with the act
## towers swapped in and the act spells, DECISIONS Y5).
const ORDERS: Dictionary = {
	"wastes_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "build", "spot": "plot:3", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "plot:8", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:8", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:4", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "post:1", "tower": "abomination"},
			{"do": "build", "spot": "plot:7", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:6", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:0", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "post:4", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:10", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:10", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "post:0"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:5", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:5"},
		],
	},
	"wastes_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
		],
	},
	"assembly_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:3", "tower": "archer"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "build", "spot": "plot:1", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "plot:4", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:4", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "build", "spot": "plot:8", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "post:3", "tower": "abomination"},
			{"do": "build", "spot": "plot:6", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "plot:7", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:0", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "post:4", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:9", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:9", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "post:0"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:5", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:5"},
		],
	},
	"assembly_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:3", "tower": "archer"},
		],
	},
	"citadel_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:16", "tower": "archer"},
			{"do": "build", "spot": "post:4", "tower": "warrior"},
			{"do": "build", "spot": "plot:17", "tower": "archer"},
			{"do": "build", "spot": "plot:11", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:16"},
			{"do": "upgrade", "spot": "plot:17"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "plot:14", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:14", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "build", "spot": "plot:15", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:16"},
			{"do": "upgrade", "spot": "plot:17"},
			{"do": "build", "spot": "post:5", "tower": "abomination"},
			{"do": "build", "spot": "plot:5", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:4", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:16"},
			{"do": "upgrade", "spot": "plot:17"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:9", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:9", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:16"},
			{"do": "upgrade", "spot": "plot:17"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:1", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:16"},
			{"do": "upgrade", "spot": "plot:17"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "post:0"},
			{"do": "upgrade", "spot": "post:5"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:1"},
		],
	},
	"citadel_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:16", "tower": "archer"},
		],
	},
	"empire_kit": {
		"spells": true,
		"loadout": ["death_ray", "hollow_puppet", "scrap_swarm"],
		"steps_by_map": {
			"wastes": [
				{"do": "build", "spot": "plot:1", "tower": "archer"},
				{"do": "build", "spot": "post:0", "tower": "warrior"},
				{"do": "build", "spot": "plot:2", "tower": "grave_drone"},
				{"do": "build", "spot": "plot:3", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "post:2", "tower": "warrior"},
				{"do": "build", "spot": "plot:8", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:8", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:4", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "post:1", "tower": "iron_revenant"},
				{"do": "build", "spot": "plot:7", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "plot:6", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:0", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "post:4", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:10", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:10", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "evolve", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "post:0"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:5", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:1"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "post:1"},
				{"do": "upgrade", "spot": "post:1"},
				{"do": "upgrade", "spot": "post:1"},
				{"do": "evolve", "spot": "post:1"},
			],
			"assembly": [
				{"do": "build", "spot": "plot:3", "tower": "archer"},
				{"do": "build", "spot": "post:0", "tower": "warrior"},
				{"do": "build", "spot": "plot:2", "tower": "grave_drone"},
				{"do": "build", "spot": "plot:1", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "post:2", "tower": "warrior"},
				{"do": "build", "spot": "plot:4", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:4", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "build", "spot": "plot:8", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "post:3", "tower": "iron_revenant"},
				{"do": "build", "spot": "plot:6", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "plot:7", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "plot:0", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "post:4", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "plot:9", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:9", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "evolve", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "post:0"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "plot:5", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "evolve", "spot": "post:3"},
			],
			"citadel": [
				{"do": "build", "spot": "plot:16", "tower": "archer"},
				{"do": "build", "spot": "post:4", "tower": "warrior"},
				{"do": "build", "spot": "plot:17", "tower": "grave_drone"},
				{"do": "build", "spot": "plot:11", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:16"},
				{"do": "upgrade", "spot": "plot:17"},
				{"do": "build", "spot": "post:0", "tower": "warrior"},
				{"do": "build", "spot": "plot:14", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:14", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "build", "spot": "plot:15", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:16"},
				{"do": "upgrade", "spot": "plot:17"},
				{"do": "build", "spot": "post:5", "tower": "iron_revenant"},
				{"do": "build", "spot": "plot:5", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "build", "spot": "plot:2", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:4", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:16"},
				{"do": "upgrade", "spot": "plot:17"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "build", "spot": "post:1", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:9", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:9", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:16"},
				{"do": "upgrade", "spot": "plot:17"},
				{"do": "evolve", "spot": "plot:17"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:1", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:16"},
				{"do": "upgrade", "spot": "plot:17"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "post:0"},
				{"do": "upgrade", "spot": "post:5"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "post:5"},
				{"do": "upgrade", "spot": "post:5"},
				{"do": "upgrade", "spot": "post:5"},
				{"do": "evolve", "spot": "post:5"},
			],
		},
	},
}

## Battlefield moods of the three maps (keys: TdMoodData.MOODS). Cold chrome
## and gunmetal under signal-amber and red warning lights.
const MOODS: Dictionary = {
	"wastes": {
		"props": [{"sprite": "obstacles/emitter_pylon_m", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(1.0, 0.25, 0.15, 0.55), "glow_r": 46.0,
			"glow_at": Vector2(0, -62), "flicker": 0.25, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) red signal masts on the ridges
			{"sprite": "obstacles/wreck_ribs_s", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(1.0, 0.68, 0.1, 0.35), "glow_r": 36.0,
			"glow_at": Vector2(0, -12), "flicker": 0.15, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) smouldering wrecks
		"fog": 3,  # TUNING (not in GDD) blowing grit
		"pools": 0,
	},
	"assembly": {
		"props": [{"sprite": "obstacles/press_machine_s", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(1.0, 0.55, 0.15, 0.55), "glow_r": 50.0,
			"glow_at": Vector2(0, -20), "flicker": 0.2, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) furnace light from the presses
			{"sprite": "obstacles/emitter_pylon_s", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(1.0, 0.68, 0.1, 0.45), "glow_r": 40.0,
			"glow_at": Vector2(0, -44), "flicker": 0.1, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) amber line lamps
		"fog": 2,  # TUNING (not in GDD) furnace smoke
		"pools": 3,  # TUNING (not in GDD) pools of furnace light
	},
	"citadel": {
		"props": [{"sprite": "obstacles/gate_pylon_m", "frames": 1, "count": 5, "scale": 1.0, "glow": Color(0.55, 0.8, 1.0, 0.5), "glow_r": 46.0,
			"glow_at": Vector2(0, -50), "flicker": 0.1, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) shield gate pylons humming
			{"sprite": "obstacles/emitter_pylon_m", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(1.0, 0.25, 0.15, 0.5), "glow_r": 44.0,
			"glow_at": Vector2(0, -62), "flicker": 0.2, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) red warning beacons
		"fog": 0,
		"pools": 4,  # TUNING (not in GDD) floodlight pools
	},
}

## The Line of Fire and the Lock-On (scripts/maps/rules/empire/line_of_fire.gd;
## Necropathy's EmpireShots and LockOn).
const RULE: Dictionary = {
	"lock_time": 1.5,  # Necropathy owner-approved proposal: "a 1.5 s painted line"
	"lock_cap": 3,  # TUNING (not in GDD) Necropathy LockOn: at most 3 painted lines at once (bosses override)
	"banner": "Line of Fire: Empire guns shoot your towers. A post or Bone Wall in the line stops the shot",  # the first wave's banner
}

## The act's looks (drawing only; read by its traits, bosses, spells, tower and HUD).
const LOOK: Dictionary = {
	"lock_tint": Color(1.0, 0.18, 0.12, 0.9),  # TUNING (not in GDD) a painted Lock-On line and its reticle (red)
	"lock_w0": 3.0,  # TUNING (not in GDD) px of a fresh paint line
	"lock_w1": 10.0,  # TUNING (not in GDD) px just before the shot
	"reticle": 26.0,  # TUNING (not in GDD) px radius of the reticle on the painted tower (closes in)
	"line_tint": Color(1.0, 0.68, 0.1, 0.55),  # TUNING (not in GDD) a telegraph line (lunges, charges): signal amber
	"line_w": 4.0,  # TUNING (not in GDD) px
	"cut_tint": Color(1.0, 0.85, 0.55, 1.0),  # TUNING (not in GDD) the bright cut of a blade
	"cut_w": 12.0,  # TUNING (not in GDD) px
	"cut_time": 0.35,  # TUNING (not in GDD) s the cut shows
	"line_over": 26.0,  # TUNING (not in GDD) px a line runs past both ends
	"arc_tint": Color(0.55, 0.8, 1.0, 0.95),  # TUNING (not in GDD) arc-welder blue (repairs, jams, fabrication)
	"flame_tint": Color(1.0, 0.5, 0.15),  # TUNING (not in GDD) flamethrower / welding orange
	"flame_d": 110.0,  # TUNING (not in GDD) px of the flame burst over a post
	"stomp_tint": Color(1.0, 0.75, 0.45),  # TUNING (not in GDD) a stomp / swipe burst
	"stomp_d": 110.0,  # TUNING (not in GDD) px
	"blast_d": 150.0,  # TUNING (not in GDD) px of the Trojan Horse's hull split
	"pulse_tint": Color(0.75, 0.55, 1.0, 0.9),  # TUNING (not in GDD) Varn's overload pulse (violet)
	"dial_px": 34.0,  # TUNING (not in GDD) HUD cue icon size (px)
	"dial_margin": Vector2(10.0, 10.0),  # TUNING (not in GDD) px from the screen's left edge / under the top bar
	"dial_color": Color(1.0, 0.8, 0.45),  # TUNING (not in GDD) the label: signal amber
	"dial_hot": Color(1.0, 0.4, 0.35),  # TUNING (not in GDD) the label while a tower is painted
	# --- The act spells and towers ---
	"ray_tint": Color(0.75, 0.55, 1.0),  # TUNING (not in GDD) Death Ray's soul laser (violet)
	"ray_w": 14.0,  # TUNING (not in GDD) px of the drawn beam
	"spark_tint": Color(0.8, 0.85, 1.0),  # TUNING (not in GDD) its lightning sparks
	"string_tint": Color(0.74, 0.46, 0.96),  # TUNING (not in GDD) Hollow Puppet's soul strings
	"swarm_tint": Color(0.8, 0.6, 1.0),  # TUNING (not in GDD) Scrap Swarm bolts
	"drone_hover": 6.0,  # TUNING (not in GDD) px a Grave Drone bobs over its plot (drawn only)
}
