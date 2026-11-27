## The Sanguine Court's data (ActData id "court", Act III of the campaign;
## Necropathy's Act VII, GDD §7.3, docs/act7/PROPOSAL.md): vampires, bats,
## werewolves and witches who kept their own will in death and come, starving,
## for the necromancer who emptied their table. Acts merges KINDS (enemy rows,
## keys as TdEnemyData.KINDS), ORDERS (build orders, keys as
## BuildOrderData.ORDERS) and MOODS (keys as TdMoodData.MOODS); the act rule
## (scripts/maps/rules/court/blood_moon.gd) reads RULE and LOOK, the map rule
## (scripts/maps/rules/court/court_structures.gd) reads STRUCTURES. Every kind
## reuses Necropathy's Act VII art (assets/sprites/court/, bosses/,
## structures/). Data only, no logic. Every number is TUNING (not in GDD)
## unless marked: the GDD gives the act's gimmick (§7.3) but no numbers.
extends RefCounted

## Enemy kinds of the Sanguine Court (keys: TdEnemyData.KINDS). Trait ids
## "court/<id>" load scripts/enemies/traits/court/<id>.gd, boss ids
## scripts/bosses/court/<id>.gd; each script documents its args.
const KINDS: Dictionary = {
	# --- The shared kinds (Necropathy CourtEnemyData) ---
	# Fodder: a bitten servant, pale and slow, in mobs. Feeds under the Blood Moon (the act rule).
	"blood_thrall": {
		"name": "Blood Thrall", "sprite": "court/blood_thrall", "rank": "fodder", "souls": 5,  # TUNING (not in GDD) X2: later acts' fodder pays 5 (income curve)
		"hp": 52.0, "speed": 46.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Flying fodder in swarms (GDD §7.3 "bats fly over the road"): blockers and walls never hold it.
	"vampire_bat": {
		"name": "Vampire Bat", "sprite": "court/vampire_bat", "rank": "fodder", "souls": 5,  # TUNING (not in GDD) X2: later acts' fodder pays 5 (income curve)
		"hp": 34.0, "speed": 84.0, "armour": 0.0, "radius": 9.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": false, "trait": "", "args": {},
	},
	# Ravensmoor's pack fodder: stops to eat a fresh corpse beside it and heals doing it.
	"ghoul": {
		"name": "Ghoul", "sprite": "court/ghoul", "rank": "fodder", "souls": 5,  # TUNING (not in GDD) X2: later acts' fodder pays 5 (income curve)
		"hp": 46.0, "speed": 66.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 5.0, "attack_interval": 0.9,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "court/ghoul",
		"args": {"eat_time": 1.6, "eat_heal": 0.45, "eat_cooldown": 6.0},  # TUNING (not in GDD) Necropathy eat_time / eat_heal
	},
	# Soldier: blood-red plate and a halberd; every blow cleaves the post's other bodies.
	"blood_knight": {
		"name": "Blood Knight", "sprite": "court/blood_knight", "rank": "elite",
		"hp": 260.0, "speed": 38.0, "armour": 3.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 12.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "court/cleave",
		"args": {"cleave": 0.5},  # TUNING (not in GDD) Necropathy halberd cleave
	},
	# Heavy: a silver-crossbow hunter (shoots towers and blockers) until the Blood
	# Moon or half HP, then a huge beast for good (Necropathy WEREBEAST).
	"werewolf": {
		"name": "Werewolf", "sprite": "court/werewolf", "rank": "elite",
		"hp": 240.0, "speed": 42.0, "armour": 1.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 10.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "court/werewolf",
		"args": {"range": 200.0, "interval": 4.0, "target": "any", "damage": 14.0, "disable": 1.4, "cause": "shot",
			"speed": 360.0, "arc": false, "look": "arrow",  # TUNING (not in GDD) the hunter's silver crossbow (shooter keys)
			"beast_at": 0.5,  # Necropathy beast_at: HP share below which it turns
			"beast_sprite": "court/werewolf_beast",  # its beast art
			"beast_speed": 1.55, "beast_damage": 2.0, "beast_radius": 16.0},  # TUNING (not in GDD) speed / damage multipliers, body px
	},
	# Elite (the Countess): a blood-drain beam on a blocker body that heals her; once
	# per life at low HP she turns to mist, unseen, and reforms down the road.
	"vampire_noble": {
		"name": "Vampire Noble", "sprite": "court/vampire_noble", "rank": "elite",
		"hp": 300.0, "speed": 40.0, "armour": 1.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 10.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "court/noble",
		"args": {"drain_range": 150.0, "drain_every": 7.0, "drain_time": 1.4, "drain_tick": 0.25, "drain_damage": 7.0,  # TUNING (not in GDD) Necropathy beam: 1.4 s, a hit every 0.25 s
			"mist_at": 0.35, "mist_time": 1.5, "mist_jump": 90.0},  # Necropathy mist at 35% HP for 1.5 s; jump TUNING (not in GDD)
	},
	# Support (the Witchwood's coven): hex circles that weaken towers; under the Blood
	# Moon or near a hex stone she also heals the Court around her.
	"crimson_witch": {
		"name": "Crimson Witch", "sprite": "court/crimson_witch", "rank": "elite",
		"hp": 200.0, "speed": 40.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "court/witch",
		"args": {"range": 170.0, "every": 7.0, "circle_r": 60.0, "mult": 0.7, "time": 4.0,  # TUNING (not in GDD) px reach, s, px, tower damage x, s
			"heal": 10.0, "heal_radius": 90.0, "stone_range": 220.0},  # TUNING (not in GDD) HP per cast, px, px from a hex stone
	},
	# Heavy: swollen with blood; dies into a pool that heals the Court walking through it.
	"bloated_thrall": {
		"name": "Bloated Thrall", "sprite": "court/bloated_thrall", "rank": "elite",
		"hp": 480.0, "speed": 30.0, "armour": 2.0, "radius": 15.0,  # TUNING (not in GDD)
		"damage": 14.0, "attack_interval": 1.5,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "court/bloated",
		"args": {"pool_radius": 70.0, "pool_life": 8.0, "pool_heal": 12.0},  # TUNING (not in GDD) px, s, HP per s to each Court foe inside
	},
	# Castle Sanguis' elite flier: a sonic shriek stuns the towers in a circle.
	"chiropteran": {
		"name": "Chiropteran", "sprite": "court/chiropteran", "rank": "elite",
		"hp": 220.0, "speed": 52.0, "armour": 0.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": false, "trait": "court/shriek",
		"args": {"range": 180.0, "first": 3.0, "every": 10.0, "radius": 60.0, "delay": 1.0, "stun": 1.0},  # Necropathy shriek_stun 1.5; rest TUNING (not in GDD)
	},
	# Carmilla's Waking: a thrall with a chalice walking to the kneeling Queen.
	"blood_bearer": {
		"name": "Blood Bearer", "sprite": "court/blood_thrall", "rank": "fodder",
		"hp": 110.0, "speed": 72.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 2.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "court/bearer",
		"args": {"pour_reach": 40.0},  # TUNING (not in GDD) px from the Queen at which it pours
	},
	# Isolde's three sisters (her phase 2): all must fall close together or the fallen rise again.
	"isolde_sister": {
		"name": "Sister of the Red Moon", "sprite": "court/crimson_witch", "rank": "elite",
		"hp": 1000.0, "speed": 28.0, "armour": 2.0, "radius": 13.0,  # TUNING (not in GDD)
		"damage": 14.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "court/sister",
		"args": {"range": 180.0, "every": 6.0, "circle_r": 60.0, "mult": 0.55, "time": 4.0},  # TUNING (not in GDD) her hex circles (as the witch's)
	},
	# --- Structures (the map rule raises them: STRUCTURES) ---
	# Ravensmoor's sleeping coffin: break it before a Blood Moon or a Vampire Noble climbs out.
	"court_coffin": {
		"name": "Sleeping Coffin", "sprite": "structures/court_coffin", "rank": "elite", "structure": true,
		"hp": 520.0, "speed": 0.0, "armour": 2.0, "radius": 14.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": false, "ignores_walls": true, "trait": "court/coffin",
		"args": {"kind": "vampire_noble"},  # Necropathy: "a Vampire Noble climbs out when the moon turns"
	},
	# The Witchwood's hex stone: witches near it cast faster and heal; break it to silence them.
	"hex_stone": {
		"name": "Hex Stone", "sprite": "structures/hex_stone", "rank": "elite", "structure": true,
		"hp": 650.0, "speed": 0.0, "armour": 3.0, "radius": 14.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": false, "ignores_walls": true, "trait": "", "args": {},
	},
	# Castle Sanguis' blood fountain (the Banquet): heals the Court around it until broken.
	"blood_fountain": {
		"name": "Blood Fountain", "sprite": "structures/blood_fountain", "rank": "elite", "structure": true,
		"hp": 750.0, "speed": 0.0, "armour": 2.0, "radius": 16.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": false, "ignores_walls": true, "trait": "court/fountain",
		"args": {"heal": 10.0, "interval": 2.0, "radius": 130.0},  # TUNING (not in GDD) HP, s, px
	},
	# --- Minibosses (their death drops the chest) ---
	# Ravensmoor: Old Greymane, the pack's alpha: howls werewolves into beasts and lunges.
	"old_greymane": {
		"name": "Old Greymane", "sprite": "court/old_greymane", "rank": "miniboss",
		"hp": 3400.0, "speed": 22.0, "armour": 4.0, "radius": 20.0,  # TUNING (not in GDD) X3: was 2100.0
		"damage": 24.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "court/greymane",
		"args": {"howl_first": 4.0, "howl_every": 13.0, "howl_radius": 280.0, "haste": 1.4, "haste_time": 5.0,  # Necropathy howl; numbers TUNING (not in GDD)
			"lunge_every": 9.0, "lunge_jump": 30.0, "lunge_reach": 70.0, "lunge_damage": 70.0, "feed": 0.5},  # TUNING (not in GDD) s, px, px, body damage, share healed
	},
	# The Witchwood: the Bog Mother drags blocker bodies into the fen and slams the towers.
	"bog_mother": {
		"name": "The Bog Mother", "sprite": "court/bog_mother", "rank": "miniboss",
		"hp": 4000.0, "speed": 18.0, "armour": 4.0, "radius": 22.0,  # TUNING (not in GDD) X3: was 2000.0
		"damage": 22.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "court/bog_mother",
		"args": {"drag_every": 10.0, "drag_reach": 150.0, "drag_count": 2, "drown_damage": 70.0,  # Necropathy drag_count 2; rest TUNING (not in GDD)
			"slam_every": 12.0, "slam_reach": 200.0, "slam_radius": 70.0, "slam_delay": 1.2, "slam_disable": 2.5, "slam_damage": 30.0},  # TUNING (not in GDD)
	},
	# Castle Sanguis: the Chiropteran King flies over the road, carries a blocker off,
	# shrieks the towers silent and calls his colony at half health.
	"chiropteran_king": {
		"name": "The Chiropteran King", "sprite": "court/chiropteran_king", "rank": "miniboss",
		"hp": 5200.0, "speed": 24.0, "armour": 3.0, "radius": 20.0,  # TUNING (not in GDD) X3: was 2200.0
		"damage": 18.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": true, "trait": "court/bat_king",
		"args": {"shriek_first": 4.0, "shriek_every": 10.0, "shriek_reach": 220.0, "shriek_radius": 110.0, "shriek_delay": 1.0, "shriek_stun": 2.5,  # Necropathy great shriek; TUNING (not in GDD)
			"grab_first": 7.0, "grab_every": 14.0, "grab_reach": 120.0,  # TUNING (not in GDD) s, s, px: the blocker body he carries off falls
			"swarm_at": 0.5, "swarm_count": 8, "swarm_kind": "vampire_bat"},  # Necropathy THE COLONY below half health
	},
	# --- Bosses (scripts/bosses/court/<id>.gd; their phases documented there) ---
	# Ravensmoor: Vargr, the Moon-Eater (the Hunt, the Turning, the Moon-Eater).
	"vargr": {
		"name": "Vargr, the Moon-Eater", "sprite": "bosses/vargr", "rank": "boss",
		"hp": 9000.0, "speed": 22.0, "armour": 5.0, "radius": 26.0,  # TUNING (not in GDD)
		"damage": 32.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "court/vargr",
		"args": {
			"phase2_hp": 0.66, "phase3_hp": 0.33,  # Necropathy: three phases by HP
			"lunge_first": 5.0, "lunge_every": 11.0, "lunge_windup": 0.8, "lunge_jump": 45.0, "lunge_reach": 160.0, "lunge_damage": 85.0,  # TUNING (not in GDD) s, s, s, px, px, body damage
			"feed": 0.5, "feed_p3": 0.8,  # TUNING (not in GDD) share of his lunge / blows healed (the Moon-Eater feeds harder)
			"howl_every": 15.0, "howl_radius": 320.0, "pack_count": 3, "pack_kind": "werewolf", "pack_gap": 30.0,  # Necropathy the Turning; TUNING (not in GDD)
			"p3_speed": 1.15, "lunge_every_p3": 8.0,  # TUNING (not in GDD) the Moon-Eater: faster
			"pose_time": 0.6,  # TUNING (not in GDD) s the crouch / howl pose shows
		},
	},
	# The Witchwood: Isolde Vane, the Witch of the Red Moon (the Witch, the Three Sisters, the Red Moon).
	"isolde": {
		"name": "Isolde Vane, the Witch of the Red Moon", "sprite": "bosses/isolde", "rank": "boss",
		"hp": 9500.0, "speed": 22.0, "armour": 4.0, "radius": 24.0,  # TUNING (not in GDD)
		"damage": 24.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "court/isolde",
		"args": {
			"circle_first": 4.0, "circle_every": 9.0, "circle_count": 2, "circle_reach": 260.0, "circle_r": 70.0, "circle_mult": 0.5, "circle_time": 5.0,  # Necropathy hex circles on the ring; TUNING (not in GDD)
			"bomb_first": 6.0, "bomb_every": 11.0, "bomb_count": 2, "bomb_reach": 260.0, "bomb_radius": 60.0, "bomb_delay": 1.2, "bomb_damage": 40.0,  # Necropathy cauldron bombs; TUNING (not in GDD)
			"pool_radius": 60.0, "pool_life": 7.0, "pool_heal": 14.0,  # TUNING (not in GDD) the blood pool a bomb leaves (px, s, HP per s)
			"phase2_hp": 0.6, "phase3_hp": 0.3,  # TUNING (not in GDD) Necropathy: sisters, then the Red Moon
			"sister_kind": "isolde_sister", "sister_gap": 50.0, "sisters_window": 10.0, "rise_hp": 0.5, "sabbath_wane": 45.0,  # Necropathy "within 10 s of each other or the fallen rise again"; rest TUNING
			"p3_every_mult": 0.65, "pose_time": 0.7,  # TUNING (not in GDD) the Red Moon: circles and bombs come faster; s of the cast pose
		},
	},
	# Castle Sanguis: Queen Carmilla, then the Elder in two forms (the Court, the Waking, the Elder).
	"carmilla": {
		"name": "Queen Carmilla", "sprite": "bosses/carmilla", "rank": "boss",
		"hp": 9000.0, "speed": 26.0, "armour": 4.0, "radius": 22.0,  # TUNING (not in GDD)
		"damage": 24.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "court/carmilla",
		"args": {
			"mist_first": 6.0, "mist_every": 14.0, "mist_time": 1.4, "mist_jump": 80.0, "mist_reach": 50.0, "mist_damage": 40.0, "mist_feed": 0.5,  # Necropathy the Mist Dance; TUNING (not in GDD)
			"noble_count": 2, "noble_every": 30.0, "noble_max": 4, "noble_kind": "vampire_noble", "noble_gap": 30.0,  # Necropathy nobles step out beside her; TUNING
			"waking_hp": 0.4, "waking_time": 14.0, "elder_hp": 9000.0, "elder_floor": 0.45, "feed_rate": 0.02,  # Necropathy the Waking; TUNING (not in GDD)
			"bearer_kind": "blood_bearer", "bearer_count": 3, "bearer_every": 5.0, "bearer_back": 260.0, "bearer_heal": 0.05,  # Necropathy Blood Bearers; TUNING (not in GDD)
			"elder_sprite": "bosses/elder_vampire", "elder_radius": 26.0, "elder_speed": 30.0, "elder_damage": 30.0,  # the Vampire Lord (first form)
			"lunge_every": 7.0, "lunge_jump": 90.0, "lunge_reach": 50.0, "lunge_damage": 50.0,  # Necropathy blood-blade lunge; TUNING (not in GDD)
			"horror_at": 0.5, "change_time": 2.0,  # Necropathy THE TRANSFORMATION at horror_at of his health
			"horror_sprite": "bosses/elder", "horror_radius": 30.0, "horror_speed": 22.0, "horror_damage": 34.0, "horror_feed": 0.5,  # the Bat-Winged Horror
			"command_every": 15.0, "command_bats": 6, "bat_kind": "vampire_bat",  # Necropathy commands every bat; TUNING (not in GDD)
			"buffet_every": 10.0, "buffet_radius": 90.0, "buffet_damage": 45.0, "buffet_tower_r": 130.0, "buffet_disable": 1.5,  # Necropathy wing buffet; TUNING (not in GDD)
			"pose_time": 0.7,  # TUNING (not in GDD) s a cast pose shows
		},
	},
}

## Map structures raised by the map rule court_structures at the start of a
## map: map id -> [[kind, map px], ...] (beside the nearest road).
const STRUCTURES: Dictionary = {
	"ravensmoor": [["court_coffin", Vector2(284, 229)], ["court_coffin", Vector2(306, 568)], ["court_coffin", Vector2(559, 435)], ["court_coffin", Vector2(885, 343)]],  # Necropathy "sealed coffins in each zone"
	"witchwood": [["hex_stone", Vector2(520, 320)], ["hex_stone", Vector2(520, 410)], ["hex_stone", Vector2(620, 365)]],  # Necropathy "standing stones that power the covens' circles"
	"castle_sanguis": [["blood_fountain", Vector2(300, 300)], ["blood_fountain", Vector2(990, 420)], ["blood_fountain", Vector2(420, 530)]],  # the Banquet's blood fountains
}

## The Blood Moon (the act rule, GDD §7.3 Blood Moon): every `every` waves from
## wave `first` the moon rises for `duration` s from the wave's start. Under it
## Bloodfeast runs (a kill heals the Court within `feed_radius` px by
## `kill_heal`; a fallen blocker body heals the Court within `body_radius` px by
## `body_heal`), healing past full becomes a blood shield (TdCombat.ward_enemy:
## they take `shield_ward` of every hit for `shield_time` s), every Court enemy
## on the road and spawned meanwhile is shielded, a flight of `bats` bats per
## entrance crosses over the road at its rise, werewolves turn, sleeping
## coffins open and witches heal.
const RULE: Dictionary = {
	"first": 6,  # TUNING (not in GDD) first Blood Moon wave (1-based)
	"every": 5,  # TUNING (not in GDD) waves between two moons (Necropathy: every 4:00)
	"duration": 40.0,  # Necropathy "for 45 s", TD TUNING: 40 s from the wave start
	"warn_waves": 1,  # TUNING (not in GDD) the HUD cue turns red this many waves ahead
	"feed_radius": 110.0,  # TUNING (not in GDD) px around a kill
	"kill_heal": 10.0,  # TUNING (not in GDD) HP to each Court foe near a kill
	"feed_max": 3,  # TUNING (not in GDD) most Court foes one kill or fallen body feeds (the nearest)
	"body_radius": 100.0,  # TUNING (not in GDD) px around a fallen blocker body
	"body_heal": 60.0,  # TUNING (not in GDD) HP to each Court foe near it
	"shield_ward": 0.8,  # TUNING (not in GDD) share of each hit a blood-shielded foe takes
	"shield_time": 6.0,  # TUNING (not in GDD) s a banked shield lasts
	"bats": 5,  # TUNING (not in GDD) bats per entrance road at the moon's rise
	"bat_kind": "vampire_bat",  # GDD §7.3 "bats fly over the road"
	"bat_spacing": 0.5,  # TUNING (not in GDD) px of road between two bats of the flight, x their radius
}

## The Blood Moon's look (drawn only; never read by the simulation).
const LOOK: Dictionary = {
	"band": Color(0.75, 0.04, 0.10, 0.55),  # TUNING (not in GDD) red sky edge bands at the moon's height (alpha = strength)
	"band_depth": 0.22,  # TUNING (not in GDD) band depth as a share of the map's height / width
	"moon_pos": Vector2(1110, 96),  # TUNING (not in GDD) map px of the blood moon disc (top right, under the HUD bar)
	"moon_d": 120.0,  # TUNING (not in GDD) px of the moon's glow disc
	"moon_tint": Color(1.0, 0.25, 0.22, 0.85),  # TUNING (not in GDD) the moon's glow
	"fade": 2.0,  # TUNING (not in GDD) s the sky takes to turn red / clear
	"shield_tint": Color(1.0, 0.15, 0.25, 0.6),  # TUNING (not in GDD) ring under a blood-shielded foe
	"shield_scale": 3.0,  # TUNING (not in GDD) ring diameter as a multiple of the foe's radius
	"feed_tint": Color(1.0, 0.2, 0.25, 0.9),  # TUNING (not in GDD) red thread from a feed to its feeder
	"feed_w": 6.0,  # TUNING (not in GDD) px of that thread
	"pool_tint": Color(0.75, 0.05, 0.12, 0.65),  # TUNING (not in GDD) blood pools on the ground
	"circle_tint": Color(1.0, 0.2, 0.35, 0.6),  # TUNING (not in GDD) witches' hex circles on towers
	"mark_tint": Color(1.0, 0.25, 0.2, 0.6),  # TUNING (not in GDD) a boss's landing / bite mark
	"cue_ahead": Color(0.85, 0.7, 0.75),  # TUNING (not in GDD) HUD cue text while the moon is waves away
	"cue_near": Color(1.0, 0.45, 0.45),  # TUNING (not in GDD) HUD cue text the wave before it
	"cue_up": Color(1.0, 0.25, 0.25),  # TUNING (not in GDD) HUD cue text while it is up
	"cue_pos": Vector2(-250, 8),  # TUNING (not in GDD) px from the top-right corner under the HUD bar
	"cue_box": Vector2(240, 44),  # TUNING (not in GDD) px room of the cue (it moves to the left edge when a road runs under the right spot, X6)
}

## Battlefield moods (keys: TdMoodData.MOODS), one per map.
const MOODS: Dictionary = {
	"ravensmoor": {
		"props": [{"sprite": "obstacles/grave_cross_s", "frames": 1, "count": 5, "scale": 1.0, "glow": Color(0.7, 0.75, 1.0, 0.35), "glow_r": 46.0,
			"glow_at": Vector2(0, -14), "flicker": 0.05, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) moonlit churchyard crosses
			{"art": "mood_lantern", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(1.0, 0.6, 0.3, 0.65), "glow_r": 60.0,
			"glow_at": Vector2(0, -24), "flicker": 0.1, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) the village's lit lamps
		"fog": 5,  # TUNING (not in GDD) moor mist
		"pools": 0,
	},
	"witchwood": {
		"props": [{"sprite": "obstacles/witch_cauldron_s", "frames": 1, "count": 5, "scale": 1.0, "glow": Color(1.0, 0.2, 0.25, 0.6), "glow_r": 54.0,
			"glow_at": Vector2(0, -12), "flicker": 0.18, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) red brew bubbling
		"fog": 6,  # TUNING (not in GDD) fen mist
		"pools": 0,
	},
	"castle_sanguis": {
		"props": [{"sprite": "obstacles/candelabra_s", "frames": 1, "count": 8, "scale": 1.0, "glow": Color(1.0, 0.75, 0.4, 0.55), "glow_r": 48.0,
			"glow_at": Vector2(0, -26), "flicker": 0.15, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) the Banquet's candles
		"fog": 0,
		"pools": 4,  # TUNING (not in GDD) light through the tall windows
	},
}

## Build orders of the act (keys: BuildOrderData.ORDERS).
const ORDERS: Dictionary = {
	# Wins Ravensmoor on Necromancer: the merge plots that see both columns first, blockers after the merge.
	"ravensmoor_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "build", "spot": "plot:10", "tower": "archer"},
			{"do": "build", "spot": "plot:1", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "plot:11", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:11", "mode": "strongest"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "plot:3", "tower": "mage"},
			{"do": "build", "spot": "plot:9", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "build", "spot": "plot:12", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "post:4", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "build", "spot": "plot:0", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "plot:13", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:13", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "plot:15", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "evolve", "spot": "plot:2"},
			{"do": "evolve", "spot": "plot:10"},
			{"do": "evolve", "spot": "plot:1"},
			{"do": "evolve", "spot": "plot:3"},
		],
	},
	# Loses Ravensmoor: one archer on a corner plot, no blockers, no spells.
	"ravensmoor_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:5", "tower": "archer"},
		],
	},
	# Wins the Witchwood on Necromancer: the stone circle's plots that see both paths, blockers on the trunk.
	"witchwood_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:1", "tower": "archer"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "plot:0", "tower": "archer"},
			{"do": "build", "spot": "plot:8", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "build", "spot": "plot:2", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:2", "mode": "strongest"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "build", "spot": "plot:7", "tower": "mage"},
			{"do": "build", "spot": "plot:6", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:4", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "post:4", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:5", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "build", "spot": "plot:13", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:13", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "build", "spot": "plot:14", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "evolve", "spot": "plot:1"},
			{"do": "evolve", "spot": "plot:0"},
			{"do": "evolve", "spot": "plot:8"},
			{"do": "evolve", "spot": "plot:7"},
		],
	},
	# Loses the Witchwood: one archer in a corner.
	"witchwood_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:10", "tower": "archer"},
		],
	},
	# Wins Castle Sanguis on Necromancer: the inner plots that see two rings of the spiral, blockers on the inner rings.
	"castle_sanguis_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:6", "tower": "archer"},
			{"do": "build", "spot": "post:5", "tower": "warrior"},
			{"do": "build", "spot": "plot:5", "tower": "archer"},
			{"do": "build", "spot": "plot:1", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:10", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:10", "mode": "strongest"},
			{"do": "build", "spot": "post:4", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:7", "tower": "mage"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "plot:9", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "post:2", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "plot:8", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "post:5"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:13", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:13", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:11", "tower": "banshee"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "build", "spot": "plot:4", "tower": "archer"},
			{"do": "build", "spot": "plot:12", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "build", "spot": "plot:3", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "post:5"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:14", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "post:5"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "evolve", "spot": "plot:6"},
			{"do": "evolve", "spot": "plot:5"},
			{"do": "evolve", "spot": "plot:1"},
			{"do": "evolve", "spot": "plot:7"},
		],
	},
	# Loses Castle Sanguis: one archer on the outer band.
	"castle_sanguis_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:15", "tower": "archer"},
		],
	},
	# The act's kit (every Court map): its default order with Blood Spawn on the two
	# first Warrior posts (both evolve into the Nosferatu when they can), a Banshee
	# beside one of them (the Red Waltz) and the Court spells (the character's own
	# spell takes slot 1: --character=dhampir brings Night Swarm too).
	"court_kit": {
		"spells": true,
		"bonus_souls": 300,  # TUNING (not in GDD) test order: the Blood Spawn's extra levels
		"loadout": ["moonfang", "witch_circle", "night_swarm"],
		"steps": [],
		"steps_by_map": {
			"ravensmoor": [
				{"do": "build", "spot": "plot:2", "tower": "archer"},
				{"do": "build", "spot": "post:3", "tower": "blood_spawn"},
				{"do": "build", "spot": "plot:10", "tower": "archer"},
				{"do": "build", "spot": "plot:1", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "build", "spot": "plot:11", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:11", "mode": "strongest"},
				{"do": "build", "spot": "post:2", "tower": "blood_spawn"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "build", "spot": "plot:3", "tower": "mage"},
				{"do": "build", "spot": "plot:9", "tower": "banshee"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "build", "spot": "plot:12", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "post:4", "tower": "abomination"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "build", "spot": "plot:0", "tower": "mage"},
				{"do": "evolve", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "build", "spot": "plot:13", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:13", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "build", "spot": "plot:15", "tower": "banshee"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "evolve", "spot": "post:3"},
				{"do": "evolve", "spot": "plot:2"},
				{"do": "evolve", "spot": "plot:10"},
				{"do": "evolve", "spot": "plot:1"},
				{"do": "evolve", "spot": "plot:3"},
			],
			"witchwood": [
				{"do": "build", "spot": "plot:1", "tower": "archer"},
				{"do": "build", "spot": "post:2", "tower": "blood_spawn"},
				{"do": "build", "spot": "plot:0", "tower": "archer"},
				{"do": "build", "spot": "plot:8", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "build", "spot": "plot:2", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:2", "mode": "strongest"},
				{"do": "build", "spot": "post:3", "tower": "blood_spawn"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "build", "spot": "plot:7", "tower": "banshee"},
				{"do": "build", "spot": "plot:6", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:4", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "post:4", "tower": "abomination"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:5", "tower": "mage"},
				{"do": "evolve", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "build", "spot": "plot:13", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:13", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "build", "spot": "plot:14", "tower": "banshee"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "evolve", "spot": "post:3"},
				{"do": "evolve", "spot": "plot:1"},
				{"do": "evolve", "spot": "plot:0"},
				{"do": "evolve", "spot": "plot:8"},
				{"do": "evolve", "spot": "plot:7"},
			],
			"castle_sanguis": {"base": "castle_sanguis_default", "swap": ["abomination", "blood_spawn"]},  # DECISIONS Y5: the default order with the act tower in one spot
		},
	},
}
