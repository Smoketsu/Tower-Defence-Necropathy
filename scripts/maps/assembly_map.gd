## The Assembly Halls (Act XII map 2; Necropathy stage "assembly"): the
## Empire's factory, three assembly lines one above the other. The one road
## comes in from the east along the top line, doubles back along the middle
## line and again along the bottom line to the gate in the west (3320 px), so
## every row of plots between two lines covers both. 14 plots, 6 posts. 23
## waves. Line of Fire (act rule empire/line_of_fire). Fabricators crawl the
## lines building drones; the Beta Build (miniboss, chest) on wave 12 patches
## itself from them; the Motherboard on wave 23. Keys as graveyard_map.gd.
## Data only.
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
		["obstacles/press_machine_l_v", Vector2(1240, 360)], ["obstacles/cargo_crate_l_v", Vector2(40, 450)],
		["obstacles/citadel_crate_m", Vector2(400, 660)], ["obstacles/press_machine_s", Vector2(900, 660)],
		["obstacles/cargo_crate_s", Vector2(80, 230)], ["obstacles/press_machine_s_v", Vector2(240, 460)],
	],
	"roads": {
		"main": {
			"points": [Vector2(1320, 170), Vector2(240, 170), Vector2(180, 230), Vector2(180, 300),
				Vector2(240, 360), Vector2(1040, 360), Vector2(1100, 420), Vector2(1100, 500),
				Vector2(1040, 560), Vector2(90, 560)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
	},
	"gate": Vector2(62, 560),
	"plots": [
		Vector2(330, 265), Vector2(530, 265), Vector2(730, 265), Vector2(930, 265), Vector2(1200, 265),
		Vector2(330, 460), Vector2(530, 460), Vector2(730, 460), Vector2(930, 460), Vector2(1210, 460),
		Vector2(70, 330), Vector2(130, 460), Vector2(1180, 650), Vector2(640, 655),
	],
	"posts": [Vector2(800, 170), Vector2(180, 265), Vector2(600, 360), Vector2(1100, 460), Vector2(700, 560), Vector2(320, 560)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 3.6,  # TUNING (not in GDD) DECISIONS Z4: 3.35 -> 3.6; Part Three
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
