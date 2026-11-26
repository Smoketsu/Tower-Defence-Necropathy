## The Proving Moon (Act XIII map 2; Necropathy stage "proving_moon"): the
## Vrask hunting ground, a grey moon of craters where they prove themselves on
## worthy prey. The hunting road comes in at the bottom left and SPIRALS round
## the duelling ring to the gate at its heart, so the inner plots cover two
## passes; the landing road comes in at the bottom right and joins the spiral's
## east side. Two sky lanes cross the ring diagonally (map road key "sky").
## 16 plots, 6 posts, 23
## waves. Abduction (act rule concord/abduction). The Warbeast (miniboss,
## chest) on wave 12; Vrask'Tal, the Hunt-Lord, on wave 23. Keys as
## graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "proving_moon",
	"name": "The Proving Moon",
	"floor": "tiles/proving_moon_craters",
	"decals": ["decals/proving_moon_craters_crater", "decals/proving_moon_landing_crater"],
	"obstacles": [
		["obstacles/moon_boulder_l", Vector2(440, 350)], ["obstacles/moon_shrine_l", Vector2(140, 140)],
		["obstacles/moon_boulder_m", Vector2(1220, 520)], ["obstacles/trophy_pillar_l_v", Vector2(1180, 180)],
		["obstacles/moon_boulder_s", Vector2(80, 520)], ["obstacles/moon_shrine_s", Vector2(900, 680)],
		["obstacles/moon_boulder_m", Vector2(100, 700)], ["obstacles/trophy_pillar_s_v", Vector2(1060, 100)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 620), Vector2(300, 620), Vector2(360, 560), Vector2(360, 200), Vector2(420, 140),
				Vector2(860, 140), Vector2(920, 200), Vector2(920, 460), Vector2(860, 520), Vector2(580, 520),
				Vector2(520, 460), Vector2(520, 330), Vector2(740, 330)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"low": {
			"points": [Vector2(1320, 640), Vector2(1080, 640), Vector2(1020, 580), Vector2(1020, 460), Vector2(980, 400), Vector2(920, 400)],
			"next": "main", "next_at": 1594.6,  # joins main at (920, 400)
			"entrance": true,
		},
		"sky_a": {
			"points": [Vector2(-60, 240), Vector2(1340, 480)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true, "sky": true,
		},
		"sky_b": {
			"points": [Vector2(1340, 230), Vector2(-60, 490)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true, "sky": true,
		},
	},
	"gate": Vector2(762, 330),
	"plots": [
		Vector2(440, 280), Vector2(440, 420), Vector2(640, 240), Vector2(800, 240), Vector2(820, 420),
		Vector2(640, 420), Vector2(260, 480), Vector2(260, 300), Vector2(640, 70), Vector2(1000, 260),
		Vector2(300, 690), Vector2(640, 600), Vector2(1160, 560), Vector2(180, 540), Vector2(1100, 400),
		Vector2(820, 600),
	],
	"posts": [Vector2(200, 620), Vector2(360, 380), Vector2(640, 140), Vector2(920, 300), Vector2(720, 520), Vector2(1150, 640)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 3.0,  # TUNING (not in GDD) (DECISIONS Z4: kept, with Vrask'Tal 9000 -> 8000) rising through the act
	"rule": "",
	"act_rule": "concord/abduction",
	"build_order": "proving_moon_default",
	"weak_order": "proving_moon_weak",
	"waves": [
		{"banner": "The Hunt begins: prey is sent onto the moon", "groups": [{"kind": "concord_broodling", "count": 15, "spacing": 0.6}, {"kind": "concord_broodling", "count": 9, "spacing": 0.6, "delay": 4.0, "road": "low"}]},
		{"banner": "A saucer: shoot it down while its beam grows", "groups": [{"kind": "concord_grey_drone", "count": 2, "spacing": 1.5, "road": "low"}, {"kind": "concord_broodling", "count": 13, "spacing": 0.6, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "concord_burrower", "count": 5, "spacing": 1.5}, {"kind": "concord_acid_spitter", "count": 3, "spacing": 1.5, "delay": 3.0, "road": "low"}]},
		{"banner": "", "groups": [{"kind": "concord_burrower", "count": 4, "spacing": 1.4}, {"kind": "concord_broodling", "count": 15, "spacing": 0.5, "delay": 2.0, "road": "low"}]},
		{"banner": "", "groups": [{"kind": "concord_broodling", "count": 17, "spacing": 0.5, "road": "low"}, {"kind": "concord_burrower", "count": 5, "spacing": 1.4, "delay": 2.0}]},
		{"banner": "A Lumen Sentinel: its shield soaks the first hits", "groups": [{"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0}, {"kind": "concord_grey_drone", "count": 4, "spacing": 1.2, "delay": 1.0, "road": "low"}]},
		{"banner": "", "groups": [{"kind": "concord_acid_spitter", "count": 6, "spacing": 1.2}, {"kind": "concord_burrower", "count": 7, "spacing": 1.2, "delay": 2.0, "road": "low"}]},
		{"banner": "A Star-Seer: her prism shields the hunters near her", "groups": [{"kind": "concord_prism", "count": 1, "spacing": 1.0, "road": "low"}, {"kind": "concord_grey_drone", "count": 4, "spacing": 1.1, "delay": 1.0, "road": "low"}, {"kind": "concord_broodling", "count": 17, "spacing": 0.5, "delay": 3.0}]},
		{"banner": "A Vrask Hunter: a shimmer that moves. Posts hold it, spells reveal it", "groups": [{"kind": "concord_vrask_hunter", "count": 1, "spacing": 4.0}, {"kind": "concord_burrower", "count": 7, "spacing": 1.1, "delay": 2.0, "road": "low"}]},
		{"banner": "", "groups": [{"kind": "concord_lumen_sentinel", "count": 2, "spacing": 4.0, "road": "low"}, {"kind": "concord_acid_spitter", "count": 7, "spacing": 1.0, "delay": 2.0}, {"kind": "concord_broodling", "count": 17, "spacing": 0.5, "delay": 4.0, "road": "low"}]},
		{"banner": "", "groups": [{"kind": "concord_grey_drone", "count": 9, "spacing": 1.0}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 2.0}, {"kind": "concord_vrask_hunter", "count": 1, "spacing": 1.0, "delay": 5.0, "road": "low"}]},
		{"banner": "The Warbeast is loosed: it charges through your posts!", "groups": [{"kind": "concord_warbeast", "count": 1, "spacing": 1.0}, {"kind": "concord_burrower", "count": 7, "spacing": 1.3, "delay": 4.0, "road": "low"}, {"kind": "concord_grey_drone", "count": 5, "spacing": 1.3, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "concord_broodling", "count": 21, "spacing": 0.4}, {"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "low"}, {"kind": "concord_acid_spitter", "count": 7, "spacing": 1.0, "delay": 4.0, "road": "low"}]},
		{"banner": "", "groups": [{"kind": "concord_vrask_hunter", "count": 2, "spacing": 4.0, "road": "low"}, {"kind": "concord_burrower", "count": 10, "spacing": 1.0, "delay": 1.0}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "concord_grey_drone", "count": 10, "spacing": 0.9, "road": "low"}, {"kind": "concord_lumen_sentinel", "count": 2, "spacing": 4.0, "delay": 2.0}]},
		{"banner": "The trophy hall: the Vrask come for skulls", "groups": [{"kind": "concord_vrask_hunter", "count": 2, "spacing": 3.0}, {"kind": "concord_vrask_hunter", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "low"}, {"kind": "concord_broodling", "count": 21, "spacing": 0.4, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "concord_burrower", "count": 11, "spacing": 0.9, "road": "low"}, {"kind": "concord_acid_spitter", "count": 8, "spacing": 0.9, "delay": 2.0}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 4.0, "road": "low"}]},
		{"banner": "", "groups": [{"kind": "concord_lumen_sentinel", "count": 2, "spacing": 4.0}, {"kind": "concord_grey_drone", "count": 10, "spacing": 0.9, "delay": 1.0, "road": "low"}, {"kind": "concord_vrask_hunter", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "concord_broodling", "count": 19, "spacing": 0.4, "road": "low"}, {"kind": "concord_burrower", "count": 11, "spacing": 0.9, "delay": 1.0}, {"kind": "concord_prism", "count": 2, "spacing": 4.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "concord_vrask_hunter", "count": 2, "spacing": 3.5, "road": "low"}, {"kind": "concord_acid_spitter", "count": 9, "spacing": 0.9, "delay": 1.0}, {"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0, "delay": 4.0, "road": "low"}]},
		{"banner": "The duelling ring fills", "groups": [{"kind": "concord_grey_drone", "count": 10, "spacing": 0.9}, {"kind": "concord_burrower", "count": 11, "spacing": 0.9, "delay": 2.0, "road": "low"}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "The Hunt-Lord's guard", "groups": [{"kind": "concord_lumen_sentinel", "count": 2, "spacing": 4.0, "road": "low"}, {"kind": "concord_vrask_hunter", "count": 2, "spacing": 3.0, "delay": 1.0}, {"kind": "concord_broodling", "count": 19, "spacing": 0.4, "delay": 4.0}]},
		{"banner": "Vrask'Tal, the Hunt-Lord, stalks onto the moon!", "groups": [{"kind": "concord_vrask_tal", "count": 1, "spacing": 1.0}, {"kind": "concord_grey_drone", "count": 8, "spacing": 1.2, "delay": 5.0, "road": "low"}, {"kind": "concord_burrower", "count": 9, "spacing": 1.2, "delay": 10.0}, {"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0, "delay": 16.0, "road": "low"}]},
	],
}
