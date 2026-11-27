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
		["obstacles/wreck_ribs_l", Vector2(760, 470)], ["obstacles/wreck_plate_l", Vector2(120, 470)],
		["obstacles/crash_hull_shard_l", Vector2(900, 620)], ["obstacles/crash_rubble_l", Vector2(1220, 640)],
		["obstacles/wreck_plate_s", Vector2(1240, 265)], ["obstacles/crash_rubble_m", Vector2(60, 300)],
		["obstacles/crash_hull_shard_l_v", Vector2(680, 640)], ["obstacles/wreck_ribs_s", Vector2(240, 110)],
		["obstacles/crash_rubble_s", Vector2(1040, 130)], ["obstacles/crash_hull_shard_s", Vector2(400, 360)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 660), Vector2(386, 544), Vector2(405, 561), Vector2(426, 575), Vector2(450, 587),
				Vector2(474, 594), Vector2(499, 599), Vector2(525, 600), Vector2(551, 597), Vector2(576, 592),
				Vector2(600, 582), Vector2(622, 570), Vector2(643, 555), Vector2(661, 537), Vector2(677, 517),
				Vector2(690, 494), Vector2(700, 471), Vector2(707, 446), Vector2(710, 420), Vector2(709, 395),
				Vector2(706, 369), Vector2(698, 344), Vector2(688, 321), Vector2(674, 299), Vector2(658, 279),
				Vector2(639, 262), Vector2(618, 247), Vector2(595, 235), Vector2(571, 227), Vector2(546, 222),
				Vector2(520, 220), Vector2(1190, 220)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"ridge": {
			"points": [Vector2(-40, 110), Vector2(374, 288), Vector2(388, 273), Vector2(403, 260), Vector2(419, 249),
				Vector2(437, 239), Vector2(455, 231), Vector2(474, 226), Vector2(494, 222), Vector2(513, 220)],
			"next": "main", "next_at": 1186.6,  # joins main at (520, 220)
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
	"gate": Vector2(1218, 190),
	"plots": [
		Vector2(160, 120), Vector2(600, 480), Vector2(530, 520), Vector2(620, 340), Vector2(540, 290), Vector2(720, 160),
		Vector2(330, 190), Vector2(110, 250), Vector2(410, 180), Vector2(890, 160), Vector2(360, 620), Vector2(230, 650),
		Vector2(130, 550), Vector2(750, 280), Vector2(1040, 160), Vector2(1040, 280), Vector2(150, 680),
	],
	"posts": [Vector2(338, 557), Vector2(710, 417), Vector2(694, 220), Vector2(273, 244), Vector2(994, 220)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 2.4,  # TUNING (not in GDD) L4: 2.65 before the road redraw; Part Three: a step above the Empyrean
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
