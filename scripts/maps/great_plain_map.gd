## The Great Plain (Act XIV map 2, the Age of Titans; Necropathy's "great_plain"
## stage, GDD §7.3): open dust flats under a hot sky, a canyon of red walls in
## the east and the watering hole in the middle. Two paths come in from the west
## in wide sweeping arcs, meet in the middle, and the joined path sweeps north
## round the plain and back south to the necromancer's gate at the canyon's
## mouth. Two herd trails cross the plain (off-road, exits): the long trail from
## the east to the watering hole and south, and the canyon trail north to south.
## At the WATERING HOLE herd beasts wade in to drink; a beast hurt there bolts
## its whole herd forward instead of turning it. Rocks beside the road stop a
## charge (MAP "rocks"): a Horncharger or Ironbrow that runs into one is
## stunned. Act rule: the Stampedes (rules/primeval/stampedes.gd). 16 plots, 5
## posts, 23 waves; Mother Clubtail (miniboss) on wave 12, Old Ironbrow on wave
## 23. Keys as graveyard_map.gd plus "herd_trails", "hole", "rocks" (the act
## rule and its charge kit). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and stampedes.gd).
const MAP: Dictionary = {
	"id": "great_plain",
	"name": "The Great Plain",
	"floor": "tiles/great_plain_dust_flats",
	"decals": [],
	"obstacles": [
		["obstacles/primeval_rock_m", Vector2(483, 604)], ["obstacles/primeval_rock_m", Vector2(653, 95)],
		["obstacles/primeval_rock_m", Vector2(1012, 464)], ["obstacles/primeval_canyon_wall_m_v", Vector2(1250, 330)],
		["obstacles/primeval_canyon_wall_m", Vector2(1010, 120)], ["obstacles/primeval_canyon_wall_m_v", Vector2(1250, 560)],
		["obstacles/primeval_fossil_m", Vector2(120, 380)], ["obstacles/primeval_rock_m", Vector2(60, 690)],
		["obstacles/primeval_fossil_m_v", Vector2(660, 690)], ["obstacles/primeval_rock_m", Vector2(913, 193)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 620), Vector2(-24, 621), Vector2(-4, 624), Vector2(20, 627), Vector2(47, 630),
				Vector2(76, 633), Vector2(106, 637), Vector2(137, 639), Vector2(167, 641), Vector2(197, 642),
				Vector2(225, 642), Vector2(250, 640), Vector2(279, 636), Vector2(308, 630), Vector2(337, 624),
				Vector2(365, 616), Vector2(391, 607), Vector2(417, 596), Vector2(440, 585), Vector2(461, 573),
				Vector2(480, 560), Vector2(504, 538), Vector2(524, 512), Vector2(539, 484), Vector2(551, 455),
				Vector2(558, 426), Vector2(560, 400), Vector2(554, 375), Vector2(539, 351), Vector2(519, 327),
				Vector2(500, 304), Vector2(485, 281), Vector2(480, 260), Vector2(485, 235), Vector2(498, 209),
				Vector2(517, 186), Vector2(542, 165), Vector2(570, 150), Vector2(590, 143), Vector2(613, 138),
				Vector2(639, 134), Vector2(666, 132), Vector2(694, 131), Vector2(723, 132), Vector2(751, 133),
				Vector2(780, 135), Vector2(806, 138), Vector2(834, 141), Vector2(864, 145), Vector2(893, 150),
				Vector2(923, 156), Vector2(951, 163), Vector2(977, 171), Vector2(1000, 180), Vector2(1020, 190),
				Vector2(1044, 208), Vector2(1063, 230), Vector2(1078, 255), Vector2(1089, 280), Vector2(1096, 306),
				Vector2(1100, 330), Vector2(1096, 358), Vector2(1084, 387), Vector2(1068, 415), Vector2(1054, 443),
				Vector2(1050, 470), Vector2(1056, 498), Vector2(1069, 529), Vector2(1086, 557), Vector2(1104, 578),
				Vector2(1120, 590), Vector2(1147, 578), Vector2(1175, 545), Vector2(1195, 520)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"north": {
			"points": [Vector2(-40, 300), Vector2(-24, 301), Vector2(-2, 302), Vector2(24, 304), Vector2(53, 305),
				Vector2(84, 307), Vector2(116, 309), Vector2(146, 310), Vector2(175, 310), Vector2(200, 310),
				Vector2(234, 308), Vector2(268, 306), Vector2(299, 302), Vector2(328, 298), Vector2(356, 294),
				Vector2(380, 290), Vector2(422, 281), Vector2(454, 271), Vector2(476, 264)],
			"next": "main", "next_at": 882.6,  # joins main at (481, 263)
			"entrance": true,
		},
		"long_trail": {
			"points": [Vector2(1320, 450), Vector2(980, 450), Vector2(820, 420), Vector2(560, 450), Vector2(560, 560),
				Vector2(600, 780)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
		"long_trail_back": {
			"points": [Vector2(600, 780), Vector2(560, 560), Vector2(560, 450), Vector2(820, 420), Vector2(980, 450),
				Vector2(1320, 450)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
		"canyon_trail": {
			"points": [Vector2(940, -40), Vector2(940, 200), Vector2(980, 330), Vector2(940, 560), Vector2(960, 780)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
		"canyon_trail_back": {
			"points": [Vector2(960, 780), Vector2(940, 560), Vector2(980, 330), Vector2(940, 200), Vector2(940, -40)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
	},
	"herd_trails": {"long_trail": "long_trail_back", "canyon_trail": "canyon_trail_back"},  # Herd trails and the roads a turned herd runs back along.
	"hole": [Vector2(815, 425), 56.0],  # TUNING (not in GDD) the watering hole: centre px, radius px
	"rocks": [Vector2(483, 604), Vector2(653, 95), Vector2(1012, 464), Vector2(913, 193)],  # The rocks beside the road a charge breaks on (the obstacles of the same place).
	"gate": Vector2(1210, 495),
	"plots": [
		Vector2(350, 550), Vector2(250, 580), Vector2(1140, 430), Vector2(420, 510), Vector2(640, 230), Vector2(240, 250),
		Vector2(760, 190), Vector2(170, 370), Vector2(410, 220), Vector2(160, 250), Vector2(990, 300), Vector2(950, 230),
		Vector2(150, 580), Vector2(550, 250), Vector2(450, 410), Vector2(1030, 590),
	],
	"posts": [Vector2(177, 642), Vector2(135, 309), Vector2(490, 551), Vector2(714, 132), Vector2(1054, 443)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 2.25,  # TUNING (not in GDD) L4: 2.5 before the road redraw; its roster (charges, sweeps, herds) carries the difficulty; 2.5 loses seeds 3-4 (cliff check)
	"rule": "",
	"act_rule": "primeval/stampedes",
	"build_order": "great_plain_default",
	"weak_order": "great_plain_weak",
	"waves": [
		{"banner": "The Dust Flats: the plain is alive", "groups": [{"kind": "prim_scuttler", "count": 12, "spacing": 0.5}, {"kind": "prim_razorclaw", "count": 4, "spacing": 1.3, "delay": 2.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "prim_razorclaw", "count": 6, "spacing": 1.0}, {"kind": "prim_frill_spitter", "count": 3, "spacing": 1.4, "delay": 3.0, "road": "north"}]},
		{"banner": "A herd on the long trail: hurt it before it reaches your plots and it turns back", "groups": [{"kind": "prim_duckbill", "count": 3, "spacing": 1.2, "delay": 5.0, "road": "long_trail"}, {"kind": "prim_scuttler", "count": 12, "spacing": 0.45}, {"kind": "prim_razorclaw", "count": 4, "spacing": 1.2, "delay": 3.0, "road": "north"}]},
		{"banner": "The watering hole: a beast hurt while it drinks sends its herd bolting on", "groups": [{"kind": "prim_frill_spitter", "count": 6, "spacing": 1.2}, {"kind": "prim_razorclaw", "count": 6, "spacing": 1.0, "delay": 2.0, "road": "north"}]},
		{"banner": "Hornchargers break through your posts, but a rock stops them cold", "groups": [{"kind": "prim_horncharger", "count": 2, "spacing": 5.0}, {"kind": "prim_scuttler", "count": 14, "spacing": 0.45, "delay": 2.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "prim_skyraider", "count": 8, "spacing": 0.8}, {"kind": "prim_razorclaw", "count": 8, "spacing": 0.9, "delay": 2.0}, {"kind": "prim_duckbill", "count": 4, "spacing": 1.1, "delay": 5.0, "road": "canyon_trail"}]},
		{"banner": "Clubtails: armour plates and a tail that sweeps your posts", "groups": [{"kind": "prim_clubtail", "count": 2, "spacing": 5.0, "road": "north"}, {"kind": "prim_frill_spitter", "count": 6, "spacing": 1.1, "delay": 2.0}, {"kind": "prim_scuttler", "count": 12, "spacing": 0.4, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 10, "spacing": 0.8, "delay": 1.0}, {"kind": "prim_longneck", "count": 2, "spacing": 3.0, "delay": 5.0, "road": "long_trail"}]},
		{"banner": "", "groups": [{"kind": "prim_horncharger", "count": 2, "spacing": 4.0, "road": "north"}, {"kind": "prim_skyraider", "count": 8, "spacing": 0.8, "delay": 2.0}, {"kind": "prim_frill_spitter", "count": 6, "spacing": 1.1, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "prim_clubtail", "count": 2, "spacing": 4.0}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8, "delay": 2.0, "road": "north"}, {"kind": "prim_duckbill", "count": 5, "spacing": 1.0, "delay": 6.0, "road": "canyon_trail"}]},
		{"banner": "The Canyon", "groups": [{"kind": "prim_scuttler", "count": 20, "spacing": 0.35}, {"kind": "prim_horncharger", "count": 2, "spacing": 4.0, "delay": 3.0}, {"kind": "prim_frill_spitter", "count": 6, "spacing": 1.1, "delay": 5.0, "road": "north"}]},
		{"banner": "MOTHER CLUBTAIL! Her sweep stuns the towers round her", "groups": [{"kind": "prim_mother_clubtail", "count": 1, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 10, "spacing": 0.9, "delay": 3.0, "road": "north"}, {"kind": "prim_scuttler", "count": 12, "spacing": 0.45, "delay": 7.0}]},
		{"banner": "", "groups": [{"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0, "road": "north"}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8}, {"kind": "prim_longneck", "count": 2, "spacing": 3.0, "delay": 5.0, "road": "long_trail"}, {"kind": "prim_skyraider", "count": 6, "spacing": 0.9, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "prim_clubtail", "count": 2, "spacing": 4.0, "road": "north"}, {"kind": "prim_horncharger", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "prim_frill_spitter", "count": 8, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "A Tyrant crosses the plain", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0}, {"kind": "prim_scuttler", "count": 18, "spacing": 0.35, "delay": 2.0, "road": "north"}, {"kind": "prim_duckbill", "count": 5, "spacing": 1.0, "delay": 6.0, "road": "canyon_trail"}]},
		{"banner": "", "groups": [{"kind": "prim_horncharger", "count": 3, "spacing": 3.5, "road": "north"}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8, "delay": 2.0}, {"kind": "prim_skyraider", "count": 8, "spacing": 0.8, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "prim_clubtail", "count": 3, "spacing": 3.5}, {"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "north"}, {"kind": "prim_frill_spitter", "count": 10, "spacing": 0.9, "delay": 3.0}, {"kind": "prim_longneck", "count": 3, "spacing": 2.5, "delay": 6.0, "road": "long_trail"}]},
		{"banner": "The Watering Hole", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0, "road": "north"}, {"kind": "prim_horncharger", "count": 2, "spacing": 4.0, "delay": 3.0}, {"kind": "prim_scuttler", "count": 20, "spacing": 0.35, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "prim_razorclaw", "count": 14, "spacing": 0.7, "road": "north"}, {"kind": "prim_clubtail", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "prim_skyraider", "count": 10, "spacing": 0.7, "delay": 5.0}, {"kind": "prim_duckbill", "count": 6, "spacing": 0.9, "delay": 6.0, "road": "canyon_trail"}]},
		{"banner": "", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0}, {"kind": "prim_horncharger", "count": 3, "spacing": 3.5, "delay": 2.0, "road": "north"}, {"kind": "prim_frill_spitter", "count": 10, "spacing": 0.9, "delay": 4.0}]},
		{"banner": "The Bone Gate", "groups": [{"kind": "prim_clubtail", "count": 3, "spacing": 3.5, "road": "north"}, {"kind": "prim_razorclaw_alpha", "count": 2, "spacing": 3.0, "delay": 2.0}, {"kind": "prim_razorclaw", "count": 14, "spacing": 0.7, "delay": 3.0}, {"kind": "prim_longneck", "count": 3, "spacing": 2.5, "delay": 6.0, "road": "long_trail"}]},
		{"banner": "Every herd of the plain is running", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0, "road": "north"}, {"kind": "prim_horncharger", "count": 3, "spacing": 3.0, "delay": 2.0}, {"kind": "prim_skyraider", "count": 10, "spacing": 0.7, "delay": 4.0}, {"kind": "prim_duckbill", "count": 6, "spacing": 0.9, "delay": 6.0, "road": "canyon_trail"}]},
		{"banner": "OLD IRONBROW, THE HORNED TITAN, leads the herd!", "groups": [{"kind": "prim_ironbrow", "count": 1, "spacing": 1.0}, {"kind": "prim_horncharger", "count": 2, "spacing": 5.0, "delay": 8.0, "road": "north"}, {"kind": "prim_razorclaw", "count": 10, "spacing": 1.0, "delay": 12.0}]},
	],
}
