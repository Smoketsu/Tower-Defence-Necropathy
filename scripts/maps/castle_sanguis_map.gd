## Castle Sanguis (the Sanguine Court, map 3 and the act's finale; Necropathy
## Stage 21, GDD §7.3): the courtyard, the banquet hall, the crypt gallery and
## the Throne of Blood. One road enters top right and spirals inward round the
## castle's halls to the gate at the throne in the middle, so the plots in the
## bands between its rings see it twice or three times; the bottom ring stays
## above the spell bar. 16 plots, 6 posts.
## Rule: three blood fountains beside the road (court/court_structures: they
## heal the Court until broken). Act rule: the Blood Moon. 25 back-to-back
## waves with every Court kind and the Chiropterans; the Chiropteran King
## (miniboss, chest) on wave 13 and Queen Carmilla and the Elder on wave 25.
## Data only, no logic. MAP keys: graveyard_map.gd.
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
		["obstacles/crypt_pillar_l", Vector2(1230, 680)], ["obstacles/feast_table_l", Vector2(570, 425)],
		["obstacles/wine_barrel_l", Vector2(390, 300)], ["obstacles/blood_urn_l", Vector2(760, 300)],
		["obstacles/candelabra_l", Vector2(1230, 250)], ["obstacles/feast_table_s", Vector2(1060, 470)],
	],
	"roads": {
		"main": {
			"points": [Vector2(1320, 92), Vector2(180, 92), Vector2(120, 152), Vector2(120, 558), Vector2(180, 618),
				Vector2(1100, 618), Vector2(1160, 558), Vector2(1160, 282), Vector2(1100, 222), Vector2(360, 222),
				Vector2(300, 282), Vector2(300, 428), Vector2(360, 488), Vector2(860, 488)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
	},
	"gate": Vector2(900, 448),
	"plots": [
		Vector2(500, 157), Vector2(630, 157), Vector2(760, 157), Vector2(890, 157), Vector2(1020, 157),
		Vector2(480, 355), Vector2(660, 355), Vector2(830, 340), Vector2(1040, 355),
		Vector2(500, 553), Vector2(680, 553), Vector2(860, 553), Vector2(1040, 553),
		Vector2(210, 300), Vector2(210, 430), Vector2(1230, 420),
	],
	"posts": [Vector2(700, 92), Vector2(120, 380), Vector2(640, 618), Vector2(1160, 450), Vector2(700, 222), Vector2(600, 488)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2: every map from Act II on starts with 300
	"wave_hp_end": 5.3,  # TUNING (not in GDD) the act's finale presses hardest
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
