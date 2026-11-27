## The Asphodel Underworld (Act VIII map 3, the finale; Necropathy stage
## "underworld"): the grey fields of asphodel by the Styx. The main road winds
## along the bank of the Styx in long smooth S-bends (the plots inside each bend
## see the column's backs on the way out); the ferry road crosses straight over
## from the east and joins the bottom bend. 16 plots, 6 posts, 24 waves. Wrath
## of the Gods: Hades' fissures from wave 3. Cerberus (miniboss, chest) on wave
## 13; Hades on wave 24: he cloaks, claims fallen blockers as his shades and
## raises a ring of wardens. Beating him unlocks the Myrmidon Shades. Keys as
## graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "underworld",
	"name": "The Asphodel Underworld",
	"floor": "tiles/underworld_asphodel",
	"decals": [],
	"obstacles": [
		["obstacles/styx_rock_l", Vector2(850, 320)], ["obstacles/styx_rock_m", Vector2(75, 250)],
		["obstacles/styx_rock_s", Vector2(663, 639)], ["obstacles/judges_column_l", Vector2(975, 110)],
		["obstacles/judgement_bench_l", Vector2(340, 399)], ["obstacles/judges_column_s", Vector2(362, 647)],
		["obstacles/cypress_l", Vector2(1245, 390)], ["obstacles/styx_rock_m", Vector2(937, 423)],
		["obstacles/judges_column_m", Vector2(75, 530)], ["obstacles/cypress_s", Vector2(975, 250)],
		["obstacles/styx_rock_s", Vector2(1245, 250)], ["obstacles/judgement_bench_s", Vector2(1195, 76)],
		["obstacles/cypress_m", Vector2(490, 600)], ["obstacles/styx_rock_l", Vector2(435, 250)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 600), Vector2(-24, 602), Vector2(-3, 604), Vector2(21, 608), Vector2(49, 612),
				Vector2(79, 616), Vector2(110, 619), Vector2(141, 622), Vector2(172, 624), Vector2(201, 625),
				Vector2(227, 623), Vector2(250, 620), Vector2(278, 612), Vector2(306, 601), Vector2(332, 587),
				Vector2(356, 572), Vector2(377, 555), Vector2(395, 537), Vector2(410, 518), Vector2(420, 500),
				Vector2(427, 474), Vector2(426, 445), Vector2(419, 414), Vector2(408, 384), Vector2(394, 355),
				Vector2(380, 330), Vector2(360, 308), Vector2(332, 288), Vector2(302, 269), Vector2(274, 252),
				Vector2(255, 236), Vector2(250, 220), Vector2(258, 206), Vector2(275, 191), Vector2(299, 176),
				Vector2(327, 163), Vector2(358, 152), Vector2(390, 144), Vector2(420, 140), Vector2(444, 140),
				Vector2(470, 142), Vector2(498, 145), Vector2(527, 150), Vector2(555, 157), Vector2(583, 166),
				Vector2(608, 176), Vector2(631, 187), Vector2(650, 200), Vector2(670, 220), Vector2(686, 243),
				Vector2(699, 270), Vector2(708, 298), Vector2(715, 327), Vector2(719, 354), Vector2(720, 380),
				Vector2(714, 409), Vector2(698, 438), Vector2(679, 466), Vector2(661, 493), Vector2(649, 518),
				Vector2(650, 540), Vector2(662, 557), Vector2(681, 574), Vector2(706, 589), Vector2(734, 603),
				Vector2(764, 613), Vector2(793, 619), Vector2(820, 620), Vector2(847, 616), Vector2(876, 607),
				Vector2(906, 594), Vector2(935, 579), Vector2(961, 560), Vector2(984, 541), Vector2(1000, 520),
				Vector2(1009, 497), Vector2(1010, 471), Vector2(1007, 442), Vector2(1002, 412), Vector2(998, 383),
				Vector2(996, 355), Vector2(1000, 330), Vector2(1011, 304), Vector2(1026, 279), Vector2(1044, 255),
				Vector2(1064, 234), Vector2(1083, 215), Vector2(1100, 200), Vector2(1134, 181), Vector2(1167, 174),
				Vector2(1190, 170)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"ferry": {
			"points": [Vector2(1320, 640), Vector2(830, 615)],
			"next": "main", "next_at": 1878.5,  # joins main at (831, 618)
			"entrance": true,
		},
	},
	"gate": Vector2(1218, 135),
	"plots": [
		Vector2(1130, 560), Vector2(300, 520), Vector2(620, 290), Vector2(480, 240), Vector2(1050, 570), Vector2(900, 520),
		Vector2(1110, 310), Vector2(810, 510), Vector2(640, 370), Vector2(160, 560), Vector2(730, 510), Vector2(390, 240),
		Vector2(290, 110), Vector2(150, 680), Vector2(1020, 180), Vector2(320, 430),
	],
	"posts": [Vector2(426, 463), Vector2(396, 143), Vector2(718, 346), Vector2(998, 381), Vector2(1128, 185), Vector2(1119, 630)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 2.2,  # TUNING (not in GDD) the act's shields and wrath make its kinds tougher than their row HP: tuned to the loss pattern (BALANCE.md)
	"rule": "",
	"act_rule": "pantheon/pantheon_rules",
	"build_order": "underworld_default",
	"weak_order": "underworld_weak",
	"waves": [
		{"banner": "The shades of Asphodel drift toward the gate", "groups": [{"kind": "shade_of_dead", "count": 6, "spacing": 0.8}, {"kind": "shade_hoplite", "count": 4, "spacing": 1.2, "delay": 2.0, "road": "ferry"}]},
		{"banner": "Shade hoplites: the dead still hold the phalanx", "groups": [{"kind": "shade_hoplite", "count": 6, "spacing": 1.2}, {"kind": "wolf_of_rome", "count": 6, "spacing": 0.7, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 1, "spacing": 4.0, "road": "ferry"}, {"kind": "wolf_of_rome", "count": 8, "spacing": 0.7, "delay": 3.0}, {"kind": "shade_of_dead", "count": 4, "spacing": 0.8, "delay": 5.0}]},
		{"banner": "Shade archers loose ghost arrows", "groups": [{"kind": "shade_hoplite", "count": 8, "spacing": 1.2}, {"kind": "shade_archer", "count": 3, "spacing": 1.2, "delay": 2.0, "road": "ferry"}]},
		{"banner": "", "groups": [{"kind": "wolf_of_rome", "count": 10, "spacing": 0.7}, {"kind": "shade_hoplite", "count": 6, "spacing": 1.2, "delay": 2.0, "road": "ferry"}, {"kind": "shade_of_dead", "count": 6, "spacing": 0.8, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 1, "spacing": 4.0}, {"kind": "hoplite", "count": 8, "spacing": 1.3, "delay": 3.0}, {"kind": "shade_archer", "count": 4, "spacing": 1.2, "delay": 5.0, "road": "ferry"}]},
		{"banner": "", "groups": [{"kind": "shade_hoplite", "count": 10, "spacing": 1.2, "road": "ferry"}, {"kind": "shade_archer", "count": 5, "spacing": 1.2, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "wolf_of_rome", "count": 14, "spacing": 0.7}, {"kind": "shade_of_dead", "count": 8, "spacing": 0.8, "delay": 2.0, "road": "ferry"}]},
		{"banner": "", "groups": [{"kind": "shade_hoplite", "count": 10, "spacing": 1.2}, {"kind": "hoplite", "count": 6, "spacing": 1.3, "delay": 2.0, "road": "ferry"}, {"kind": "pan_hero", "count": 1, "spacing": 4.0, "delay": 4.0}]},
		{"banner": "A Bronze Titan climbs out of Tartarus", "groups": [{"kind": "bronze_titan", "count": 1, "spacing": 6.0}, {"kind": "hoplite", "count": 10, "spacing": 1.3, "delay": 3.0, "road": "ferry"}]},
		{"banner": "", "groups": [{"kind": "shade_hoplite", "count": 12, "spacing": 1.2}, {"kind": "shade_archer", "count": 6, "spacing": 1.2, "delay": 2.0, "road": "ferry"}, {"kind": "shade_of_dead", "count": 8, "spacing": 0.8, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 2, "spacing": 4.0}, {"kind": "gorgon", "count": 1, "spacing": 4.0, "delay": 3.0, "road": "ferry"}, {"kind": "wolf_of_rome", "count": 14, "spacing": 0.7, "delay": 6.0}]},
		{"banner": "CERBERUS, the hound of the gates, breaks his chain!", "groups": [{"kind": "cerberus", "count": 1, "spacing": 1.0}, {"kind": "shade_hoplite", "count": 8, "spacing": 1.2, "delay": 2.0}, {"kind": "shade_of_dead", "count": 8, "spacing": 0.8, "delay": 4.0, "road": "ferry"}]},
		{"banner": "", "groups": [{"kind": "hoplite", "count": 12, "spacing": 1.3}, {"kind": "shade_hoplite", "count": 10, "spacing": 1.2, "delay": 2.0, "road": "ferry"}, {"kind": "centaur_archer", "count": 4, "spacing": 1.4, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 2, "spacing": 4.0}, {"kind": "shade_archer", "count": 8, "spacing": 1.2, "delay": 3.0}, {"kind": "shade_of_dead", "count": 12, "spacing": 0.8, "delay": 5.0, "road": "ferry"}]},
		{"banner": "", "groups": [{"kind": "bronze_titan", "count": 2, "spacing": 6.0, "road": "ferry"}, {"kind": "shade_hoplite", "count": 12, "spacing": 1.2, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "shade_hoplite", "count": 14, "spacing": 1.2}, {"kind": "gorgon", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "ferry"}, {"kind": "shade_archer", "count": 8, "spacing": 1.2, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 3, "spacing": 4.0}, {"kind": "hoplite", "count": 14, "spacing": 1.3, "delay": 3.0, "road": "ferry"}, {"kind": "wolf_of_rome", "count": 12, "spacing": 0.7, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "shade_of_dead", "count": 16, "spacing": 0.8, "road": "ferry"}, {"kind": "shade_hoplite", "count": 12, "spacing": 1.2, "delay": 2.0}, {"kind": "shade_archer", "count": 8, "spacing": 1.2, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "bronze_titan", "count": 2, "spacing": 6.0}, {"kind": "pan_hero", "count": 2, "spacing": 4.0, "delay": 3.0, "road": "ferry"}, {"kind": "centaur_archer", "count": 6, "spacing": 1.4, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "shade_hoplite", "count": 16, "spacing": 1.2}, {"kind": "gorgon", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "shade_of_dead", "count": 14, "spacing": 0.8, "delay": 5.0, "road": "ferry"}]},
		{"banner": "", "groups": [{"kind": "pan_hero", "count": 3, "spacing": 4.0}, {"kind": "hoplite", "count": 16, "spacing": 1.3, "delay": 3.0, "road": "ferry"}, {"kind": "shade_archer", "count": 10, "spacing": 1.2, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "bronze_titan", "count": 2, "spacing": 6.0}, {"kind": "shade_hoplite", "count": 16, "spacing": 1.2, "delay": 3.0}, {"kind": "shade_of_dead", "count": 16, "spacing": 0.8, "delay": 5.0, "road": "ferry"}]},
		{"banner": "HADES, LORD OF THE DEAD, claims what is his!", "groups": [{"kind": "hades", "count": 1, "spacing": 1.0}, {"kind": "shade_hoplite", "count": 10, "spacing": 1.2, "delay": 2.0}, {"kind": "pan_hero", "count": 2, "spacing": 4.0, "delay": 4.0, "road": "ferry"}, {"kind": "shade_of_dead", "count": 12, "spacing": 0.8, "delay": 7.0, "road": "ferry"}]},
	],
}
