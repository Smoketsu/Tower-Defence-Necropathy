## The Palace of Silk and Ash (Act IX map 2; Necropathy stage "silk_palace"):
## the court of desire: the rose garden, the hall of mirrors, the ballroom
## over the lava lake and the queen's chamber. Two entrances on the west (the
## rose garden road above, the mirror gallery below) merge before the
## ballroom; the joined road loops around it, up and back down to the
## queen's chamber, so the ballroom plots cover it twice. 17 plots, 6 posts,
## 24 waves. The Portals: waves 5 (on post 1), 10 (on post 2) and 15 (the
## ballroom's far side, no post); Hell Pits from wave 7; succubi kiss the
## posts (Temptation: a Mender heal or a Warder barrier breaks it). The Twin
## Succubi (Naamah the miniboss, chest; Agrat her sister) on wave 13,
## Lilith, Queen of the Night, on wave 24: beating her unlocks the Bound
## Succubus tower, Temptation and the Succubus Queen.
## Keys as graveyard_map.gd plus the Portals keys (the act data's RULE). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and the Inferno's RULE).
const MAP: Dictionary = {
	"id": "silk_palace",
	"name": "The Palace of Silk and Ash",
	"floor": "tiles/silk_palace_roses",
	"decals": [],
	"obstacles": [
		["obstacles/black_rosebush_l", Vector2(80, 80)], ["obstacles/rose_column_l", Vector2(640, 90)],
		["obstacles/black_rosebush_s", Vector2(120, 330)], ["obstacles/mirror_wall_l", Vector2(140, 440)],
		["obstacles/palace_mirror_l", Vector2(760, 250)], ["obstacles/velvet_divan_l", Vector2(1040, 470)],
		["obstacles/rose_column_s", Vector2(820, 680)], ["obstacles/mirror_wall_s", Vector2(260, 690)],
		["obstacles/palace_mirror_s", Vector2(1250, 660)], ["obstacles/black_rosebush_l", Vector2(1250, 80)],
		["obstacles/velvet_divan_s", Vector2(330, 360)], ["obstacles/candelabra_l", Vector2(1040, 360)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 140), Vector2(460, 140), Vector2(520, 200), Vector2(520, 330),
				Vector2(580, 390), Vector2(860, 390), Vector2(920, 330), Vector2(920, 180),
				Vector2(980, 120), Vector2(1130, 120), Vector2(1190, 180), Vector2(1190, 560),
				Vector2(1130, 620), Vector2(1000, 620)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"mirrors": {
			"points": [Vector2(-40, 620), Vector2(460, 620), Vector2(520, 560), Vector2(520, 450), Vector2(580, 390)],
			"next": "main", "next_at": 799.7, "entrance": true,  # joins main at (580, 390)
		},
	},
	"gate": Vector2(960, 580),
	"plots": [
		Vector2(220, 210), Vector2(380, 210), Vector2(450, 270), Vector2(600, 260), Vector2(220, 550),
		Vector2(380, 550), Vector2(450, 480), Vector2(650, 320), Vector2(760, 460), Vector2(840, 300),
		Vector2(850, 190), Vector2(1000, 190), Vector2(1060, 280), Vector2(1110, 440), Vector2(1100, 540),
		Vector2(1260, 300), Vector2(680, 560),
	],
	"posts": [Vector2(300, 140), Vector2(520, 270), Vector2(300, 620), Vector2(720, 390), Vector2(1060, 120), Vector2(1190, 450)],
	"portals": [
		{"at": Vector2(520, 270), "wave": 5, "squad": [["damned_soul", 3], ["hell_imp", 2]], "every": 7.0, "squads": 4},  # TUNING (not in GDD) on post 1
		{"at": Vector2(300, 620), "wave": 10, "squad": [["hell_knight", 1], ["lava_hound", 3]], "every": 8.0, "squads": 4},  # TUNING (not in GDD) on post 2
		{"at": Vector2(920, 250), "wave": 15, "squad": [["hell_knight", 2], ["hell_imp", 2]], "every": 8.0, "squads": 4},  # TUNING (not in GDD) no post
	],
	"pits": [Vector2(720, 390), Vector2(1190, 450), Vector2(520, 270)],
	"pits_from": 7,  # TUNING (not in GDD)
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 3.2,  # TUNING (not in GDD) rising through the act
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
