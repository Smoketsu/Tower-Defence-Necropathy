## The Black Tide's data (ActData "corsair", Act II; GDD §7.3 "Broadsides:
## deck cannons shell plots on a telegraph"): pirates of Necropathy's Black
## Tide boarding the necromancer's ship. Acts merges KINDS (enemy rows, keys
## as TdEnemyData.KINDS), ORDERS (build orders, keys as BuildOrderData.ORDERS)
## and MOODS (mood rows, keys as TdMoodData.MOODS); the act rule
## (scripts/maps/rules/corsair/broadsides.gd) reads RULE and BROADSIDES. Sprites
## are Necropathy's Black Tide art (assets/sprites/corsair/, docs/tide/
## ART_MANIFEST.md there). Every number is TUNING until the balance pass (the
## source rows are Necropathy's CorsairEnemyData and stage data, rescaled for
## the road). Data only, no logic.
##
## Extra kind row key used here (read by TdEnemy._draw_body, drawn only):
##   tint — optional Color multiplied into the sprite (the Maelstrom's ghost crew
##          reuse the living crew's art in spectral green).
extends RefCounted

## Spectral green of the ghost crew (Necropathy's `spectre` ramp, drawn only).
const GHOST_TINT: Color = Color(0.55, 1.15, 0.95, 0.85)  # TUNING (not in GDD)

## Enemy kinds of the Black Tide (keys: TdEnemyData.KINDS).
const KINDS: Dictionary = {
	# --- The Brotherhood (shared by the three maps) ---
	# Necropathy deckhand: cutlass fodder off the boats.
	"tide_deckhand": {
		"name": "Deckhand", "sprite": "corsair/deckhand", "rank": "fodder",
		"hp": 62.0, "speed": 54.0, "armour": 1.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Necropathy musketeer: shoots the blockers from range (the ball also stops on the first body in its way).
	"tide_musketeer": {
		"name": "Musketeer", "sprite": "corsair/musketeer", "rank": "fodder",
		"hp": 55.0, "speed": 48.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 190.0, "interval": 4.0, "target": "body", "damage": 10.0, "disable": 0.0, "cause": "shot", "speed": 420.0, "arc": false, "look": "musket"},  # TUNING (not in GDD)
	},
	# Necropathy powder runner: a lit keg; held by a blocker it bursts on both sides.
	"tide_powder_runner": {
		"name": "Powder Runner", "sprite": "corsair/powder_runner", "rank": "fodder",
		"hp": 50.0, "speed": 78.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "corsair/powder_runner",
		"args": {
			"fuse": 0.9,  # TUNING (not in GDD) s from being held to the blast
			"radius": 62.0,  # TUNING (not in GDD) px of the blast
			"body_damage": 40.0,  # TUNING (not in GDD) to every blocker body in it
			"enemy_damage": 30.0,  # TUNING (not in GDD) to every other enemy in it (both sides, Necropathy)
		},
	},
	# Necropathy swashbuckler (female, figure style): a rapier lunge past the post that holds her.
	"tide_swashbuckler": {
		"name": "Swashbuckler", "sprite": "corsair/swashbuckler", "rank": "elite",
		"hp": 200.0, "speed": 56.0, "armour": 1.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 11.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "corsair/lunge",
		"args": {
			"every": 6.5,  # TUNING (not in GDD) s between lunges (Necropathy 5)
			"windup": 0.4,  # TUNING (not in GDD) s she draws back while held
			"damage": 22.0,  # TUNING (not in GDD) to the body she lunges through
			"time": 0.6,  # TUNING (not in GDD) s she cannot be held after it
			"speed_mult": 2.2,  # TUNING (not in GDD) her speed meanwhile
		},
	},
	# Necropathy grappler: throws his hook over the blockers at a tower and pulls it off its guard.
	"tide_grappler": {
		"name": "Grappler", "sprite": "corsair/grappler", "rank": "elite",
		"hp": 150.0, "speed": 50.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 5.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 170.0, "interval": 9.0, "target": "tower", "damage": 0.0, "disable": 2.5, "cause": "hooked", "speed": 340.0, "arc": true, "look": "hook"},  # TUNING (not in GDD) Necropathy grapple every 7.5 s
	},
	# Necropathy boatswain: a bellow that speeds and shields his crew (Necropathy +20% speed, 200 px).
	"tide_boatswain": {
		"name": "Boatswain", "sprite": "corsair/boatswain", "rank": "elite",
		"hp": 210.0, "speed": 46.0, "armour": 1.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 5.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "corsair/bellow",
		"args": {
			"every": 8.0,  # Necropathy bellow every 8 s
			"radius": 160.0,  # TUNING (not in GDD) px (Necropathy 200 on the open deck)
			"speed_mult": 1.2,  # Necropathy +20% speed
			"ward": 0.75,  # TUNING (not in GDD) damage taken x this meanwhile (Necropathy's shield)
			"time": 4.0,  # Necropathy 4 s
		},
	},
	# Necropathy gunnery mate (female, figure style): lobs grenadoes over the blockers at towers;
	# while one lives the broadsides fire faster (the act rule's crew).
	"tide_gunnery_mate": {
		"name": "Gunnery Mate", "sprite": "corsair/gunnery_mate", "rank": "elite",
		"hp": 170.0, "speed": 50.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 230.0, "interval": 6.0, "target": "tower", "damage": 0.0, "disable": 2.0, "cause": "shelled", "speed": 260.0, "arc": true, "look": "grenado"},  # TUNING (not in GDD) Necropathy lob every 4.4 s
	},
	# Necropathy voodoo navigator (female, figure style): marks a tower; the sea strikes it after a telegraph.
	"tide_voodoo_navigator": {
		"name": "Voodoo Navigator", "sprite": "corsair/voodoo_navigator", "rank": "elite",
		"hp": 190.0, "speed": 46.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "corsair/sea_mark",
		"args": {
			"every": 9.0,  # TUNING (not in GDD) s between marks
			"reach": 220.0,  # TUNING (not in GDD) px to the marked tower
			"telegraph": 1.5,  # Necropathy "the sea strikes it 1.5 s later"
			"radius": 46.0,  # TUNING (not in GDD) px of the strike
			"disable": 3.0,  # TUNING (not in GDD) s the struck towers are disabled
		},
	},
	# Necropathy boarding bruiser: armour 3, an axe that cleaves two blockers in a line.
	"tide_boarding_bruiser": {
		"name": "Boarding Bruiser", "sprite": "corsair/boarding_bruiser", "rank": "elite",
		"hp": 560.0, "speed": 36.0, "armour": 3.0, "radius": 14.0,  # Necropathy flat armour 3; rest TUNING (not in GDD)
		"damage": 16.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "lash",
		"args": {"reach": 40.0, "second_mult": 0.8},  # TUNING (not in GDD) px to the second body, its damage share
	},
	# Necropathy hull crab: climbs the hull, armour 4 (here 5), the shell takes frontal hits.
	"tide_hull_crab": {
		"name": "Hull Crab", "sprite": "corsair/hull_crab", "rank": "elite",
		"hp": 360.0, "speed": 34.0, "armour": 5.0, "radius": 15.0,  # TUNING (not in GDD)
		"damage": 12.0, "attack_interval": 1.5,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shield_front",
		"args": {
			"front_mult": 0.6,  # TUNING (not in GDD) share of a frontal hit that gets through the shell
			"ignore": ["corpse_catapult", "powder_wraith"],  # TUNING (not in GDD) lobbed boulders and kegs land on top
		},
	},
	# Necropathy gunboat: never boards; sails the sea lane and shells towers from range.
	"tide_gunboat": {
		"name": "Gunboat", "sprite": "corsair/gunboat", "rank": "elite",
		"hp": 700.0, "speed": 30.0, "armour": 2.0, "radius": 22.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": false, "ignores_walls": true, "trait": "shooter",
		"args": {"range": 260.0, "interval": 4.5, "target": "tower", "damage": 0.0, "disable": 2.5, "cause": "shelled", "speed": 300.0, "arc": true, "look": "cannon"},  # TUNING (not in GDD)
	},
	# Necropathy sea serpent: rises from the sea lane and spits at towers and blockers.
	"tide_sea_serpent": {
		"name": "Sea Serpent", "sprite": "corsair/sea_serpent", "rank": "elite",
		"hp": 900.0, "speed": 34.0, "armour": 2.0, "radius": 20.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": false, "ignores_walls": true, "trait": "shooter",
		"args": {"range": 230.0, "interval": 3.5, "target": "any", "damage": 22.0, "disable": 1.6, "cause": "grabbed", "speed": 380.0, "arc": false, "look": "spit"},  # TUNING (not in GDD)
	},
	# --- The Maelstrom's ghost crew (Necropathy ghost_deckhand / ghost_gunner, spectral tint) ---
	"tide_ghost_deckhand": {
		"name": "Drowned Deckhand", "sprite": "corsair/deckhand", "rank": "fodder", "tint": GHOST_TINT,
		"hp": 72.0, "speed": 60.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 7.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	"tide_ghost_gunner": {
		"name": "Drowned Gunner", "sprite": "corsair/musketeer", "rank": "fodder", "tint": GHOST_TINT,
		"hp": 64.0, "speed": 50.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 200.0, "interval": 3.6, "target": "body", "damage": 10.0, "disable": 0.0, "cause": "shot", "speed": 360.0, "arc": false, "look": "spectral"},  # TUNING (not in GDD)
	},
	# --- The act rule's structures and Marrec's coins ---
	# A deck cannon run out at the rail (the Broadsides; the act rule raises them per BROADSIDES).
	"tide_deck_cannon": {
		"name": "Deck Cannon", "sprite": "obstacles/deck_cannon_l", "rank": "elite", "structure": true,
		"hp": 950.0, "speed": 0.0, "armour": 4.0, "radius": 16.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": false, "ignores_walls": true, "trait": "", "args": {},
	},
	# Powder barrels lashed beside a cannon: one shot sets them off (the Broadsides' counter). Not a structure:
	# towers and splash hit them like any foe (the act rule clears leftovers when the map ends).
	"tide_powder_keg": {
		"name": "Powder Barrels", "sprite": "obstacles/deck_barrels_s", "rank": "fodder",
		"hp": 45.0, "speed": 0.0, "armour": 0.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": false, "ignores_walls": true, "trait": "", "args": {},
	},
	# Marrec's cursed coins (Gold Fever): standing still on the road, each one near her cuts her damage taken.
	"tide_cursed_coin": {
		"name": "Cursed Coin", "sprite": "corsair/cursed_coin", "rank": "fodder",
		"hp": 60.0, "speed": 0.0, "armour": 0.0, "radius": 8.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": false, "ignores_walls": true, "trait": "corsair/cursed_coin",
		"args": {"life": 14.0},  # TUNING (not in GDD) s before an unbroken coin sinks into the deck
	},
	# --- Minibosses (their death drops the chest) ---
	# The Cutter's miniboss: Bosun Gorran's chain sweep and bellow (Necropathy BosunGorranKit).
	"bosun_gorran": {
		"name": "Bosun Gorran", "sprite": "corsair/bosun_gorran", "rank": "miniboss",
		"hp": 2300.0, "speed": 26.0, "armour": 5.0, "radius": 20.0,  # TUNING (not in GDD)
		"damage": 24.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "corsair/gorran",
		"args": {
			"sweep_every": 7.0,  # TUNING (not in GDD) s between chain sweeps
			"sweep_windup": 0.8,  # TUNING (not in GDD) s the chain whirls (telegraph ring)
			"sweep_radius": 72.0,  # TUNING (not in GDD) px
			"sweep_damage": 40.0,  # TUNING (not in GDD) to every blocker body in it
			"bellow_every": 10.0,  # TUNING (not in GDD) s between bellows
			"bellow_radius": 180.0,  # TUNING (not in GDD) px
			"bellow_speed": 1.3,  # TUNING (not in GDD) crew speed multiplier
			"bellow_ward": 1.0,  # Necropathy: his bellow has no shield
			"bellow_time": 4.0,  # TUNING (not in GDD) s
		},
	},
	# The Galleon's miniboss: Old Hollow-Eye, the kraken; its tentacles seize towers (Necropathy OldHollowEyeKit).
	"old_hollow_eye": {
		"name": "Old Hollow-Eye", "sprite": "corsair/old_hollow_eye", "rank": "miniboss",
		"hp": 1450.0, "speed": 22.0, "armour": 4.0, "radius": 26.0,  # TUNING (not in GDD)
		"damage": 28.0, "attack_interval": 1.5,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "corsair/hollow_eye",
		"args": {
			"first": 3.0,  # TUNING (not in GDD) s after it arrives before the first grab
			"every": 8.0,  # TUNING (not in GDD) s between tentacle grabs
			"reach": 260.0,  # TUNING (not in GDD) px to the seized tower
			"telegraph": 1.2,  # TUNING (not in GDD) s the tentacle's circle shows
			"radius": 48.0,  # TUNING (not in GDD) px of the grab
			"disable": 3.0,  # TUNING (not in GDD) s a seized tower is held
			"body_damage": 30.0,  # TUNING (not in GDD) to blocker bodies in the circle
		},
	},
	# The Maelstrom's miniboss: the Ghost Bosun, whose whistle calls a spectral longboat (Necropathy GhostBosunKit).
	"ghost_bosun": {
		"name": "The Ghost Bosun", "sprite": "corsair/ghost_bosun", "rank": "miniboss", "tint": GHOST_TINT,
		"hp": 1800.0, "speed": 30.0, "armour": 3.0, "radius": 16.0,  # TUNING (not in GDD)
		"damage": 22.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "corsair/ghost_bosun",
		"args": {
			"first": 4.0,  # TUNING (not in GDD) s before the first whistle
			"every": 14.0,  # TUNING (not in GDD) s between whistles
			"windup": 1.0,  # TUNING (not in GDD) s he stands with the whistle at his lips
			"crew": 4,  # TUNING (not in GDD) drowned deckhands per longboat
			"gunners": 2,  # TUNING (not in GDD) drowned gunners per longboat
			"road": "grapple",  # the road the longboat's crew boards by (missing: his own road's entrance)
			"gap": 24.0,  # TUNING (not in GDD) px between boarders
		},
	},
	# --- Bosses ---
	# The Cutter's boss: Captain Ezekiel Crow, the Gull King (Necropathy BossCrow: Broadside, the Leap, the Fire Ship).
	"crow": {
		"name": "Captain Crow, the Gull King", "sprite": "corsair/crow", "rank": "boss",
		"hp": 7000.0, "speed": 21.0, "armour": 6.0, "radius": 26.0,  # TUNING (not in GDD)
		"damage": 30.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "corsair/crow",
		"args": {
			"broadside_first": 5.0,  # TUNING (not in GDD) s after he arrives
			"broadside_every": 16.0,  # TUNING (not in GDD) s between his sloop's broadsides (Necropathy 20)
			"telegraph": 1.0,  # TUNING (not in GDD) s he points his cutlass (windup pose)
			"shells": 3,  # Necropathy three cannon lines: here the three towers nearest him
			"shell_delay": 1.5,  # Necropathy 1.5 s telegraph
			"shell_radius": 52.0,  # TUNING (not in GDD) px
			"shell_disable": 3.0,  # TUNING (not in GDD) s
			"leap_first": 6.0,  # TUNING (not in GDD) s before his first leap
			"leap_every": 12.0,  # TUNING (not in GDD) s between leaps (Necropathy 9)
			"leap_range": 110.0,  # TUNING (not in GDD) px ahead at which he leaps over a post
			"leap_windup": 0.6,  # TUNING (not in GDD) s he crouches
			"leap_damage": 120.0,  # TUNING (not in GDD) to every body of the post he lands on
			"leap_dist": 90.0,  # TUNING (not in GDD) px he lands past the post
			"fire_hp": 0.4,  # Necropathy "below 40%": the Fire Ship
			"fire_mult": 0.6,  # TUNING (not in GDD) his clocks x this in the Fire Ship
			"pose_time": 0.6,  # TUNING (not in GDD) s a strike pose shows
		},
	},
	# The Galleon's boss: Admiral Isabeau Marrec, the Sea Wolf (Necropathy BossMarrec: the Fleet, the Boarding, the lunge, Gold Fever).
	"marrec": {
		"name": "Admiral Marrec, the Sea Wolf", "sprite": "corsair/marrec", "rank": "boss",
		"hp": 8000.0, "speed": 21.0, "armour": 5.0, "radius": 22.0,  # TUNING (not in GDD)
		"damage": 28.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "corsair/marrec",
		"args": {
			"fleet_hp": 0.8,  # Necropathy: the Fleet ends below 80% HP
			"fleet_every": 12.0,  # TUNING (not in GDD) s between her flagship's broadsides
			"fleet_shells": 2,  # TUNING (not in GDD) towers shelled each broadside
			"shell_delay": 1.5,  # TUNING (not in GDD) s telegraph
			"shell_radius": 50.0,  # TUNING (not in GDD) px
			"shell_disable": 3.0,  # TUNING (not in GDD) s
			"marines": [{"kind": "tide_deckhand", "count": 6}, {"kind": "tide_swashbuckler", "count": 2}],  # TUNING (not in GDD) the Boarding (Necropathy 6 marines)
			"marine_road": "grapple",  # the road her marines board by (missing: the first entrance)
			"marine_gap": 22.0,  # TUNING (not in GDD) px between marines
			"lunge_every": 5.5,  # Necropathy lunge every 5.5 s
			"lunge_damage": 70.0,  # TUNING (not in GDD) to the body she lunges through
			"lunge_time": 0.9,  # TUNING (not in GDD) s unholdable after it
			"lunge_speed": 2.4,  # TUNING (not in GDD) speed multiplier meanwhile
			"gold_hp": 0.4,  # Necropathy "below 40%": Gold Fever
			"coin_every": 10.0,  # Necropathy every 10 s
			"coins": 4,  # TUNING (not in GDD) coins a scatter (Necropathy 6)
			"coin_spread": 34.0,  # TUNING (not in GDD) px between coins along the road around her
			"coin_reach": 140.0,  # TUNING (not in GDD) px within which a coin shields her
			"coin_cut": 0.12,  # Necropathy 12% per coin
			"coin_cap": 0.5,  # Necropathy at most 50%
			"pose_time": 0.6,  # TUNING (not in GDD) s a pose shows
		},
	},
	# The Maelstrom's boss: Captain Cornelius Vandermere at his wheel (Necropathy BossVandermere: Dead Men's Oath, the Crew, the lantern volley, the Maelstrom).
	"vandermere": {
		"name": "Captain Vandermere", "sprite": "corsair/vandermere", "rank": "boss",
		"hp": 8500.0, "speed": 20.0, "armour": 4.0, "radius": 26.0,  # TUNING (not in GDD)
		"damage": 30.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "corsair/vandermere",
		"args": {
			"oath_taken": 0.35,  # TUNING (not in GDD) damage taken x this while the Oath holds (Necropathy oath_taken)
			"oath_chip": 0.06,  # TUNING (not in GDD) Oath lost per enemy killed while he is on the map (the crew's souls claimed)
			"vulnerable_taken": 1.4,  # TUNING (not in GDD) damage taken x this while broken
			"vulnerable_time": 12.0,  # TUNING (not in GDD) s broken (Necropathy 15)
			"crew_first": 6.0,  # TUNING (not in GDD) s before his first crew call
			"crew_every": 16.0,  # TUNING (not in GDD) s between crew calls
			"crew_cast": 1.0,  # TUNING (not in GDD) s he calls (windup pose)
			"crew": [{"kind": "tide_ghost_deckhand", "count": 4}, {"kind": "tide_ghost_gunner", "count": 2}],  # TUNING (not in GDD)
			"crew_road": "grapple",  # the road his crew boards by (missing: the first entrance)
			"crew_gap": 24.0,  # TUNING (not in GDD) px between boarders
			"volley_every": 7.0,  # TUNING (not in GDD) s between lantern volleys
			"volley_count": 3,  # TUNING (not in GDD) spectral shots at the nearest towers
			"volley_range": 240.0,  # TUNING (not in GDD) px
			"volley_disable": 2.0,  # TUNING (not in GDD) s per tower struck
			"volley_speed": 320.0,  # TUNING (not in GDD) px/s of a spectral shot
			"maelstrom_hp": 0.4,  # Necropathy phase2_hp: the Maelstrom
			"kraken_every": 8.0,  # TUNING (not in GDD) s between kraken strikes in the Maelstrom
			"kraken_radius": 56.0,  # TUNING (not in GDD) px
			"kraken_telegraph": 1.3,  # TUNING (not in GDD) s
			"kraken_disable": 4.0,  # TUNING (not in GDD) s
			"kraken_body_damage": 50.0,  # TUNING (not in GDD)
			"pose_time": 0.8,  # TUNING (not in GDD) s a pose shows
		},
	},
}

## Build orders of the Black Tide (keys: BuildOrderData.ORDERS): per map a
## default order (Act I towers and Act I's unlocks; must win on Necromancer) and
## a weak one (must lose); tide_kit plays the act tower and the act spells.
const ORDERS: Dictionary = {
	"cutter_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:4", "tower": "archer"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "build", "spot": "plot:3", "tower": "archer"},
			{"do": "build", "spot": "plot:6", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:2", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:2", "mode": "strongest"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:5", "tower": "mage"},
			{"do": "build", "spot": "plot:9", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:13", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "post:4", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:14", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:10", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:10", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "evolve", "spot": "plot:4"},
			{"do": "build", "spot": "plot:11", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "evolve", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "evolve", "spot": "plot:6"},
			{"do": "evolve", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:13"},
		],
	},
	"galleon_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:5", "tower": "archer"},
			{"do": "build", "spot": "post:4", "tower": "warrior"},
			{"do": "build", "spot": "plot:7", "tower": "archer"},
			{"do": "build", "spot": "plot:14", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:6", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:6", "mode": "strongest"},
			{"do": "build", "spot": "post:5", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:4", "tower": "mage"},
			{"do": "build", "spot": "plot:3", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:13", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "post:3", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:10", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:17", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:17", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:17"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "evolve", "spot": "plot:5"},
			{"do": "build", "spot": "plot:2", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:17"},
			{"do": "evolve", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:17"},
			{"do": "upgrade", "spot": "post:5"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "evolve", "spot": "plot:14"},
			{"do": "evolve", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:13"},
		],
	},
	"maelstrom_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:14", "tower": "archer"},
			{"do": "build", "spot": "post:5", "tower": "warrior"},
			{"do": "build", "spot": "plot:15", "tower": "archer"},
			{"do": "build", "spot": "plot:13", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "build", "spot": "plot:12", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:12", "mode": "strongest"},
			{"do": "build", "spot": "post:4", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "build", "spot": "plot:7", "tower": "mage"},
			{"do": "build", "spot": "plot:5", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "build", "spot": "plot:9", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "post:3", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "build", "spot": "plot:8", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "post:5"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "build", "spot": "plot:6", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:6", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "evolve", "spot": "plot:14"},
			{"do": "build", "spot": "plot:16", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "evolve", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "evolve", "spot": "plot:13"},
			{"do": "evolve", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:9"},
		],
	},
	"cutter_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:4", "tower": "archer"},
		],
	},
	"galleon_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:4", "tower": "archer"},
		],
	},
	"maelstrom_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:14", "tower": "archer"},
		],
	},
	# The act tower, its evolution and synergy and the act spells on every Black Tide map (ACT_TEMPLATE step 10).
	"tide_kit": {
		"spells": true,
		"bonus_souls": 300,  # TUNING (not in GDD)
		"loadout": ["chain_shot", "cannonade", "anchor_drop"],
		"steps": [],
		"steps_by_map": {
			"cutter": [  # the act tower first, then the map's default order (its evolutions after 30 steps, none of the default's)
				{"do": "build", "spot": "plot:4", "tower": "powder_wraith"},
				{"do": "build", "spot": "post:3", "tower": "abomination"},
				{"do": "build", "spot": "plot:3", "tower": "archer"},
				{"do": "build", "spot": "plot:6", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "plot:2", "tower": "powder_wraith"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:4", "tower": "archer"},
				{"do": "build", "spot": "post:3", "tower": "warrior"},
				{"do": "build", "spot": "plot:3", "tower": "archer"},
				{"do": "build", "spot": "plot:6", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:2", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:2", "mode": "strongest"},
				{"do": "build", "spot": "post:1", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:5", "tower": "mage"},
				{"do": "build", "spot": "plot:9", "tower": "archer"},
				{"do": "evolve", "spot": "plot:4"},
				{"do": "evolve", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:13", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "post:4", "tower": "abomination"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:14", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:10", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:10", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:11", "tower": "banshee"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "post:1"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:13"},

			],
			"galleon": [  # the act tower first, then the map's default order (its evolutions after 30 steps, none of the default's)
				{"do": "build", "spot": "plot:7", "tower": "powder_wraith"},
				{"do": "build", "spot": "post:2", "tower": "abomination"},
				{"do": "build", "spot": "plot:5", "tower": "powder_wraith"},
				{"do": "build", "spot": "plot:14", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:5", "tower": "archer"},
				{"do": "build", "spot": "post:4", "tower": "warrior"},
				{"do": "build", "spot": "plot:7", "tower": "archer"},
				{"do": "build", "spot": "plot:14", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:6", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:6", "mode": "strongest"},
				{"do": "build", "spot": "post:5", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:4", "tower": "mage"},
				{"do": "build", "spot": "plot:3", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "plot:13", "tower": "frost_wraith"},
				{"do": "evolve", "spot": "plot:7"},
				{"do": "evolve", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "post:3", "tower": "abomination"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "plot:10", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:17", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:17", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:17"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:2", "tower": "banshee"},
				{"do": "upgrade", "spot": "plot:17"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:17"},
				{"do": "upgrade", "spot": "post:5"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:13"},

			],
			"maelstrom": [  # the act tower first, then the map's default order (its evolutions after 30 steps, none of the default's)
				{"do": "build", "spot": "plot:14", "tower": "powder_wraith"},
				{"do": "build", "spot": "post:5", "tower": "abomination"},
				{"do": "build", "spot": "plot:15", "tower": "archer"},
				{"do": "build", "spot": "plot:13", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "build", "spot": "plot:7", "tower": "powder_wraith"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "post:5"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:14", "tower": "archer"},
				{"do": "build", "spot": "post:5", "tower": "warrior"},
				{"do": "build", "spot": "plot:15", "tower": "archer"},
				{"do": "build", "spot": "plot:13", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "build", "spot": "plot:12", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:12", "mode": "strongest"},
				{"do": "build", "spot": "post:4", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "build", "spot": "plot:7", "tower": "mage"},
				{"do": "build", "spot": "plot:5", "tower": "archer"},
				{"do": "evolve", "spot": "plot:14"},
				{"do": "evolve", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "build", "spot": "plot:9", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "post:3", "tower": "abomination"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "build", "spot": "plot:8", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "post:5"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "build", "spot": "plot:6", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:6", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "build", "spot": "plot:16", "tower": "banshee"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:9"},

			],
		},
	},
}

## The Broadsides' numbers (the act rule, scripts/maps/rules/corsair/broadsides.gd).
const RULE: Dictionary = {
	"every": 18.0,  # TUNING (not in GDD) s between one cannon's broadsides
	"first_delay": 8.0,  # TUNING (not in GDD) s after a cannon is run out before it first fires
	"crew_mult": 0.8,  # TUNING (not in GDD) the interval x this while any Gunnery Mate lives (she mans the guns)
	"crew_kind": "tide_gunnery_mate",  # the kind that crews the guns
	"reach": 360.0,  # TUNING (not in GDD) px from a cannon to the plots it can shell
	"delay": 1.6,  # TUNING (not in GDD) s of telegraph (GDD §7.3 "on a telegraph")
	"radius": 46.0,  # TUNING (not in GDD) px of a shell
	"disable": 3.0,  # TUNING (not in GDD) s a shelled tower is disabled
	"keg_radius": 96.0,  # TUNING (not in GDD) px of the powder barrels' blast
	"keg_damage": 110.0,  # TUNING (not in GDD) to every enemy in it
	"keg_cannon_damage": 420.0,  # TUNING (not in GDD) to every deck cannon in it (structures take it too)
	"keg_spike": 30.0,  # TUNING (not in GDD) s a cannon in the blast is spiked (cannot fire)
	"keg_restock": 40.0,  # TUNING (not in GDD) s after a blast before fresh barrels are lashed (while their cannon stands)
	"cannon_kind": "tide_deck_cannon",  # structure kind of a cannon
	"keg_kind": "tide_powder_keg",  # structure kind of the barrels
}

## Per map: the cannons the Broadsides run out ({wave (1-based) it is run out,
## pos map px at the rail, keg map px of its powder barrels}).
const BROADSIDES: Dictionary = {
	"cutter": [
		{"wave": 3, "pos": Vector2(420, 632), "keg": Vector2(470, 640)},  # TUNING (not in GDD)
		{"wave": 7, "pos": Vector2(980, 632), "keg": Vector2(1030, 640)},  # TUNING (not in GDD)
		{"wave": 15, "pos": Vector2(1220, 330), "keg": Vector2(1220, 390)},  # TUNING (not in GDD)
	],
	"galleon": [
		{"wave": 4, "pos": Vector2(1228, 420), "keg": Vector2(1228, 470)},  # TUNING (not in GDD)
		{"wave": 9, "pos": Vector2(770, 664), "keg": Vector2(820, 668)},  # TUNING (not in GDD)
		{"wave": 15, "pos": Vector2(1228, 200), "keg": Vector2(1228, 250)},  # TUNING (not in GDD)
		{"wave": 20, "pos": Vector2(80, 250), "keg": Vector2(80, 300)},  # TUNING (not in GDD)
	],
	"maelstrom": [
		{"wave": 3, "pos": Vector2(1236, 640), "keg": Vector2(1190, 650)},  # TUNING (not in GDD)
		{"wave": 7, "pos": Vector2(60, 650), "keg": Vector2(110, 655)},  # TUNING (not in GDD)
		{"wave": 13, "pos": Vector2(640, 664), "keg": Vector2(690, 668)},  # TUNING (not in GDD)
		{"wave": 19, "pos": Vector2(1240, 120), "keg": Vector2(1240, 170)},  # TUNING (not in GDD)
	],
}

## The Broadsides' look (drawn only; never read by the simulation).
const LOOK: Dictionary = {
	"sea_h": 44.0,  # TUNING (not in GDD) px of the sea band drawn along the bottom edge (the deck's rail beyond)
	"rail_w": 6.0,  # TUNING (not in GDD) px of the rail line between deck and sea
	"rail_tint": Color(0.17, 0.11, 0.08),  # TUNING (not in GDD) tarred oak (Necropathy corsair_oak_dark)
	"sea_tint": Color(0.85, 0.92, 1.0),  # TUNING (not in GDD) modulate of the sea tile
	"fuse_d": 46.0,  # TUNING (not in GDD) px of the fuse ring over a cannon
	"fuse_tint": Color(1.0, 0.65, 0.23),  # Necropathy corsair_lantern: every telegraph is lantern amber
	"spiked_tint": Color(0.55, 0.6, 0.7),  # TUNING (not in GDD) ring of a spiked cannon (powder grey)
	"muzzle_d": 90.0,  # TUNING (not in GDD) px of a cannon's muzzle flash
	"trail_w": 10.0,  # TUNING (not in GDD) px of the shot's streak from cannon to target
	"keg_d": 200.0,  # TUNING (not in GDD) px of the barrels' blast burst (2 x keg_radius)
	"shake": 3.0,  # TUNING (not in GDD) px of screen shake on a blast
	# --- the kinds' looks (traits and bosses) ---
	"amber": Color(1.0, 0.65, 0.23),  # Necropathy corsair_lantern: fuses, bellows, telegraph streaks
	"blast_tint": Color(1.0, 0.75, 0.4),  # TUNING (not in GDD) a keg's blast burst
	"fuse_spark": 30.0,  # TUNING (not in GDD) px of a Powder Runner's fuse spark
	"slash_d": 80.0,  # TUNING (not in GDD) px of a lunge's slash
	"slash_tint": Color(1.0, 0.35, 0.3),  # TUNING (not in GDD) enemy blows read red (V-rows)
	"leap_d": 140.0,  # TUNING (not in GDD) px of Crow's landing burst
	"leap_streak_w": 22.0,  # TUNING (not in GDD) px of his leap's streak
	"coin_burst": 120.0,  # TUNING (not in GDD) px of Marrec's coin scatter sparkle
	"coin_tint": Color(1.0, 0.8, 0.3),  # TUNING (not in GDD) cursed gold
	"splash_d": 110.0,  # TUNING (not in GDD) px of a boarding boat's splash
	"oath_tint": Color(0.45, 1.0, 0.8),  # Necropathy spectre ramp: Vandermere's Oath ring
	"oath_pulse": 0.9,  # TUNING (not in GDD) s between Oath ring pulses
	"oath_ring": 46.0,  # TUNING (not in GDD) px radius of a pulse at an empty Oath (+ oath_ring_grow x the Oath left)
	"oath_ring_grow": 20.0,  # TUNING (not in GDD) see oath_ring
	"oath_ring_from": 30.0,  # TUNING (not in GDD) px radius a pulse starts from
}

## Mood rows of the three decks (keys: TdMoodData.MOODS).
const MOODS: Dictionary = {
	"cutter": {
		"props": [{"art": "mood_lantern", "frames": 1, "count": 6, "scale": 1.0, "glow": Color(1.0, 0.65, 0.23, 0.75), "glow_r": 66.0,
			"glow_at": Vector2(0, -24), "flicker": 0.1, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) ship's lanterns at night, lantern amber
			{"sprite": "obstacles/deck_barrels_l", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(0, 0, 0, 0), "glow_r": 0.0,
			"glow_at": Vector2.ZERO, "flicker": 0.0, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) lashed cargo
		"fog": 3,  # TUNING (not in GDD) sea mist over the night deck
		"pools": 0,
	},
	"galleon": {
		"props": [{"art": "mood_lantern", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(1.0, 0.82, 0.5, 0.5), "glow_r": 56.0,
			"glow_at": Vector2(0, -24), "flicker": 0.08, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) dawn: paler lanterns
			{"sprite": "obstacles/deck_mast_l", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(0, 0, 0, 0), "glow_r": 0.0,
			"glow_at": Vector2.ZERO, "flicker": 0.0, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) masts
		"fog": 0,
		"pools": 0,
	},
	"maelstrom": {
		"props": [{"art": "mood_lantern", "frames": 1, "count": 6, "scale": 1.0, "glow": Color(0.45, 1.0, 0.75, 0.7), "glow_r": 70.0,
			"glow_at": Vector2(0, -24), "flicker": 0.2, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) ghost-lit lanterns (Necropathy spectre green)
		"fog": 5,  # TUNING (not in GDD) the whirlpool's spray
		"pools": 0,
	},
}
