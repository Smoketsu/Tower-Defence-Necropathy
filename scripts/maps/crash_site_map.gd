## The Crash Site (Act XIII map 1; Necropathy stage "crash_site"): the crater
## where a Concord harvester ship came down, the Brood hatching in its wreck.
## Debris furrows run straight in toward the crater: the main road's furrow
## comes from the bottom left, wraps three quarters of the way round the
## crater's rim and leaves along the top to the gate on the right; the ridge
## road's furrow comes from the upper left and meets it at the top of the rim,
## so the plots inside the crater cover the whole wrap. Two sky lanes cross the
## map (map road key "sky": the saucers' flight paths, drawn by the act's
## layer). 17 plots, 5 posts, 22 waves. Abduction (act rule concord/abduction):
## saucers stop over a post or a plot and lift it. The Brood Matriarch
## (miniboss, chest) on wave 12; the Hive Mother on wave 22. Keys as
## graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "crash_site",
	"name": "The Crash Site",
	"floor": "tiles/crash_site_ruins",
	"decals": [],
	"obstacles": [
		["obstacles/wreck_ribs_l", Vector2(765, 479)], ["obstacles/wreck_plate_l", Vector2(120, 470)],
		["obstacles/crash_hull_shard_l", Vector2(900, 620)], ["obstacles/crash_rubble_l", Vector2(1220, 640)],
		["obstacles/wreck_plate_s", Vector2(1200, 220)], ["obstacles/crash_rubble_m", Vector2(60, 300)],
		["obstacles/crash_hull_shard_l_v", Vector2(680, 640)], ["obstacles/wreck_ribs_s", Vector2(271, 161)],
		["obstacles/crash_rubble_s", Vector2(1040, 130)], ["obstacles/crash_hull_shard_s", Vector2(400, 360)],
	],
	"roads": {
		"main": {
			"points": [Vector2(520, 760), Vector2(520, 600), Vector2(494, 598), Vector2(469, 593), Vector2(445, 585),
				Vector2(423, 573), Vector2(402, 559), Vector2(383, 541), Vector2(366, 522), Vector2(353, 500),
				Vector2(342, 477), Vector2(335, 452), Vector2(331, 427), Vector2(330, 401), Vector2(333, 376),
				Vector2(339, 351), Vector2(349, 328), Vector2(361, 305), Vector2(377, 285), Vector2(395, 267),
				Vector2(415, 251), Vector2(438, 239), Vector2(461, 229), Vector2(486, 223), Vector2(511, 220),
				Vector2(537, 221), Vector2(562, 225), Vector2(587, 232), Vector2(610, 243), Vector2(632, 256),
				Vector2(651, 273), Vector2(669, 292), Vector2(683, 313), Vector2(695, 335), Vector2(703, 359),
				Vector2(708, 384), Vector2(710, 410), Vector2(1190, 410)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"ridge": {
			"points": [Vector2(-40, 110), Vector2(420, 90), Vector2(800, 120), Vector2(900, 250), Vector2(900, 408)],
			"next": "main", "next_at": 1244.7,  # joins main at (900, 410)
			"entrance": true,
		},
		"sky_a": {
			"points": [Vector2(-60, 400), Vector2(1340, 520)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true, "sky": true,
		},
		"sky_b": {
			"points": [Vector2(1340, 140), Vector2(-60, 300)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true, "sky": true,
		},
	},
	"gate": Vector2(1218, 380),
	"plots": [
		Vector2(390, 630), Vector2(390, 180), Vector2(440, 440), Vector2(790, 270), Vector2(840, 340), Vector2(700, 210),
		Vector2(480, 160), Vector2(960, 310), Vector2(440, 360), Vector2(460, 520), Vector2(1030, 350), Vector2(290, 190),
		Vector2(460, 670), Vector2(590, 170), Vector2(1040, 470), Vector2(160, 160), Vector2(80, 170),
	],
	"posts": [Vector2(336, 457), Vector2(667, 290), Vector2(975, 410), Vector2(609, 105), Vector2(1105, 410)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 2.0,  # TUNING (not in GDD) L7: 3.2 before the break fixes (crater ring redrawn); L4: 2.65 before the road redraw
	"rule": "",
	"act_rule": "concord/abduction",
	"build_order": "crash_site_default",
	"weak_order": "crash_site_weak",
	"waves": [
		{"banner": "Broodlings pour out of the wreck", "groups": [{"kind": "concord_broodling", "count": 12, "spacing": 0.6}, {"kind": "concord_burrower", "count": 2, "spacing": 2.0, "delay": 5.0}]},
		{"banner": "Burrowers: they dig under the posts and surface further on", "groups": [{"kind": "concord_burrower", "count": 5, "spacing": 1.6}, {"kind": "concord_broodling", "count": 10, "spacing": 0.6, "delay": 3.0, "road": "ridge"}]},
		{"banner": "A saucer comes: shoot it down before its beam lifts a tower", "groups": [{"kind": "concord_acid_spitter", "count": 5, "spacing": 1.5}, {"kind": "concord_burrower", "count": 5, "spacing": 1.4, "delay": 3.0}]},
		{"banner": "Grey Drones: their probes stun a tower", "groups": [{"kind": "concord_grey_drone", "count": 6, "spacing": 1.4, "road": "ridge"}, {"kind": "concord_broodling", "count": 14, "spacing": 0.5, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "concord_burrower", "count": 7, "spacing": 1.3}, {"kind": "concord_acid_spitter", "count": 5, "spacing": 1.3, "delay": 2.0, "road": "ridge"}]},
		{"banner": "A Lumen Sentinel: its shield of light soaks the first hits", "groups": [{"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0}, {"kind": "concord_burrower", "count": 6, "spacing": 1.3, "delay": 1.0}, {"kind": "concord_broodling", "count": 12, "spacing": 0.5, "delay": 4.0, "road": "ridge"}]},
		{"banner": "", "groups": [{"kind": "concord_grey_drone", "count": 7, "spacing": 1.2}, {"kind": "concord_acid_spitter", "count": 6, "spacing": 1.2, "delay": 2.0, "road": "ridge"}]},
		{"banner": "A Star-Seer: her prism shields the Brood near her. Kill her first", "groups": [{"kind": "concord_prism", "count": 1, "spacing": 1.0}, {"kind": "concord_burrower", "count": 8, "spacing": 1.1, "delay": 1.0}, {"kind": "concord_broodling", "count": 14, "spacing": 0.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "concord_lumen_sentinel", "count": 2, "spacing": 4.0, "road": "ridge"}, {"kind": "concord_grey_drone", "count": 6, "spacing": 1.2, "delay": 2.0}, {"kind": "concord_burrower", "count": 6, "spacing": 1.2, "delay": 3.0, "road": "ridge"}]},
		{"banner": "", "groups": [{"kind": "concord_broodling", "count": 20, "spacing": 0.4}, {"kind": "concord_acid_spitter", "count": 8, "spacing": 1.0, "delay": 2.0, "road": "ridge"}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "concord_burrower", "count": 9, "spacing": 1.0, "road": "ridge"}, {"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0, "delay": 3.0}, {"kind": "concord_grey_drone", "count": 6, "spacing": 1.1, "delay": 4.0}]},
		{"banner": "The Brood Matriarch flies over the crater, spitting egg sacs!", "groups": [{"kind": "concord_brood_matriarch", "count": 1, "spacing": 1.0}, {"kind": "concord_burrower", "count": 6, "spacing": 1.3, "delay": 4.0}, {"kind": "concord_acid_spitter", "count": 5, "spacing": 1.3, "delay": 8.0, "road": "ridge"}]},
		{"banner": "", "groups": [{"kind": "concord_prism", "count": 1, "spacing": 1.0, "road": "ridge"}, {"kind": "concord_burrower", "count": 10, "spacing": 1.0, "delay": 1.0, "road": "ridge"}, {"kind": "concord_broodling", "count": 16, "spacing": 0.4, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "concord_lumen_sentinel", "count": 2, "spacing": 4.0}, {"kind": "concord_grey_drone", "count": 8, "spacing": 1.0, "delay": 1.0, "road": "ridge"}, {"kind": "concord_acid_spitter", "count": 6, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "A Vrask Hunter: a shimmer that moves. Spells reveal it, posts hold it", "groups": [{"kind": "concord_vrask_hunter", "count": 1, "spacing": 1.0}, {"kind": "concord_burrower", "count": 10, "spacing": 1.0, "delay": 1.0}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 4.0, "road": "ridge"}]},
		{"banner": "", "groups": [{"kind": "concord_broodling", "count": 22, "spacing": 0.35, "road": "ridge"}, {"kind": "concord_grey_drone", "count": 8, "spacing": 1.0, "delay": 2.0}, {"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "concord_burrower", "count": 12, "spacing": 0.9}, {"kind": "concord_acid_spitter", "count": 8, "spacing": 1.0, "delay": 2.0, "road": "ridge"}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "The hatchery wakes: the Brood floods both roads", "groups": [{"kind": "concord_broodling", "count": 18, "spacing": 0.35}, {"kind": "concord_broodling", "count": 18, "spacing": 0.35, "delay": 2.0, "road": "ridge"}, {"kind": "concord_lumen_sentinel", "count": 2, "spacing": 4.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "concord_vrask_hunter", "count": 1, "spacing": 1.0, "road": "ridge"}, {"kind": "concord_burrower", "count": 12, "spacing": 0.9, "delay": 1.0}, {"kind": "concord_grey_drone", "count": 8, "spacing": 1.0, "delay": 3.0, "road": "ridge"}]},
		{"banner": "", "groups": [{"kind": "concord_prism", "count": 2, "spacing": 4.0}, {"kind": "concord_acid_spitter", "count": 10, "spacing": 0.9, "delay": 1.0}, {"kind": "concord_burrower", "count": 10, "spacing": 0.9, "delay": 3.0, "road": "ridge"}]},
		{"banner": "The Brood gathers at the queen's crater", "groups": [{"kind": "concord_lumen_sentinel", "count": 2, "spacing": 4.0, "road": "ridge"}, {"kind": "concord_burrower", "count": 12, "spacing": 0.9, "delay": 1.0}, {"kind": "concord_prism", "count": 1, "spacing": 1.0, "delay": 4.0}, {"kind": "concord_broodling", "count": 16, "spacing": 0.35, "delay": 5.0}]},
		{"banner": "The Hive Mother tears loose from the wreck!", "groups": [{"kind": "concord_hive_mother", "count": 1, "spacing": 1.0}, {"kind": "concord_burrower", "count": 8, "spacing": 1.2, "delay": 5.0}, {"kind": "concord_acid_spitter", "count": 6, "spacing": 1.2, "delay": 10.0, "road": "ridge"}, {"kind": "concord_lumen_sentinel", "count": 1, "spacing": 1.0, "delay": 16.0}]},
	],
}
