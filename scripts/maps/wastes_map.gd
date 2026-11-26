## The Scrap Wastes (Act XII map 1; Necropathy stage "wastes"): the Empire's
## old battlefield of slag hills and fallen war titans. The main road comes in
## from the west along the top, turns back along the middle and out again along
## the bottom to the gate in the east (an S of three long stretches, 3270 px);
## the gully road comes in from the east and joins it where it turns down, so
## two columns meet in the middle stretch. 14 plots between the stretches, 6
## posts. 22 waves. Line of Fire (act rule empire/line_of_fire): the riflemen
## and drones shoot the towers; a post between them and a plot stops the shot.
## The Trojan Horse (miniboss, chest) on wave 12; Kestrel, the Dead Pixel, on
## wave 22. Keys as graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "wastes",
	"name": "The Scrap Wastes",
	"floor": "tiles/wastes_slag",
	"decals": [],
	"obstacles": [
		["obstacles/titan_hull_l", Vector2(480, 330)], ["obstacles/slag_mound_l", Vector2(140, 210)],
		["obstacles/wreck_plate_l", Vector2(860, 210)], ["obstacles/titan_hull_l_v", Vector2(1240, 420)],
		["obstacles/ridge_boulder_m", Vector2(1000, 470)], ["obstacles/tank_trap_l", Vector2(430, 460)],
		["obstacles/slag_mound_m", Vector2(680, 330)], ["obstacles/wall_segment_s", Vector2(300, 680)],
		["obstacles/wreck_plate_s", Vector2(860, 680)], ["obstacles/tank_trap_s", Vector2(80, 600)],
		["obstacles/ridge_boulder_l", Vector2(1210, 100)], ["obstacles/slag_mound_s", Vector2(640, 470)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 150), Vector2(1000, 150), Vector2(1060, 210), Vector2(1060, 330),
				Vector2(1000, 390), Vector2(260, 390), Vector2(200, 450), Vector2(200, 540),
				Vector2(260, 600), Vector2(1190, 600)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"gully": {
			"points": [Vector2(1320, 270), Vector2(1060, 270)],
			"next": "main", "next_at": 1184.85,  # joins main at (1060, 270)
			"entrance": true,
		},
	},
	"gate": Vector2(1218, 600),
	"plots": [
		Vector2(180, 270), Vector2(380, 270), Vector2(580, 270), Vector2(780, 270), Vector2(940, 270),
		Vector2(330, 495), Vector2(530, 495), Vector2(730, 495), Vector2(930, 495), Vector2(1110, 495),
		Vector2(1180, 400), Vector2(90, 480), Vector2(1190, 170), Vector2(60, 280),
	],
	"posts": [Vector2(700, 150), Vector2(1060, 310), Vector2(600, 390), Vector2(200, 495), Vector2(560, 600), Vector2(900, 600)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 3.2,  # TUNING (not in GDD) Part Three: a step above the Empyrean
	"rule": "",
	"act_rule": "empire/line_of_fire",
	"build_order": "wastes_default",
	"weak_order": "wastes_weak",
	"waves": [
		{"banner": "Scout drones skim the slag", "groups": [{"kind": "empire_scout_drone", "count": 10, "spacing": 0.6}, {"kind": "empire_line_trooper", "count": 3, "spacing": 1.1, "delay": 2.0}]},
		{"banner": "Line Troopers: they march and fire at your towers", "groups": [{"kind": "empire_line_trooper", "count": 6, "spacing": 1.1}, {"kind": "empire_scout_drone", "count": 6, "spacing": 0.6, "delay": 2.0, "road": "gully"}]},
		{"banner": "Aegis Bots: their shields turn frontal hits aside", "groups": [{"kind": "empire_aegis_bot", "count": 5, "spacing": 1.2}, {"kind": "empire_line_trooper", "count": 5, "spacing": 1.1, "delay": 2.0}]},
		{"banner": "A Spotter paints a tower red: a post in the line takes the shot", "groups": [{"kind": "empire_spotter", "count": 1, "spacing": 1.0}, {"kind": "empire_line_trooper", "count": 8, "spacing": 1.1, "delay": 1.0}, {"kind": "empire_scout_drone", "count": 8, "spacing": 0.6, "delay": 3.0, "road": "gully"}]},
		{"banner": "", "groups": [{"kind": "empire_aegis_bot", "count": 6, "spacing": 1.2}, {"kind": "empire_line_trooper", "count": 6, "spacing": 1.1, "delay": 2.0, "road": "gully"}]},
		{"banner": "Mortar Walkers: their shells fly over the posts. Kill them", "groups": [{"kind": "empire_mortar_walker", "count": 1, "spacing": 1.0}, {"kind": "empire_line_trooper", "count": 8, "spacing": 1.1, "delay": 1.0}, {"kind": "empire_aegis_bot", "count": 4, "spacing": 1.2, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "empire_scout_drone", "count": 14, "spacing": 0.6, "road": "gully"}, {"kind": "empire_line_trooper", "count": 8, "spacing": 1.1, "delay": 2.0}, {"kind": "empire_spotter", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "Kill-Drones: armoured, they fire as they fly over", "groups": [{"kind": "empire_kill_drone", "count": 2, "spacing": 3.5}, {"kind": "empire_aegis_bot", "count": 8, "spacing": 1.2, "delay": 1.0}]},
		{"banner": "", "groups": [{"kind": "empire_line_trooper", "count": 10, "spacing": 1.1}, {"kind": "empire_mortar_walker", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "gully"}, {"kind": "empire_spotter", "count": 1, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "empire_aegis_bot", "count": 10, "spacing": 1.2}, {"kind": "empire_kill_drone", "count": 2, "spacing": 3.5, "delay": 2.0, "road": "gully"}, {"kind": "empire_scout_drone", "count": 10, "spacing": 0.6, "delay": 3.0}]},
		{"banner": "The Wreck Gullies", "groups": [{"kind": "empire_spotter", "count": 2, "spacing": 4.0}, {"kind": "empire_line_trooper", "count": 10, "spacing": 1.1, "delay": 1.0, "road": "gully"}, {"kind": "empire_mortar_walker", "count": 1, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "The Trojan Horse rolls in: its rockets fly at your towers!", "groups": [{"kind": "empire_trojan_horse", "count": 1, "spacing": 1.0}, {"kind": "empire_line_trooper", "count": 8, "spacing": 1.1, "delay": 1.0}, {"kind": "empire_aegis_bot", "count": 6, "spacing": 1.2, "delay": 3.0, "road": "gully"}]},
		{"banner": "", "groups": [{"kind": "empire_kill_drone", "count": 2, "spacing": 3.5}, {"kind": "empire_line_trooper", "count": 12, "spacing": 1.1, "delay": 1.0}, {"kind": "empire_scout_drone", "count": 12, "spacing": 0.6, "delay": 3.0, "road": "gully"}]},
		{"banner": "", "groups": [{"kind": "empire_aegis_bot", "count": 12, "spacing": 1.2, "road": "gully"}, {"kind": "empire_mortar_walker", "count": 2, "spacing": 5.0, "delay": 2.0}, {"kind": "empire_spotter", "count": 1, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "empire_line_trooper", "count": 12, "spacing": 1.1}, {"kind": "empire_spotter", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "gully"}, {"kind": "empire_kill_drone", "count": 2, "spacing": 3.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "empire_scout_drone", "count": 16, "spacing": 0.6}, {"kind": "empire_aegis_bot", "count": 10, "spacing": 1.2, "delay": 2.0}, {"kind": "empire_mortar_walker", "count": 1, "spacing": 1.0, "delay": 4.0, "road": "gully"}]},
		{"banner": "Pylon Ridge: the signal masts call the spotters", "groups": [{"kind": "empire_spotter", "count": 2, "spacing": 4.0}, {"kind": "empire_line_trooper", "count": 12, "spacing": 1.1, "delay": 1.0}, {"kind": "empire_kill_drone", "count": 2, "spacing": 3.5, "delay": 3.0, "road": "gully"}]},
		{"banner": "", "groups": [{"kind": "empire_aegis_bot", "count": 12, "spacing": 1.2}, {"kind": "empire_mortar_walker", "count": 2, "spacing": 5.0, "delay": 2.0}, {"kind": "empire_scout_drone", "count": 12, "spacing": 0.6, "delay": 3.0, "road": "gully"}]},
		{"banner": "", "groups": [{"kind": "empire_kill_drone", "count": 3, "spacing": 3.5}, {"kind": "empire_line_trooper", "count": 14, "spacing": 1.1, "delay": 2.0, "road": "gully"}, {"kind": "empire_spotter", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "The Outer Wall: the garrison marches out", "groups": [{"kind": "empire_aegis_bot", "count": 14, "spacing": 1.2}, {"kind": "empire_mortar_walker", "count": 2, "spacing": 5.0, "delay": 2.0, "road": "gully"}, {"kind": "empire_spotter", "count": 2, "spacing": 4.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "empire_line_trooper", "count": 14, "spacing": 1.1}, {"kind": "empire_kill_drone", "count": 3, "spacing": 3.5, "delay": 2.0, "road": "gully"}, {"kind": "empire_scout_drone", "count": 14, "spacing": 0.6, "delay": 4.0}]},
		{"banner": "Kestrel, the Dead Pixel, takes aim: three red lines at once!", "groups": [{"kind": "empire_kestrel", "count": 1, "spacing": 1.0}, {"kind": "empire_line_trooper", "count": 8, "spacing": 1.1, "delay": 1.0}, {"kind": "empire_aegis_bot", "count": 8, "spacing": 1.2, "delay": 3.0, "road": "gully"}, {"kind": "empire_spotter", "count": 2, "spacing": 4.0, "delay": 5.0}]},
	],
}
