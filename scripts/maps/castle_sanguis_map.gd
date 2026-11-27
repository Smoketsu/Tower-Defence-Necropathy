## Castle Sanguis (the Sanguine Court, map 3 and the act's finale; Necropathy
## Stage 21, GDD §7.3): the courtyard, the banquet hall, the crypt gallery and
## the Throne of Blood. One road walks the crenellated rampart (square teeth
## along the top wall) from the west, down the east wall, back along the bottom
## wall and up the west wall, then spirals once round the round keep to the gate
## at the throne in the middle; the bottom wall stays above the spell bar. 16
## plots, 6 posts. Rule: three blood fountains beside the road
## (court/court_structures: they heal the Court until broken). Act rule: the
## Blood Moon. 25 back-to-back waves with every Court kind and the Chiropterans;
## the Chiropteran King (miniboss, chest) on wave 13 and Queen Carmilla and the
## Elder on wave 25. Data only, no logic. MAP keys: graveyard_map.gd.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "castle_sanguis",
	"name": "Castle Sanguis",
	"floor": "tiles/castle_sanguis_courtyard",
	"decals": ["decals/sanctum_halls_carpet", "decals/sanctum_halls_rosette", "decals/sanctum_courtyard_moss", "decals/corpse_3"],
	"obstacles": [
		["obstacles/castle_wall_l", Vector2(60, 680)], ["obstacles/castle_well_l", Vector2(1230, 60)],
		["obstacles/gargoyle_statue_l", Vector2(40, 250)], ["obstacles/gargoyle_statue_l", Vector2(40, 520)],
		["obstacles/castle_wall_l", Vector2(260, 700)], ["obstacles/sarcophagus_l", Vector2(900, 700)],
		["obstacles/crypt_pillar_l", Vector2(1230, 680)], ["obstacles/feast_table_l", Vector2(610, 425)],
		["obstacles/wine_barrel_l", Vector2(390, 300)], ["obstacles/blood_urn_l", Vector2(747, 369)],
		["obstacles/candelabra_l", Vector2(1230, 250)], ["obstacles/feast_table_s", Vector2(1060, 470)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 175), Vector2(70, 175), Vector2(70, 100), Vector2(180, 100), Vector2(180, 175),
				Vector2(290, 175), Vector2(290, 100), Vector2(400, 100), Vector2(400, 175), Vector2(510, 175),
				Vector2(510, 100), Vector2(620, 100), Vector2(620, 175), Vector2(730, 175), Vector2(730, 100),
				Vector2(840, 100), Vector2(840, 175), Vector2(950, 175), Vector2(950, 100), Vector2(1000, 100),
				Vector2(1180, 230), Vector2(1180, 615), Vector2(130, 615), Vector2(130, 330), Vector2(413, 370),
				Vector2(433, 348), Vector2(457, 327), Vector2(485, 310), Vector2(517, 295), Vector2(553, 284),
				Vector2(590, 277), Vector2(629, 274), Vector2(667, 276), Vector2(705, 281), Vector2(741, 291),
				Vector2(774, 305), Vector2(802, 323), Vector2(825, 344), Vector2(842, 367), Vector2(852, 392),
				Vector2(855, 418), Vector2(850, 443), Vector2(837, 468), Vector2(817, 490), Vector2(790, 508),
				Vector2(758, 523), Vector2(721, 531), Vector2(683, 534), Vector2(645, 531), Vector2(609, 521),
				Vector2(579, 505), Vector2(556, 484), Vector2(544, 460), Vector2(542, 444)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
	},
	"gate": Vector2(539, 414),
	"plots": [
		Vector2(260, 550), Vector2(750, 230), Vector2(150, 240), Vector2(1070, 510), Vector2(1050, 230), Vector2(520, 230),
		Vector2(380, 230), Vector2(300, 230), Vector2(720, 470), Vector2(220, 480), Vector2(830, 230), Vector2(830, 560),
		Vector2(920, 560), Vector2(680, 380), Vector2(480, 560), Vector2(1120, 280),
	],
	"posts": [Vector2(389, 100), Vector2(893, 175), Vector2(1180, 589), Vector2(517, 615), Vector2(147, 332), Vector2(771, 517)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 4.9,  # TUNING (not in GDD) L4: 5.3 before the road redraw; the act's finale presses hardest
	"rule": "court/court_structures",
	"act_rule": "court/blood_moon",
	"build_order": "castle_sanguis_default",
	"weak_order": "castle_sanguis_weak",
	"waves": [
		{"banner": "The gates of Castle Sanguis open", "groups": [{"kind": "blood_thrall", "count": 12, "spacing": 1.1}, {"kind": "ghoul", "count": 6, "spacing": 0.8, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "vampire_bat", "count": 10, "spacing": 0.6}, {"kind": "blood_thrall", "count": 8, "spacing": 0.9, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 3, "spacing": 5.0}, {"kind": "ghoul", "count": 10, "spacing": 0.7, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "crimson_witch", "count": 2, "spacing": 5.0}, {"kind": "blood_thrall", "count": 14, "spacing": 0.8, "delay": 2.0}, {"kind": "vampire_bat", "count": 8, "spacing": 0.6, "delay": 8.0}]},
		{"banner": "Chiropterans shriek the towers silent", "groups": [{"kind": "chiropteran", "count": 2, "spacing": 5.0}, {"kind": "ghoul", "count": 12, "spacing": 0.7, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "werewolf", "count": 3, "spacing": 5.0}, {"kind": "blood_thrall", "count": 14, "spacing": 0.7, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "vampire_noble", "count": 2, "spacing": 6.0}, {"kind": "bloated_thrall", "count": 2, "spacing": 6.0, "delay": 4.0}, {"kind": "vampire_bat", "count": 10, "spacing": 0.5, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 5, "spacing": 4.0}, {"kind": "crimson_witch", "count": 3, "spacing": 4.0, "delay": 6.0}]},
		{"banner": "", "groups": [{"kind": "chiropteran", "count": 3, "spacing": 4.0}, {"kind": "werewolf", "count": 3, "spacing": 5.0, "delay": 4.0}, {"kind": "ghoul", "count": 14, "spacing": 0.6, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "bloated_thrall", "count": 3, "spacing": 5.0}, {"kind": "vampire_noble", "count": 3, "spacing": 5.0, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "vampire_bat", "count": 18, "spacing": 0.45}, {"kind": "blood_knight", "count": 5, "spacing": 4.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "werewolf", "count": 5, "spacing": 4.0}, {"kind": "crimson_witch", "count": 3, "spacing": 4.0, "delay": 4.0}, {"kind": "blood_thrall", "count": 16, "spacing": 0.6, "delay": 2.0}]},
		{"banner": "The Chiropteran King descends with his colony", "groups": [{"kind": "chiropteran_king", "count": 1, "spacing": 1.0}, {"kind": "chiropteran", "count": 3, "spacing": 4.0, "delay": 5.0}, {"kind": "ghoul", "count": 14, "spacing": 0.6, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "vampire_noble", "count": 4, "spacing": 4.5}, {"kind": "blood_knight", "count": 5, "spacing": 4.0, "delay": 3.0}, {"kind": "vampire_bat", "count": 12, "spacing": 0.5, "delay": 9.0}]},
		{"banner": "", "groups": [{"kind": "bloated_thrall", "count": 4, "spacing": 4.5}, {"kind": "chiropteran", "count": 3, "spacing": 4.0, "delay": 4.0}, {"kind": "blood_thrall", "count": 16, "spacing": 0.6, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "werewolf", "count": 6, "spacing": 3.5}, {"kind": "crimson_witch", "count": 4, "spacing": 3.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 7, "spacing": 3.0}, {"kind": "vampire_noble", "count": 3, "spacing": 5.0, "delay": 5.0}, {"kind": "vampire_bat", "count": 14, "spacing": 0.5, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "chiropteran", "count": 4, "spacing": 3.5}, {"kind": "bloated_thrall", "count": 4, "spacing": 4.5, "delay": 3.0}, {"kind": "ghoul", "count": 18, "spacing": 0.5, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "werewolf", "count": 6, "spacing": 3.5}, {"kind": "vampire_noble", "count": 4, "spacing": 4.5, "delay": 4.0}, {"kind": "blood_thrall", "count": 18, "spacing": 0.6, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "blood_knight", "count": 8, "spacing": 3.0}, {"kind": "crimson_witch", "count": 4, "spacing": 3.5, "delay": 5.0}, {"kind": "chiropteran", "count": 3, "spacing": 4.0, "delay": 9.0}]},
		{"banner": "", "groups": [{"kind": "vampire_bat", "count": 22, "spacing": 0.4}, {"kind": "bloated_thrall", "count": 5, "spacing": 4.0, "delay": 3.0}, {"kind": "werewolf", "count": 4, "spacing": 4.0, "delay": 8.0}]},
		{"banner": "", "groups": [{"kind": "vampire_noble", "count": 5, "spacing": 4.0}, {"kind": "blood_knight", "count": 7, "spacing": 3.0, "delay": 3.0}, {"kind": "ghoul", "count": 18, "spacing": 0.5, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "chiropteran", "count": 5, "spacing": 3.0}, {"kind": "werewolf", "count": 6, "spacing": 3.5, "delay": 3.0}, {"kind": "crimson_witch", "count": 4, "spacing": 3.5, "delay": 8.0}]},
		{"banner": "The Banquet of the Court", "groups": [{"kind": "blood_knight", "count": 8, "spacing": 3.0}, {"kind": "vampire_noble", "count": 5, "spacing": 4.0, "delay": 4.0}, {"kind": "bloated_thrall", "count": 4, "spacing": 4.5, "delay": 8.0}, {"kind": "vampire_bat", "count": 16, "spacing": 0.45, "delay": 12.0}]},
		{"banner": "Queen Carmilla descends from the Throne of Blood", "groups": [{"kind": "carmilla", "count": 1, "spacing": 1.0}, {"kind": "blood_knight", "count": 5, "spacing": 4.0, "delay": 6.0}, {"kind": "ghoul", "count": 14, "spacing": 0.6, "delay": 3.0}, {"kind": "chiropteran", "count": 3, "spacing": 4.0, "delay": 14.0}]},
	],
}
