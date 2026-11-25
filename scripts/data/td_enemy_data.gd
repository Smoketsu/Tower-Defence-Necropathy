## TdEnemyData: the Covenant kinds on the road (GDD §6.1), with Necropathy's
## sprites and walk strips. HP and speed start from Necropathy's EnemyData /
## MarchEnemyData rows and are rescaled for tower damage; every number is
## TUNING until the balance pass. Data only, no logic.
##
## To add an enemy kind: add a KINDS row; for a special rule write
## scripts/enemies/traits/<trait>.gd (extends EnemyTrait) and name it in "trait".
## A boss is a kind of rank "boss" whose trait lives in scripts/bosses/<id>.gd.
class_name TdEnemyData
extends RefCounted

## Kind rows. Keys:
##   name            — UI name (banners, next-wave preview).
##   sprite          — SpriteData key (walk strip "<sprite>_walk" when it exists).
##   rank            — "fodder" | "elite" | "miniboss" | "boss": souls (EconomyData.KILL_SOULS),
##                     lives on a leak (TdRulesData.LEAK_LIVES), ultimate charge (SpellData).
##   hp              — max HP before difficulty scaling.
##   speed           — px/s along the road.
##   armour          — flat damage removed from each hit (GDD §6.1 "flat armour 6").
##   radius          — body radius px (holding, splash, tap picking).
##   damage          — damage per attack on the blocker body holding it.
##   attack_interval — s between those attacks.
##   flying          — true: never held by blockers or walls (later acts' flyers).
##   ignores_walls   — true: walks through Bone Wall (GDD §5 bosses and minibosses).
##   trait           — "" or the id of its EnemyTrait script (traits/ or bosses/).
##   structure       — optional, true: a map structure (ward generator, crystal): speed 0,
##                     belongs to no wave, targeted only when nothing else is in range
##                     (or on Strongest), never warded, removed when the map ends.
##   args            — the trait's own numbers (documented in the trait script).
##   souls           — optional: souls its kill pays instead of its rank's EconomyData.KILL_SOULS
##                     (later acts' soldier tiers: tougher than fodder, still one life on a leak).
const KINDS: Dictionary = {
	# GDD §6.1 "Baseline fodder" (Necropathy: Covenant Recruit).
	"recruit": {
		"name": "Covenant Recruit", "sprite": "enemies/recruit", "rank": "fodder",
		"hp": 44.0, "speed": 52.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Necropathy "armored melee, moderate damage resistance".
	"footman": {
		"name": "Crimson Footman", "sprite": "enemies/footman", "rank": "fodder",
		"hp": 100.0, "speed": 44.0, "armour": 3.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 7.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Necropathy Zealous Archer: on the road a fast, frail walker.
	"archer": {
		"name": "Zealous Archer", "sprite": "enemies/archer", "rank": "fodder",
		"hp": 50.0, "speed": 58.0, "armour": 0.0, "radius": 9.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Necropathy Purifier: fragile and fast.
	"purifier": {
		"name": "Purifier", "sprite": "enemies/purifier", "rank": "fodder",
		"hp": 60.0, "speed": 72.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 9.0, "attack_interval": 0.9,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Necropathy Chaplain: heals nearby enemies (GDD §6.1 healer pattern).
	"chaplain": {
		"name": "Covenant Chaplain", "sprite": "enemies/chaplain", "rank": "elite",
		"hp": 150.0, "speed": 42.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "healer",
		"args": {"heal": 14.0, "interval": 3.0, "radius": 90.0},  # TUNING (not in GDD)
	},
	# GDD §6.1 "Charges: brief speed burst after the first hit".
	"templar": {
		"name": "Templar Knight", "sprite": "enemies/templar", "rank": "elite",
		"hp": 320.0, "speed": 40.0, "armour": 4.0, "radius": 13.0,  # TUNING (not in GDD)
		"damage": 14.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "templar_charge",
		"args": {"speed_mult": 2.4, "time": 1.6},  # TUNING (not in GDD)
	},
	# GDD §6.1 "Nearby enemies move faster" (Crimson March kind, ready for map 2).
	"banner_bearer": {
		"name": "Banner Bearer", "sprite": "enemies/banner_bearer", "rank": "elite",
		"hp": 200.0, "speed": 44.0, "armour": 2.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 5.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "banner_aura",
		"args": {"radius": 90.0, "speed_mult": 1.3, "refresh": 0.25},  # TUNING (not in GDD)
	},
	# Graveyard miniboss (GDD §6.3: picked from an existing elite kind): the Inquisitor.
	"inquisitor": {
		"name": "Covenant Inquisitor", "sprite": "enemies/inquisitor", "rank": "miniboss",
		"hp": 2700.0, "speed": 30.0, "armour": 5.0, "radius": 18.0,  # TUNING (not in GDD)
		"damage": 20.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "", "args": {},
	},
	# GDD §6.3 Sir Alaric: walks the road, charges through one blocker post at intervals.
	"alaric": {
		"name": "Sir Alaric, the Gravebreaker", "sprite": "bosses/alaric", "rank": "boss",
		"hp": 8200.0, "speed": 26.0, "armour": 6.0, "radius": 28.0,  # TUNING (not in GDD)
		"damage": 30.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "alaric",
		"args": {
			"charge_first": 4.0,  # s after he arrives before his first charge may start
			"charge_every": 10.0,  # s after a charge ends before the next may start
			"charge_range": 90.0,  # px ahead on his road at which he winds up on a post
			"telegraph": 1.0,  # s of the wind-up (he stands still, windup pose, banner)
			"charge_damage": 220.0,  # damage to every body of the post he breaks through
			"charge_speed_mult": 3.5,  # speed multiplier during the charge
			"charge_time": 1.6,  # s the charge lasts (he cannot be held meanwhile)
		},  # TUNING (not in GDD)
	},
	# ---------------------------------------------------------------- Crimson March and Sanctum kinds (gw-maps)
	# GDD §6.1 "Takes less damage from the front" (Necropathy MarchEnemyData shieldbearer).
	"shieldbearer": {
		"name": "Covenant Shieldbearer", "sprite": "enemies/shieldbearer", "rank": "fodder",
		"hp": 95.0, "speed": 42.0, "armour": 1.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shield_front",
		"args": {
			"front_mult": 0.5,  # TUNING (not in GDD) share of a frontal hit that gets through
			"ignore": ["corpse_catapult"],  # GDD §6.1 "Countered by Catapult": arcing boulders go over the shield
		},
	},
	# GDD §6.1 "Hits blockers hard, long reach" (Necropathy halberdier: 12 px reach, heavy armour).
	"halberdier": {
		"name": "Crimson Halberdier", "sprite": "enemies/halberdier", "rank": "elite",
		"hp": 300.0, "speed": 38.0, "armour": 4.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 10.0, "attack_interval": 1.5,  # TUNING (not in GDD) hits blockers hard (x BLOCKER_HIT_MULT)
		"flying": false, "ignores_walls": false, "trait": "halberd_reach",
		"args": {"reach": 60.0},  # TUNING (not in GDD) px ahead it strikes a post from
	},
	# GDD §6.1 "Lash hits two blockers in a line" (Necropathy battle_sister: 62 px lash, two bodies).
	"battle_sister": {
		"name": "Sister of the Scourge", "sprite": "enemies/battle_sister", "rank": "elite",
		"hp": 220.0, "speed": 52.0, "armour": 1.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 12.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "lash",
		"args": {
			"reach": 40.0,  # TUNING (not in GDD) px from the struck body to the second one
			"second_mult": 1.0,  # TUNING (not in GDD) damage share on the second body
		},
	},
	# GDD §6.1 "Flat armour 6" (Necropathy sanctified_sentinel flat_armor 6).
	"sanctified_sentinel": {
		"name": "Sanctified Sentinel", "sprite": "enemies/sanctified_sentinel", "rank": "elite",
		"hp": 420.0, "speed": 30.0, "armour": 6.0, "radius": 15.0,  # GDD §6.1 armour 6; rest TUNING (not in GDD)
		"damage": 14.0, "attack_interval": 1.6,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# GDD §6.1 "Holy zone suppresses towers in a small radius".
	"radiant_inquisitor": {
		"name": "Radiant Inquisitor", "sprite": "enemies/radiant_inquisitor", "rank": "elite",
		"hp": 240.0, "speed": 46.0, "armour": 1.0, "radius": 13.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "holy_zone",
		"args": {
			"first": 3.0,  # TUNING (not in GDD) s after spawning before the first zone
			"interval": 8.0,  # TUNING (not in GDD) s between zones (Necropathy zone_cooldown 8)
			"radius": 100.0,  # TUNING (not in GDD) px a zone reaches towers
			"duration": 5.0,  # TUNING (not in GDD) s towers stay suppressed
			"suppress_mult": 0.5,  # TUNING (not in GDD) damage multiplier on suppressed towers
		},
	},
	# GDD §6.1 "Heals and revives nearby enemies" (Necropathy high_confessor: 120 px heals, a revive every 12 s, max 3).
	"high_confessor": {
		"name": "High Confessor", "sprite": "enemies/high_confessor", "rank": "elite",
		"hp": 260.0, "speed": 42.0, "armour": 1.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "confessor",
		"args": {
			"heal": 18.0,  # TUNING (not in GDD) HP per heal
			"heal_interval": 3.0,  # TUNING (not in GDD) Necropathy heal_interval 3
			"heal_radius": 110.0,  # TUNING (not in GDD) Necropathy 120
			"boss_heal_mult": 3.0,  # TUNING (not in GDD) x heal on a boss
			"revive_first": 6.0,  # Necropathy revive_first 6
			"revive_interval": 12.0,  # Necropathy (owner-approved) every 12 s
			"revive_radius": 140.0,  # Necropathy (owner-approved) 140 px
			"revive_age": 20.0,  # Necropathy revive_max_age 20 s
			"revive_hp": 0.6,  # Necropathy revive_hp_fraction 0.6
			"revive_max": 3,  # Necropathy (owner-approved) at most 3 per Confessor
		},
	},
	# GDD §6.1 "20% ward aura on nearby enemies" (Necropathy sun_paladin ward 110 px, 20%).
	"sun_paladin": {
		"name": "Sun Paladin", "sprite": "enemies/sun_paladin", "rank": "elite",
		"hp": 440.0, "speed": 40.0, "armour": 5.0, "radius": 14.0,  # TUNING (not in GDD)
		"damage": 16.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "sun_ward",
		"args": {
			"radius": 100.0,  # TUNING (not in GDD) Necropathy 110 px
			"ward_mult": 0.8,  # GDD §6.1 20% less damage taken
			"refresh": 0.3,  # TUNING (not in GDD) s the ward lingers after leaving the aura
		},
	},
	# Crimson March miniboss (GDD §6.3: picked from an existing elite kind): a Templar
	# commander whose banner hastens the column around him.
	"templar_commander": {
		"name": "Templar Commander", "sprite": "enemies/templar", "rank": "miniboss",
		"hp": 1500.0, "speed": 30.0, "armour": 5.0, "radius": 18.0,  # TUNING (not in GDD)
		"damage": 20.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "banner_aura",
		"args": {"radius": 110.0, "speed_mult": 1.25, "refresh": 0.25},  # TUNING (not in GDD)
	},
	# GDD §6.3 the Sanctum's miniboss (Necropathy cathedral_guardian: slams, sweeping beam).
	"cathedral_guardian": {
		"name": "Cathedral Guardian", "sprite": "enemies/cathedral_guardian", "rank": "miniboss",
		"hp": 3000.0, "speed": 26.0, "armour": 6.0, "radius": 26.0,  # TUNING (not in GDD)
		"damage": 12.0, "attack_interval": 1.6,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "guardian",
		"args": {
			"slam_every": 5.0,  # TUNING (not in GDD) s between slams while held
			"slam_damage": 25.0,  # TUNING (not in GDD) to every body of the post holding it
			"beam_first": 4.0,  # TUNING (not in GDD) s before its first beam
			"beam_every": 12.0,  # TUNING (not in GDD) s between beams
			"beam_radius": 150.0,  # TUNING (not in GDD) px around it
			"beam_time": 4.0,  # TUNING (not in GDD) s towers stay suppressed
			"beam_mult": 0.5,  # TUNING (not in GDD) damage multiplier on suppressed towers
		},
	},
	# GDD §6.3 Marshal Vael: calls reinforcement squads from side lanes while advancing.
	"vael": {
		"name": "Marshal Vael", "sprite": "bosses/vael", "rank": "boss",
		"hp": 8000.0, "speed": 26.0, "armour": 6.0, "radius": 24.0,  # TUNING (not in GDD)
		"damage": 30.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "vael",
		"args": {
			"call_first": 4.0,  # s after he arrives before the first squad
			"call_every": 14.0,  # s between squads
			"enrage_hp": 0.5,  # HP share below which he calls faster
			"enrage_call_mult": 0.6,  # x call_every once enraged
			"lanes": ["lane_n", "lane_s"],  # road ids the squads enter by (the Crimson March's side lanes)
			"squad": [{"kind": "footman", "count": 3}, {"kind": "shieldbearer", "count": 2}],  # one squad per lane
			"squad_gap": 18.0,  # px between two soldiers of a squad
			"pose_time": 0.8,  # s the windup pose shows on a call
			"wall_every": 11.0,  # s between Shieldwalls (Necropathy shieldwall_cooldown 16)
			"wall_time": 4.0,  # s a Shieldwall lasts (Necropathy 4)
			"wall_mult": 0.5,  # share of frontal hits that gets through (Necropathy 0.5)
		},  # TUNING (not in GDD)
	},
	# High Confessors who walk with Seraphine (her pace) and heal her.
	"confessor_attendant": {
		"name": "Confessor Attendant", "sprite": "enemies/high_confessor", "rank": "elite",
		"hp": 420.0, "speed": 24.0, "armour": 2.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "confessor",
		"args": {
			"heal": 20.0, "heal_interval": 3.0, "heal_radius": 130.0,  # TUNING (not in GDD) see high_confessor
			"boss_heal_mult": 4.0,  # TUNING (not in GDD) x heal on Seraphine
			"revive_first": 999.0, "revive_interval": 999.0, "revive_radius": 0.0,  # TUNING (not in GDD) attendants never revive
			"revive_age": 0.0, "revive_hp": 0.0, "revive_max": 0,  # TUNING (not in GDD)
		},
	},
	# GDD §6.3 Grand Inquisitor Seraphine: teleports forward, suppresses towers with beams, healed by attendants.
	"seraphine": {
		"name": "Grand Inquisitor Seraphine", "sprite": "bosses/seraphine", "rank": "boss",
		"hp": 13000.0, "speed": 24.0, "armour": 4.0, "radius": 22.0,  # TUNING (not in GDD)
		"damage": 28.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "seraphine",
		"args": {
			"attendants": 3,  # escorts at her arrival (Necropathy: 3 minus altars destroyed)
			"attendant_kind": "confessor_attendant",  # their kind
			"attendant_gap": 26.0,  # px between her and each escort
			"teleport_first": 8.0,  # s before her first blink
			"teleport_every": 14.0,  # s between blinks
			"teleport_every_p2": 9.0,  # s between blinks below phase2_hp
			"phase2_hp": 0.5,  # HP share of her second phase
			"teleport_dist": 150.0,  # px blinked down the road
			"keep_away": 700.0,  # px from the gate she never blinks inside
			"beam_radius": 130.0,  # px around her landing point
			"beam_time": 5.0,  # s towers stay suppressed
			"beam_mult": 0.4,  # damage multiplier on suppressed towers
			"pose_time": 0.7,  # s the cast pose shows
		},  # TUNING (not in GDD)
	},
	# GDD §7.2 Crimson March rule: Holy Ward Generators shield enemies beside the road until destroyed.
	"ward_generator": {
		"name": "Holy Ward Generator", "sprite": "structures/ward_generator", "rank": "elite",
		"hp": 800.0, "speed": 0.0, "armour": 3.0, "radius": 16.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": true, "ignores_walls": true, "trait": "ward_structure", "structure": true,
		"args": {
			"radius": 120.0,  # TUNING (not in GDD) px of its shield
			"ward_mult": 0.5,  # TUNING (not in GDD) share of each hit a shielded enemy takes
			"refresh": 0.3,  # TUNING (not in GDD) s the shield lingers after leaving
		},
	},
	# GDD §7.2 Sanctum rule: the ward crystals of a sanctified chamber (no shield of their own).
	"ward_crystal": {
		"name": "Ward Crystal", "sprite": "structures/ward_crystal", "rank": "elite",
		"hp": 650.0, "speed": 0.0, "armour": 2.0, "radius": 14.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": true, "ignores_walls": true, "trait": "ward_structure", "structure": true,
		"args": {"radius": 0.0, "ward_mult": 1.0, "refresh": 0.0},  # no shield: the chamber rule reads its life
	},
}
