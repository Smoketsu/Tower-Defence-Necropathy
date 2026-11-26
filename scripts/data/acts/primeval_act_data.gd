## Act XIV, the Age of Titans (ActData "primeval"; GDD §7.3 "Stampedes: herds
## cross the map off-road and trample plots in their path"; Necropathy's Age of
## Titans, docs/titans/, PrimevalEnemyData / FernBasinEnemyData /
## GreatPlainEnemyData / LastDayEnemyData, the stages fern_basin / great_plain /
## last_day): its enemy kinds (KINDS, keys as TdEnemyData.KINDS), its build
## orders (ORDERS, keys as BuildOrderData.ORDERS), its three map moods (MOODS,
## keys as TdMoodData.MOODS), the numbers of its act rule, the Stampedes and the
## three map twists (RULE, read by scripts/maps/rules/primeval/stampedes.gd) and
## the act's looks (LOOK). No gods, no armies, no walls: only animals the size
## of houses, fern green, volcanic orange, tar black, dust ochre and bone white.
## Every sprite is Necropathy's Titans art (assets/sprites/primeval/, summons/,
## player/, fx/primeval_*, markers/primeval_*). The ids carry a "prim_" prefix
## (unique across acts). Data only.
extends RefCounted

## Enemy kinds of the Age of Titans (keys: TdEnemyData.KINDS). Traits live in
## scripts/enemies/traits/primeval/ and scripts/bosses/primeval/ (each script
## documents its args). Herd beasts walk the maps' herd TRAILS (off-road, exit:
## no lives lost) and trample the plots beside them (the act rule's Stampedes).
const KINDS: Dictionary = {
	# The swarm: fast, tiny, chittering lizards in swarms (Necropathy "Scuttler (swarm of 12)").
	"prim_scuttler": {
		"name": "Scuttler", "sprite": "primeval/scuttler", "rank": "fodder", "souls": 3,  # TUNING (not in GDD) a swarm pays under the soldiers (X2)
		"hp": 34.0, "speed": 74.0, "armour": 0.0, "radius": 7.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 0.8,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# A hunter: the pack raptor. Held, it LEAPS over the post once and rakes a body (Necropathy "pack leap over the first blocker").
	"prim_razorclaw": {
		"name": "Razorclaw", "sprite": "primeval/razorclaw", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) soldier tier (X2, Part Three)
		"hp": 110.0, "speed": 52.0, "armour": 1.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 8.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "primeval/pack_leap",
		"args": {"windup": 1.0, "leap": 60.0, "rake": 16.0, "unhold": 0.5, "one_in": 2},  # TUNING (not in GDD) one leap a life
	},
	# The pack's alpha (female, a bone-white crest): the raptors near her run faster (Act I banner_aura; "kill the alpha first").
	"prim_razorclaw_alpha": {
		"name": "Razorclaw Alpha", "sprite": "primeval/razorclaw_alpha", "rank": "elite",
		"hp": 480.0, "speed": 56.0, "armour": 2.0, "radius": 13.0,  # TUNING (not in GDD)
		"damage": 12.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "banner_aura",
		"args": {"radius": 110.0, "speed_mult": 1.3, "refresh": 0.25},  # TUNING (not in GDD)
	},
	# A hunter: lobs a venom bolt over the posts at a tower (stops it) or a blocker (Necropathy "Frill-Spitter").
	"prim_frill_spitter": {
		"name": "Frill-Spitter", "sprite": "primeval/frill_spitter", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) soldier tier
		"hp": 105.0, "speed": 50.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 200.0, "interval": 4.0, "target": "body", "damage": 12.0, "disable": 1.0, "cause": "shot", "speed": 260.0, "arc": true, "look": "spit"},  # TUNING (not in GDD)
	},
	# A herd beast: a huge, slow sauropod on a herd trail; it never fights, it TRAMPLES (the Stampedes).
	"prim_longneck": {
		"name": "Longneck", "sprite": "primeval/longneck", "rank": "elite", "souls": 4,  # TUNING (not in GDD) a beast pays little: turning it is the point
		"hp": 1000.0, "speed": 34.0, "armour": 2.0, "radius": 24.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": false, "ignores_walls": true, "trait": "primeval/herd",
		"args": {"radius": 72.0, "disable": 3.0, "body_radius": 40.0, "body_damage": 80.0},  # TUNING (not in GDD)
	},
	# A herd beast: a crested duckbill; smaller and quicker.
	"prim_duckbill": {
		"name": "Duckbill", "sprite": "primeval/duckbill", "rank": "fodder", "souls": 3,  # TUNING (not in GDD)
		"hp": 300.0, "speed": 50.0, "armour": 1.0, "radius": 16.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": false, "ignores_walls": true, "trait": "primeval/herd",
		"args": {"radius": 58.0, "disable": 2.0, "body_radius": 32.0, "body_damage": 45.0},  # TUNING (not in GDD)
	},
	# A flier: a pterosaur clutching a stolen crystal; it flies over the posts (Necropathy "Skyraider").
	"prim_skyraider": {
		"name": "Skyraider", "sprite": "primeval/skyraider", "rank": "fodder", "souls": 6,  # TUNING (not in GDD)
		"hp": 95.0, "speed": 54.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD) DECISIONS Z4: speed 64 -> 54 (a flock outran every tower on one seed)
		"damage": 4.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": true, "trait": "", "args": {},
	},
	# A titan: the great tyrant. Its ROAR stuns the towers round it; held, it SWALLOWS the body holding it.
	"prim_tyrant": {
		"name": "Tyrant", "sprite": "primeval/tyrant", "rank": "elite",
		"hp": 950.0, "speed": 30.0, "armour": 4.0, "radius": 24.0,  # TUNING (not in GDD)
		"damage": 26.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "primeval/tyrant",
		"args": {"roar_first": 5.0, "roar_every": 13.0, "roar_windup": 1.0, "roar_radius": 130.0, "roar_stun": 1.6,
			"swallow_every": 14.0, "swallow_windup": 0.9},  # TUNING (not in GDD) Necropathy TyrantKit: the roar and the swallow
	},
	# A hunter of the tar: in a tar seep it lies SUBMERGED (no tower sees it); its first bite on a post is a lunge.
	"prim_bog_croc": {
		"name": "Bog Croc", "sprite": "primeval/bog_croc", "rank": "fodder", "souls": 10,  # TUNING (not in GDD) the top soldier tier
		"hp": 250.0, "speed": 46.0, "armour": 2.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 10.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "primeval/bog_croc",
		"args": {"lunge": 60.0, "sprite_sunk": "primeval/bog_croc_submerged"},  # TUNING (not in GDD) Necropathy BogCrocKit: the lunge bite
	},
	# A titan: a three-horned charger. Its CHARGE breaks through the posts; into a rock it is stunned.
	"prim_horncharger": {
		"name": "Horncharger", "sprite": "primeval/horncharger", "rank": "elite",
		"hp": 540.0, "speed": 38.0, "armour": 3.0, "radius": 18.0,  # TUNING (not in GDD)
		"damage": 16.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "primeval/charge",
		"args": {"first": 3.0, "every": 12.0, "windup": 0.8, "time": 1.4, "speed_mult": 2.4, "gore": 28.0,
			"rock_r": 44.0, "rock_stun": 2.5},  # TUNING (not in GDD) Necropathy HornchargerKit: "a charge that runs into a rock leaves it stuck 2 s"
	},
	# A titan: an ankylosaur, flat armour 6, whose TAIL SWEEP strikes every body round it.
	"prim_clubtail": {
		"name": "Clubtail", "sprite": "primeval/clubtail", "rank": "elite",
		"hp": 600.0, "speed": 30.0, "armour": 6.0, "radius": 18.0,  # TUNING (not in GDD) Necropathy: flat armour 5
		"damage": 14.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "primeval/tail_sweep",
		"args": {"first": 3.0, "every": 7.0, "windup": 0.8, "reach": 70.0, "body_damage": 22.0, "disable": 0.0},  # TUNING (not in GDD)
	},
	# A flier elite: a great pterosaur whose WING GUST stops the towers under it, then she lands to peck (hit her then).
	"prim_stormwing": {
		"name": "Stormwing", "sprite": "primeval/stormwing", "rank": "elite",
		"hp": 420.0, "speed": 44.0, "armour": 1.0, "radius": 16.0,  # TUNING (not in GDD)
		"damage": 10.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": true, "trait": "primeval/gust",
		"args": {"first": 4.0, "every": 11.0, "windup": 1.0, "radius": 110.0, "disable": 1.6, "land_time": 2.5, "land_mult": 1.5,
			"land_slow": 0.35, "land_sprite": "primeval/stormwing_landed"},  # TUNING (not in GDD)
	},
	# Ironjaw's nest: a mound of fern and eggshells beside the road; it pours out Scuttlers and shields its mother.
	"prim_nest": {
		"name": "Primeval Nest", "sprite": "primeval/primeval_nest", "rank": "elite", "souls": 20,  # TUNING (not in GDD)
		"hp": 700.0, "speed": 0.0, "armour": 2.0, "radius": 18.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": false, "ignores_walls": true, "trait": "primeval/nest",
		"args": {"every": 6.0, "brood": 3, "kind": "prim_scuttler"},  # TUNING (not in GDD) Necropathy: "the nest spawns Scuttlers until it is destroyed"
	},
	# Fern Basin miniboss: Ironjaw, the Nest Mother. Her nest wards her; held, her iron jaw lunges through the post.
	"prim_ironjaw": {
		"name": "Ironjaw, the Nest Mother", "sprite": "primeval/ironjaw", "rank": "miniboss",
		"hp": 3600.0, "speed": 22.0, "armour": 5.0, "radius": 24.0,  # TUNING (not in GDD) X3: under 4000, her nest wards her
		"damage": 26.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "primeval/ironjaw",
		"args": {"nest_kind": "prim_nest", "nest_ahead": 700.0, "nest_lane": 46.0, "nest_ward": 0.7,
			"bite_first": 3.0, "bite_every": 6.0, "windup": 0.7, "bite_damage": 55.0, "targets": 1},  # TUNING (not in GDD) Necropathy IronjawKit
	},
	# Scarmaw's alpha-guard: a great Razorclaw with a bone crest; while she lives Scarmaw's blood is up.
	"prim_scarmaw_guard": {
		"name": "Scarmaw's Alpha-Guard", "sprite": "primeval/scarmaw_guard", "rank": "elite",
		"hp": 1300.0, "speed": 54.0, "armour": 3.0, "radius": 14.0,  # TUNING (not in GDD)
		"damage": 16.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "banner_aura",
		"args": {"radius": 130.0, "speed_mult": 1.3, "refresh": 0.25},  # TUNING (not in GDD)
	},
	# Fern Basin boss: Scarmaw, the Great Raptor. The Hunt calls packs; the Leap clears the post holding her;
	# the Ambush hides her in the ferns; Blood Up brings her alpha-guard.
	"prim_scarmaw": {
		"name": "Scarmaw, the Great Raptor", "sprite": "primeval/scarmaw", "rank": "boss",
		"hp": 6200.0, "speed": 30.0, "armour": 4.0, "radius": 26.0,  # TUNING (not in GDD) DECISIONS Z4: 7000 -> 6200 (her leak ended seed 2 at +0.2); she walks and leaps: under the Voice (12000, who stands still)
		"damage": 30.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "primeval/scarmaw",
		"args": {"hunt_first": 4.0, "hunt_every": 15.0, "hunt": [["prim_razorclaw", 3], ["prim_razorclaw_alpha", 1]], "hunt_gap": 0.8,
			"leap_first": 8.0, "leap_every": 14.0, "windup": 0.9, "leap": 90.0, "leap_damage": 60.0, "leap_radius": 50.0,
			"ambush_hp": 0.6, "ambush_every": 18.0, "ambush_time": 3.0, "ambush_lunge": 90.0,
			"blood_hp": 0.3, "guard_kind": "prim_scarmaw_guard", "blood_haste": 1.3, "pose_time": 0.6},  # TUNING (not in GDD) Necropathy BossScarmaw / ScarmawData
	},
	# Great Plain miniboss: Mother Clubtail, an armoured matriarch whose tail sweep stuns the towers round her.
	"prim_mother_clubtail": {
		"name": "Mother Clubtail", "sprite": "primeval/mother_clubtail", "rank": "miniboss",
		"hp": 3600.0, "speed": 20.0, "armour": 8.0, "radius": 26.0,  # TUNING (not in GDD) X3: under 4000, her sweep stuns towers
		"damage": 24.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "primeval/tail_sweep",
		"args": {"first": 3.0, "every": 6.5, "windup": 1.0, "reach": 100.0, "body_damage": 36.0, "disable": 1.4},  # TUNING (not in GDD)
	},
	# Great Plain boss: Old Ironbrow, the Horned Titan. The Charge breaks every post on its line and stuns him
	# on a rock; every second charge his herd stampedes; the Break snaps a horn and he charges more often.
	"prim_ironbrow": {
		"name": "Old Ironbrow, the Horned Titan", "sprite": "primeval/ironbrow", "rank": "boss",
		"hp": 9000.0, "speed": 22.0, "armour": 6.0, "radius": 30.0,  # TUNING (not in GDD) his charges carry him past the posts: under the Voice
		"damage": 34.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "primeval/ironbrow",
		"args": {"first": 5.0, "every": 12.0, "every_broken": 8.0, "windup": 1.0, "time": 1.5, "speed_mult": 2.2, "gore": 60.0,
			"rock_r": 50.0, "rock_stun": 7.5, "stunned_mult": 1.8, "herd_every": 2, "herd": [["prim_duckbill", 4]], "herd_gap": 0.7,
			"break_hp": 0.4, "pose_time": 0.6},  # TUNING (not in GDD) Necropathy BossIronbrow / IronbrowData
	},
	# Last Day miniboss: Thunderwing, the Sky King, a giant pterosaur whose gusts clear a wide ring of towers.
	"prim_thunderwing": {
		"name": "Thunderwing, the Sky King", "sprite": "primeval/thunderwing", "rank": "miniboss",
		"hp": 2800.0, "speed": 26.0, "armour": 3.0, "radius": 24.0,  # TUNING (not in GDD) X3: a flier no post holds needs less
		"damage": 20.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": true, "ignores_walls": true, "trait": "primeval/gust",
		"args": {"first": 4.0, "every": 9.0, "windup": 1.2, "radius": 170.0, "disable": 2.0, "land_time": 3.0, "land_mult": 1.6,
			"land_slow": 0.3, "land_sprite": ""},  # TUNING (not in GDD)
	},
	# Last Day boss: Old Gravejaw, the Tyrant King. The Bite swallows a body whole; the Roar stuns the towers round
	# him and calls the swarm; on the Last Day he rampages through the posts under falling stars.
	"prim_gravejaw": {
		"name": "Old Gravejaw, the Tyrant King", "sprite": "primeval/gravejaw", "rank": "boss",
		"hp": 9500.0, "speed": 20.0, "armour": 6.0, "radius": 32.0,  # TUNING (not in GDD) the act's heaviest (the swallow and the roar weigh with it)
		"damage": 40.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "primeval/gravejaw",
		"args": {"bite_first": 3.0, "bite_every": 11.0, "windup": 1.0,
			"roar_first": 6.0, "roar_every": 15.0, "roar_windup": 1.2, "roar_radius": 150.0, "roar_stun": 1.6,
			"call": [["prim_scuttler", 8]], "call_gap": 0.4, "roar_herd": [["prim_duckbill", 3]], "herd_gap": 0.8,
			"mound_dist": 860.0, "last_hp": 0.2, "rampage_every": 10.0, "rampage_time": 1.2, "speed_mult": 2.4, "gore": 70.0, "meteor_mult": 0.5,
			"pose_time": 0.8},  # TUNING (not in GDD) Necropathy BossGravejaw / GravejawData
	},
}

## Build orders of the Titans maps (keys: BuildOrderData.ORDERS): each map's
## default (must win on Necromancer) and weak order (must lose), and one kit
## order for every Act XIV map ("titans_kit": the default with one Corpse
## Catapult a Bonehorn, raised to its Fossil Tyrant, the Abomination on the post beside it
## (Thundering Herd), and the act spells; DECISIONS Y5).
const ORDERS: Dictionary = {
	"fern_basin_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:3", "tower": "archer"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:6", "tower": "archer"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "plot:8", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:7", "mode": "strongest"},
			{"do": "build", "spot": "plot:15", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:4", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "post:4", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "build", "spot": "plot:13", "tower": "archer"},
			{"do": "build", "spot": "plot:9", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:11", "tower": "mage"},
			{"do": "build", "spot": "plot:2", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:5", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:5", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:1", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:15"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:1"},
		],
	},
	"fern_basin_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:3", "tower": "archer"},
		],
	},
	"great_plain_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:4", "tower": "archer"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "build", "spot": "plot:14", "tower": "archer"},
			{"do": "build", "spot": "post:4", "tower": "warrior"},
			{"do": "build", "spot": "plot:13", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "build", "spot": "plot:8", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:8", "mode": "strongest"},
			{"do": "build", "spot": "plot:2", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "build", "spot": "plot:5", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "build", "spot": "post:2", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:10", "tower": "archer"},
			{"do": "build", "spot": "plot:9", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "build", "spot": "plot:11", "tower": "mage"},
			{"do": "build", "spot": "plot:3", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:7", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "build", "spot": "plot:0", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:14"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:0"},
		],
	},
	"great_plain_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:4", "tower": "archer"},
		],
	},
	"last_day_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:4", "tower": "archer"},
			{"do": "build", "spot": "post:4", "tower": "warrior"},
			{"do": "build", "spot": "plot:5", "tower": "archer"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:3", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "plot:10", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:10", "mode": "strongest"},
			{"do": "build", "spot": "plot:6", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:11", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "post:2", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "build", "spot": "plot:7", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:1", "tower": "mage"},
			{"do": "build", "spot": "plot:9", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:0", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:0", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:8", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:8"},
		],
	},
	"last_day_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:4", "tower": "archer"},
		],
	},
	"titans_kit": {
		"spells": true,
		"loadout": ["meteor_call", "stampede", "pack_leap"],  # The Gravecaller's Shadow Bolt takes the last slot (CharacterModifiers.loadout)
		"steps_by_map": {
			"fern_basin": [
				{"do": "build", "spot": "plot:3", "tower": "archer"},
				{"do": "build", "spot": "post:1", "tower": "warrior"},
				{"do": "build", "spot": "plot:6", "tower": "archer"},
				{"do": "build", "spot": "post:4", "tower": "warrior"},
				{"do": "build", "spot": "plot:8", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "plot:7", "tower": "bonehorn"},
				{"do": "target", "spot": "plot:7", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "evolve", "spot": "plot:7"},
				{"do": "build", "spot": "plot:15", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "plot:4", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "post:2", "tower": "abomination"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "build", "spot": "plot:13", "tower": "archer"},
				{"do": "build", "spot": "plot:9", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "plot:11", "tower": "mage"},
				{"do": "build", "spot": "plot:2", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "post:0", "tower": "warrior"},
				{"do": "build", "spot": "post:3", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "plot:5", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:5", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "plot:1", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:15"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "post:1"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:1"},
			],
			"great_plain": [
				{"do": "build", "spot": "plot:4", "tower": "archer"},
				{"do": "build", "spot": "post:2", "tower": "warrior"},
				{"do": "build", "spot": "plot:14", "tower": "archer"},
				{"do": "build", "spot": "post:4", "tower": "warrior"},
				{"do": "build", "spot": "plot:13", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "build", "spot": "plot:8", "tower": "bonehorn"},
				{"do": "target", "spot": "plot:8", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "evolve", "spot": "plot:8"},
				{"do": "build", "spot": "plot:2", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "build", "spot": "plot:5", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "build", "spot": "post:3", "tower": "abomination"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:10", "tower": "archer"},
				{"do": "build", "spot": "plot:9", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "build", "spot": "plot:11", "tower": "mage"},
				{"do": "build", "spot": "plot:3", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "build", "spot": "post:0", "tower": "warrior"},
				{"do": "build", "spot": "post:1", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:7", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "build", "spot": "plot:0", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:14"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:0"},
			],
			"last_day": [
				{"do": "build", "spot": "plot:4", "tower": "archer"},
				{"do": "build", "spot": "post:2", "tower": "warrior"},
				{"do": "build", "spot": "plot:5", "tower": "archer"},
				{"do": "build", "spot": "post:1", "tower": "warrior"},
				{"do": "build", "spot": "plot:3", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "plot:10", "tower": "bonehorn"},
				{"do": "target", "spot": "plot:10", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "evolve", "spot": "plot:10"},
				{"do": "build", "spot": "plot:6", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:11", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "post:4", "tower": "abomination"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "plot:2", "tower": "archer"},
				{"do": "build", "spot": "plot:7", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:1", "tower": "mage"},
				{"do": "build", "spot": "plot:9", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "build", "spot": "post:0", "tower": "warrior"},
				{"do": "build", "spot": "post:3", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:0", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:0", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:8", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:1"},
				{"do": "upgrade", "spot": "plot:9"},
				{"do": "upgrade", "spot": "plot:8"},
			],
		},
	},
}

## Battlefield moods of the three maps (keys: TdMoodData.MOODS). Fern green and
## tar on the Basin, dust ochre on the Plain, volcanic orange on the Last Day.
const MOODS: Dictionary = {
	"fern_basin": {
		"props": [{"sprite": "obstacles/primeval_tree_fern_m", "frames": 1, "count": 6, "scale": 1.0, "glow": Color(0.55, 0.85, 0.4, 0.3), "glow_r": 40.0,
			"glow_at": Vector2(0, -16), "flicker": 0.05, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.6},  # TUNING (not in GDD) tree ferns swaying in a damp green light
			{"sprite": "obstacles/primeval_fossil_m", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(0.95, 0.9, 0.75, 0.3), "glow_r": 34.0,
			"glow_at": Vector2(0, -6), "flicker": 0.03, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) bleached fossils
		"fog": 3,  # TUNING (not in GDD) swamp mist
		"pools": 0,  # no stained glass in the basin
	},
	"great_plain": {
		"props": [{"sprite": "obstacles/primeval_rock_m", "frames": 1, "count": 5, "scale": 1.0, "glow": Color(1.0, 0.85, 0.55, 0.25), "glow_r": 38.0,
			"glow_at": Vector2(0, -10), "flicker": 0.04, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) sunlit boulders in the dust
			{"sprite": "obstacles/primeval_fossil_m_v", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(1.0, 0.95, 0.8, 0.25), "glow_r": 34.0,
			"glow_at": Vector2(0, -10), "flicker": 0.03, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD)
		"fog": 2,  # TUNING (not in GDD) dust haze
		"pools": 0,
	},
	"last_day": {
		"props": [{"sprite": "obstacles/primeval_lava_rock_m", "frames": 1, "count": 6, "scale": 1.0, "glow": Color(1.0, 0.45, 0.15, 0.55), "glow_r": 50.0,
			"glow_at": Vector2(0, -8), "flicker": 0.2, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) lava rocks glowing orange
			{"sprite": "obstacles/primeval_fossil_m", "frames": 1, "count": 2, "scale": 1.0, "glow": Color(1.0, 0.6, 0.3, 0.3), "glow_r": 36.0,
			"glow_at": Vector2(0, -6), "flicker": 0.1, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD)
		"fog": 3,  # TUNING (not in GDD) ash drifting
		"pools": 0,  # no stained glass on the Last Day
	},
}

## The Stampedes and the map twists (scripts/maps/rules/primeval/stampedes.gd;
## Necropathy's Herds, the Fern Basin's tar, the Great Plain's watering hole,
## the Last Day's Fire from the Sky). Numbers of the simulation first, then the look.
const RULE: Dictionary = {
	# The Stampedes: a wave group on a herd trail (map key "herd_trails": trail road id ->
	# its reversed road id) is a herd. Its trail is marked `lead` s before the first beast
	# comes (the group's delay must be at least that). Every beast tramples the towers it
	# passes and knocks down the blocker bodies on its trail (traits/primeval/herd.gd).
	"lead": 4.0,  # TUNING (not in GDD) s the dust line shows ahead of a herd (Necropathy: 2 s; a TD map needs longer to react)
	"turn_share": 0.18,  # TUNING (not in GDD) share of a herd's spawned HP that, dealt to it, turns the whole herd back (owner rule: "runs away from what hurts it")
	"mark_r": 72.0,  # TUNING (not in GDD) px from a trail within which a plot is marked as in the herd's path (drawn; the beasts' radius decides)
	# The Fern Basin's tar seeps (map key "tar": [[centre px, radius px], ...]): every
	# ground walker in one is slowed (not the swimmers: Bog Crocs sink out of sight there).
	"tar_slow": 0.5,  # TUNING (not in GDD) speed x of a walker in a tar seep
	"tick": 0.25,  # TUNING (not in GDD) s between two applications of the tar / the watering hole
	# The Great Plain's watering hole (map key "hole": [centre px, radius px]): herd beasts
	# wade in and drink (slowed hard); a herd hurt enough to turn while its beast drinks
	# there BOLTS forward instead, hasted, and no longer turns.
	"hole_slow": 0.2,  # TUNING (not in GDD) speed x of a herd beast drinking
	"bolt_haste": 1.8,  # TUNING (not in GDD) speed x of a bolting herd
	# The Last Day's Fire from the Sky (map key "meteors": true): a meteorite falls on a
	# telegraphed circle every `every` s (first after `first`), on a tower half the time
	# (seeded) and on the road ahead of the foes otherwise; it hits BOTH armies.
	"meteor": {"first": 40.0, "every": 18.0, "every_late": 11.0, "late_wave": 14, "delay": 2.6, "radius": 62.0,
		"disable": 2.5, "body_damage": 60.0, "enemy_damage": 160.0},  # TUNING (not in GDD) Necropathy LastDayDirector: telegraphed meteorites, faster each zone
	# --- The look (drawing only) ---
	"dust_tint": Color(0.85, 0.7, 0.45, 0.75),  # TUNING (not in GDD) the dust line along a marked trail (pulses)
	"dust_w": 10.0,  # TUNING (not in GDD) px of that line
	"arrow_every": 70.0,  # TUNING (not in GDD) px between two running arrows on a marked trail
	"arrow_px": 26.0,  # TUNING (not in GDD) px of one arrow (fx/primeval_dust_front, turned along the trail)
	"arrow_speed": 90.0,  # TUNING (not in GDD) px/s the arrows run down the trail
	"mark_tint": Color(1.0, 0.6, 0.25, 0.9),  # TUNING (not in GDD) the pulsing ring under a plot in the herd's path
	"mark_px": 34.0,  # TUNING (not in GDD) px radius of that ring
	"turn_tint": Color(0.75, 0.95, 0.6, 0.9),  # TUNING (not in GDD) the burst over a herd that turns back
	"pool_tar": Color(1.0, 1.0, 1.0, 0.95),  # TUNING (not in GDD) tar seep art modulate
	"pool_hole": Color(1.0, 1.0, 1.0, 0.95),  # TUNING (not in GDD) watering hole art modulate
	"meteor_tint": Color(1.0, 0.5, 0.2, 0.9),  # TUNING (not in GDD) the meteor's landing ring and streak
	"meteor_lift": 260.0,  # TUNING (not in GDD) px above its circle a meteor starts its fall (drawn)
	"meteor_px": 14.0,  # TUNING (not in GDD) px of the burning rock (drawn)
	"cue_px": 32.0,  # TUNING (not in GDD) HUD cue icon size (px)
	"cue_margin": Vector2(10.0, 54.0),  # TUNING (not in GDD) px from the screen's left / top edges (under the top bar)
	"cue_color": Color(0.95, 0.85, 0.6),  # TUNING (not in GDD) the label: dust ochre
	"cue_hot": Color(1.0, 0.55, 0.3),  # TUNING (not in GDD) the label while a stampede is coming
}

## The act's looks (drawing only; read by its traits, bosses, spells and tower).
const LOOK: Dictionary = {
	"line_tint": Color(1.0, 0.75, 0.4, 0.55),  # TUNING (not in GDD) a telegraph line (leap, charge, lunge)
	"line_w": 5.0,  # TUNING (not in GDD) px
	"cut_tint": Color(1.0, 0.95, 0.85, 1.0),  # TUNING (not in GDD) the bright strike line
	"cut_w": 12.0,  # TUNING (not in GDD) px
	"cut_time": 0.35,  # TUNING (not in GDD) s the strike shows
	"warn_tint": Color(1.0, 0.6, 0.3, 0.65),  # TUNING (not in GDD) a roar / sweep / gust telegraph ring
	"roar_tint": Color(1.0, 0.75, 0.4, 0.95),  # TUNING (not in GDD) the roar's ring
	"gust_tint": Color(0.85, 0.95, 1.0, 0.9),  # TUNING (not in GDD) a wing gust's ring
	"sweep_tint": Color(0.95, 0.85, 0.6, 0.95),  # TUNING (not in GDD) a tail sweep's ring
	"gore_tint": Color(1.0, 0.6, 0.35),  # TUNING (not in GDD) a charge's goring burst
	"gore_d": 70.0,  # TUNING (not in GDD) px of that burst
	"ward_tint": Color(0.95, 0.9, 0.7, 0.7),  # TUNING (not in GDD) the thread from Ironjaw to her nest
	"stun_tint": Color(1.0, 0.9, 0.4),  # TUNING (not in GDD) the stars over a charger stunned on a rock
	# --- The act spells and tower ---
	"leap_d": 70.0,  # TUNING (not in GDD) px of a Pack Leap raptor's landing burst
	"herd_px": 26.0,  # TUNING (not in GDD) px of the spectral herd's drawn front (Stampede)
	"bonehorn_w": 18.0,  # TUNING (not in GDD) px of the Bonehorn's charge streak
}
