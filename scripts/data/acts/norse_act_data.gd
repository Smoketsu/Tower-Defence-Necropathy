## Act VI, the Hall of the Slain (ActData "norse"; GDD §7.3; Necropathy's Norse
## act: docs/norse/, NorseRulesData, NorseEnemyData and the stages
## barrow_fields / valgard / vigrid): its enemy kinds (KINDS, keys as
## TdEnemyData.KINDS), its build orders (ORDERS, keys as BuildOrderData.ORDERS),
## its three map moods (MOODS, keys as TdMoodData.MOODS), the numbers of its act
## rule, the Long Winter (RULE, read by scripts/maps/rules/norse/long_winter.gd)
## and its looks (LOOK). Every sprite is Necropathy's Norse art
## (assets/sprites/norse/). Data only.
extends RefCounted

## Enemy kinds of the Hall of the Slain (keys: TdEnemyData.KINDS). Traits live in
## scripts/enemies/traits/norse/ and scripts/bosses/norse/ (each script documents
## its args). Every id carries the act's prefix except the named minibosses and
## bosses (ids are unique across all acts).
const KINDS: Dictionary = {
	# Raiders: axe and round shield, in crowds; Berserkergang below half HP (Necropathy "Raider").
	"norse_raider": {
		"name": "Raider", "sprite": "norse/raider", "rank": "fodder", "souls": 7,  # TUNING (not in GDD) Part Two pays Act V's step (X2)
		"hp": 84.0, "speed": 52.0, "armour": 1.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 7.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "norse/berserk",
		"args": {"at": 0.4, "speed_mult": 1.25, "damage_mult": 1.35, "shrug_slow": false},  # TUNING (not in GDD) Necropathy BERSERK share
	},
	# Shield-Maiden: shield and spear; less from the front, her bash staggers the post; berserk when hurt.
	"norse_shield_maiden": {
		"name": "Shield-Maiden", "sprite": "norse/shield_maiden", "rank": "fodder", "souls": 11,  # TUNING (not in GDD) soldier tier
		"hp": 220.0, "speed": 46.0, "armour": 3.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 11.0, "attack_interval": 1.15,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "norse/shield_maiden",
		"args": {"front_mult": 0.7, "ignore": ["corpse_catapult"], "at": 0.5, "speed_mult": 1.3, "damage_mult": 1.4, "shrug_slow": false,
			"bash_every": 3, "bash_stagger": 1.2},  # TUNING (not in GDD) Necropathy bash: "throws one summon back"
	},
	# Berserker: bear pelt, two axes, in the fury from the first step; shrugs off slows while raging.
	"norse_berserker": {
		"name": "Berserker", "sprite": "norse/berserker", "rank": "elite",
		"hp": 460.0, "speed": 50.0, "armour": 2.0, "radius": 13.0,  # TUNING (not in GDD)
		"damage": 18.0, "attack_interval": 0.9,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "norse/berserk",
		"args": {"at": 1.01, "speed_mult": 1.12, "damage_mult": 1.4, "shrug_slow": true},  # TUNING (not in GDD) Necropathy berserk_always
	},
	# Skald: a war-song; warriors near him march faster (Act I banner_aura).
	"norse_skald": {
		"name": "Skald", "sprite": "norse/skald", "rank": "fodder", "souls": 10,  # TUNING (not in GDD) soldier tier
		"hp": 160.0, "speed": 44.0, "armour": 1.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "banner_aura",
		"args": {"radius": 100.0, "speed_mult": 1.22, "refresh": 0.25},  # TUNING (not in GDD) Necropathy song_radius
	},
	# Valkyrie: flies over the posts; her spear dive lands on a telegraphed circle and stuns the towers there.
	"norse_valkyrie": {
		"name": "Valkyrie", "sprite": "norse/valkyrie", "rank": "elite",
		"hp": 290.0, "speed": 56.0, "armour": 1.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 8.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": true, "trait": "norse/valkyrie",
		"args": {"first": 3.0, "every": 11.0, "range": 230.0, "radius": 60.0, "delay": 1.2, "stun": 1.5, "body_damage": 40.0},  # TUNING (not in GDD) Necropathy spear dive
	},
	# Seer: douses the braziers she passes; her curse blinds the nearest tower a while.
	"norse_seer": {
		"name": "Seer", "sprite": "norse/seer", "rank": "fodder", "souls": 10,  # TUNING (not in GDD) soldier tier
		"hp": 150.0, "speed": 44.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 5.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "norse/seer",
		"args": {"douse_radius": 70.0, "curse_first": 4.0, "curse_every": 14.0, "curse_range": 180.0, "blind": 1.5},  # TUNING (not in GDD) Necropathy curse_time
	},
	# Draugr: barrow-dead in rusted mail; its cold touch slows the strikes of the body holding it.
	"norse_draugr": {
		"name": "Draugr", "sprite": "norse/draugr", "rank": "fodder", "souls": 9,  # TUNING (not in GDD)
		"hp": 160.0, "speed": 40.0, "armour": 3.0, "radius": 10.0,  # TUNING (not in GDD) Necropathy flat armour 3
		"damage": 8.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "norse/draugr",
		"args": {"chill": 0.6},  # TUNING (not in GDD) s each blow delays the body's next strike
	},
	# The female draugr: the same barrow-dead (Necropathy alternates the art).
	"norse_draugr_female": {
		"name": "Draugr", "sprite": "norse/draugr_female", "rank": "fodder", "souls": 9,  # TUNING (not in GDD)
		"hp": 160.0, "speed": 40.0, "armour": 3.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 8.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "norse/draugr",
		"args": {"chill": 0.6},  # TUNING (not in GDD)
	},
	# Wolves of the wastes: fast packs that lunge past the post (the Black Tide's lunge trait).
	"norse_wolf": {
		"name": "Wolf of the Wastes", "sprite": "norse/wolf_of_the_wastes", "rank": "fodder", "souls": 5,  # TUNING (not in GDD) a pack beast
		"hp": 60.0, "speed": 74.0, "armour": 0.0, "radius": 9.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 0.9,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "corsair/lunge",
		"args": {"every": 4.0, "windup": 0.6, "damage": 10.0, "time": 1.0, "speed_mult": 1.4},  # TUNING (not in GDD) Necropathy wolf lunge
	},
	# Frost giant: hurls a boulder over the posts at a tower and douses the braziers it passes.
	"norse_frost_giant": {
		"name": "Frost Giant", "sprite": "norse/frost_giant", "rank": "elite",
		"hp": 950.0, "speed": 26.0, "armour": 5.0, "radius": 18.0,  # TUNING (not in GDD)
		"damage": 26.0, "attack_interval": 1.6,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "norse/frost_giant",
		"args": {"range": 260.0, "interval": 10.0, "target": "tower", "damage": 30.0, "disable": 1.8, "cause": "frozen", "speed": 260.0, "arc": true,
			"look": "boulder", "douse_radius": 80.0},  # TUNING (not in GDD) Necropathy boulder throw
	},
	# Einherjar: gold-lit heroes of the hall who rise once more when they fall.
	"norse_einherjar": {
		"name": "Einherjar", "sprite": "norse/einherjar", "rank": "fodder", "souls": 13,  # TUNING (not in GDD) soldier tier
		"hp": 250.0, "speed": 44.0, "armour": 4.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 12.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "norse/einherjar",
		"args": {"rise_hp": 0.5},  # TUNING (not in GDD) share of max HP it rises with (once)
	},
	# Fire-giant of Muspelheim: a telegraphed stomp that cracks the posts and stuns the towers round it.
	"norse_fire_giant": {
		"name": "Fire Giant", "sprite": "norse/fire_giant", "rank": "elite",
		"hp": 1150.0, "speed": 24.0, "armour": 5.0, "radius": 20.0,  # TUNING (not in GDD)
		"damage": 28.0, "attack_interval": 1.6,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "norse/fire_giant",
		"args": {"stomp_first": 4.0, "stomp_every": 8.0, "radius": 90.0, "delay": 1.0, "disable": 1.6, "body_damage": 45.0,
			"track_every": 0.0, "track_radius": 0.0, "track_disable": 0.0},  # TUNING (not in GDD) Necropathy fire-giant stomp
	},
	# Raven: Odin's birds, small flyers over the posts.
	"norse_raven": {
		"name": "Raven of Odin", "sprite": "norse/raven", "rank": "fodder", "souls": 3,  # TUNING (not in GDD) a summoned bird
		"hp": 55.0, "speed": 68.0, "armour": 0.0, "radius": 8.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": true, "trait": "", "args": {},
	},
	# Rune-Stone: a structure beside the road; the hall's foes near it are warded and march faster until it falls.
	"norse_rune_stone": {
		"name": "Rune-Stone", "sprite": "norse/rune_stone", "rank": "elite", "structure": true, "souls": 20,  # TUNING (not in GDD) a bounty for breaking it
		"hp": 1100.0, "speed": 0.0, "armour": 3.0, "radius": 14.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": false, "ignores_walls": true, "trait": "norse/rune_stone",
		"args": {"radius": 125.0, "ward_mult": 0.75, "speed_mult": 1.15, "refresh": 0.3},  # TUNING (not in GDD) Necropathy RUNE_STONES ward
	},
	# Hrimgar's barrow: rises where he sinks; break it before he returns and he stays down.
	"hrimgar_barrow": {
		"name": "Hrimgar's Barrow", "sprite": "norse/boss_barrow", "rank": "elite", "structure": true, "souls": 0,  # TUNING (not in GDD) the kill is the reward
		"hp": 3500.0, "speed": 0.0, "armour": 4.0, "radius": 18.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": false, "ignores_walls": true, "trait": "", "args": {},
	},
	# Barrow Fields miniboss: the Barrow-Wight, a draugr chieftain whose howl stuns the posts and towers round him.
	"barrow_wight": {
		"name": "The Barrow-Wight", "sprite": "norse/barrow_wight", "rank": "miniboss",
		"hp": 4300.0, "speed": 26.0, "armour": 5.0, "radius": 22.0,  # TUNING (not in GDD) X3 band
		"damage": 26.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "norse/barrow_wight",
		"args": {"howl_first": 4.0, "howl_every": 11.0, "windup": 1.0, "radius": 125.0, "stun": 1.0,
			"call_kind": "norse_draugr", "call_count": 1, "call_gap": 30.0, "pose_time": 0.6},  # TUNING (not in GDD) Necropathy howl_radius / howl_stun
	},
	# Valgard miniboss: the Einherjar Champion; the hero's sweep cuts every body round him, his horn wakes the hall.
	"einherjar_champion": {
		"name": "The Einherjar Champion", "sprite": "norse/einherjar_champion", "rank": "miniboss",
		"hp": 5400.0, "speed": 30.0, "armour": 6.0, "radius": 22.0,  # TUNING (not in GDD) X3 band
		"damage": 28.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "norse/champion",
		"args": {"sweep_first": 3.0, "sweep_every": 6.0, "sweep_radius": 75.0, "sweep_windup": 0.8, "sweep_damage": 70.0,
			"horn_first": 6.0, "horn_every": 16.0, "horn_count": 3, "horn_kind": "norse_einherjar", "horn_gap": 26.0, "pose_time": 0.6},  # TUNING (not in GDD) Necropathy sweep / horn
	},
	# Vigrid miniboss: the Fire-Giant of the South, a fire-giant's stomp plus burning tracks behind him.
	"muspel_giant": {
		"name": "The Fire-Giant of the South", "sprite": "norse/fire_giant", "rank": "miniboss",
		"hp": 5600.0, "speed": 22.0, "armour": 6.0, "radius": 26.0,  # TUNING (not in GDD) X3 band
		"damage": 30.0, "attack_interval": 1.5,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "norse/fire_giant",
		"args": {"stomp_first": 3.0, "stomp_every": 7.0, "radius": 110.0, "delay": 1.0, "disable": 1.8, "body_damage": 55.0,
			"track_every": 3.0, "track_radius": 70.0, "track_disable": 1.2},  # TUNING (not in GDD) Necropathy burning tracks
	},
	# Barrow Fields boss: Hrimgar the Draugr-King. He rises three times; his barrow can be broken while he lies in it.
	"hrimgar": {
		"name": "Hrimgar the Draugr-King", "sprite": "norse/hrimgar", "rank": "boss",
		"hp": 5200.0, "speed": 22.0, "armour": 5.0, "radius": 26.0,  # TUNING (not in GDD) per life (three lives)
		"damage": 30.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "norse/hrimgar",
		"args": {"lives": 3, "rise_time": 14.0, "barrow_kind": "hrimgar_barrow", "barrow_side": 34.0, "rise_hp": [1.0, 0.85, 0.75],
			"mist_first": 5.0, "mist_every": 10.0, "mist_radius": 120.0, "mist_delay": 1.2, "mist_disable": 2.0,
			"call_every": 8.0, "call_kind": "norse_draugr", "call_count": 2, "call_gap": 30.0,
			"cleave_every": 5.0, "cleave_damage": 70.0,
			"drag_every": 7.0, "drag_damage": 400.0, "pose_time": 0.7},  # TUNING (not in GDD) Necropathy HrimgarData: the Grave, the Barrow Lord, the Last Rising
	},
	# Valgard boss: Sigrun the Shield-Queen. The Charge, the Holmgang (a duel with one post), the Doors of the Hall.
	"sigrun": {
		"name": "Sigrun, the Shield-Queen", "sprite": "norse/sigrun", "rank": "boss",
		"hp": 15000.0, "speed": 28.0, "armour": 5.0, "radius": 24.0,  # TUNING (not in GDD)
		"damage": 34.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "norse/sigrun",
		"args": {"charge_first": 5.0, "charge_every": 12.0, "charge_windup": 0.8, "charge_time": 1.6, "charge_speed": 2.6, "charge_radius": 34.0, "charge_damage": 90.0,
			"duel_at": [0.7, 0.35], "duel_time": 15.0, "duel_mult": 0.25, "duel_range": 520.0,
			"doors_at": 0.5, "doors_kind": "norse_einherjar", "doors_count": 6, "doors_gap": 30.0, "pose_time": 0.7},  # TUNING (not in GDD) Necropathy SigrunData
	},
	# Vigrid boss: Odin the All-Father. The Wolf (he watches, out of reach), the All-Father (Gungnir, ravens), Ragnarok.
	"odin": {
		"name": "Odin the All-Father", "sprite": "norse/odin", "rank": "boss",
		"hp": 11000.0, "speed": 24.0, "armour": 5.0, "radius": 22.0,  # TUNING (not in GDD)
		"damage": 32.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "norse/odin",
		"args": {"wolf_kind": "fenrir", "wolf_gap": 70.0, "stand_dist": 90.0, "chain_hp": 0.55, "ragnarok_hp": 0.5, "doom_time": 6.0,
			"spear_first": 3.0, "spear_every": 7.0, "spear_range": 380.0, "spear_disable": 4.0, "spear_damage": 120.0, "spear_speed": 520.0,
			"raven_every": 9.0, "raven_kind": "norse_raven", "raven_count": 3,
			"fire_every": 6.0, "fire_count": 2, "fire_radius": 70.0, "fire_delay": 1.4, "fire_disable": 2.0, "fire_damage": 40.0, "pose_time": 0.7},  # TUNING (not in GDD) Necropathy OdinData
	},
	# Fenrir, the great wolf at Odin's side: he swallows the post that holds him and breaks free.
	"fenrir": {
		"name": "Fenrir", "sprite": "norse/fenrir", "rank": "boss",
		"hp": 9000.0, "speed": 34.0, "armour": 4.0, "radius": 24.0,  # TUNING (not in GDD)
		"damage": 30.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "norse/fenrir",
		"args": {"swallow_first": 3.0, "swallow_every": 9.0, "swallow_damage": 600.0, "free_time": 1.2, "speed_mult": 1.5,
			"rage_speed": 1.3},  # TUNING (not in GDD) Necropathy FenrirKit swallow
	},
}

## Build orders of the Hall of the Slain (keys: BuildOrderData.ORDERS): each map's
## default (must win on Necromancer) and weak order (must lose), and one kit
## order for every Act VI map ("norse_kit": the Draugr Thane on the posts and its
## Barrow King, the act spells, Cold Iron beside a Frost Wraith).
const ORDERS: Dictionary = {
	"barrow_fields_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:7", "tower": "archer"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "plot:8", "tower": "archer"},
			{"do": "build", "spot": "plot:9", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:6", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:6", "mode": "strongest"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:1", "tower": "mage"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:10", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "build", "spot": "post:2", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:3", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "post:0"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:4", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:4", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:13", "tower": "mage"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "post:0"},
		],
	},
	"barrow_fields_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
		],
	},
	"valgard_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "build", "spot": "plot:4", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:6", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:6", "mode": "strongest"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:7", "tower": "mage"},
			{"do": "build", "spot": "plot:8", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:3", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "post:2", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:9", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "post:0"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:10", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:10", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:11", "tower": "mage"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "post:0"},
		],
	},
	"valgard_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
		],
	},
	"vigrid_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "build", "spot": "plot:4", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:6", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:6", "mode": "strongest"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:7", "tower": "mage"},
			{"do": "build", "spot": "plot:8", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:3", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "post:2", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:9", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "post:0"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:10", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:10", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:11", "tower": "mage"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "post:0"},
		],
	},
	"vigrid_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
		],
	},
}

## Battlefield moods of the three maps (keys: TdMoodData.MOODS).
const MOODS: Dictionary = {
	"barrow_fields": {
		"props": [{"sprite": "obstacles/barrow_open", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(0.55, 0.85, 1.0, 0.4), "glow_r": 56.0,
			"glow_at": Vector2(0, -4), "flicker": 0.2, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) open barrows breathing grave-cold light
		"fog": 3,  # TUNING (not in GDD) frost mist over the mounds
		"pools": 0,
	},
	"valgard": {
		"props": [{"art": "mood_fire", "frames": 8, "count": 4, "scale": 1.0, "glow": Color(1.0, 0.62, 0.28, 0.6), "glow_r": 70.0,
			"glow_at": Vector2(0, -6), "flicker": 0.25, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) the hall's long fires
			{"sprite": "obstacles/standing_shield_s", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(0, 0, 0, 0), "glow_r": 0.0,
			"glow_at": Vector2.ZERO, "flicker": 0.0, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) shields hung on the pillars
		"fog": 0,
		"pools": 0,
	},
	"vigrid": {
		"props": [{"art": "mood_fire", "frames": 8, "count": 5, "scale": 1.0, "glow": Color(1.0, 0.4, 0.15, 0.65), "glow_r": 76.0,
			"glow_at": Vector2(0, -6), "flicker": 0.3, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) Muspel's embers on the last field
		"fog": 2,  # TUNING (not in GDD) ash drifting
		"pools": 0,
	},
}

## The Long Winter (scripts/maps/rules/norse/long_winter.gd; GDD §7.3; Necropathy's
## NorseRulesData.LONG_WINTER). Numbers of the simulation first, then the look.
const RULE: Dictionary = {
	# Wave (1-based) at which each cold level begins on each map (level 0 before the first).
	"cold_waves": {
		"barrow_fields": [4, 10, 17],  # TUNING (not in GDD) Necropathy: one level per step_every of the 20:00 clock
		"valgard": [3, 9, 15],  # TUNING (not in GDD)
		"vigrid": [3, 8, 14],  # TUNING (not in GDD)
	},
	"rate_by_level": [1.0, 0.9, 0.8, 0.7],  # TUNING (not in GDD) attack-rate multiplier of a tower OUT of warmth at levels 0..3
	"warm_radius": 170.0,  # TUNING (not in GDD) px around a lit brazier that is warm (towers there work normally)
	"relight_time": 24.0,  # TUNING (not in GDD) s a doused brazier stays cold before it rekindles by itself
	"relight_cost": 15,  # TUNING (not in GDD) souls to relight a doused brazier at once with a tap
	"bot_reserve": 120,  # TUNING (not in GDD) the autotest bot relights a brazier only with this many souls in hand
	"tap_radius": 30.0,  # TUNING (not in GDD) px around a brazier a tap picks it
	"check_every": 0.25,  # TUNING (not in GDD) s between two warmth checks of the towers
	# --- The look (drawing only) ---
	"frost_px": [0.0, 26.0, 40.0, 56.0],  # TUNING (not in GDD) px of the frost edge band at levels 0..3 (norse/frost_creep)
	"frost_tint": Color(0.75, 0.9, 1.0, 0.85),  # TUNING (not in GDD) the frost band's tint
	"warm_ring": Color(1.0, 0.7, 0.35, 0.32),  # TUNING (not in GDD) the warmth's real edge around a lit brazier
	"glow": Color(1.0, 0.62, 0.3, 0.55),  # TUNING (not in GDD) additive warm glow on a lit brazier
	"glow_r": 80.0,  # TUNING (not in GDD) px of that glow
	"rime": Color(0.7, 0.88, 1.0, 0.75),  # TUNING (not in GDD) the rime ring under a chilled tower
	"rime_d": 50.0,  # TUNING (not in GDD) px of that ring
	"doused_tint": Color(0.7, 0.8, 1.0),  # TUNING (not in GDD) a doused brazier's sprite tint
	"anim_fps": 8.0,  # TUNING (not in GDD) frames per second of the brazier loops
	"meter_px": 40.0,  # TUNING (not in GDD) HUD cold meter icon size (px)
	"meter_margin": Vector2(10.0, 8.0),  # TUNING (not in GDD) px from the screen's left / bottom edges
	"meter_colors": [Color(1.0, 0.82, 0.5), Color(0.8, 0.92, 1.0), Color(0.6, 0.82, 1.0), Color(0.45, 0.7, 1.0)],  # TUNING (not in GDD) label colour per cold level
}

## The act's looks (drawing only; read by its traits, bosses, tower and spells).
const LOOK: Dictionary = {
	"howl_tint": Color(0.6, 0.85, 1.0, 0.8),  # TUNING (not in GDD) the Barrow-Wight's howl ring
	"mist_tint": Color(0.7, 0.9, 1.0, 0.75),  # TUNING (not in GDD) Hrimgar's frost mist
	"barrow_tint": Color(0.5, 0.8, 1.0, 0.8),  # TUNING (not in GDD) a grave-light burst as a barrow opens / Hrimgar sinks
	"sweep_tint": Color(1.0, 0.85, 0.4, 0.9),  # TUNING (not in GDD) the champion's gold sweep
	"rise_tint": Color(1.0, 0.85, 0.45, 0.85),  # TUNING (not in GDD) an einherjar rising again
	"rage_tint": Color(1.0, 0.3, 0.2, 0.75),  # TUNING (not in GDD) the berserk flare
	"rage_d": 46.0,  # TUNING (not in GDD) px of that flare
	"charge_tint": Color(1.0, 0.9, 0.6, 0.9),  # TUNING (not in GDD) Sigrun's charge streak
	"charge_w": 16.0,  # TUNING (not in GDD) px wide
	"duel_tint": Color(1.0, 0.85, 0.45, 0.9),  # TUNING (not in GDD) the Holmgang's hazel square
	"duel_half": 46.0,  # TUNING (not in GDD) px half-side of the Holmgang square around the post
	"duel_rod": 5.0,  # TUNING (not in GDD) px thickness of its rods
	"spear_tint": Color(0.75, 0.9, 1.0, 1.0),  # TUNING (not in GDD) Odin's Gungnir (soul-light white)
	"fire_tint": Color(1.0, 0.45, 0.15, 0.8),  # TUNING (not in GDD) Ragnarok's burning ground
	"swallow_d": 90.0,  # TUNING (not in GDD) px of Fenrir's swallow burst
	"cleave_d": 110.0,  # TUNING (not in GDD) px of a cleave burst (Hrimgar, the Draugr Thane)
	"chill_tint": Color(0.65, 0.88, 1.0, 0.8),  # TUNING (not in GDD) the draugr / thane chill
	# --- The act spells ---
	"hand_d": 46.0,  # TUNING (not in GDD) px of a Barrow Grasp hand burst
	"hand_tint": Color(0.55, 0.85, 1.0, 0.9),  # TUNING (not in GDD) grave-cold hands
	"spear_w": 12.0,  # TUNING (not in GDD) px of a Valkyrie Spear / Gungnir streak
	"valk_tint": Color(1.0, 0.9, 0.55, 1.0),  # TUNING (not in GDD) the Valkyrie Spear's gold
	"spear_show": 0.5,  # TUNING (not in GDD) s a thrown Gungnir shows its flight
}
