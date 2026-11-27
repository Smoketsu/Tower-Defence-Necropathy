## The Fern Basin (Act XIV map 1, the Age of Titans; Necropathy's "fern_basin"
## stage, GDD §7.3): a steaming basin of tree ferns, tar seeps and bleached
## fossils. The hunters' game trail enters from the west, dips in one big smooth
## bowl down through the basin (through a tar seep) and climbs out to the
## necromancer's gate in the east; a second path comes up from the river ford in
## the south (through another seep) and joins it at the bowl's bottom. A herd
## trail runs north to south across the eastern basin (off-road, an exit): herds
## trample the plots beside it unless they are hurt enough to turn back. Tar
## seeps slow every walker (Bog Crocs sink out of sight in them). Act rule: the
## Stampedes (rules/primeval/stampedes.gd). 16 plots, 5 posts, 22 waves;
## Ironjaw, the Nest Mother (miniboss) on wave 11, Scarmaw on wave 22. Keys as
## graveyard_map.gd plus "herd_trails", "tar" (the act rule). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and stampedes.gd).
const MAP: Dictionary = {
	"id": "fern_basin",
	"name": "The Fern Basin",
	"floor": "tiles/fern_basin_fern_floor",
	"decals": [],
	"obstacles": [
		["obstacles/primeval_tree_fern_m", Vector2(60, 420)], ["obstacles/primeval_tree_fern_m", Vector2(250, 120)],
		["obstacles/primeval_fossil_m", Vector2(520, 300)], ["obstacles/primeval_tree_fern_m", Vector2(700, 110)],
		["obstacles/primeval_rock_m", Vector2(1205, 131)], ["obstacles/primeval_tree_fern_m", Vector2(1240, 620)],
		["obstacles/primeval_fossil_m_v", Vector2(80, 620)], ["obstacles/primeval_tree_fern_m", Vector2(830, 657)],
		["obstacles/primeval_rock_m", Vector2(400, 680)], ["obstacles/primeval_tree_fern_m", Vector2(1040, 420)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 190), Vector2(-23, 190), Vector2(-1, 189), Vector2(26, 188), Vector2(56, 186),
				Vector2(88, 186), Vector2(119, 186), Vector2(149, 187), Vector2(177, 190), Vector2(200, 195),
				Vector2(230, 206), Vector2(257, 222), Vector2(282, 240), Vector2(303, 259), Vector2(319, 280),
				Vector2(330, 300), Vector2(331, 324), Vector2(320, 350), Vector2(306, 377), Vector2(296, 404),
				Vector2(300, 430), Vector2(312, 449), Vector2(330, 470), Vector2(351, 490), Vector2(376, 511),
				Vector2(403, 529), Vector2(431, 546), Vector2(460, 560), Vector2(483, 569), Vector2(508, 576),
				Vector2(534, 583), Vector2(561, 588), Vector2(588, 593), Vector2(616, 596), Vector2(644, 598),
				Vector2(672, 600), Vector2(700, 600), Vector2(728, 600), Vector2(757, 598), Vector2(787, 596),
				Vector2(816, 593), Vector2(846, 588), Vector2(874, 583), Vector2(902, 576), Vector2(927, 569),
				Vector2(950, 560), Vector2(977, 546), Vector2(1003, 530), Vector2(1027, 511), Vector2(1048, 491),
				Vector2(1066, 470), Vector2(1080, 450), Vector2(1090, 430), Vector2(1091, 401), Vector2(1078, 371),
				Vector2(1062, 341), Vector2(1049, 313), Vector2(1050, 290), Vector2(1069, 272), Vector2(1100, 257),
				Vector2(1135, 246), Vector2(1168, 237), Vector2(1190, 230)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"ford": {
			"points": [Vector2(620, 770), Vector2(627, 749), Vector2(638, 720), Vector2(650, 690), Vector2(664, 659),
				Vector2(679, 627), Vector2(690, 604)],
			"next": "main", "next_at": 994.2,  # joins main at (690, 600)
			"entrance": true,
		},
		"fern_trail": {
			"points": [Vector2(980, -40), Vector2(980, 110), Vector2(930, 300), Vector2(900, 420), Vector2(940, 620),
				Vector2(940, 780)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
		"fern_trail_back": {
			"points": [Vector2(940, 780), Vector2(940, 620), Vector2(900, 420), Vector2(930, 300), Vector2(980, 110),
				Vector2(980, -40)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
	},
	"herd_trails": {"fern_trail": "fern_trail_back"},  # The herd trail and the road a turned herd runs back along.
	"tar": [[Vector2(331, 314), 52.0], [Vector2(905, 370), 48.0], [Vector2(662, 660), 40.0]],  # TUNING (not in GDD) tar seeps: [centre px, radius px]
	"gate": Vector2(1217, 192),
	"plots": [
		Vector2(1140, 310), Vector2(820, 530), Vector2(1000, 380), Vector2(180, 290), Vector2(960, 450), Vector2(380, 380),
		Vector2(530, 650), Vector2(640, 540), Vector2(780, 660), Vector2(1150, 390), Vector2(490, 500), Vector2(250, 330),
		Vector2(110, 250), Vector2(420, 450), Vector2(1020, 600), Vector2(720, 540),
	],
	"posts": [Vector2(202, 196), Vector2(598, 594), Vector2(897, 578), Vector2(1077, 455), Vector2(1067, 273)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 2.4,  # TUNING (not in GDD) L4: 2.9 before the road redraw; S3: 2.8 before the spot fix; Part Three: its roster carries the step up (DECISIONS T14.7)
	"rule": "",
	"act_rule": "primeval/stampedes",
	"build_order": "fern_basin_default",
	"weak_order": "fern_basin_weak",
	"waves": [
		{"banner": "The Fern Floor: scuttlers stream through the ferns", "groups": [{"kind": "prim_scuttler", "count": 14, "spacing": 0.5}, {"kind": "prim_razorclaw", "count": 4, "spacing": 1.4, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "prim_razorclaw", "count": 8, "spacing": 1.1}, {"kind": "prim_scuttler", "count": 10, "spacing": 0.5, "delay": 2.0, "road": "ford"}]},
		{"banner": "Frill-Spitters lob venom over your posts", "groups": [{"kind": "prim_frill_spitter", "count": 3, "spacing": 1.4}, {"kind": "prim_razorclaw", "count": 4, "spacing": 1.1, "delay": 3.0}]},
		{"banner": "A herd on the fern trail: hurt it before it reaches your plots and it turns back", "groups": [{"kind": "prim_duckbill", "count": 4, "spacing": 1.2, "delay": 5.0, "road": "fern_trail"}, {"kind": "prim_scuttler", "count": 10, "spacing": 0.5}, {"kind": "prim_razorclaw", "count": 3, "spacing": 1.2, "delay": 3.0, "road": "ford"}]},
		{"banner": "Razorclaws leap over the first post that holds them", "groups": [{"kind": "prim_razorclaw", "count": 10, "spacing": 0.9}, {"kind": "prim_frill_spitter", "count": 4, "spacing": 1.4, "delay": 4.0, "road": "ford"}]},
		{"banner": "Bog Crocs sink out of sight in the tar seeps", "groups": [{"kind": "prim_bog_croc", "count": 3, "spacing": 2.0}, {"kind": "prim_scuttler", "count": 14, "spacing": 0.4, "delay": 2.0}, {"kind": "prim_frill_spitter", "count": 4, "spacing": 1.3, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "prim_skyraider", "count": 4, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 6, "spacing": 1.0, "delay": 2.0, "road": "ford"}, {"kind": "prim_duckbill", "count": 3, "spacing": 1.2, "delay": 6.0, "road": "fern_trail"}]},
		{"banner": "An alpha leads the pack: kill her first", "groups": [{"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 10, "spacing": 0.8, "delay": 1.0}, {"kind": "prim_bog_croc", "count": 3, "spacing": 2.0, "delay": 5.0, "road": "ford"}]},
		{"banner": "Longnecks: slow, huge, and they flatten what they pass", "groups": [{"kind": "prim_longneck", "count": 2, "spacing": 3.0, "delay": 5.0, "road": "fern_trail"}, {"kind": "prim_frill_spitter", "count": 8, "spacing": 1.0}, {"kind": "prim_scuttler", "count": 16, "spacing": 0.4, "delay": 3.0, "road": "ford"}]},
		{"banner": "", "groups": [{"kind": "prim_bog_croc", "count": 5, "spacing": 1.8}, {"kind": "prim_skyraider", "count": 8, "spacing": 0.8, "delay": 3.0}, {"kind": "prim_razorclaw", "count": 8, "spacing": 0.9, "delay": 5.0, "road": "ford"}]},
		{"banner": "IRONJAW, THE NEST MOTHER! Break her nest, then bring her down", "groups": [{"kind": "prim_ironjaw", "count": 1, "spacing": 1.0}, {"kind": "prim_scuttler", "count": 12, "spacing": 0.5, "delay": 3.0}, {"kind": "prim_razorclaw", "count": 6, "spacing": 1.0, "delay": 6.0, "road": "ford"}]},
		{"banner": "", "groups": [{"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0, "road": "ford"}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8}, {"kind": "prim_frill_spitter", "count": 6, "spacing": 1.1, "delay": 4.0}, {"kind": "prim_duckbill", "count": 4, "spacing": 1.1, "delay": 6.0, "road": "fern_trail"}]},
		{"banner": "The Tar Seep", "groups": [{"kind": "prim_bog_croc", "count": 6, "spacing": 1.5}, {"kind": "prim_scuttler", "count": 18, "spacing": 0.35, "delay": 2.0, "road": "ford"}, {"kind": "prim_skyraider", "count": 6, "spacing": 0.9, "delay": 4.0}]},
		{"banner": "A Tyrant walks the basin: its roar stuns your towers", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 10, "spacing": 0.9, "delay": 2.0, "road": "ford"}, {"kind": "prim_frill_spitter", "count": 6, "spacing": 1.1, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "prim_longneck", "count": 3, "spacing": 2.5, "delay": 5.0, "road": "fern_trail"}, {"kind": "prim_razorclaw_alpha", "count": 2, "spacing": 4.0}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8, "delay": 3.0}, {"kind": "prim_skyraider", "count": 6, "spacing": 0.9, "delay": 6.0, "road": "ford"}]},
		{"banner": "", "groups": [{"kind": "prim_bog_croc", "count": 6, "spacing": 1.4, "road": "ford"}, {"kind": "prim_frill_spitter", "count": 10, "spacing": 0.9, "delay": 2.0}, {"kind": "prim_scuttler", "count": 20, "spacing": 0.35, "delay": 4.0}]},
		{"banner": "The River Ford", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0, "road": "ford"}, {"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0, "delay": 3.0}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8, "delay": 4.0}, {"kind": "prim_duckbill", "count": 5, "spacing": 1.0, "delay": 8.0, "road": "fern_trail"}]},
		{"banner": "", "groups": [{"kind": "prim_skyraider", "count": 12, "spacing": 0.6}, {"kind": "prim_bog_croc", "count": 6, "spacing": 1.4, "delay": 2.0, "road": "ford"}, {"kind": "prim_frill_spitter", "count": 8, "spacing": 1.0, "delay": 5.0}]},
		{"banner": "The Nesting Hollow", "groups": [{"kind": "prim_tyrant", "count": 2, "spacing": 7.0}, {"kind": "prim_razorclaw", "count": 14, "spacing": 0.7, "delay": 2.0, "road": "ford"}, {"kind": "prim_longneck", "count": 2, "spacing": 3.0, "delay": 6.0, "road": "fern_trail"}]},
		{"banner": "", "groups": [{"kind": "prim_razorclaw_alpha", "count": 2, "spacing": 3.0, "road": "ford"}, {"kind": "prim_bog_croc", "count": 8, "spacing": 1.2, "delay": 2.0}, {"kind": "prim_scuttler", "count": 24, "spacing": 0.3, "delay": 4.0, "road": "ford"}]},
		{"banner": "The whole basin wakes", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0}, {"kind": "prim_frill_spitter", "count": 12, "spacing": 0.8, "delay": 2.0, "road": "ford"}, {"kind": "prim_razorclaw", "count": 14, "spacing": 0.7, "delay": 4.0}, {"kind": "prim_skyraider", "count": 8, "spacing": 0.8, "delay": 6.0}, {"kind": "prim_duckbill", "count": 5, "spacing": 1.0, "delay": 8.0, "road": "fern_trail"}]},
		{"banner": "SCARMAW, THE GREAT RAPTOR, comes for the hunt!", "groups": [{"kind": "prim_scarmaw", "count": 1, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 10, "spacing": 1.0, "delay": 6.0, "road": "ford"}, {"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0, "delay": 10.0}, {"kind": "prim_frill_spitter", "count": 6, "spacing": 1.2, "delay": 12.0}]},
	],
}
