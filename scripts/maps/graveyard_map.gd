## The Desecrated Graveyard (GDD §7.2): the teaching map. One road, one
## entrance: the churchyard path winds in from the west between the graves and
## rounds the central crypt in a long flat oval (three quarters of it, so the
## plots inside see both sides), then winds back west along the bottom to the
## ossuary gate; 14 grave plots and 4 road posts on Necropathy's graveyard
## floor, 22 back-to-back waves, the Inquisitor miniboss on wave 11 and Sir
## Alaric on the final wave. Units are mirrored side views (GDD §13 sprite
## facing). Data only, no logic. This file documents every MAP key for all maps.
extends RefCounted

## The map. Keys:
##   id, name        — registry id and UI name.
##   unlock_after    — map id whose boss must be beaten to open this map ("" = open
##                     from the start; GDD §3 "Beating a map's boss opens the next map").
##   floor           — SpriteData-style key of the floor tile, repeated over the map.
##   decals          — floor decal keys scattered by MapView (a pure position hash).
##   obstacles       — [sprite key, position] pairs: decoration only, nothing collides.
##   roads           — road id -> {points: Array of Vector2 (map px, start to end),
##                     next: road id it joins at its end ("" = ends at the gate),
##                     next_at: px along `next` where it joins, entrance: true when
##                     enemies may spawn at its start (an entrance arch is drawn)}.
##                     Two roads that merge = one road with next set (Crimson March).
##   gate            — map px of the Ossuary gate (drawn there; the final road ends at it).
##   plots           — map px of each grave plot (ranged / support towers).
##   posts           — map px of each road post (blockers); snapped to the nearest road.
##   lives / souls   — optional overrides of TdRulesData.START_LIVES / EconomyData.START_SOULS (0 = default).
##   wave_hp_end     — optional override of TdRulesData.WAVE_HP_END (the last waves' HP multiplier; 0 = default).
##   rule            — "" or scripts/maps/rules/<id>.gd (extends MapRule): the map's own rule.
##   build_order     — build order id (BuildOrderData / the act's ORDERS) the autotest plays by default.
##   weak_order      — build order id of a deliberately weak build (must load and end cleanly;
##                     CI and tools/run_all_maps.sh run both). MapLoader.validate() checks both.
##   act_rule        — optional act rule id (scripts/maps/rules/<id>.gd, extends MapRule), run
##                     beside "rule"; absent = the act's ActData "rule" ("" = none).
##   music / mood    — optional: run loop (SoundData.SCORES id, "" = Act I loop) and mood row id;
##                     absent = the act's ActData defaults (floor too).
##   roads keys      — also: off_road (true: a trail across the map, not a road; nothing holds
##                     on it, no post or spell uses it) and exit (true: reaching its end leaves
##                     the map with no lives lost, a crossing herd).
##   waves           — wave rows, in order. Each wave: {groups: [...], banner: "" or a
##                     line shown when it starts}. Each group: kind (TdEnemyData id),
##                     count, spacing (s between two spawns, default
##                     TdRulesData.DEFAULT_SPACING), delay (s after the wave start of
##                     the first spawn, default 0), road (default the first entrance road).
##                     The final wave must hold the map's boss (GDD §3).
const MAP: Dictionary = {
	"id": "graveyard",
	"name": "The Desecrated Graveyard",
	"unlock_after": "",
	"floor": "tiles/graveyard",
	"decals": ["decals/graveyard_grass", "decals/graveyard_grass_2", "decals/graveyard_grass_3",
		"decals/graveyard_grave", "decals/graveyard_grave_2", "decals/graveyard_fog"],
	"obstacles": [
		["obstacles/dead_tree_l", Vector2(70, 300)], ["obstacles/gravestone_l", Vector2(140, 230)],
		["obstacles/gravestone_s", Vector2(330, 60)], ["obstacles/crypt_wall_m", Vector2(420, 80)],
		["obstacles/dead_tree_m", Vector2(800, 70)], ["obstacles/gravestone_s", Vector2(1000, 90)],
		["obstacles/dead_tree_s", Vector2(1150, 160)], ["obstacles/gravestone_l", Vector2(1165, 304)],
		["obstacles/crypt_wall_s", Vector2(542, 311)], ["obstacles/gravestone_s", Vector2(737, 302)],
		["obstacles/gravestone_l", Vector2(510, 440)], ["obstacles/dead_tree_m", Vector2(940, 425)],
		["obstacles/gravestone_s", Vector2(43, 524)], ["obstacles/crypt_wall_l", Vector2(303, 670)],
		["obstacles/dead_tree_s", Vector2(760, 650)], ["obstacles/gravestone_l", Vector2(1100, 640)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 170), Vector2(-19, 164), Vector2(11, 155), Vector2(45, 146), Vector2(80, 139),
				Vector2(110, 140), Vector2(136, 151), Vector2(161, 170), Vector2(185, 191), Vector2(208, 210),
				Vector2(230, 220), Vector2(258, 215), Vector2(285, 198), Vector2(310, 183), Vector2(330, 180),
				Vector2(344, 198), Vector2(353, 230), Vector2(359, 262), Vector2(363, 285), Vector2(381, 278),
				Vector2(400, 272), Vector2(420, 267), Vector2(441, 261), Vector2(463, 257), Vector2(485, 252),
				Vector2(508, 248), Vector2(532, 245), Vector2(557, 242), Vector2(582, 240), Vector2(607, 238),
				Vector2(633, 236), Vector2(658, 235), Vector2(684, 235), Vector2(710, 235), Vector2(736, 236),
				Vector2(762, 237), Vector2(787, 239), Vector2(812, 241), Vector2(837, 244), Vector2(861, 247),
				Vector2(885, 250), Vector2(908, 255), Vector2(930, 259), Vector2(951, 264), Vector2(971, 270),
				Vector2(991, 276), Vector2(1009, 282), Vector2(1026, 288), Vector2(1043, 295), Vector2(1057, 302),
				Vector2(1071, 310), Vector2(1083, 318), Vector2(1094, 326), Vector2(1104, 334), Vector2(1112, 342),
				Vector2(1119, 351), Vector2(1124, 360), Vector2(1127, 368), Vector2(1129, 377), Vector2(1130, 386),
				Vector2(1129, 395), Vector2(1127, 404), Vector2(1123, 412), Vector2(1117, 421), Vector2(1110, 429),
				Vector2(1102, 438), Vector2(1092, 446), Vector2(1081, 454), Vector2(1068, 462), Vector2(1054, 469),
				Vector2(1039, 476), Vector2(1023, 483), Vector2(1005, 490), Vector2(987, 496), Vector2(967, 502),
				Vector2(946, 507), Vector2(925, 512), Vector2(902, 516), Vector2(879, 520), Vector2(856, 524),
				Vector2(831, 527), Vector2(807, 530), Vector2(781, 532), Vector2(756, 533), Vector2(730, 534),
				Vector2(704, 535), Vector2(678, 535), Vector2(653, 534), Vector2(627, 533), Vector2(601, 532),
				Vector2(576, 530), Vector2(551, 527), Vector2(527, 524), Vector2(503, 521), Vector2(480, 517),
				Vector2(458, 512), Vector2(436, 507), Vector2(415, 502), Vector2(396, 496), Vector2(402, 519),
				Vector2(411, 553), Vector2(421, 590), Vector2(425, 621), Vector2(420, 640), Vector2(402, 641),
				Vector2(375, 630), Vector2(342, 613), Vector2(309, 597), Vector2(280, 590), Vector2(247, 595),
				Vector2(216, 608), Vector2(186, 621), Vector2(160, 630), Vector2(118, 628), Vector2(90, 620)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
	},
	"gate": Vector2(63, 583),
	"plots": [
		Vector2(880, 460), Vector2(130, 260), Vector2(920, 320), Vector2(300, 530), Vector2(990, 380), Vector2(480, 590),
		Vector2(180, 100), Vector2(740, 470), Vector2(560, 590), Vector2(490, 180), Vector2(410, 200), Vector2(240, 670),
		Vector2(730, 180), Vector2(1180, 440),
	],
	"posts": [Vector2(516, 247), Vector2(1126, 406), Vector2(403, 499), Vector2(205, 613)],
	"lives": 0,
	"souls": 0,
	"wave_hp_end": 2.0,  # TUNING (not in GDD) L4: 2.6 before the road redraw; integration balance: the first map is the gentlest
	"rule": "",
	"build_order": "graveyard_default",
	"weak_order": "weak",
	"waves": [
		{"banner": "The Covenant marches on the crypt", "groups": [{"kind": "recruit", "count": 8, "spacing": 1.35}]},
		{"banner": "", "groups": [{"kind": "recruit", "count": 12, "spacing": 1.08}]},
		{"banner": "", "groups": [{"kind": "recruit", "count": 8, "spacing": 0.95}, {"kind": "archer", "count": 6, "spacing": 0.95, "delay": 5.4}]},
		{"banner": "Footmen: armoured", "groups": [{"kind": "footman", "count": 6, "spacing": 1.49}, {"kind": "recruit", "count": 8, "spacing": 0.95, "delay": 4.1}]},
		{"banner": "Purifiers: fast", "groups": [{"kind": "purifier", "count": 8, "spacing": 0.81}, {"kind": "recruit", "count": 10, "spacing": 0.95, "delay": 2.7}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 10, "spacing": 1.22}, {"kind": "archer", "count": 8, "spacing": 0.95, "delay": 2.7}]},
		{"banner": "Chaplains heal those around them", "groups": [{"kind": "footman", "count": 8, "spacing": 0.95}, {"kind": "chaplain", "count": 2, "spacing": 4.05, "delay": 2.7}, {"kind": "recruit", "count": 10, "spacing": 0.95, "delay": 6.8}]},
		{"banner": "Templars charge when struck", "groups": [{"kind": "templar", "count": 2, "spacing": 5.40}, {"kind": "recruit", "count": 14, "spacing": 0.95, "delay": 1.4}]},
		{"banner": "", "groups": [{"kind": "purifier", "count": 14, "spacing": 0.68}, {"kind": "archer", "count": 10, "spacing": 0.95, "delay": 4.1}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 14, "spacing": 1.08}, {"kind": "chaplain", "count": 3, "spacing": 4.05, "delay": 4.1}, {"kind": "templar", "count": 2, "spacing": 4.05, "delay": 8.1}]},
		{"banner": "The Inquisitor comes for the crypt", "groups": [{"kind": "inquisitor", "count": 1, "spacing": 0.95}, {"kind": "recruit", "count": 16, "spacing": 0.81, "delay": 2.7}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 4, "spacing": 2.70}, {"kind": "purifier", "count": 12, "spacing": 0.68, "delay": 2.7}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 18, "spacing": 0.94}, {"kind": "chaplain", "count": 4, "spacing": 3.38, "delay": 4.1}]},
		{"banner": "", "groups": [{"kind": "archer", "count": 24, "spacing": 0.54}, {"kind": "purifier", "count": 10, "spacing": 0.68, "delay": 5.4}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 6, "spacing": 2.16}, {"kind": "footman", "count": 12, "spacing": 0.95, "delay": 2.7}]},
		{"banner": "A swarm of recruits", "groups": [{"kind": "recruit", "count": 30, "spacing": 0.47}, {"kind": "chaplain", "count": 4, "spacing": 2.70, "delay": 4.1}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 6, "spacing": 2.03}, {"kind": "chaplain", "count": 4, "spacing": 2.70, "delay": 2.7}, {"kind": "footman", "count": 14, "spacing": 0.95, "delay": 5.4}]},
		{"banner": "", "groups": [{"kind": "purifier", "count": 20, "spacing": 0.54}, {"kind": "templar", "count": 4, "spacing": 2.70, "delay": 4.1}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 22, "spacing": 0.81}, {"kind": "archer", "count": 16, "spacing": 0.54, "delay": 4.1}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 10, "spacing": 1.62}, {"kind": "chaplain", "count": 6, "spacing": 2.43, "delay": 2.7}]},
		{"banner": "The Covenant's full muster", "groups": [{"kind": "footman", "count": 16, "spacing": 0.81}, {"kind": "templar", "count": 8, "spacing": 1.62, "delay": 2.7}, {"kind": "purifier", "count": 16, "spacing": 0.54, "delay": 6.8}, {"kind": "chaplain", "count": 5, "spacing": 2.70, "delay": 8.1}]},
		{"banner": "Sir Alaric, the Gravebreaker, has arrived!", "groups": [{"kind": "alaric", "count": 1, "spacing": 0.95}, {"kind": "templar", "count": 4, "spacing": 2.70, "delay": 4.1}, {"kind": "footman", "count": 10, "spacing": 1.08, "delay": 8.1}]},
	],
}
