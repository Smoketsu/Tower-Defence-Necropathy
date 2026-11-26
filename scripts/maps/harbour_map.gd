## Gullhaven Harbour (Act XI map 1; Necropathy stage "harbour"): a fishing
## town at low tide, at night, where the Ancient Eye has lived in the open for
## generations. The strand road comes up off the mudflats on the left, climbs
## past the fish market in a long U round the chapel square and runs along the
## seawall to the gate; the pier road comes in along the top from the sea and
## joins the U's top stretch. 16 plots, 6 posts, 22 waves. Claims (act rule
## eye/claims): Chanters claim the bodies that fall near them. The Harbourmaster
## (miniboss, chest) on wave 12; Abbot Merrow on wave 22. Keys as
## graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "harbour",
	"name": "Gullhaven Harbour",
	"floor": "tiles/harbour_market",
	"decals": ["decals/harbour_market_fish", "decals/harbour_market_rope", "decals/harbour_market_scales", "decals/harbour_mudflats_kelp",
		"decals/harbour_mudflats_shells", "decals/harbour_seawall_chain", "decals/harbour_chapel_barnacles"],
	"obstacles": [
		["obstacles/wreck_ribs_l", Vector2(110, 690)], ["obstacles/mooring_post_l", Vector2(40, 520)],
		["obstacles/net_pile_l", Vector2(240, 160)], ["obstacles/fish_stall_l", Vector2(560, 680)],
		["obstacles/barrel_stack_l", Vector2(700, 690)], ["obstacles/crate_stack_l", Vector2(470, 470)],
		["obstacles/drowned_idol_l", Vector2(620, 330)], ["obstacles/tide_font_l", Vector2(760, 470)],
		["obstacles/coral_pillar_l", Vector2(1000, 380)], ["obstacles/anchor_monument_l", Vector2(1240, 640)],
		["obstacles/bollard_l", Vector2(1240, 280)], ["obstacles/lobster_pots_l", Vector2(1100, 660)],
		["obstacles/mooring_post_s", Vector2(1210, 80)], ["obstacles/net_pile_s", Vector2(80, 300)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 600), Vector2(300, 600), Vector2(360, 540), Vector2(360, 300), Vector2(420, 240), Vector2(780, 240), Vector2(840, 300), Vector2(840, 500), Vector2(900, 560), Vector2(1080, 560), Vector2(1140, 500), Vector2(1140, 380), Vector2(1190, 380)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"pier": {
			"points": [Vector2(1320, 130), Vector2(680, 130), Vector2(620, 190), Vector2(620, 240)],
			"next": "main", "next_at": 949.7,  # joins main at (620, 240)
			"entrance": true,
		},
	},
	"gate": Vector2(1218, 380),
	"plots": [
		Vector2(200, 520), Vector2(470, 560), Vector2(270, 400), Vector2(470, 400), Vector2(620, 440), Vector2(740, 400),
		Vector2(950, 420), Vector2(990, 470), Vector2(1235, 480), Vector2(1050, 290), Vector2(520, 330), Vector2(920, 200),
		Vector2(250, 250), Vector2(620, 560), Vector2(100, 420), Vector2(1180, 220),
	],
	"posts": [Vector2(200, 600), Vector2(360, 420), Vector2(720, 240), Vector2(840, 420), Vector2(1000, 560), Vector2(900, 130)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 3.8,  # TUNING (not in GDD) Part Three: a step above the Empyrean
	"rule": "",
	"act_rule": "eye/claims",
	"build_order": "harbour_default",
	"weak_order": "harbour_weak",
	"waves": [
		{"banner": "Initiates of the Eye come up from the mudflats", "groups": [{"kind": "eye_initiate", "count": 12, "spacing": 0.7}, {"kind": "eye_deep_kin", "count": 2, "spacing": 2.0, "delay": 4.0}]},
		{"banner": "A Chanter leads them: a body that falls near him rises as a Drowned Thrall", "groups": [{"kind": "eye_initiate", "count": 10, "spacing": 0.7}, {"kind": "eye_chanter", "count": 1, "spacing": 1.0, "delay": 2.0}, {"kind": "eye_initiate", "count": 6, "spacing": 0.7, "delay": 6.0}]},
		{"banner": "Deep Kin: they leap onto your posts", "groups": [{"kind": "eye_deep_kin", "count": 6, "spacing": 1.4}, {"kind": "eye_initiate", "count": 8, "spacing": 0.6, "delay": 3.0}]},
		{"banner": "Tide Callers: their water line soaks the towers by the road", "groups": [{"kind": "eye_tide_caller", "count": 3, "spacing": 2.5}, {"kind": "eye_initiate", "count": 10, "spacing": 0.6, "delay": 1.0}, {"kind": "eye_deep_kin", "count": 3, "spacing": 1.5, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "eye_initiate", "count": 14, "spacing": 0.5, "road": "pier"}, {"kind": "eye_chanter", "count": 1, "spacing": 1.0, "delay": 3.0, "road": "pier"}, {"kind": "eye_deep_kin", "count": 4, "spacing": 1.3, "delay": 4.0}]},
		{"banner": "Netcasters: their nets stop a tower", "groups": [{"kind": "eye_netcaster", "count": 4, "spacing": 2.0}, {"kind": "eye_initiate", "count": 10, "spacing": 0.6, "delay": 2.0}, {"kind": "eye_chanter", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_deep_kin", "count": 8, "spacing": 1.1}, {"kind": "eye_tide_caller", "count": 2, "spacing": 3.0, "delay": 2.0, "road": "pier"}, {"kind": "eye_initiate", "count": 10, "spacing": 0.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "eye_chanter", "count": 2, "spacing": 4.0}, {"kind": "eye_initiate", "count": 16, "spacing": 0.5, "delay": 1.0}, {"kind": "eye_netcaster", "count": 3, "spacing": 2.0, "delay": 4.0, "road": "pier"}]},
		{"banner": "The tide turns: the pier fills with the faithful", "groups": [{"kind": "eye_initiate", "count": 16, "spacing": 0.4, "road": "pier"}, {"kind": "eye_deep_kin", "count": 6, "spacing": 1.2, "delay": 2.0}, {"kind": "eye_tide_caller", "count": 3, "spacing": 2.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_netcaster", "count": 4, "spacing": 1.8}, {"kind": "eye_deep_kin", "count": 6, "spacing": 1.2, "delay": 2.0, "road": "pier"}, {"kind": "eye_chanter", "count": 2, "spacing": 4.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "eye_tide_caller", "count": 4, "spacing": 2.2}, {"kind": "eye_initiate", "count": 18, "spacing": 0.4, "delay": 1.0}, {"kind": "eye_deep_kin", "count": 4, "spacing": 1.3, "delay": 5.0, "road": "pier"}]},
		{"banner": "The Harbourmaster drags his chained anchor up the strand!", "groups": [{"kind": "eye_harbourmaster", "count": 1, "spacing": 1.0}, {"kind": "eye_initiate", "count": 10, "spacing": 0.6, "delay": 4.0}, {"kind": "eye_deep_kin", "count": 4, "spacing": 1.4, "delay": 8.0, "road": "pier"}]},
		{"banner": "", "groups": [{"kind": "eye_chanter", "count": 2, "spacing": 3.5, "road": "pier"}, {"kind": "eye_initiate", "count": 16, "spacing": 0.4, "delay": 1.0, "road": "pier"}, {"kind": "eye_netcaster", "count": 4, "spacing": 1.8, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "eye_deep_kin", "count": 10, "spacing": 1.0}, {"kind": "eye_tide_caller", "count": 3, "spacing": 2.5, "delay": 2.0}, {"kind": "eye_initiate", "count": 12, "spacing": 0.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_chanter", "count": 2, "spacing": 4.0}, {"kind": "eye_netcaster", "count": 5, "spacing": 1.6, "delay": 1.0, "road": "pier"}, {"kind": "eye_deep_kin", "count": 6, "spacing": 1.1, "delay": 3.0}]},
		{"banner": "Chanters chant on the seawall: guard your posts", "groups": [{"kind": "eye_chanter", "count": 3, "spacing": 3.0}, {"kind": "eye_initiate", "count": 20, "spacing": 0.4, "delay": 1.0}, {"kind": "eye_tide_caller", "count": 3, "spacing": 2.5, "delay": 4.0, "road": "pier"}]},
		{"banner": "", "groups": [{"kind": "eye_deep_kin", "count": 10, "spacing": 0.9, "road": "pier"}, {"kind": "eye_netcaster", "count": 4, "spacing": 1.8, "delay": 2.0}, {"kind": "eye_initiate", "count": 12, "spacing": 0.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_tide_caller", "count": 5, "spacing": 2.0}, {"kind": "eye_chanter", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "pier"}, {"kind": "eye_deep_kin", "count": 8, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "eye_initiate", "count": 22, "spacing": 0.3}, {"kind": "eye_netcaster", "count": 5, "spacing": 1.6, "delay": 2.0, "road": "pier"}, {"kind": "eye_chanter", "count": 2, "spacing": 4.0, "delay": 4.0}]},
		{"banner": "High tide: the whole town walks into the sea", "groups": [{"kind": "eye_deep_kin", "count": 12, "spacing": 0.9}, {"kind": "eye_tide_caller", "count": 4, "spacing": 2.2, "delay": 2.0, "road": "pier"}, {"kind": "eye_chanter", "count": 2, "spacing": 4.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_chanter", "count": 3, "spacing": 3.0, "road": "pier"}, {"kind": "eye_initiate", "count": 20, "spacing": 0.3, "delay": 1.0}, {"kind": "eye_netcaster", "count": 5, "spacing": 1.6, "delay": 3.0}, {"kind": "eye_deep_kin", "count": 6, "spacing": 1.0, "delay": 5.0, "road": "pier"}]},
		{"banner": "Abbot Merrow, Voice of the Deep, comes to preach his last sermon!", "groups": [{"kind": "eye_merrow", "count": 1, "spacing": 1.0}, {"kind": "eye_initiate", "count": 12, "spacing": 0.5, "delay": 5.0}, {"kind": "eye_deep_kin", "count": 6, "spacing": 1.2, "delay": 10.0, "road": "pier"}, {"kind": "eye_chanter", "count": 2, "spacing": 4.0, "delay": 16.0}]},
	],
}
