## The Last Day (Act XIV map 3, the Age of Titans' finale; Necropathy's
## "last_day" stage, GDD §7.3): a scorched plain under a white sky, lava fields
## and an ash forest, the meteor already burning overhead. Two paths come in
## from the west and the east along the bottom of the plain and curve between
## the meteor craters (each bend round an old crater), meet in the middle and
## run up together to the necromancer's gate on the mound at the top. The ash
## trail crosses the whole plain west to east (off-road, an exit): the last
## herds run for their lives over it. FIRE FROM THE SKY: meteorites fall on
## telegraphed circles, on your towers half the time and on the road ahead of
## the foes otherwise, striking both armies. Act rule: the Stampedes
## (rules/primeval/stampedes.gd). 16 plots, 5 posts, 24 waves; Thunderwing, the
## Sky King (miniboss) on wave 12, Old Gravejaw on wave 24. Beating him unlocks
## the Bonehorn. Keys as graveyard_map.gd plus "herd_trails", "meteors" (the act
## rule). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and stampedes.gd).
const MAP: Dictionary = {
	"id": "last_day",
	"name": "The Last Day",
	"floor": "tiles/last_day_scorched_plain",
	"decals": [],
	"obstacles": [
		["obstacles/primeval_lava_rock_m", Vector2(60, 300)], ["obstacles/primeval_lava_rock_m", Vector2(1220, 300)],
		["obstacles/primeval_fossil_m", Vector2(640, 600)], ["obstacles/primeval_lava_rock_m", Vector2(380, 140)],
		["obstacles/primeval_lava_rock_m", Vector2(900, 140)], ["obstacles/primeval_fossil_m_v", Vector2(40, 520)],
		["obstacles/primeval_lava_rock_m", Vector2(1240, 520)], ["obstacles/primeval_rock_m", Vector2(560, 690)],
		["obstacles/primeval_rock_m", Vector2(740, 690)], ["obstacles/primeval_lava_rock_m", Vector2(478, 432)],
		["obstacles/primeval_lava_rock_m", Vector2(793, 551)], ["obstacles/primeval_lava_rock_m", Vector2(597, 325)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 600), Vector2(-24, 602), Vector2(-3, 605), Vector2(22, 608), Vector2(50, 613),
				Vector2(79, 617), Vector2(110, 620), Vector2(140, 623), Vector2(170, 625), Vector2(196, 626),
				Vector2(220, 625), Vector2(250, 621), Vector2(279, 615), Vector2(305, 607), Vector2(330, 597),
				Vector2(353, 586), Vector2(373, 573), Vector2(390, 560), Vector2(410, 538), Vector2(425, 513),
				Vector2(435, 485), Vector2(440, 457), Vector2(440, 430), Vector2(430, 403), Vector2(409, 376),
				Vector2(386, 349), Vector2(367, 323), Vector2(360, 300), Vector2(370, 273), Vector2(392, 247),
				Vector2(421, 227), Vector2(450, 215), Vector2(479, 215), Vector2(511, 224), Vector2(543, 237),
				Vector2(570, 250), Vector2(600, 274), Vector2(624, 299), Vector2(640, 300), Vector2(644, 283),
				Vector2(645, 255), Vector2(644, 221), Vector2(643, 186), Vector2(641, 155), Vector2(640, 135)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"east": {
			"points": [Vector2(1320, 600), Vector2(1303, 598), Vector2(1281, 594), Vector2(1254, 589), Vector2(1224, 584),
				Vector2(1193, 579), Vector2(1161, 575), Vector2(1131, 572), Vector2(1104, 570), Vector2(1080, 570),
				Vector2(1045, 577), Vector2(1016, 591), Vector2(990, 607), Vector2(965, 618), Vector2(940, 620),
				Vector2(917, 612), Vector2(892, 599), Vector2(868, 581), Vector2(847, 561), Vector2(830, 540),
				Vector2(820, 520), Vector2(822, 495), Vector2(835, 467), Vector2(853, 439), Vector2(867, 413),
				Vector2(870, 390), Vector2(856, 367), Vector2(831, 348), Vector2(800, 332), Vector2(770, 320),
				Vector2(737, 311), Vector2(700, 307), Vector2(666, 304), Vector2(643, 302)],
			"next": "main", "next_at": 1090.2,  # joins main at (640, 300)
			"entrance": true,
		},
		"ash_trail": {
			"points": [Vector2(-60, 500), Vector2(220, 490), Vector2(640, 470), Vector2(1060, 490), Vector2(1340, 480)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
		"ash_trail_back": {
			"points": [Vector2(1340, 480), Vector2(1060, 490), Vector2(640, 470), Vector2(220, 490), Vector2(-60, 500)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
	},
	"herd_trails": {"ash_trail": "ash_trail_back"},  # The herd trail and the road a turned herd runs back along.
	"meteors": true,  # Fire from the Sky (the act rule's RULE "meteor").
	"rocks": [Vector2(478, 432), Vector2(793, 551), Vector2(597, 325)],  # Lava rocks beside the road a charge breaks on (the obstacles of the same place).
	"gate": Vector2(640, 110),
	"plots": [
		Vector2(240, 680), Vector2(1120, 640), Vector2(750, 250), Vector2(490, 380), Vector2(520, 300), Vector2(970, 510),
		Vector2(730, 380), Vector2(310, 500), Vector2(840, 280), Vector2(150, 680), Vector2(440, 310), Vector2(570, 180),
		Vector2(420, 620), Vector2(70, 680), Vector2(1200, 640), Vector2(850, 650),
	],
	"posts": [Vector2(203, 626), Vector2(415, 384), Vector2(820, 513), Vector2(1109, 570), Vector2(645, 230)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 2.3,  # TUNING (not in GDD) DECISIONS Z4: 2.4 -> 2.3 (skyraiders 64 -> 54 px/s); the act's finale presses hardest
	"rule": "",
	"act_rule": "primeval/stampedes",
	"build_order": "last_day_default",
	"weak_order": "last_day_weak",
	"waves": [
		{"banner": "The Scorched Plain: the sky is falling", "groups": [{"kind": "prim_scuttler", "count": 8, "spacing": 0.5}, {"kind": "prim_scuttler", "count": 8, "spacing": 0.5, "delay": 2.0, "road": "east"}, {"kind": "prim_razorclaw", "count": 3, "spacing": 1.3, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "prim_razorclaw", "count": 4, "spacing": 1.1}, {"kind": "prim_razorclaw", "count": 4, "spacing": 1.1, "delay": 2.0, "road": "east"}]},
		{"banner": "Fire from the Sky: a meteor strikes both armies inside its circle", "groups": [{"kind": "prim_frill_spitter", "count": 4, "spacing": 1.2, "road": "east"}, {"kind": "prim_razorclaw", "count": 5, "spacing": 1.0, "delay": 2.0}]},
		{"banner": "The last herds run over the ash trail", "groups": [{"kind": "prim_duckbill", "count": 5, "spacing": 1.0, "delay": 5.0, "road": "ash_trail"}, {"kind": "prim_scuttler", "count": 12, "spacing": 0.4}, {"kind": "prim_frill_spitter", "count": 3, "spacing": 1.3, "delay": 3.0, "road": "east"}]},
		{"banner": "Stormwings: a wing gust stops your towers, then she lands; hit her then", "groups": [{"kind": "prim_stormwing", "count": 1, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 7, "spacing": 0.9, "delay": 2.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "prim_skyraider", "count": 6, "spacing": 0.8, "road": "east"}, {"kind": "prim_horncharger", "count": 1, "spacing": 4.0, "delay": 2.0}, {"kind": "prim_scuttler", "count": 12, "spacing": 0.4, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "prim_clubtail", "count": 1, "spacing": 4.0}, {"kind": "prim_frill_spitter", "count": 6, "spacing": 1.0, "delay": 2.0, "road": "east"}, {"kind": "prim_longneck", "count": 2, "spacing": 3.0, "delay": 5.0, "road": "ash_trail"}]},
		{"banner": "The Ash Forest", "groups": [{"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0, "road": "east"}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8, "delay": 1.0, "road": "east"}, {"kind": "prim_stormwing", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0}, {"kind": "prim_scuttler", "count": 18, "spacing": 0.35, "delay": 2.0, "road": "east"}, {"kind": "prim_duckbill", "count": 5, "spacing": 1.0, "delay": 6.0, "road": "ash_trail"}]},
		{"banner": "", "groups": [{"kind": "prim_horncharger", "count": 1, "spacing": 4.0, "road": "east"}, {"kind": "prim_skyraider", "count": 8, "spacing": 0.7, "delay": 2.0}, {"kind": "prim_frill_spitter", "count": 8, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "prim_clubtail", "count": 1, "spacing": 4.0, "road": "east"}, {"kind": "prim_stormwing", "count": 1, "spacing": 6.0, "delay": 2.0}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8, "delay": 3.0}]},
		{"banner": "THUNDERWING, THE SKY KING! His gusts clear a wide ring of towers", "groups": [{"kind": "prim_thunderwing", "count": 1, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 10, "spacing": 0.9, "delay": 3.0, "road": "east"}, {"kind": "prim_scuttler", "count": 14, "spacing": 0.4, "delay": 7.0}]},
		{"banner": "The Lava Fields", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0, "road": "east"}, {"kind": "prim_frill_spitter", "count": 10, "spacing": 0.9, "delay": 2.0}, {"kind": "prim_longneck", "count": 3, "spacing": 2.5, "delay": 6.0, "road": "ash_trail"}]},
		{"banner": "", "groups": [{"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8, "delay": 1.0}, {"kind": "prim_horncharger", "count": 2, "spacing": 4.0, "delay": 3.0, "road": "east"}, {"kind": "prim_skyraider", "count": 8, "spacing": 0.8, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "prim_clubtail", "count": 3, "spacing": 3.5}, {"kind": "prim_stormwing", "count": 2, "spacing": 5.0, "delay": 2.0, "road": "east"}, {"kind": "prim_scuttler", "count": 20, "spacing": 0.35, "delay": 4.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 14, "spacing": 0.7, "delay": 2.0, "road": "east"}, {"kind": "prim_duckbill", "count": 6, "spacing": 0.9, "delay": 6.0, "road": "ash_trail"}]},
		{"banner": "", "groups": [{"kind": "prim_horncharger", "count": 3, "spacing": 3.5, "road": "east"}, {"kind": "prim_frill_spitter", "count": 10, "spacing": 0.9, "delay": 2.0}, {"kind": "prim_skyraider", "count": 10, "spacing": 0.7, "delay": 4.0, "road": "east"}]},
		{"banner": "The Impact Rim", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0, "road": "east"}, {"kind": "prim_stormwing", "count": 2, "spacing": 5.0, "delay": 2.0}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8, "delay": 3.0}, {"kind": "prim_longneck", "count": 3, "spacing": 2.5, "delay": 6.0, "road": "ash_trail"}]},
		{"banner": "", "groups": [{"kind": "prim_clubtail", "count": 3, "spacing": 3.5, "road": "east"}, {"kind": "prim_razorclaw_alpha", "count": 2, "spacing": 3.0, "delay": 2.0}, {"kind": "prim_scuttler", "count": 22, "spacing": 0.3, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0}, {"kind": "prim_horncharger", "count": 3, "spacing": 3.0, "delay": 2.0, "road": "east"}, {"kind": "prim_frill_spitter", "count": 10, "spacing": 0.9, "delay": 4.0}, {"kind": "prim_duckbill", "count": 6, "spacing": 0.9, "delay": 6.0, "road": "ash_trail"}]},
		{"banner": "", "groups": [{"kind": "prim_stormwing", "count": 3, "spacing": 4.0, "road": "east"}, {"kind": "prim_razorclaw", "count": 14, "spacing": 0.7, "delay": 2.0}, {"kind": "prim_skyraider", "count": 12, "spacing": 0.6, "delay": 4.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0, "road": "east"}, {"kind": "prim_clubtail", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0, "delay": 3.0}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8, "delay": 4.0}]},
		{"banner": "The world ends tonight", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0}, {"kind": "prim_horncharger", "count": 3, "spacing": 3.0, "delay": 2.0, "road": "east"}, {"kind": "prim_stormwing", "count": 2, "spacing": 5.0, "delay": 4.0}, {"kind": "prim_longneck", "count": 3, "spacing": 2.5, "delay": 6.0, "road": "ash_trail"}]},
		{"banner": "OLD GRAVEJAW, THE TYRANT KING, rules the Last Day!", "groups": [{"kind": "prim_gravejaw", "count": 1, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 10, "spacing": 1.0, "delay": 8.0, "road": "east"}, {"kind": "prim_horncharger", "count": 2, "spacing": 5.0, "delay": 12.0}]},
	],
}
