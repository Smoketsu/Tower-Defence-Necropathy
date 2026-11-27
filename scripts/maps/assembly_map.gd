## The Assembly Halls (Act XII map 2; Necropathy stage "assembly"): the Empire's
## factory floor of conveyor loops. The one road drops in from the north onto
## the east conveyor and rides three quarters of its loop, crosses to the west
## conveyor and rides three quarters of that one the other way, then runs off to
## the gate at the bottom centre (2800 px), so the plots inside each loop cover
## it all the way round. 14 plots, 6 posts. 23 waves. Line of Fire (act rule
## empire/line_of_fire). Fabricators crawl the lines building drones; the Beta
## Build (miniboss, chest) on wave 12 patches itself from them; the Motherboard
## on wave 23. Keys as graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "assembly",
	"name": "The Assembly Halls",
	"floor": "tiles/assembly_fabricator",
	"decals": [],
	"obstacles": [
		["obstacles/press_machine_l", Vector2(430, 265)], ["obstacles/cargo_crate_l", Vector2(830, 265)],
		["obstacles/press_machine_s", Vector2(630, 460)], ["obstacles/cargo_crate_s", Vector2(1030, 470)],
		["obstacles/press_machine_l_v", Vector2(1142, 380)], ["obstacles/cargo_crate_l_v", Vector2(43, 490)],
		["obstacles/citadel_crate_m", Vector2(400, 660)], ["obstacles/press_machine_s", Vector2(900, 660)],
		["obstacles/cargo_crate_s", Vector2(50, 230)], ["obstacles/press_machine_s_v", Vector2(240, 460)],
	],
	"roads": {
		"main": {
			"points": [Vector2(955, -40), Vector2(955, 150), Vector2(981, 151), Vector2(1006, 154), Vector2(1031, 160),
				Vector2(1055, 167), Vector2(1078, 176), Vector2(1099, 188), Vector2(1120, 201), Vector2(1138, 216),
				Vector2(1155, 232), Vector2(1170, 249), Vector2(1183, 268), Vector2(1193, 288), Vector2(1201, 308),
				Vector2(1206, 329), Vector2(1209, 351), Vector2(1210, 372), Vector2(1208, 394), Vector2(1203, 415),
				Vector2(1196, 436), Vector2(1186, 456), Vector2(1174, 475), Vector2(1160, 493), Vector2(1144, 509),
				Vector2(1126, 524), Vector2(1106, 538), Vector2(1085, 550), Vector2(1062, 560), Vector2(1039, 568),
				Vector2(1014, 574), Vector2(989, 578), Vector2(964, 580), Vector2(938, 580), Vector2(913, 577),
				Vector2(888, 572), Vector2(863, 566), Vector2(840, 557), Vector2(818, 546), Vector2(797, 534),
				Vector2(778, 520), Vector2(760, 504), Vector2(745, 487), Vector2(731, 468), Vector2(720, 449),
				Vector2(711, 429), Vector2(705, 408), Vector2(701, 387), Vector2(700, 365), Vector2(585, 365),
				Vector2(584, 343), Vector2(580, 322), Vector2(574, 301), Vector2(565, 281), Vector2(554, 262),
				Vector2(540, 243), Vector2(525, 226), Vector2(507, 210), Vector2(488, 196), Vector2(467, 184),
				Vector2(445, 173), Vector2(422, 164), Vector2(397, 158), Vector2(372, 153), Vector2(347, 150),
				Vector2(321, 150), Vector2(296, 152), Vector2(271, 156), Vector2(246, 162), Vector2(223, 170),
				Vector2(200, 180), Vector2(179, 192), Vector2(159, 206), Vector2(141, 221), Vector2(125, 237),
				Vector2(111, 255), Vector2(99, 274), Vector2(89, 294), Vector2(82, 315), Vector2(77, 336),
				Vector2(75, 358), Vector2(76, 379), Vector2(79, 401), Vector2(84, 422), Vector2(92, 442),
				Vector2(102, 462), Vector2(115, 481), Vector2(130, 498), Vector2(147, 514), Vector2(165, 529),
				Vector2(186, 542), Vector2(207, 554), Vector2(230, 563), Vector2(254, 570), Vector2(279, 576),
				Vector2(304, 579), Vector2(330, 580), Vector2(640, 615)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
	},
	"gate": Vector2(668, 588),
	"plots": [
		Vector2(480, 280), Vector2(170, 340), Vector2(1080, 110), Vector2(650, 500), Vector2(640, 310), Vector2(270, 220),
		Vector2(160, 420), Vector2(1130, 310), Vector2(1130, 410), Vector2(880, 500), Vector2(370, 220), Vector2(960, 520),
		Vector2(300, 510), Vector2(400, 530),
	],
	"posts": [Vector2(1175, 257), Vector2(861, 565), Vector2(584, 344), Vector2(201, 180), Vector2(139, 507), Vector2(445, 593)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 2.2,  # TUNING (not in GDD) B4: 2.6 before the balance pass; L4: 3.6 before the road redraw; DECISIONS Z4: 3.35 -> 3.6; Part Three
	"rule": "",
	"act_rule": "empire/line_of_fire",
	"build_order": "assembly_default",
	"weak_order": "assembly_weak",
	"waves": [
		{"banner": "The line starts: drones and troopers roll off it", "groups": [{"kind": "empire_scout_drone", "count": 8, "spacing": 0.6}, {"kind": "empire_line_trooper", "count": 3, "spacing": 1.1, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "empire_line_trooper", "count": 6, "spacing": 1.1}, {"kind": "empire_aegis_bot", "count": 3, "spacing": 1.2, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "empire_aegis_bot", "count": 6, "spacing": 1.2}, {"kind": "empire_scout_drone", "count": 8, "spacing": 0.6, "delay": 2.0}]},
		{"banner": "Arc Engineers: they repair the machines and jam your towers", "groups": [{"kind": "empire_arc_engineer", "count": 1, "spacing": 1.0}, {"kind": "empire_line_trooper", "count": 6, "spacing": 1.1, "delay": 1.0}, {"kind": "empire_spotter", "count": 1, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "Fabricators: each one builds drones until it is smashed", "groups": [{"kind": "empire_fabricator", "count": 1, "spacing": 1.0}, {"kind": "empire_line_trooper", "count": 6, "spacing": 1.1, "delay": 1.0}, {"kind": "empire_aegis_bot", "count": 4, "spacing": 1.2, "delay": 3.0}]},
		{"banner": "Juggernauts: armour and a flamethrower. Mages pierce the plate", "groups": [{"kind": "empire_juggernaut", "count": 1, "spacing": 1.0}, {"kind": "empire_line_trooper", "count": 8, "spacing": 1.1, "delay": 1.0}, {"kind": "empire_scout_drone", "count": 8, "spacing": 0.6, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "empire_scout_drone", "count": 12, "spacing": 0.6}, {"kind": "empire_aegis_bot", "count": 8, "spacing": 1.2, "delay": 2.0}, {"kind": "empire_spotter", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "empire_mortar_walker", "count": 1, "spacing": 1.0}, {"kind": "empire_line_trooper", "count": 10, "spacing": 1.1, "delay": 1.0}, {"kind": "empire_arc_engineer", "count": 1, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "empire_juggernaut", "count": 1, "spacing": 1.0}, {"kind": "empire_aegis_bot", "count": 10, "spacing": 1.2, "delay": 1.0}, {"kind": "empire_fabricator", "count": 1, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "The Fabricator Floor", "groups": [{"kind": "empire_kill_drone", "count": 2, "spacing": 3.5}, {"kind": "empire_line_trooper", "count": 10, "spacing": 1.1, "delay": 1.0}, {"kind": "empire_arc_engineer", "count": 1, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "empire_fabricator", "count": 1, "spacing": 1.0}, {"kind": "empire_aegis_bot", "count": 8, "spacing": 1.2, "delay": 1.0}, {"kind": "empire_spotter", "count": 1, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "The Beta Build: it patches itself from every Fabricator standing!", "groups": [{"kind": "empire_beta_build", "count": 1, "spacing": 1.0}, {"kind": "empire_fabricator", "count": 1, "spacing": 1.0, "delay": 1.0}, {"kind": "empire_line_trooper", "count": 8, "spacing": 1.1, "delay": 2.0}, {"kind": "empire_aegis_bot", "count": 6, "spacing": 1.2, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "empire_juggernaut", "count": 1, "spacing": 1.0}, {"kind": "empire_line_trooper", "count": 12, "spacing": 1.1, "delay": 1.0}, {"kind": "empire_arc_engineer", "count": 1, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "empire_mortar_walker", "count": 2, "spacing": 5.0}, {"kind": "empire_aegis_bot", "count": 10, "spacing": 1.2, "delay": 1.0}, {"kind": "empire_scout_drone", "count": 12, "spacing": 0.6, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "empire_kill_drone", "count": 2, "spacing": 3.5}, {"kind": "empire_line_trooper", "count": 12, "spacing": 1.1, "delay": 1.0}, {"kind": "empire_spotter", "count": 1, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "The Furnace Channels", "groups": [{"kind": "empire_juggernaut", "count": 2, "spacing": 5.0}, {"kind": "empire_arc_engineer", "count": 1, "spacing": 1.0, "delay": 1.0}, {"kind": "empire_aegis_bot", "count": 10, "spacing": 1.2, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "empire_fabricator", "count": 1, "spacing": 1.0}, {"kind": "empire_line_trooper", "count": 12, "spacing": 1.1, "delay": 1.0}, {"kind": "empire_mortar_walker", "count": 1, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "empire_spotter", "count": 2, "spacing": 4.0}, {"kind": "empire_aegis_bot", "count": 12, "spacing": 1.2, "delay": 1.0}, {"kind": "empire_kill_drone", "count": 2, "spacing": 3.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "empire_juggernaut", "count": 2, "spacing": 5.0}, {"kind": "empire_line_trooper", "count": 12, "spacing": 1.1, "delay": 1.0}, {"kind": "empire_arc_engineer", "count": 1, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "empire_mortar_walker", "count": 2, "spacing": 5.0}, {"kind": "empire_aegis_bot", "count": 12, "spacing": 1.2, "delay": 1.0}, {"kind": "empire_scout_drone", "count": 14, "spacing": 0.6, "delay": 3.0}]},
		{"banner": "The Loading Docks", "groups": [{"kind": "empire_kill_drone", "count": 3, "spacing": 3.5}, {"kind": "empire_line_trooper", "count": 14, "spacing": 1.1, "delay": 2.0}, {"kind": "empire_arc_engineer", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "empire_juggernaut", "count": 2, "spacing": 5.0}, {"kind": "empire_fabricator", "count": 1, "spacing": 1.0, "delay": 1.0}, {"kind": "empire_aegis_bot", "count": 12, "spacing": 1.2, "delay": 2.0}, {"kind": "empire_spotter", "count": 2, "spacing": 4.0, "delay": 4.0}]},
		{"banner": "The Motherboard comes online: crane arms, press-stamps, turrets!", "groups": [{"kind": "empire_motherboard", "count": 1, "spacing": 1.0}, {"kind": "empire_line_trooper", "count": 8, "spacing": 1.1, "delay": 1.0}, {"kind": "empire_arc_engineer", "count": 1, "spacing": 1.0, "delay": 3.0}, {"kind": "empire_aegis_bot", "count": 8, "spacing": 1.2, "delay": 4.0}]},
	],
}
