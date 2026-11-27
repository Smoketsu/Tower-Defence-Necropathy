## The Palace of Silk and Ash (Act IX map 2; Necropathy stage "silk_palace"):
## the court of desire: the rose garden, the hall of mirrors, the ballroom over
## the lava lake and the queen's chamber. Two entrances on the west (the rose
## garden road above, the mirror gallery below) are mirrored silk ribbons,
## flowing in the same curves on either side of the hall's axis; they meet in
## the ballroom and the joined ribbon sweeps up to the queen's chamber in the
## north-east, so the plots between the ribbons cover both. 17 plots, 6 posts,
## 24 waves. The Portals: waves 5 (on post 1), 10 (on post 2) and 15 (the
## ballroom's far side, no post); Hell Pits from wave 7; succubi kiss the posts
## (Temptation: a Mender heal or a Warder barrier breaks it). The Twin Succubi
## (Naamah the miniboss, chest; Agrat her sister) on wave 13, Lilith, Queen of
## the Night, on wave 24: beating her unlocks the Bound Succubus tower,
## Temptation and the Succubus Queen. Keys as graveyard_map.gd plus the Portals
## keys (the act data's RULE). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and the Inferno's RULE).
const MAP: Dictionary = {
	"id": "silk_palace",
	"name": "The Palace of Silk and Ash",
	"floor": "tiles/silk_palace_roses",
	"decals": [],
	"obstacles": [
		["obstacles/black_rosebush_l", Vector2(119, 161)], ["obstacles/rose_column_l", Vector2(603, 75)],
		["obstacles/black_rosebush_s", Vector2(120, 330)], ["obstacles/mirror_wall_l", Vector2(140, 440)],
		["obstacles/palace_mirror_l", Vector2(737, 231)], ["obstacles/velvet_divan_l", Vector2(1057, 480)],
		["obstacles/rose_column_s", Vector2(820, 680)], ["obstacles/mirror_wall_s", Vector2(260, 690)],
		["obstacles/palace_mirror_s", Vector2(1250, 660)], ["obstacles/black_rosebush_l", Vector2(1250, 80)],
		["obstacles/velvet_divan_s", Vector2(330, 360)], ["obstacles/candelabra_l", Vector2(1098, 399)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 120), Vector2(-21, 117), Vector2(4, 111), Vector2(35, 104), Vector2(68, 98),
				Vector2(101, 94), Vector2(133, 94), Vector2(160, 100), Vector2(183, 113), Vector2(204, 133),
				Vector2(223, 157), Vector2(242, 183), Vector2(260, 209), Vector2(279, 232), Vector2(300, 250),
				Vector2(326, 267), Vector2(353, 283), Vector2(381, 297), Vector2(409, 307), Vector2(435, 311),
				Vector2(460, 310), Vector2(482, 300), Vector2(503, 282), Vector2(522, 259), Vector2(541, 234),
				Vector2(560, 210), Vector2(580, 190), Vector2(604, 167), Vector2(627, 143), Vector2(651, 122),
				Vector2(675, 106), Vector2(700, 100), Vector2(725, 104), Vector2(753, 116), Vector2(782, 132),
				Vector2(809, 151), Vector2(829, 171), Vector2(840, 190), Vector2(836, 213), Vector2(817, 239),
				Vector2(792, 266), Vector2(771, 290), Vector2(760, 310), Vector2(766, 333), Vector2(787, 347),
				Vector2(820, 360), Vector2(841, 368), Vector2(867, 376), Vector2(896, 384), Vector2(925, 390),
				Vector2(954, 392), Vector2(980, 390), Vector2(1004, 382), Vector2(1027, 369), Vector2(1050, 353),
				Vector2(1071, 335), Vector2(1092, 317), Vector2(1110, 300), Vector2(1135, 273), Vector2(1158, 244),
				Vector2(1177, 218), Vector2(1190, 200)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"mirrors": {
			"points": [Vector2(-40, 600), Vector2(-21, 603), Vector2(4, 609), Vector2(35, 616), Vector2(68, 622),
				Vector2(101, 626), Vector2(133, 626), Vector2(160, 620), Vector2(183, 607), Vector2(204, 587),
				Vector2(223, 563), Vector2(242, 537), Vector2(260, 511), Vector2(279, 488), Vector2(300, 470),
				Vector2(326, 453), Vector2(353, 437), Vector2(381, 423), Vector2(409, 413), Vector2(435, 409),
				Vector2(460, 410), Vector2(482, 420), Vector2(503, 438), Vector2(522, 461), Vector2(541, 486),
				Vector2(560, 510), Vector2(580, 530), Vector2(604, 553), Vector2(627, 577), Vector2(651, 598),
				Vector2(675, 614), Vector2(700, 620), Vector2(725, 616), Vector2(753, 604), Vector2(782, 588),
				Vector2(809, 569), Vector2(829, 549), Vector2(840, 530), Vector2(836, 507), Vector2(817, 481),
				Vector2(792, 454), Vector2(770, 430), Vector2(760, 410), Vector2(772, 387), Vector2(801, 372),
				Vector2(822, 362)],
			"next": "main", "next_at": 1316.4,  # joins main at (822, 361)
			"entrance": true,
		},
	},
	"gate": Vector2(1204, 175),
	"plots": [
		Vector2(580, 400), Vector2(70, 160), Vector2(510, 360), Vector2(700, 460), Vector2(380, 530), Vector2(1150, 360),
		Vector2(690, 180), Vector2(700, 260), Vector2(930, 300), Vector2(870, 440), Vector2(690, 540), Vector2(300, 390),
		Vector2(1040, 270), Vector2(380, 190), Vector2(140, 200), Vector2(150, 540), Vector2(150, 680),
	],
	"posts": [Vector2(435, 311), Vector2(838, 186), Vector2(447, 409), Vector2(864, 375), Vector2(1028, 369), Vector2(1128, 281)],
	"portals": [
		{"at": Vector2(838, 186), "wave": 5, "squad": [["damned_soul", 3], ["hell_imp", 2]], "every": 7.0, "squads": 4},  # TUNING (not in GDD) on post 1
		{"at": Vector2(447, 409), "wave": 10, "squad": [["hell_knight", 1], ["lava_hound", 3]], "every": 8.0, "squads": 4},  # TUNING (not in GDD) on post 2
		{"at": Vector2(771, 125), "wave": 15, "squad": [["hell_knight", 2], ["hell_imp", 2]], "every": 8.0, "squads": 4},  # TUNING (not in GDD) no post
	],
	"pits": [Vector2(617, 219), Vector2(1016, 429), Vector2(383, 350)],
	"pits_from": 7,  # TUNING (not in GDD)
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 3.3,  # TUNING (not in GDD) B4: 3.4 before the balance pass; L4: 4.0 before the road redraw; rising through the act
	"rule": "",
	"act_rule": "inferno/portals",
	"build_order": "silk_palace_default",
	"weak_order": "silk_palace_weak",
	"waves": [
		{"banner": "The damned shuffle through the rose garden", "groups": [{"kind": "damned_soul", "count": 12, "spacing": 1.0}]},
		{"banner": "", "groups": [{"kind": "damned_soul", "count": 10, "spacing": 0.9, "road": "mirrors"}, {"kind": "hell_imp", "count": 6, "spacing": 1.0, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "hell_knight", "count": 4, "spacing": 2.2}, {"kind": "damned_soul", "count": 10, "spacing": 0.8, "delay": 2.0, "road": "mirrors"}]},
		{"banner": "A succubus: her kiss turns a blocker on its own post", "groups": [{"kind": "succubus", "count": 1, "spacing": 1.0}, {"kind": "damned_soul", "count": 12, "spacing": 0.8, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "lava_hound", "count": 8, "spacing": 0.8, "road": "mirrors"}, {"kind": "hell_knight", "count": 4, "spacing": 1.8, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "hell_imp", "count": 10, "spacing": 0.7}, {"kind": "succubus", "count": 1, "spacing": 1.0, "delay": 4.0, "road": "mirrors"}, {"kind": "damned_soul", "count": 10, "spacing": 0.7, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "hell_knight", "count": 6, "spacing": 1.6, "road": "mirrors"}, {"kind": "pit_cultist", "count": 2, "spacing": 3.0, "delay": 3.0}]},
		{"banner": "Lilim Witches: pits under your posts, heals at the portals", "groups": [{"kind": "lilim_witch", "count": 2, "spacing": 4.0}, {"kind": "damned_soul", "count": 14, "spacing": 0.7, "delay": 2.0, "road": "mirrors"}]},
		{"banner": "", "groups": [{"kind": "lava_hound", "count": 10, "spacing": 0.6}, {"kind": "succubus", "count": 2, "spacing": 3.0, "delay": 3.0, "road": "mirrors"}]},
		{"banner": "", "groups": [{"kind": "hell_knight", "count": 7, "spacing": 1.4}, {"kind": "hell_imp", "count": 8, "spacing": 0.7, "delay": 3.0, "road": "mirrors"}]},
		{"banner": "", "groups": [{"kind": "demon_brute", "count": 1, "spacing": 1.0, "road": "mirrors"}, {"kind": "lilim_witch", "count": 2, "spacing": 3.0, "delay": 3.0}, {"kind": "damned_soul", "count": 12, "spacing": 0.6, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "succubus", "count": 2, "spacing": 3.0}, {"kind": "hell_knight", "count": 6, "spacing": 1.3, "delay": 2.0, "road": "mirrors"}, {"kind": "pit_cultist", "count": 2, "spacing": 3.0, "delay": 4.0}]},
		{"banner": "The Twin Succubi descend: kill one and the other rages", "groups": [{"kind": "twin_naamah", "count": 1, "spacing": 1.0}, {"kind": "twin_agrat", "count": 1, "spacing": 1.0, "road": "mirrors"}, {"kind": "hell_imp", "count": 8, "spacing": 0.7, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "lava_hound", "count": 12, "spacing": 0.5, "road": "mirrors"}, {"kind": "hell_knight", "count": 6, "spacing": 1.3, "delay": 3.0}]},
		{"banner": "", "groups": [{"kind": "demon_brute", "count": 1, "spacing": 1.0}, {"kind": "succubus", "count": 2, "spacing": 3.0, "delay": 3.0, "road": "mirrors"}, {"kind": "damned_soul", "count": 14, "spacing": 0.5, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "lilim_witch", "count": 3, "spacing": 2.5, "road": "mirrors"}, {"kind": "hell_knight", "count": 8, "spacing": 1.1, "delay": 2.0}]},
		{"banner": "", "groups": [{"kind": "hell_imp", "count": 14, "spacing": 0.5}, {"kind": "pit_cultist", "count": 3, "spacing": 2.5, "delay": 3.0, "road": "mirrors"}]},
		{"banner": "", "groups": [{"kind": "demon_brute", "count": 2, "spacing": 4.0, "road": "mirrors"}, {"kind": "succubus", "count": 2, "spacing": 3.0, "delay": 3.0}, {"kind": "lava_hound", "count": 10, "spacing": 0.6, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "hell_knight", "count": 10, "spacing": 1.0}, {"kind": "lilim_witch", "count": 2, "spacing": 3.0, "delay": 3.0, "road": "mirrors"}]},
		{"banner": "", "groups": [{"kind": "succubus", "count": 3, "spacing": 2.5, "road": "mirrors"}, {"kind": "damned_soul", "count": 16, "spacing": 0.5, "delay": 2.0}, {"kind": "hell_imp", "count": 8, "spacing": 0.6, "delay": 4.0, "road": "mirrors"}]},
		{"banner": "", "groups": [{"kind": "demon_brute", "count": 2, "spacing": 3.0}, {"kind": "hell_knight", "count": 8, "spacing": 1.0, "delay": 3.0, "road": "mirrors"}]},
		{"banner": "", "groups": [{"kind": "lava_hound", "count": 12, "spacing": 0.5, "road": "mirrors"}, {"kind": "lilim_witch", "count": 3, "spacing": 2.5, "delay": 2.0}, {"kind": "succubus", "count": 2, "spacing": 3.0, "delay": 4.0}]},
		{"banner": "The court gathers in the queen's chamber", "groups": [{"kind": "demon_brute", "count": 2, "spacing": 3.0, "road": "mirrors"}, {"kind": "hell_knight", "count": 8, "spacing": 1.0, "delay": 2.0}, {"kind": "succubus", "count": 2, "spacing": 3.0, "delay": 5.0}]},
		{"banner": "Lilith, Queen of the Night! Her charm waves turn whole posts", "groups": [{"kind": "lilith", "count": 1, "spacing": 1.0}, {"kind": "hell_imp", "count": 10, "spacing": 0.6, "delay": 4.0, "road": "mirrors"}, {"kind": "hell_knight", "count": 6, "spacing": 1.2, "delay": 6.0}]},
	],
}
