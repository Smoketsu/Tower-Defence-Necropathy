## Gullhaven Harbour (Act XI map 1; Necropathy stage "harbour"): a fishing town
## at low tide, at night, where the Ancient Eye has lived in the open for
## generations. The quay road runs east along the seawall and out along two
## finger piers and back (a comb: each pier a narrow U into the water) to the
## gate at the east end; the pier road comes up from the sea in the south and
## lands on the first pier's tip. 16 plots, 6 posts, 22 waves. Claims (act rule
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
		["obstacles/net_pile_l", Vector2(218, 115)], ["obstacles/fish_stall_l", Vector2(560, 680)],
		["obstacles/barrel_stack_l", Vector2(700, 690)], ["obstacles/crate_stack_l", Vector2(470, 470)],
		["obstacles/drowned_idol_l", Vector2(555, 355)], ["obstacles/tide_font_l", Vector2(783, 489)],
		["obstacles/coral_pillar_l", Vector2(1000, 380)], ["obstacles/anchor_monument_l", Vector2(1240, 640)],
		["obstacles/bollard_l", Vector2(1240, 280)], ["obstacles/lobster_pots_l", Vector2(1100, 660)],
		["obstacles/mooring_post_s", Vector2(1210, 80)], ["obstacles/net_pile_s", Vector2(80, 300)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 180), Vector2(230, 180), Vector2(230, 365), Vector2(233, 383), Vector2(240, 400),
				Vector2(252, 414), Vector2(268, 424), Vector2(286, 429), Vector2(304, 429), Vector2(322, 424),
				Vector2(338, 414), Vector2(350, 400), Vector2(357, 383), Vector2(360, 365), Vector2(360, 180),
				Vector2(620, 180), Vector2(620, 405), Vector2(623, 423), Vector2(630, 440), Vector2(642, 454),
				Vector2(658, 464), Vector2(676, 469), Vector2(694, 469), Vector2(712, 464), Vector2(728, 454),
				Vector2(740, 440), Vector2(747, 423), Vector2(750, 405), Vector2(750, 180), Vector2(1190, 180)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"pier": {
			"points": [Vector2(295, 760), Vector2(295, 434)],
			"next": "main", "next_at": 556.8,  # joins main at (295, 429)
			"entrance": true,
		},
	},
	"gate": Vector2(1218, 150),
	"plots": [
		Vector2(300, 190), Vector2(130, 280), Vector2(350, 530), Vector2(680, 310), Vector2(290, 350), Vector2(290, 270),
		Vector2(360, 610), Vector2(680, 390), Vector2(900, 240), Vector2(500, 120), Vector2(240, 550), Vector2(680, 230),
		Vector2(1000, 240), Vector2(490, 270), Vector2(1040, 120), Vector2(60, 240),
	],
	"posts": [Vector2(101, 180), Vector2(230, 229), Vector2(360, 297), Vector2(620, 254), Vector2(750, 309), Vector2(295, 583)],
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
