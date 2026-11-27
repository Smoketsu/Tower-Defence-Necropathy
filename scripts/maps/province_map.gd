## The Burning Province (Act V map 1; Necropathy stage "province"): rice
## terraces and a village in flames. Two entrances: the main road comes in from
## the west along the raised dikes, turning at right angles round the staggered
## rectangular paddies; the village lane climbs from the south by its own dikes
## and joins it in the middle, so the towers there cover both. 16 plots, 5
## posts, 22 waves. The Sun's Course (act rule shogunate/sun_course): day, dusk
## from wave 9 (ninja ambush mid-road), night from wave 15 (towers see only
## inside lantern light; the oni, onryo and kappa walk). Shuten-doji (miniboss,
## chest) on wave 16, Kage, Mistress of the Hidden Hand, on wave 22. Keys as
## graveyard_map.gd, plus the Sun's Course keys (documented in
## rules/shogunate/sun_course.gd): lanterns (map px of each stone lantern) and
## ambush ([road id, px along it] points ninja appear at). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and sun_course.gd).
const MAP: Dictionary = {
	"id": "province",
	"name": "The Burning Province",
	"floor": "tiles/province_paddies",
	"decals": [],
	"obstacles": [
		["obstacles/rice_sheaves_l", Vector2(60, 110)], ["obstacles/rice_sheaves_s", Vector2(300, 110)],
		["obstacles/bamboo_stand_l", Vector2(660, 120)], ["obstacles/bamboo_stand_m", Vector2(760, 160)],
		["obstacles/bamboo_stand_s", Vector2(870, 120)], ["obstacles/burning_house_l", Vector2(1180, 420)],
		["obstacles/burning_house_s", Vector2(1100, 690)], ["obstacles/rice_sheaves_l", Vector2(70, 420)],
		["obstacles/burning_house_s_v", Vector2(840, 650)], ["obstacles/bamboo_stand_m", Vector2(60, 700)],
		["obstacles/shrine_hall_s", Vector2(1210, 90)], ["obstacles/rice_sheaves_s", Vector2(560, 700)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 190), Vector2(240, 190), Vector2(240, 300), Vector2(470, 300), Vector2(470, 190),
				Vector2(720, 190), Vector2(720, 400), Vector2(950, 400), Vector2(950, 250), Vector2(1190, 250)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"village": {
			"points": [Vector2(330, 770), Vector2(330, 600), Vector2(600, 600), Vector2(600, 500), Vector2(720, 500),
				Vector2(720, 402)],
			"next": "main", "next_at": 1190.0,  # joins main at (720, 400)
			"entrance": true,
		},
	},
	"gate": Vector2(1218, 220),
	"plots": [
		Vector2(150, 130), Vector2(1040, 190), Vector2(780, 460), Vector2(340, 200), Vector2(1040, 310), Vector2(610, 440),
		Vector2(380, 360), Vector2(130, 290), Vector2(820, 300), Vector2(450, 540), Vector2(580, 280), Vector2(660, 350),
		Vector2(1010, 390), Vector2(590, 130), Vector2(530, 530), Vector2(420, 670),
	],
	"posts": [Vector2(240, 260), Vector2(470, 225), Vector2(720, 390), Vector2(509, 600), Vector2(980, 250)],
	"lanterns": [Vector2(170, 250), Vector2(415, 251), Vector2(462, 650), Vector2(670, 296), Vector2(1007, 345), Vector2(1108, 300)],
	"ambush": [["main", 654.2], ["village", 237.0], ["main", 1168.2]],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 3.2,  # TUNING (not in GDD) L4: 2.7 before the road redraw; Act V map 1: a little harder than the Sanctum
	"rule": "",
	"act_rule": "shogunate/sun_course",
	"build_order": "province_default",
	"weak_order": "province_weak",
	"waves": [
		{"banner": "Spear levies wade through the paddies", "groups": [{"kind": "ashigaru", "count": 10, "spacing": 1.3}]},
		{"banner": "", "groups": [{"kind": "ashigaru", "count": 10, "spacing": 1.0}, {"kind": "ashigaru", "count": 6, "spacing": 1.1, "delay": 3.0, "road": "village"}]},
		{"banner": "Samurai draw on the post that holds them", "groups": [{"kind": "samurai", "count": 4, "spacing": 2.4}, {"kind": "ashigaru", "count": 10, "spacing": 0.9, "delay": 3.0}]},
		{"banner": "An arquebus line: their shots stop on your blockers", "groups": [{"kind": "teppo_gunner", "count": 6, "spacing": 1.6}, {"kind": "ashigaru", "count": 8, "spacing": 0.9, "delay": 2.0, "road": "village"}]},
		{"banner": "", "groups": [{"kind": "samurai", "count": 6, "spacing": 1.8}, {"kind": "ashigaru", "count": 12, "spacing": 0.8, "delay": 4.0, "road": "village"}]},
		{"banner": "", "groups": [{"kind": "teppo_gunner", "count": 8, "spacing": 1.2}, {"kind": "samurai", "count": 4, "spacing": 2.0, "delay": 5.0, "road": "village"}]},
		{"banner": "", "groups": [{"kind": "ashigaru", "count": 20, "spacing": 0.6}, {"kind": "samurai", "count": 5, "spacing": 1.8, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "samurai", "count": 8, "spacing": 1.4, "road": "village"}, {"kind": "teppo_gunner", "count": 8, "spacing": 1.1, "delay": 3.0}]},
		{"banner": "Ninja come out of the bamboo shadows!", "groups": [{"kind": "ninja", "count": 7, "spacing": 1.4}, {"kind": "ashigaru", "count": 12, "spacing": 0.8, "delay": 2.0, "road": "village"}]},
		{"banner": "", "groups": [{"kind": "samurai", "count": 7, "spacing": 1.3}, {"kind": "ninja", "count": 5, "spacing": 1.5, "delay": 4.0, "road": "village"}]},
		{"banner": "A kunoichi: her smoke blinds your towers", "groups": [{"kind": "kunoichi", "count": 2, "spacing": 5.0}, {"kind": "ninja", "count": 7, "spacing": 1.0, "delay": 2.0}, {"kind": "ashigaru", "count": 10, "spacing": 0.7, "delay": 4.0, "road": "village"}]},
		{"banner": "", "groups": [{"kind": "teppo_gunner", "count": 8, "spacing": 1.0}, {"kind": "samurai", "count": 7, "spacing": 1.3, "delay": 3.0, "road": "village"}]},
		{"banner": "", "groups": [{"kind": "ninja", "count": 10, "spacing": 0.9}, {"kind": "kunoichi", "count": 2, "spacing": 4.0, "delay": 5.0, "road": "village"}, {"kind": "ashigaru", "count": 12, "spacing": 0.7, "delay": 2.0}]},
		{"banner": "Duelists in the failing light", "groups": [{"kind": "samurai", "count": 10, "spacing": 1.0}, {"kind": "teppo_gunner", "count": 7, "spacing": 1.0, "delay": 4.0, "road": "village"}]},
		{"banner": "Night falls: the yokai walk. Fight in the lanterns' light!", "groups": [{"kind": "onryo", "count": 7, "spacing": 0.9}, {"kind": "kappa", "count": 7, "spacing": 0.9, "delay": 3.0, "road": "village"}, {"kind": "oni", "count": 1, "spacing": 1.0, "delay": 8.0}]},
		{"banner": "Shuten-doji, the Oni King, staggers out of the night!", "groups": [{"kind": "shuten_doji", "count": 1, "spacing": 1.0}, {"kind": "kappa", "count": 7, "spacing": 0.8, "delay": 3.0, "road": "village"}, {"kind": "onryo", "count": 6, "spacing": 0.9, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "oni", "count": 1, "spacing": 5.0}, {"kind": "ninja", "count": 7, "spacing": 0.9, "delay": 2.0, "road": "village"}, {"kind": "samurai", "count": 6, "spacing": 1.2, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "kunoichi", "count": 2, "spacing": 3.5}, {"kind": "kappa", "count": 10, "spacing": 0.7, "delay": 2.0, "road": "village"}, {"kind": "onryo", "count": 8, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "teppo_gunner", "count": 8, "spacing": 0.9}, {"kind": "oni", "count": 1, "spacing": 5.0, "delay": 4.0, "road": "village"}, {"kind": "samurai", "count": 7, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "ninja", "count": 10, "spacing": 0.8}, {"kind": "kunoichi", "count": 2, "spacing": 3.5, "delay": 4.0}, {"kind": "kappa", "count": 8, "spacing": 0.7, "delay": 2.0, "road": "village"}]},
		{"banner": "The night host gathers at the shrine", "groups": [{"kind": "oni", "count": 2, "spacing": 4.0}, {"kind": "samurai", "count": 8, "spacing": 0.9, "delay": 2.0, "road": "village"}, {"kind": "onryo", "count": 10, "spacing": 0.6, "delay": 4.0}, {"kind": "kappa", "count": 7, "spacing": 0.8, "delay": 6.0}]},
		{"banner": "Kage, Mistress of the Hidden Hand! Only the light shows her true", "groups": [{"kind": "kage", "count": 1, "spacing": 1.0}, {"kind": "ninja", "count": 7, "spacing": 1.0, "delay": 4.0, "road": "village"}, {"kind": "samurai", "count": 6, "spacing": 1.2, "delay": 6.0}]},
	],
}
