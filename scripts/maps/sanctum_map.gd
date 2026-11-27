## The Sanctum of Judgment (GDD §7.2): one long procession: in from the west
## along the south ambulatory, up the east side, back along the north
## ambulatory, down the west aisle and east up the nave, then three quarters
## round the round apse to the altar gate at its heart, through two sanctified
## chambers (the north ambulatory and the nave). 15 grave plots (6 of them
## inside a chamber), 5 road posts on Necropathy's cloister floor. Rule: towers
## inside a chamber deal 25% less until its two ward crystals are broken
## (sanctified_chambers). 25 back-to-back waves: Sentinels, Radiant Inquisitors,
## High Confessors and Sun Paladins; the Cathedral Guardian (miniboss, chest) on
## wave 13 and Grand Inquisitor Seraphine on wave 25. Units are mirrored side
## views (GDD §13). Data only, no logic. MAP keys: graveyard_map.gd.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "sanctum",
	"name": "The Sanctum of Judgment",
	"unlock_after": "crimson_march",
	"floor": "tiles/sanctum_cloisters",
	"decals": ["decals/sanctum_cloisters_flowers", "decals/sanctum_cloisters_flowers_2", "decals/sanctum_cloisters_leaves",
		"decals/sanctum_cloisters_leaves_2", "decals/sanctum_cloisters_sundial", "decals/sanctum_courtyard_moss"],
	"obstacles": [
		["obstacles/fountain_m", Vector2(1112, 205)], ["obstacles/saint_statue_m", Vector2(125, 425)],
		["obstacles/marble_column_m", Vector2(1116, 289)], ["obstacles/marble_column_m", Vector2(1115, 460)],
		["obstacles/cypress_m", Vector2(75, 686)], ["obstacles/pew_m", Vector2(1040, 685)],
		["obstacles/stone_bench_m", Vector2(260, 680)], ["obstacles/cypress_s", Vector2(60, 250)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 620), Vector2(1180, 620), Vector2(1180, 110), Vector2(110, 110), Vector2(110, 360),
				Vector2(760, 360), Vector2(762, 338), Vector2(768, 317), Vector2(777, 298), Vector2(790, 280),
				Vector2(806, 266), Vector2(824, 254), Vector2(844, 245), Vector2(866, 241), Vector2(887, 240),
				Vector2(909, 243), Vector2(929, 251), Vector2(948, 261), Vector2(965, 275), Vector2(979, 292),
				Vector2(989, 311), Vector2(997, 331), Vector2(1000, 353), Vector2(999, 374), Vector2(995, 396),
				Vector2(986, 416), Vector2(974, 434), Vector2(960, 450), Vector2(942, 463), Vector2(923, 472),
				Vector2(902, 478), Vector2(880, 480), Vector2(880, 400)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
	},
	"gate": Vector2(880, 372),
	"plots": [
		Vector2(760, 540), Vector2(450, 270), Vector2(840, 560), Vector2(1040, 530), Vector2(530, 270), Vector2(870, 180),
		Vector2(1050, 220), Vector2(720, 210), Vector2(260, 170), Vector2(480, 560), Vector2(1100, 320), Vector2(200, 230),
		Vector2(1110, 490), Vector2(240, 300), Vector2(160, 560),
	],
	"posts": [Vector2(633, 620), Vector2(835, 110), Vector2(173, 110), Vector2(998, 378), Vector2(880, 476)],
	"lives": 0,
	"souls": 250,
	"wave_hp_end": 2.9,  # TUNING (not in GDD) L4: 3.15 before the road redraw; integration balance: the last map presses hardest
	"rule": "sanctified_chambers",
	"build_order": "sanctum_default",
	"weak_order": "sanctum_weak",
	"waves": [
		{"banner": "The Sanctum's doors open", "groups": [{"kind": "recruit", "count": 10, "spacing": 1.4}, {"kind": "footman", "count": 4, "spacing": 1.2, "delay": 10.2}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 8, "spacing": 1.2}, {"kind": "archer", "count": 8, "spacing": 0.8, "delay": 5.1}]},
		{"banner": "Sanctified Sentinels: flat armour 6", "groups": [{"kind": "sanctified_sentinel", "count": 2, "spacing": 6.8}, {"kind": "recruit", "count": 12, "spacing": 0.8, "delay": 3.4}]},
		{"banner": "", "groups": [{"kind": "purifier", "count": 12, "spacing": 0.8}, {"kind": "footman", "count": 8, "spacing": 1.2, "delay": 5.1}]},
		{"banner": "", "groups": [{"kind": "sanctified_sentinel", "count": 3, "spacing": 5.1}, {"kind": "chaplain", "count": 2, "spacing": 5.1, "delay": 8.5}, {"kind": "footman", "count": 8, "spacing": 1.2, "delay": 3.4}]},
		{"banner": "Radiant Inquisitors suppress the undead near them", "groups": [{"kind": "radiant_inquisitor", "count": 2, "spacing": 6.8}, {"kind": "footman", "count": 10, "spacing": 1.2, "delay": 1.7}]},
		{"banner": "", "groups": [{"kind": "shieldbearer", "count": 8, "spacing": 1.2}, {"kind": "banner_bearer", "count": 1, "spacing": 1.2, "delay": 10.2}, {"kind": "purifier", "count": 10, "spacing": 0.8, "delay": 5.1}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 3, "spacing": 5.1}, {"kind": "sanctified_sentinel", "count": 2, "spacing": 5.1, "delay": 6.8}, {"kind": "recruit", "count": 14, "spacing": 0.7, "delay": 3.4}]},
		{"banner": "High Confessors heal and raise the fallen", "groups": [{"kind": "footman", "count": 12, "spacing": 1.2}, {"kind": "high_confessor", "count": 2, "spacing": 6.8, "delay": 6.8}, {"kind": "sanctified_sentinel", "count": 2, "spacing": 5.1, "delay": 13.6}]},
		{"banner": "", "groups": [{"kind": "radiant_inquisitor", "count": 3, "spacing": 5.1}, {"kind": "purifier", "count": 16, "spacing": 0.7}]},
		{"banner": "", "groups": [{"kind": "halberdier", "count": 3, "spacing": 5.1}, {"kind": "shieldbearer", "count": 10, "spacing": 1.2, "delay": 3.4}, {"kind": "chaplain", "count": 2, "spacing": 5.1, "delay": 10.2}]},
		{"banner": "", "groups": [{"kind": "sanctified_sentinel", "count": 4, "spacing": 4.2}, {"kind": "high_confessor", "count": 2, "spacing": 5.1, "delay": 10.2}, {"kind": "footman", "count": 10, "spacing": 1.2, "delay": 5.1}]},
		{"banner": "The Cathedral Guardian wakes", "groups": [{"kind": "cathedral_guardian", "count": 1, "spacing": 1.2}, {"kind": "footman", "count": 15, "spacing": 1.2, "delay": 5.1}, {"kind": "radiant_inquisitor", "count": 2, "spacing": 5.1, "delay": 10.2}]},
		{"banner": "Sun Paladins ward their brothers", "groups": [{"kind": "sun_paladin", "count": 2, "spacing": 6.8}, {"kind": "footman", "count": 17, "spacing": 1.0, "delay": 1.7}]},
		{"banner": "", "groups": [{"kind": "battle_sister", "count": 5, "spacing": 3.4}, {"kind": "sanctified_sentinel", "count": 4, "spacing": 4.2, "delay": 6.8}, {"kind": "high_confessor", "count": 2, "spacing": 5.1, "delay": 11.9}]},
		{"banner": "", "groups": [{"kind": "purifier", "count": 24, "spacing": 0.6}, {"kind": "radiant_inquisitor", "count": 4, "spacing": 5.1, "delay": 6.8}]},
		{"banner": "", "groups": [{"kind": "sun_paladin", "count": 2, "spacing": 5.1}, {"kind": "shieldbearer", "count": 15, "spacing": 1.2, "delay": 3.4}, {"kind": "banner_bearer", "count": 2, "spacing": 5.1, "delay": 11.9}]},
		{"banner": "", "groups": [{"kind": "sanctified_sentinel", "count": 6, "spacing": 3.4}, {"kind": "high_confessor", "count": 4, "spacing": 4.2, "delay": 8.5}, {"kind": "halberdier", "count": 4, "spacing": 4.2, "delay": 5.1}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 8, "spacing": 2.5}, {"kind": "sun_paladin", "count": 2, "spacing": 5.1, "delay": 6.8}, {"kind": "footman", "count": 15, "spacing": 1.2, "delay": 3.4}]},
		{"banner": "", "groups": [{"kind": "radiant_inquisitor", "count": 5, "spacing": 4.2}, {"kind": "battle_sister", "count": 8, "spacing": 2.5, "delay": 5.1}, {"kind": "recruit", "count": 24, "spacing": 0.6, "delay": 1.7}]},
		{"banner": "", "groups": [{"kind": "sanctified_sentinel", "count": 8, "spacing": 3.4}, {"kind": "sun_paladin", "count": 4, "spacing": 5.1, "delay": 5.1}, {"kind": "high_confessor", "count": 4, "spacing": 4.2, "delay": 10.2}]},
		{"banner": "", "groups": [{"kind": "halberdier", "count": 6, "spacing": 3.4}, {"kind": "shieldbearer", "count": 17, "spacing": 1.2, "delay": 3.4}, {"kind": "banner_bearer", "count": 4, "spacing": 4.2, "delay": 10.2}, {"kind": "radiant_inquisitor", "count": 2, "spacing": 5.1, "delay": 13.6}]},
		{"banner": "", "groups": [{"kind": "purifier", "count": 29, "spacing": 0.5}, {"kind": "templar", "count": 8, "spacing": 2.5, "delay": 6.8}, {"kind": "high_confessor", "count": 4, "spacing": 4.2, "delay": 10.2}]},
		{"banner": "The Covenant's final judgment", "groups": [{"kind": "sanctified_sentinel", "count": 8, "spacing": 3.4}, {"kind": "sun_paladin", "count": 5, "spacing": 4.2, "delay": 5.1}, {"kind": "high_confessor", "count": 5, "spacing": 4.2, "delay": 8.5}, {"kind": "battle_sister", "count": 8, "spacing": 2.5, "delay": 10.2}, {"kind": "radiant_inquisitor", "count": 4, "spacing": 5.1, "delay": 13.6}]},
		{"banner": "Grand Inquisitor Seraphine descends!", "groups": [{"kind": "seraphine", "count": 1, "spacing": 1.2}, {"kind": "sanctified_sentinel", "count": 4, "spacing": 4.2, "delay": 6.8}, {"kind": "sun_paladin", "count": 2, "spacing": 5.1, "delay": 13.6}, {"kind": "footman", "count": 12, "spacing": 1.2, "delay": 3.4}]},
	],
}
