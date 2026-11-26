## The Burning Province (Act V map 1; Necropathy stage "province"): rice
## terraces and a village in flames. Two entrances: the main road winds in
## from the west through the paddies; the village lane climbs from the south
## and joins it in the middle, so the towers there cover both. 16 plots, 5
## posts, 22 waves. The Sun's Course (act rule shogunate/sun_course): day,
## dusk from wave 9 (ninja ambush mid-road), night from wave 15 (towers see
## only inside lantern light; the oni, onryo and kappa walk). Shuten-doji
## (miniboss, chest) on wave 16, Kage, Mistress of the Hidden Hand, on wave 22.
## Keys as graveyard_map.gd, plus the Sun's Course keys (documented in
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
			"points": [Vector2(-40, 180), Vector2(380, 180), Vector2(440, 240), Vector2(440, 380),
				Vector2(500, 440), Vector2(840, 440), Vector2(900, 380), Vector2(900, 300),
				Vector2(960, 240), Vector2(1190, 240)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"village": {
			"points": [Vector2(240, 770), Vector2(240, 660), Vector2(300, 600), Vector2(560, 600),
				Vector2(620, 540), Vector2(620, 440)],
			"next": "main", "next_at": 849.7, "entrance": true,  # joins main at (620, 440)
		},
	},
	"gate": Vector2(1218, 210),
	"plots": [
		Vector2(180, 110), Vector2(330, 250), Vector2(520, 250), Vector2(700, 360), Vector2(820, 330),
		Vector2(1040, 170), Vector2(1060, 320), Vector2(360, 330), Vector2(530, 360), Vector2(170, 620),
		Vector2(540, 520), Vector2(760, 520), Vector2(980, 450), Vector2(420, 680), Vector2(1140, 170),
		Vector2(220, 260),
	],
	"posts": [Vector2(260, 180), Vector2(440, 330), Vector2(780, 440), Vector2(400, 600), Vector2(1010, 240)],
	"lanterns": [Vector2(140, 240), Vector2(490, 300), Vector2(360, 650), Vector2(700, 490), Vector2(960, 320), Vector2(1120, 290)],
	"ambush": [["main", 560.0], ["village", 200.0], ["main", 1000.0]],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 2.7,  # TUNING (not in GDD) Act V map 1: a little harder than the Sanctum
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
