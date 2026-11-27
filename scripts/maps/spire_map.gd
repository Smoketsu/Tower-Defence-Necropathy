## Ul-Thalos, the Risen Spire (Act XI map 3, the act's finale; Necropathy stage
## "spire"): the god's drowned city risen from the sea, sliding back under it.
## Two tentacles wrap the spire: the west road spirals in from the breakwater
## one and a half times round it to the gate at its foot in the middle, and the
## east road curls in from the eastern shore between its coils (the two arms
## interleaved) and joins the inner coil. 15 plots, 6 posts, 23 waves. Claims
## (act rule eye/claims): Chanters and the Hierophants claim the dead. The Grand
## Hierophant (miniboss, chest) on wave 12; Vhal'Neth, the Dreaming Mother, on
## wave 23 (her face off the shore of the west road, her arms rising beside it).
## Keys as graveyard_map.gd. Data only.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "spire",
	"name": "Ul-Thalos, the Risen Spire",
	"floor": "tiles/spire_breakwater",
	"decals": [],
	"obstacles": [
		["obstacles/cyclopean_block_l", Vector2(90, 120)], ["obstacles/barnacle_pillar_l", Vector2(65, 529)],
		["obstacles/fallen_idol_l", Vector2(330, 680)], ["obstacles/step_ruin_m", Vector2(1180, 90)],
		["obstacles/sunken_idol_l", Vector2(1230, 400)], ["obstacles/gate_pylon_l", Vector2(493, 381)],
		["obstacles/gate_pylon_l", Vector2(922, 365)], ["obstacles/toppled_arch_l", Vector2(680, 210)],
		["obstacles/spire_shard_l", Vector2(868, 416)], ["obstacles/spire_shard_l", Vector2(330, 300)],
		["obstacles/barnacle_pillar_s", Vector2(1240, 700)], ["obstacles/spire_shard_s", Vector2(700, 690)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 463), Vector2(144, 463), Vector2(135, 437), Vector2(129, 412), Vector2(127, 386),
				Vector2(128, 360), Vector2(132, 334), Vector2(140, 308), Vector2(151, 283), Vector2(165, 259),
				Vector2(183, 235), Vector2(204, 213), Vector2(227, 191), Vector2(254, 171), Vector2(283, 153),
				Vector2(315, 136), Vector2(349, 121), Vector2(385, 108), Vector2(423, 97), Vector2(462, 89),
				Vector2(502, 82), Vector2(544, 78), Vector2(585, 76), Vector2(627, 77), Vector2(668, 81),
				Vector2(709, 86), Vector2(748, 95), Vector2(786, 105), Vector2(822, 118), Vector2(856, 133),
				Vector2(887, 151), Vector2(915, 170), Vector2(940, 191), Vector2(961, 213), Vector2(978, 237),
				Vector2(990, 262), Vector2(999, 287), Vector2(1002, 313), Vector2(1001, 339), Vector2(995, 365),
				Vector2(984, 390), Vector2(969, 414), Vector2(949, 437), Vector2(924, 458), Vector2(895, 477),
				Vector2(863, 494), Vector2(828, 507), Vector2(790, 518), Vector2(750, 525), Vector2(709, 529),
				Vector2(667, 529), Vector2(626, 525), Vector2(586, 518), Vector2(549, 506), Vector2(514, 491),
				Vector2(485, 473), Vector2(460, 452), Vector2(442, 429), Vector2(431, 403), Vector2(428, 377),
				Vector2(432, 352), Vector2(445, 327), Vector2(467, 304), Vector2(496, 286), Vector2(531, 272),
				Vector2(571, 264), Vector2(613, 264), Vector2(653, 272), Vector2(686, 287), Vector2(707, 310),
				Vector2(708, 335)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"east": {
			"points": [Vector2(1320, 237), Vector2(1136, 237), Vector2(1143, 263), Vector2(1147, 289), Vector2(1148, 315),
				Vector2(1145, 341), Vector2(1139, 367), Vector2(1129, 392), Vector2(1115, 417), Vector2(1099, 441),
				Vector2(1079, 464), Vector2(1056, 485), Vector2(1030, 506), Vector2(1001, 525), Vector2(969, 542),
				Vector2(935, 557), Vector2(898, 570), Vector2(860, 580), Vector2(821, 589), Vector2(780, 595),
				Vector2(738, 598), Vector2(696, 598), Vector2(655, 596), Vector2(614, 591), Vector2(574, 583),
				Vector2(536, 572), Vector2(499, 559), Vector2(466, 543), Vector2(436, 525), Vector2(410, 504),
				Vector2(388, 482), Vector2(371, 458), Vector2(359, 433), Vector2(353, 407), Vector2(353, 381),
				Vector2(359, 355), Vector2(372, 329), Vector2(390, 306), Vector2(415, 284), Vector2(446, 266),
				Vector2(481, 252), Vector2(521, 242), Vector2(562, 237), Vector2(574, 237)],
			"next": "main", "next_at": 2347.8,  # joins main at (575, 264)
			"entrance": true,
		},
	},
	"gate": Vector2(709, 353),
	"plots": [
		Vector2(520, 410), Vector2(500, 180), Vector2(610, 460), Vector2(660, 160), Vector2(1060, 350), Vector2(410, 210),
		Vector2(230, 340), Vector2(770, 180), Vector2(290, 280), Vector2(70, 320), Vector2(910, 630), Vector2(690, 460),
		Vector2(1080, 270), Vector2(770, 460), Vector2(910, 280),
	],
	"posts": [Vector2(245, 178), Vector2(904, 163), Vector2(680, 529), Vector2(664, 277), Vector2(804, 591), Vector2(584, 264)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 3.1,  # TUNING (not in GDD) L4: 3.5 before the road redraw; DECISIONS Z4: 3.7 -> 3.5, three-Spawn waves cut to two; Part Three: the act's finale presses hardest
	"rule": "",
	"act_rule": "eye/claims",
	"build_order": "spire_default",
	"weak_order": "spire_weak",
	"waves": [
		{"banner": "The faithful climb the drowned steps of Ul-Thalos", "groups": [{"kind": "eye_initiate", "count": 14, "spacing": 0.6}, {"kind": "eye_deep_kin", "count": 3, "spacing": 1.8, "delay": 4.0}]},
		{"banner": "Sirens of the Eye: their song turns your blockers on their own post", "groups": [{"kind": "eye_siren", "count": 1, "spacing": 1.0}, {"kind": "eye_initiate", "count": 12, "spacing": 0.6, "delay": 1.0}, {"kind": "eye_deep_kin", "count": 2, "spacing": 2.0, "delay": 5.0, "road": "east"}]},
		{"banner": "Spawns of the Deep: a tentacle grabs and squeezes a body", "groups": [{"kind": "eye_spawn", "count": 1, "spacing": 1.0}, {"kind": "eye_initiate", "count": 12, "spacing": 0.5, "delay": 1.0}, {"kind": "eye_tide_caller", "count": 2, "spacing": 2.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_initiate", "count": 14, "spacing": 0.5, "road": "east"}, {"kind": "eye_chanter", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "east"}, {"kind": "eye_deep_kin", "count": 4, "spacing": 1.3, "delay": 3.0}]},
		{"banner": "Hierophants: they claim the dead, and ASCEND unless you break them", "groups": [{"kind": "eye_hierophant", "count": 1, "spacing": 1.0}, {"kind": "eye_initiate", "count": 12, "spacing": 0.5, "delay": 1.0}, {"kind": "eye_scribe", "count": 2, "spacing": 3.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_siren", "count": 2, "spacing": 4.0}, {"kind": "eye_deep_kin", "count": 6, "spacing": 1.2, "delay": 1.0}, {"kind": "eye_initiate", "count": 10, "spacing": 0.5, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "eye_spawn", "count": 2, "spacing": 4.0}, {"kind": "eye_tide_caller", "count": 3, "spacing": 2.5, "delay": 1.0, "road": "east"}, {"kind": "eye_initiate", "count": 12, "spacing": 0.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "eye_hierophant", "count": 1, "spacing": 1.0, "road": "east"}, {"kind": "eye_chanter", "count": 1, "spacing": 1.0, "delay": 2.0}, {"kind": "eye_initiate", "count": 16, "spacing": 0.4, "delay": 2.0}, {"kind": "eye_deep_kin", "count": 4, "spacing": 1.3, "delay": 5.0}]},
		{"banner": "The sea rises: the outer ring sinks", "groups": [{"kind": "eye_siren", "count": 2, "spacing": 3.5}, {"kind": "eye_scribe", "count": 3, "spacing": 2.5, "delay": 1.0}, {"kind": "eye_initiate", "count": 14, "spacing": 0.4, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "eye_spawn", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "eye_deep_kin", "count": 8, "spacing": 1.0, "delay": 1.0}, {"kind": "eye_tide_caller", "count": 3, "spacing": 2.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_hierophant", "count": 2, "spacing": 4.0}, {"kind": "eye_initiate", "count": 18, "spacing": 0.4, "delay": 1.0}, {"kind": "eye_siren", "count": 1, "spacing": 1.0, "delay": 5.0, "road": "east"}]},
		{"banner": "The Grand Hierophant raises his staff over the drowned city!", "groups": [{"kind": "eye_grand_hierophant", "count": 1, "spacing": 1.0}, {"kind": "eye_initiate", "count": 12, "spacing": 0.5, "delay": 4.0}, {"kind": "eye_deep_kin", "count": 4, "spacing": 1.4, "delay": 8.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "eye_chanter", "count": 2, "spacing": 4.0}, {"kind": "eye_spawn", "count": 2, "spacing": 4.0, "delay": 1.0}, {"kind": "eye_initiate", "count": 14, "spacing": 0.4, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "eye_siren", "count": 3, "spacing": 3.0}, {"kind": "eye_deep_kin", "count": 8, "spacing": 1.0, "delay": 1.0, "road": "east"}, {"kind": "eye_scribe", "count": 3, "spacing": 2.5, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "eye_hierophant", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "eye_tide_caller", "count": 4, "spacing": 2.0, "delay": 1.0}, {"kind": "eye_initiate", "count": 16, "spacing": 0.4, "delay": 3.0}]},
		{"banner": "The Dream Gate: the god's light pours through", "groups": [{"kind": "eye_spawn", "count": 2, "spacing": 3.0}, {"kind": "eye_siren", "count": 2, "spacing": 3.5, "delay": 2.0}, {"kind": "eye_initiate", "count": 16, "spacing": 0.4, "delay": 3.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "eye_chanter", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "eye_deep_kin", "count": 10, "spacing": 0.9, "delay": 1.0}, {"kind": "eye_hierophant", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_siren", "count": 3, "spacing": 3.0}, {"kind": "eye_spawn", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "east"}, {"kind": "eye_scribe", "count": 4, "spacing": 2.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "eye_initiate", "count": 22, "spacing": 0.3}, {"kind": "eye_hierophant", "count": 2, "spacing": 4.0, "delay": 2.0, "road": "east"}, {"kind": "eye_tide_caller", "count": 4, "spacing": 2.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "eye_spawn", "count": 2, "spacing": 3.0, "road": "east"}, {"kind": "eye_siren", "count": 2, "spacing": 3.5, "delay": 1.0}, {"kind": "eye_deep_kin", "count": 10, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "The last stone above the sea: the island holds its breath", "groups": [{"kind": "eye_hierophant", "count": 2, "spacing": 4.0}, {"kind": "eye_chanter", "count": 2, "spacing": 4.0, "delay": 1.0, "road": "east"}, {"kind": "eye_initiate", "count": 18, "spacing": 0.3, "delay": 2.0}, {"kind": "eye_spawn", "count": 2, "spacing": 4.0, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "eye_siren", "count": 3, "spacing": 3.0, "road": "east"}, {"kind": "eye_spawn", "count": 2, "spacing": 3.0, "delay": 2.0}, {"kind": "eye_deep_kin", "count": 8, "spacing": 1.0, "delay": 4.0, "road": "east"}, {"kind": "eye_scribe", "count": 3, "spacing": 2.5, "delay": 6.0}]},
		{"banner": "Vhal'Neth, the Dreaming Mother, rises beside the spire!", "groups": [{"kind": "eye_vhalneth", "count": 1, "spacing": 1.0}, {"kind": "eye_initiate", "count": 10, "spacing": 0.6, "delay": 6.0, "road": "east"}, {"kind": "eye_deep_kin", "count": 6, "spacing": 1.2, "delay": 12.0}, {"kind": "eye_siren", "count": 1, "spacing": 1.0, "delay": 18.0, "road": "east"}]},
	],
}
