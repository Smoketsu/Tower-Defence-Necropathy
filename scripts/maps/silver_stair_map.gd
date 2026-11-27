## The Silver Stair (Act X map 1; Necropathy stage "silver_stair"): a stair of
## light rising from hell's ashes into the clouds. The main road climbs from the
## bottom in four switchback flights that grow wider as the stair rises (a
## funnel opening toward heaven) to the Gate of Pearl at the top right, so every
## row of plots covers two flights; the cloud road comes in from the left over
## the Cloud Shelf and climbs onto the third flight. 16 plots, 6 posts, 22
## waves. The Hallowed Light (act rule host/hallowed_light): vertical shafts
## sweep left and right, wider every step; three low cloud banks drift over
## plots and hide them from it. The Cherub of the Gate (miniboss, chest) on wave
## 12; Seraiel, Warden of the Gate, on wave 22. Keys as graveyard_map.gd plus
## "clouds" ([centre px, radius px] of each cloud bank;
## rules/host/hallowed_light.gd). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and hallowed_light.gd).
const MAP: Dictionary = {
	"id": "silver_stair",
	"name": "The Silver Stair",
	"floor": "tiles/silver_stair_stair",
	"decals": [],
	"obstacles": [
		["obstacles/host_pillar_m", Vector2(60, 400)], ["obstacles/host_cloudstone_m", Vector2(120, 700)],
		["obstacles/host_pillar_m", Vector2(1220, 640)], ["obstacles/host_cloudstone_m", Vector2(790, 700)],
		["obstacles/host_pillar_m", Vector2(1220, 330)], ["obstacles/host_cloudstone_m_v", Vector2(1020, 480)],
		["obstacles/host_pillar_m", Vector2(700, 110)], ["obstacles/host_cloudstone_m", Vector2(900, 110)],
		["obstacles/host_pearl_gate", Vector2(1220, 80)], ["obstacles/host_pillar_m", Vector2(60, 250)],
		["obstacles/host_cloudstone_m", Vector2(160, 330)],
	],
	"roads": {
		"main": {
			"points": [Vector2(720, 760), Vector2(720, 600), Vector2(520, 600), Vector2(500, 597), Vector2(482, 588),
				Vector2(467, 573), Vector2(458, 555), Vector2(455, 535), Vector2(458, 515), Vector2(467, 497),
				Vector2(482, 482), Vector2(500, 473), Vector2(520, 470), Vector2(860, 470), Vector2(880, 467),
				Vector2(898, 458), Vector2(913, 443), Vector2(922, 425), Vector2(925, 405), Vector2(922, 385),
				Vector2(913, 367), Vector2(898, 352), Vector2(880, 343), Vector2(860, 340), Vector2(300, 340),
				Vector2(280, 337), Vector2(262, 328), Vector2(247, 313), Vector2(238, 295), Vector2(235, 275),
				Vector2(238, 255), Vector2(247, 237), Vector2(262, 222), Vector2(280, 213), Vector2(300, 210),
				Vector2(1170, 210)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"cloud": {
			"points": [Vector2(-40, 480), Vector2(150, 480), Vector2(380, 342)],
			"next": "main", "next_at": 1586.7,  # joins main at (380, 340)
			"entrance": true,
		},
	},
	"gate": Vector2(1198, 180),
	"plots": [
		Vector2(150, 540), Vector2(400, 280), Vector2(620, 540), Vector2(620, 270), Vector2(320, 280), Vector2(760, 410),
		Vector2(170, 390), Vector2(850, 280), Vector2(700, 270), Vector2(390, 460), Vector2(480, 280), Vector2(700, 540),
		Vector2(840, 400), Vector2(990, 270), Vector2(570, 660), Vector2(1020, 150),
	],
	"posts": [Vector2(468, 574), Vector2(918, 432), Vector2(750, 340), Vector2(274, 216), Vector2(775, 210), Vector2(178, 463)],
	"clouds": [[Vector2(394, 605), 80.0], [Vector2(828, 260), 76.0], [Vector2(485, 140), 70.0]],  # TUNING (not in GDD) the low cloud banks of the Stair
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 3.8,  # TUNING (not in GDD) L7: 3.0 before the break fixes; Part Two: a step above the Road to the Sun
	"rule": "",
	"act_rule": "host/hallowed_light",
	"build_order": "silver_stair_default",
	"weak_order": "silver_stair_weak",
	"waves": [
		{"banner": "Lesser lights descend the stair", "groups": [{"kind": "host_lesser_light", "count": 10, "spacing": 0.8}, {"kind": "host_virtue", "count": 3, "spacing": 1.8, "delay": 4.0}]},
		{"banner": "Virtues: silver spears climb the stair", "groups": [{"kind": "host_virtue", "count": 6, "spacing": 1.5}, {"kind": "host_lesser_light", "count": 6, "spacing": 0.8, "delay": 3.0}]},
		{"banner": "Powers: their white blades cut two bodies at once", "groups": [{"kind": "host_power", "count": 6, "spacing": 1.5}, {"kind": "host_virtue", "count": 6, "spacing": 1.3, "delay": 3.0}]},
		{"banner": "A Choir Angel sings: kill her first", "groups": [{"kind": "host_choir_angel", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 8, "spacing": 1.1, "delay": 1.0}, {"kind": "host_lesser_light", "count": 10, "spacing": 0.6, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_power", "count": 8, "spacing": 1.2}, {"kind": "host_virtue", "count": 8, "spacing": 1.1, "delay": 2.0}]},
		{"banner": "Heralds: each trumpet calls a squad of lights", "groups": [{"kind": "host_herald", "count": 2, "spacing": 4.0}, {"kind": "host_virtue", "count": 8, "spacing": 1.0, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "host_lesser_light", "count": 16, "spacing": 0.5, "road": "cloud"}, {"kind": "host_power", "count": 8, "spacing": 1.1, "delay": 2.0}, {"kind": "host_choir_angel", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "Cherubs: their flaming swords sweep all around them", "groups": [{"kind": "host_cherub", "count": 2, "spacing": 5.0}, {"kind": "host_virtue", "count": 10, "spacing": 1.0, "delay": 2.0, "road": "cloud"}]},
		{"banner": "", "groups": [{"kind": "host_power", "count": 10, "spacing": 1.0}, {"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "cloud"}, {"kind": "host_lesser_light", "count": 10, "spacing": 0.5, "delay": 3.0}]},
		{"banner": "A Dominion: the angels near him march faster", "groups": [{"kind": "host_dominion", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 1.0}, {"kind": "host_herald", "count": 1, "spacing": 1.0, "delay": 5.0, "road": "cloud"}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 2, "spacing": 4.0, "road": "cloud"}, {"kind": "host_power", "count": 10, "spacing": 1.0, "delay": 2.0}, {"kind": "host_lesser_light", "count": 12, "spacing": 0.5, "delay": 4.0}]},
		{"banner": "The Cherub of the Gate comes down the stair, its sword turning a full circle!", "groups": [{"kind": "host_cherub_of_the_gate", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 8, "spacing": 1.1, "delay": 4.0}, {"kind": "host_power", "count": 6, "spacing": 1.2, "delay": 8.0, "road": "cloud"}]},
		{"banner": "", "groups": [{"kind": "host_choir_angel", "count": 2, "spacing": 4.0}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 1.0, "road": "cloud"}, {"kind": "host_herald", "count": 2, "spacing": 4.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_dominion", "count": 1, "spacing": 1.0, "road": "cloud"}, {"kind": "host_power", "count": 12, "spacing": 0.9, "delay": 1.0, "road": "cloud"}, {"kind": "host_lesser_light", "count": 14, "spacing": 0.5, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 3, "spacing": 3.5}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 2.0, "road": "cloud"}, {"kind": "host_choir_angel", "count": 1, "spacing": 1.0, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "host_herald", "count": 2, "spacing": 4.0, "road": "cloud"}, {"kind": "host_power", "count": 12, "spacing": 0.9, "delay": 1.0}, {"kind": "host_dominion", "count": 1, "spacing": 1.0, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "host_virtue", "count": 14, "spacing": 0.8}, {"kind": "host_cherub", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "cloud"}, {"kind": "host_lesser_light", "count": 16, "spacing": 0.4, "delay": 3.0, "road": "cloud"}]},
		{"banner": "The Cloud Shelf: the whole choir sings", "groups": [{"kind": "host_choir_angel", "count": 3, "spacing": 3.0}, {"kind": "host_power", "count": 12, "spacing": 0.9, "delay": 1.0, "road": "cloud"}, {"kind": "host_dominion", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "host_cherub", "count": 3, "spacing": 3.5}, {"kind": "host_herald", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "cloud"}, {"kind": "host_virtue", "count": 12, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "host_dominion", "count": 2, "spacing": 4.0}, {"kind": "host_power", "count": 14, "spacing": 0.8, "delay": 1.0, "road": "cloud"}, {"kind": "host_choir_angel", "count": 2, "spacing": 4.0, "delay": 4.0}]},
		{"banner": "Before the Gate of Pearl: the guard of heaven", "groups": [{"kind": "host_cherub", "count": 3, "spacing": 3.0, "road": "cloud"}, {"kind": "host_virtue", "count": 14, "spacing": 0.8, "delay": 1.0}, {"kind": "host_dominion", "count": 1, "spacing": 1.0, "delay": 4.0}, {"kind": "host_lesser_light", "count": 14, "spacing": 0.4, "delay": 5.0}]},
		{"banner": "Seraiel, Warden of the Gate, draws the flaming sword!", "groups": [{"kind": "host_seraiel", "count": 1, "spacing": 1.0}, {"kind": "host_virtue", "count": 8, "spacing": 1.2, "delay": 5.0}, {"kind": "host_power", "count": 8, "spacing": 1.2, "delay": 10.0, "road": "cloud"}, {"kind": "host_cherub", "count": 2, "spacing": 4.0, "delay": 16.0}]},
	],
}
