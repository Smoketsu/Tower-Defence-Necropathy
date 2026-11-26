## The Crash Site (Act XIII map 1; Necropathy stage "crash_site"): the crater
## where a Concord harvester ship came down, the Brood hatching in its wreck.
## The main road climbs out of the crater from the bottom left, up past the
## wreck and across to the gate on the right; the ridge road comes in from the
## upper left and joins it in the middle, so the centre plots cover both. Two
## sky lanes cross the map (map road key "sky": the saucers' flight paths,
## drawn by the act's layer). 17 plots, 5 posts, 22 waves. Abduction (act rule
## concord/abduction): saucers stop over a post or a plot and lift it. The
## Brood Matriarch (miniboss, chest) on wave 12; the Hive Mother on wave 22.
## Keys as graveyard_map.gd. Data only.
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
		["obstacles/wreck_plate_s", Vector2(1200, 220)], ["obstacles/crash_rubble_m", Vector2(60, 300)],
		["obstacles/crash_hull_shard_l_v", Vector2(680, 640)], ["obstacles/wreck_ribs_s", Vector2(240, 110)],
		["obstacles/crash_rubble_s", Vector2(1040, 130)], ["obstacles/crash_hull_shard_s", Vector2(400, 360)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 620), Vector2(520, 620), Vector2(580, 560), Vector2(580, 320),
				Vector2(640, 260), Vector2(1000, 260), Vector2(1060, 320), Vector2(1060, 420), Vector2(1190, 420)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"ridge": {
			"points": [Vector2(-40, 170), Vector2(640, 170), Vector2(700, 260)],
			"next": "main", "next_at": 1029.7,  # joins main at (700, 260)
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
	"gate": Vector2(1218, 420),
	"plots": [
		Vector2(220, 560), Vector2(420, 560), Vector2(660, 560), Vector2(500, 440), Vector2(660, 400),
		Vector2(500, 320), Vector2(820, 330), Vector2(980, 350), Vector2(820, 200), Vector2(960, 190),
		Vector2(1140, 340), Vector2(1140, 520), Vector2(300, 240), Vector2(480, 240), Vector2(380, 110),
		Vector2(1000, 480), Vector2(440, 680),
	],
	"posts": [Vector2(300, 620), Vector2(580, 440), Vector2(860, 260), Vector2(400, 170), Vector2(1060, 370)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 2.9,  # TUNING (not in GDD) Part Three: a step above the Empyrean
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
