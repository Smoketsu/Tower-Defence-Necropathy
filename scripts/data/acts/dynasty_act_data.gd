## Act VII, the Necropolis Dynasty (ActData "dynasty"; GDD §7.3; Necropathy's
## Necropolis Dynasty: docs/dynasty/, the stages necropolis / lioness_temple /
## two_truths, DynastyRules): its enemy kinds (KINDS, keys as TdEnemyData.KINDS
## plus the Dynasty keys below), its build orders (ORDERS), its three map moods
## (MOODS), the numbers of its act rule, Rebirth and the Names
## (RULE, read by scripts/maps/rules/dynasty/rebirth.gd), and its looks (LOOK).
## Every sprite is Necropathy's Dynasty art (assets/sprites/dynasty/). Data only.
##
## Dynasty row keys (absent = off), read by the act rule only:
##   rebirth — true: a body that falls within RULE jar_radius of a standing
##             Canopic Jar leaves a Name and rises again (once) unless the Name
##             is smashed or the jar broken first. Mummies and guards only
##             (Necropathy: "scarabs and animals do not return").
##   embalms — true: every Name within RULE embalm_radius rises faster.
##   markable — true: a tap (or the bot) can mark it like a Canopic Jar, so the
##             towers that reach it shoot only it (Sekhmet's wine jars).
##   blastable — true (a structure): Corpse Explosion's blasts reach it (the Names).
extends RefCounted

## Enemy kinds of the Dynasty (keys: TdEnemyData.KINDS). Traits live in
## scripts/enemies/traits/dynasty/ and scripts/bosses/dynasty/ (each script
## documents its args); the rest reuse the generic and earlier acts' traits.
const KINDS: Dictionary = {
	# The wrapped dead (Necropathy "mummy"): slow, tough fodder that returns.
	"dyn_mummy": {
		"name": "Mummy", "sprite": "dynasty/mummy", "rank": "fodder", "souls": 5,  # TUNING (not in GDD) X2
		"hp": 78.0, "speed": 40.0, "armour": 1.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 7.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {}, "rebirth": true,
	},
	# The wrapped dead, female (Necropathy "mummy_female"): a faster walker that returns.
	"dyn_mummy_runner": {
		"name": "Hurrying Mummy", "sprite": "dynasty/mummy_female", "rank": "fodder", "souls": 5,  # TUNING (not in GDD) X2
		"hp": 56.0, "speed": 58.0, "armour": 0.0, "radius": 9.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {}, "rebirth": true,
	},
	# Sacred scarabs (Necropathy "scarab_swarm"): a fast, thin swarm; beasts do not return.
	"scarab_swarm": {
		"name": "Scarab Swarm", "sprite": "dynasty/scarab_swarm", "rank": "fodder", "souls": 4,  # TUNING (not in GDD) a swarm pays less
		"hp": 40.0, "speed": 74.0, "armour": 0.0, "radius": 9.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 0.7,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Khopesh Guard (Necropathy "khopesh_guard"): the spinning slash cuts every body on the post.
	"khopesh_guard": {
		"name": "Khopesh Guard", "sprite": "dynasty/khopesh_guard", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) soldier tier
		"hp": 170.0, "speed": 44.0, "armour": 3.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 12.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "court/cleave",
		"args": {"cleave": 0.6}, "rebirth": true,  # TUNING (not in GDD) Necropathy "a spinning slash"
	},
	# Nile Archer (Necropathy "nile_archer"): shoots towers and blockers from the column.
	"nile_archer": {
		"name": "Nile Archer", "sprite": "dynasty/nile_archer", "rank": "fodder", "souls": 7,  # TUNING (not in GDD) soldier tier
		"hp": 80.0, "speed": 46.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 5.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 190.0, "interval": 8.0, "target": "any", "damage": 16.0, "disable": 0.6, "cause": "shot", "speed": 520.0, "arc": false, "look": "arrow"},  # TUNING (not in GDD)
	},
	# Heka Priest (Necropathy "heka_priest"): writes a gold glyph on a tower that weakens it.
	"heka_priest": {
		"name": "Heka Priest", "sprite": "dynasty/heka_priest", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) soldier tier
		"hp": 160.0, "speed": 40.0, "armour": 1.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "dynasty/heka",
		"args": {"first": 2.0, "every": 9.0, "range": 190.0, "mult": 0.6, "time": 5.0},  # TUNING (not in GDD) Necropathy: one glyph at a time
	},
	# Embalmer (Necropathy "embalmer"): heals the column and hastens every Name near her.
	"embalmer": {
		"name": "Embalmer", "sprite": "dynasty/embalmer", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) soldier tier
		"hp": 130.0, "speed": 44.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "healer",
		"args": {"heal": 16.0, "interval": 2.6, "radius": 95.0}, "embalms": true,  # TUNING (not in GDD)
	},
	# Jackal Warrior (Necropathy "jackal_warrior"): an elite in pairs; a spear lunge through the post; returns.
	"jackal_warrior": {
		"name": "Jackal Warrior", "sprite": "dynasty/jackal_warrior", "rank": "elite",
		"hp": 400.0, "speed": 54.0, "armour": 2.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 14.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "corsair/lunge",
		"args": {"every": 9.0, "windup": 0.5, "damage": 30.0, "time": 0.6, "speed_mult": 1.8}, "rebirth": true,  # TUNING (not in GDD) Necropathy "a telegraphed lunge"
	},
	# Bastet Hunter (Necropathy "bastet_hunter"): dives into the sand, slipping the posts; spells reveal her.
	"bastet_hunter": {
		"name": "Bastet Hunter", "sprite": "dynasty/bastet_hunter", "rank": "elite",
		"hp": 330.0, "speed": 58.0, "armour": 1.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 13.0, "attack_interval": 0.9,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "dynasty/sand_dive",
		"args": {"first": 2.5, "every": 10.0, "time": 2.5, "speed_mult": 1.5, "hidden_mult": 0.4},  # TUNING (not in GDD) Necropathy "area damage reveals her"
	},
	# Crocodile Warden (Necropathy "crocodile_warden"): a heavy that seizes the body holding it; returns.
	"crocodile_warden": {
		"name": "Crocodile Warden", "sprite": "dynasty/crocodile_warden", "rank": "elite",
		"hp": 720.0, "speed": 32.0, "armour": 4.0, "radius": 15.0,  # TUNING (not in GDD)
		"damage": 20.0, "attack_interval": 1.5,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shogunate/kappa",
		"args": {"grapple_every": 3, "grapple": 1.8}, "rebirth": true,  # TUNING (not in GDD) Necropathy "drags a summon in"
	},
	# Awakening Statue (Necropathy "ushabti_statue"): a stone servant woken from its row; flat armour 7.
	"awakening_statue": {
		"name": "Awakening Statue", "sprite": "dynasty/ushabti_statue", "rank": "elite",
		"hp": 620.0, "speed": 30.0, "armour": 7.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 16.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# --- Structures (the act rule raises the jars; the Names are laid by Rebirth) ---
	# Canopic Jar (Necropathy "canopic_jar"): holds the Names of the dead around it. Tap to aim the towers at it.
	"canopic_jar": {
		"name": "Canopic Jar", "sprite": "dynasty/canopic_jar", "rank": "elite", "structure": true,
		"hp": 560.0, "speed": 0.0, "armour": 2.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": false, "ignores_walls": true, "trait": "", "args": {},
	},
	# A Name: the gold cartouche over a fallen body (Necropathy "cartouche"). Any hit smashes it; not a roster kind.
	"dyn_name": {
		"name": "Name", "sprite": "markers/dyn_cartouche", "rank": "fodder", "structure": true, "souls": 0,  # TUNING (not in GDD) no bounty
		"hp": 30.0, "speed": 0.0, "armour": 0.0, "radius": 8.0,  # TUNING (not in GDD) an arrow or any splash breaks it
		"damage": 0.0, "attack_interval": 1.0, "blastable": true,  # Corpse Explosion reaches it (corpse_explosion.gd)
		"flying": false, "ignores_walls": true, "trait": "", "args": {},
	},
	# Sekhmet's red-wine jar (Necropathy "wine_jar"): she drinks while it stands; break all three and she stumbles.
	"wine_jar": {
		"name": "Red Wine Jar", "sprite": "dynasty/canopic_jar", "rank": "fodder", "structure": true, "souls": 5,  # TUNING (not in GDD)
		"hp": 700.0, "speed": 0.0, "armour": 0.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0, "tint": Color(1.0, 0.45, 0.45), "markable": true,  # the same jar, wine red; a tap aims the towers at it
		"flying": false, "ignores_walls": true, "trait": "", "args": {},
	},
	# --- Minibosses (row HP is real HP, X3) ---
	# Necropolis miniboss: the Sand Colossus. His ground slam stuns the post and blinds the towers near him.
	"sand_colossus": {
		"name": "The Sand Colossus", "sprite": "dynasty/sand_colossus", "rank": "miniboss",
		"hp": 4600.0, "speed": 24.0, "armour": 6.0, "radius": 24.0,  # TUNING (not in GDD)
		"damage": 26.0, "attack_interval": 1.6,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "dynasty/slam",
		"args": {"first": 4.0, "every": 8.0, "radius": 110.0, "windup": 1.3, "disable": 1.6, "body_damage": 55.0},  # TUNING (not in GDD) Necropathy "a ground slam"
	},
	# Temple miniboss: the Lion Warden. Slam, and a roar that drives the column on.
	"lion_warden": {
		"name": "The Lion Warden", "sprite": "dynasty/lion_warden", "rank": "miniboss",
		"hp": 5800.0, "speed": 24.0, "armour": 6.0, "radius": 24.0,  # TUNING (not in GDD)
		"damage": 28.0, "attack_interval": 1.6,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "dynasty/lion_warden",
		"args": {"first": 4.0, "every": 9.0, "radius": 110.0, "windup": 1.3, "disable": 1.4, "body_damage": 60.0,
			"roar_first": 6.0, "roar_every": 12.0, "roar_radius": 220.0, "roar_haste": 1.4, "roar_time": 4.0},  # TUNING (not in GDD) Necropathy: slam and roar
	},
	# Hall miniboss: the Devourer's Whelp. It eats the Names it passes and grows stronger.
	"devourers_whelp": {
		"name": "The Devourer's Whelp", "sprite": "dynasty/devourers_whelp", "rank": "miniboss",
		"hp": 5200.0, "speed": 30.0, "armour": 4.0, "radius": 22.0,  # TUNING (not in GDD)
		"damage": 26.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "dynasty/devour",
		"args": {"reach": 90.0, "every": 1.5, "heal": 0.04, "haste": 1.08, "haste_max": 1.5, "haste_time": 30.0},  # TUNING (not in GDD) Necropathy "eats corpses"
	},
	# --- Bosses ---
	# Necropolis boss: Anubis, Opener of the Way. The Procession, the Embalmer, the Jackal.
	"anubis": {
		"name": "Anubis, Opener of the Way", "sprite": "dynasty/anubis", "rank": "boss",
		"hp": 15500.0, "speed": 22.0, "armour": 4.0, "radius": 24.0,  # TUNING (not in GDD)
		"damage": 30.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "dynasty/anubis",
		"args": {"embalm_hp": 0.66, "jackal_hp": 0.33,
			"march_first": 3.0, "march_every": 11.0, "marchers": 5, "march_kind": "dyn_mummy", "march_gap": 26.0,
			"jar_every": 14.0, "jar_ahead": 160.0, "jar_side": 46.0, "embalm_rise": 0.5,
			"lunge_every": 6.0, "lunge_time": 1.0, "lunge_speed": 2.4, "lunge_damage": 70.0, "pose_time": 0.7},  # TUNING (not in GDD) Necropathy's three phases
	},
	# Temple boss: Sekhmet, the Lioness of Retribution. The Hunt, the Red Wind, the Feast.
	"sekhmet": {
		"name": "Sekhmet, the Lioness of Retribution", "sprite": "dynasty/sekhmet", "rank": "boss",
		"hp": 16500.0, "speed": 26.0, "armour": 3.0, "radius": 22.0,  # TUNING (not in GDD)
		"damage": 32.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "dynasty/sekhmet",
		"args": {"wind_hp": 0.66, "feast_hp": 0.33,
			"leap_first": 4.0, "leap_every": 9.0, "leap_px": 150.0, "leap_radius": 90.0, "leap_delay": 0.9, "leap_disable": 1.6, "leap_damage": 60.0,
			"wind_haste": 1.3, "feast_kind": "wine_jar", "feast_ahead": [120.0, 240.0, 360.0], "feast_side": 50.0,
			"feast_mult": 0.15, "drink_every": 4.0, "drink_heal": 0.02, "stumble_time": 5.0, "stumble_mult": 1.5, "feast_cap": 45.0, "pose_time": 0.7},  # TUNING (not in GDD) Necropathy's three phases
	},
	# Hall boss: Osiris, Lord of the Dead, and Ammit the Devourer: one body, one health bar.
	"osiris": {
		"name": "Osiris and Ammit", "sprite": "dynasty/osiris", "rank": "boss",
		"hp": 18000.0, "speed": 18.0, "armour": 4.0, "radius": 24.0,  # TUNING (not in GDD)
		"damage": 34.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "dynasty/osiris",
		"args": {"ammit_hp": 0.4,
			"judge_first": 4.0, "judge_every": 10.0, "glyphs": 3, "glyph_range": 260.0, "glyph_mult": 0.55, "glyph_time": 6.0,
			"court_every": 14.0, "court": [["khopesh_guard", 3], ["embalmer", 2]], "court_gap": 26.0, "weigh_rise": 0.6,
			"ammit_sprite": "dynasty/ammit", "ammit_speed": 1.7, "eat_reach": 140.0, "eat_every": 1.0, "eat_heal": 0.01,
			"charge_every": 7.0, "charge_time": 1.0, "charge_speed": 2.6, "charge_damage": 90.0, "pose_time": 0.7},  # TUNING (not in GDD) Necropathy: the Judge, the Weighing, the Devourer
	},
}

## Build orders of the Dynasty maps (keys: BuildOrderData.ORDERS): each map's
## default (must win on Necromancer) and weak order (must lose), and one kit
## order for every Act VII map ("dynasty_kit": Ushabti Sentinels on the posts
## and an Eternal Guard, the act spells, Answering Words beside the Mages).
const ORDERS: Dictionary = {
	"necropolis_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:4", "tower": "archer"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "plot:3", "tower": "archer"},
			{"do": "build", "spot": "plot:8", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:5", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:5", "mode": "strongest"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:9", "tower": "mage"},
			{"do": "build", "spot": "plot:7", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:1", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "build", "spot": "post:0", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:10", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:14", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:14", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:12", "tower": "mage"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "post:0"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:11", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:11"},
		],
	},
	"necropolis_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:4", "tower": "archer"},
		],
	},
	"lioness_temple_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "plot:3", "tower": "archer"},
			{"do": "build", "spot": "plot:4", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:5", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:5", "mode": "strongest"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:10", "tower": "mage"},
			{"do": "build", "spot": "plot:11", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:9", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "post:4", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:6", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:12", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:12", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:15", "tower": "mage"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:7", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:7"},
		],
	},
	"lioness_temple_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:2", "tower": "archer"},
		],
	},
	"two_truths_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
			{"do": "build", "spot": "post:4", "tower": "warrior"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "build", "spot": "plot:5", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:8", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:8", "mode": "strongest"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:4", "tower": "mage"},
			{"do": "build", "spot": "plot:6", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:0", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "post:5", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:7", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:9", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:9", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:3", "tower": "mage"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "post:5"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "plot:13", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:13"},
		],
	},
	"two_truths_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
		],
	},
	"dynasty_kit": {
		"spells": true,
		"loadout": ["linen_bind", "burning_eye", "feathers_verdict"],
		"steps_by_map": {
			"necropolis": [
				{"do": "build", "spot": "plot:4", "tower": "archer"},
				{"do": "build", "spot": "post:2", "tower": "ushabti_sentinel"},
				{"do": "build", "spot": "plot:3", "tower": "archer"},
				{"do": "build", "spot": "plot:8", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:5", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:5", "mode": "strongest"},
				{"do": "build", "spot": "post:3", "tower": "ushabti_sentinel"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:9", "tower": "mage"},
				{"do": "build", "spot": "plot:7", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:1", "tower": "banshee"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "build", "spot": "post:0", "tower": "ushabti_sentinel"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:10", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "evolve", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:14", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:14", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:12", "tower": "mage"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "post:0"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "build", "spot": "post:1", "tower": "ushabti_sentinel"},
				{"do": "build", "spot": "plot:11", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:11"},
			],
			"lioness_temple": [
				{"do": "build", "spot": "plot:2", "tower": "archer"},
				{"do": "build", "spot": "post:2", "tower": "ushabti_sentinel"},
				{"do": "build", "spot": "plot:3", "tower": "archer"},
				{"do": "build", "spot": "plot:4", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:5", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:5", "mode": "strongest"},
				{"do": "build", "spot": "post:3", "tower": "ushabti_sentinel"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:10", "tower": "mage"},
				{"do": "build", "spot": "plot:11", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:9", "tower": "banshee"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "build", "spot": "post:4", "tower": "ushabti_sentinel"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:6", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "evolve", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:12", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:12", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:15", "tower": "mage"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "build", "spot": "post:0", "tower": "ushabti_sentinel"},
				{"do": "build", "spot": "post:1", "tower": "ushabti_sentinel"},
				{"do": "build", "spot": "plot:7", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:7"},
			],
			"two_truths": [
				{"do": "build", "spot": "plot:1", "tower": "archer"},
				{"do": "build", "spot": "post:4", "tower": "ushabti_sentinel"},
				{"do": "build", "spot": "plot:2", "tower": "archer"},
				{"do": "build", "spot": "plot:5", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:8", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:8", "mode": "strongest"},
				{"do": "build", "spot": "post:2", "tower": "ushabti_sentinel"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:4", "tower": "mage"},
				{"do": "build", "spot": "plot:6", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "plot:0", "tower": "banshee"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "post:5", "tower": "ushabti_sentinel"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "plot:7", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "evolve", "spot": "post:4"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:9", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:9", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "plot:3", "tower": "mage"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "post:5"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "build", "spot": "post:3", "tower": "ushabti_sentinel"},
				{"do": "build", "spot": "post:0", "tower": "ushabti_sentinel"},
				{"do": "build", "spot": "plot:13", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:13"},
			],
		},
	},
}

## Battlefield moods of the three maps (keys: TdMoodData.MOODS).
const MOODS: Dictionary = {
	"necropolis": {
		"props": [{"sprite": "obstacles/dyn_brazier", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(1.0, 0.6, 0.25, 0.6), "glow_r": 66.0,
			"glow_at": Vector2(0, -18), "flicker": 0.25, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) tomb braziers
		"fog": 2,  # TUNING (not in GDD) blown sand over the dunes
		"pools": 0,
	},
	"lioness_temple": {
		"props": [{"sprite": "obstacles/dyn_brazier", "frames": 1, "count": 5, "scale": 1.0, "glow": Color(1.0, 0.5, 0.25, 0.65), "glow_r": 70.0,
			"glow_at": Vector2(0, -18), "flicker": 0.3, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) the lioness's fire bowls
		"fog": 1,  # TUNING (not in GDD)
		"pools": 0,
	},
	"two_truths": {
		"props": [{"art": "mood_candles", "frames": 1, "count": 6, "scale": 1.0, "glow": Color(1.0, 0.85, 0.5, 0.5), "glow_r": 40.0,
			"glow_at": Vector2(0, -18), "flicker": 0.15, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) offering lamps before the throne
			{"sprite": "obstacles/dyn_brazier", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(0.55, 0.9, 1.0, 0.55), "glow_r": 64.0,
			"glow_at": Vector2(0, -18), "flicker": 0.2, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) the hall's blue judgment fires
		"fog": 0,
		"pools": 2,  # TUNING (not in GDD) light from the hall's high windows
	},
}

## Canopic Jars beside each map's road at the start: map id -> [map px, ...]
## (Structures.raise() stands each on the nearest road's side).
const JARS: Dictionary = {
	"necropolis": [Vector2(470, 195), Vector2(1090, 270), Vector2(520, 345), Vector2(180, 335), Vector2(860, 645)],  # TUNING (not in GDD) Necropathy: jars beside the tombs
	"lioness_temple": [Vector2(430, 235), Vector2(850, 150), Vector2(690, 300), Vector2(960, 465), Vector2(380, 645)],  # TUNING (not in GDD)
	"two_truths": [Vector2(420, 175), Vector2(1050, 420), Vector2(850, 605), Vector2(230, 360), Vector2(780, 465)],  # TUNING (not in GDD)
}

## Rebirth and the Names, the Sandstorm and the Scales
## (scripts/maps/rules/dynasty/rebirth.gd). Simulation first, then the look.
const RULE: Dictionary = {
	"jar_radius": 230.0,  # TUNING (not in GDD) px around a jar whose fallen leave a Name (Necropathy 300 on its larger stage)
	"rise_time": 6.0,  # TUNING (not in GDD) s a Name waits before its body rises (Necropathy 6 s)
	"return_hp": 0.7,  # Necropathy: "the body returns at 70% HP"
	"max_names": 40,  # TUNING (not in GDD) Names alive at once (more fallen simply stay dead)
	"embalm_radius": 100.0,  # TUNING (not in GDD) px around an Embalmer whose Names hasten
	"embalm_speed": 2.0,  # Necropathy REBIRTH embalm_speed x2
	"bot_names": 4,  # TUNING (not in GDD) the autotest bot marks a jar that holds this many Names
	"reborn_tint": Color(1.0, 0.85, 0.45),  # TUNING (not in GDD) a returned body's gold (drawn only)
	# The Sandstorm (Necropathy's Sandstorm: "range and sight cut while it blows").
	"storms": {
		"necropolis": {"from_wave": 8, "every": 40.0},  # TUNING (not in GDD) wave it starts, s between bands
		"lioness_temple": {"from_wave": 5, "every": 32.0},  # TUNING (not in GDD) the temple's storms come often
		"two_truths": {"from_wave": 10, "every": 45.0},  # TUNING (not in GDD)
	},
	"storm_first": 6.0,  # TUNING (not in GDD) s after the storm wave starts that the first band gathers
	"storm_warn": 3.0,  # TUNING (not in GDD) s a band gathers at the map's edge before it moves (the telegraph)
	"storm_width": 220.0,  # TUNING (not in GDD) px wide
	"storm_speed": 80.0,  # TUNING (not in GDD) px/s across the map
	"storm_sight": 0.5,  # TUNING (not in GDD) share of its range a tower inside the band still sees
	# The Scales (the Hall of Two Truths; Necropathy's TruthScales).
	"scales_maps": ["two_truths"],  # maps whose run keeps the Scales
	"scale_max": 30.0,  # TUNING (not in GDD) its ends
	"scale_mark": 12.0,  # TUNING (not in GDD) past this either way it tips the run
	"tip_return": 2.0,  # TUNING (not in GDD) toward the Dynasty per return
	"tip_smash": 1.0,  # TUNING (not in GDD) toward the necromancer per smashed Name
	"tip_jar": 4.0,  # TUNING (not in GDD) toward the necromancer per broken jar
	"scale_hp_dynasty": 1.15,  # TUNING (not in GDD) x HP of every new spawn on the Dynasty's side (Necropathy +-15%)
	"scale_hp_player": 0.9,  # TUNING (not in GDD) x HP on the necromancer's side
	"scale_rise_dynasty": 0.7,  # TUNING (not in GDD) x the Names' wait on the Dynasty's side (Necropathy "2 s sooner")
	"scale_rise_player": 1.4,  # TUNING (not in GDD) x it on the necromancer's side
}

## The act's looks (drawing only; read by its rule, traits, bosses and spells).
const LOOK: Dictionary = {
	"gold": Color(0.95, 0.78, 0.3),  # TUNING (not in GDD) the Dynasty's dull gold (Names, links, glyphs)
	"sand": Color(0.86, 0.72, 0.48),  # TUNING (not in GDD) sand puffs and the storm
	"player_side": Color(0.4, 0.95, 0.85),  # TUNING (not in GDD) soul-teal: the necromancer's side of the Scales
	"hidden_tint": Color(0.85, 0.75, 0.55, 0.35),  # TUNING (not in GDD) a Bastet Hunter in the sand (faded)
	"roar_tint": Color(1.0, 0.6, 0.3, 0.9),  # TUNING (not in GDD) the Lion Warden's roar ring
	"link_w": 6.0,  # TUNING (not in GDD) px of a jar-to-Name thread
	"link_a": 0.55,  # TUNING (not in GDD) its alpha
	"timer_w": 20.0,  # TUNING (not in GDD) px of a Name's rise bar
	"timer_y": 12.0,  # TUNING (not in GDD) px below the Name it hangs
	"mark_r": 30.0,  # TUNING (not in GDD) px of the marked jar's ring
	"tap_radius": 22.0,  # TUNING (not in GDD) px around a jar a tap picks it
	"storm_a": 0.42,  # TUNING (not in GDD) the sand band's alpha
	"storm_puff": 90.0,  # TUNING (not in GDD) px between sand puffs down the band
	"glyph_d": 56.0,  # TUNING (not in GDD) px of a Heka glyph burst over a tower
	"scales_w": 120.0,  # TUNING (not in GDD) px of the HUD Scales
	"scales_margin": Vector2(10.0, 8.0),  # TUNING (not in GDD) px from the screen's right edge / under the top bar
	"scales_art_y": 30.0,  # TUNING (not in GDD) px down to the scales sprite's centre
	"scales_bar_y": 62.0,  # TUNING (not in GDD) px down to the balance bar
	# --- The act spells ---
	"eye_d": 26.0,  # TUNING (not in GDD) px of Burning Eye's eye
	"eye_pupil": Color(0.15, 0.85, 0.75),  # TUNING (not in GDD) its soul-teal pupil
	"feather_lift": 120.0,  # TUNING (not in GDD) px Feather's Verdict's feather falls from
}
