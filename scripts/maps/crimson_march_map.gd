## The Crimson March (GDD §7.2): two roads that wind down the field and merge
## into one trunk before the gate, plus two short side lanes near the gate by
## which Marshal Vael's reinforcements enter. 16 grave plots, 5 road posts on
## Necropathy's March camp floor. Rule: Holy Ward Generators beside the roads
## shield enemies until destroyed (holy_ward_generators). 25 back-to-back
## waves: Shieldbearers, Banner Bearers, Halberdiers and Sisters join the
## column; the Templar Commander (miniboss, chest) on wave 12, Marshal Vael on
## wave 25. Roads run mostly left to right (GDD §13 sprite facing).
## Data only, no logic. MAP keys are documented in graveyard_map.gd.
extends RefCounted

## The map (keys: graveyard_map.gd).
const MAP: Dictionary = {
	"id": "crimson_march",
	"name": "The Crimson March",
	"unlock_after": "graveyard",
	"floor": "tiles/march_camp",
	"decals": ["decals/march_camp_campfire", "decals/march_camp_crate", "decals/march_camp_rope",
		"decals/march_camp_rope_2", "decals/march_checkpoint_stakes", "decals/march_checkpoint_pennant",
		"decals/march_arrow", "decals/march_arrow_2"],
	"obstacles": [
		["obstacles/tent_m", Vector2(80, 175)], ["obstacles/tent_m", Vector2(70, 560)],
		["obstacles/siege_engine_m", Vector2(1190, 140)], ["obstacles/cart_wreck_m", Vector2(1190, 620)],
		["obstacles/crates_s", Vector2(1180, 40)], ["obstacles/crates_s", Vector2(1180, 712)],
		["obstacles/barricade_m", Vector2(200, 700)], ["obstacles/stakes_l", Vector2(940, 700)],
	],
	"roads": {
		"north": {
			"points": [Vector2(-40, 100), Vector2(900, 100), Vector2(950, 150), Vector2(950, 175),
				Vector2(900, 225), Vector2(300, 225), Vector2(250, 275), Vector2(250, 310), Vector2(300, 360)],
			"next": "trunk", "next_at": 0.0, "entrance": true,
		},
		"south": {
			"points": [Vector2(-40, 620), Vector2(900, 620), Vector2(950, 570), Vector2(950, 545),
				Vector2(900, 495), Vector2(300, 495), Vector2(250, 445), Vector2(250, 410), Vector2(300, 360)],
			"next": "trunk", "next_at": 0.0, "entrance": true,
		},
		"trunk": {
			"points": [Vector2(300, 360), Vector2(1190, 360)],
			"next": "", "next_at": 0.0, "entrance": false,
		},
		# Side lanes for Vael's reinforcements (no arch: only his squads use them).
		"lane_n": {
			"points": [Vector2(1060, -40), Vector2(1060, 330), Vector2(1090, 360)],
			"next": "trunk", "next_at": 790.0, "entrance": false,
		},
		"lane_s": {
			"points": [Vector2(1060, 760), Vector2(1060, 390), Vector2(1090, 360)],
			"next": "trunk", "next_at": 790.0, "entrance": false,
		},
	},
	"gate": Vector2(1218, 330),
	"plots": [
		Vector2(360, 162), Vector2(600, 162), Vector2(840, 162),
		Vector2(150, 292), Vector2(450, 292), Vector2(700, 292), Vector2(990, 292),
		Vector2(150, 428), Vector2(450, 428), Vector2(700, 428), Vector2(990, 428),
		Vector2(360, 558), Vector2(600, 558), Vector2(840, 558),
		Vector2(1160, 260), Vector2(1160, 460),
	],
	"posts": [Vector2(520, 360), Vector2(880, 360), Vector2(600, 225), Vector2(600, 495), Vector2(1130, 360)],
	"lives": 0,
	"souls": 250,
	"wave_hp_end": 2.4,  # TUNING (not in GDD) integration balance
	"rule": "holy_ward_generators",
	"build_order": "march_default",
	"weak_order": "march_weak",
	"waves": [
		{"banner": "The Crimson March begins", "groups": [{"kind": "recruit", "count": 8, "spacing": 1.7, "road": "north"}, {"kind": "recruit", "count": 6, "spacing": 1.7, "delay": 6.8, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "recruit", "count": 10, "spacing": 1.4, "road": "north"}, {"kind": "archer", "count": 6, "spacing": 1.4, "delay": 5.1, "road": "south"}]},
		{"banner": "Shieldbearers: strike them from behind", "groups": [{"kind": "shieldbearer", "count": 4, "spacing": 2.0, "road": "north"}, {"kind": "recruit", "count": 6, "spacing": 1.2, "delay": 3.4, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 4, "spacing": 1.7, "road": "south"}, {"kind": "shieldbearer", "count": 4, "spacing": 1.7, "delay": 3.4, "road": "north"}, {"kind": "recruit", "count": 6, "spacing": 1.2, "delay": 11.9, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "purifier", "count": 7, "spacing": 0.8, "road": "north"}, {"kind": "purifier", "count": 7, "spacing": 0.8, "delay": 5.1, "road": "south"}]},
		{"banner": "Banner Bearers hasten the column", "groups": [{"kind": "shieldbearer", "count": 6, "spacing": 1.2, "road": "north"}, {"kind": "banner_bearer", "count": 1, "spacing": 1.2, "delay": 8.5, "road": "north"}, {"kind": "footman", "count": 8, "spacing": 1.2, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 8, "spacing": 1.2, "road": "south"}, {"kind": "chaplain", "count": 2, "spacing": 5.1, "delay": 6.8, "road": "south"}, {"kind": "archer", "count": 10, "spacing": 0.8, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 2, "spacing": 6.8, "road": "north"}, {"kind": "shieldbearer", "count": 8, "spacing": 1.2, "road": "south"}, {"kind": "banner_bearer", "count": 1, "spacing": 1.2, "delay": 13.6, "road": "south"}]},
		{"banner": "Halberdiers cleave the blockers", "groups": [{"kind": "halberdier", "count": 2, "spacing": 6.8, "road": "north"}, {"kind": "footman", "count": 10, "spacing": 1.2, "delay": 1.7, "road": "north"}, {"kind": "recruit", "count": 12, "spacing": 0.8, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "purifier", "count": 14, "spacing": 0.8, "road": "south"}, {"kind": "halberdier", "count": 2, "spacing": 5.1, "delay": 6.8, "road": "south"}, {"kind": "shieldbearer", "count": 8, "spacing": 1.2, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 12, "spacing": 1.2, "road": "north"}, {"kind": "chaplain", "count": 3, "spacing": 5.1, "delay": 5.1, "road": "north"}, {"kind": "templar", "count": 2, "spacing": 5.1, "road": "south"}, {"kind": "recruit", "count": 10, "spacing": 1.2, "delay": 5.1, "road": "south"}]},
		{"banner": "The Templar Commander rides at the head", "groups": [{"kind": "templar_commander", "count": 1, "spacing": 1.2, "road": "north"}, {"kind": "footman", "count": 10, "spacing": 1.2, "delay": 5.1, "road": "north"}, {"kind": "shieldbearer", "count": 10, "spacing": 1.2, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "shieldbearer", "count": 12, "spacing": 1.4, "road": "north"}, {"kind": "banner_bearer", "count": 2, "spacing": 5.1, "delay": 10.2, "road": "north"}, {"kind": "purifier", "count": 15, "spacing": 0.8, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "halberdier", "count": 5, "spacing": 4.2, "road": "south"}, {"kind": "chaplain", "count": 2, "spacing": 5.1, "delay": 6.8, "road": "south"}, {"kind": "footman", "count": 15, "spacing": 1.2, "road": "north"}]},
		{"banner": "Sisters of the Scourge lash two at once", "groups": [{"kind": "battle_sister", "count": 5, "spacing": 3.4, "road": "north"}, {"kind": "recruit", "count": 20, "spacing": 0.7, "road": "south"}, {"kind": "templar", "count": 2, "spacing": 5.1, "delay": 8.5, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "shieldbearer", "count": 15, "spacing": 1.2, "road": "north"}, {"kind": "banner_bearer", "count": 2, "spacing": 5.1, "delay": 10.2, "road": "north"}, {"kind": "halberdier", "count": 4, "spacing": 4.2, "road": "south"}, {"kind": "footman", "count": 12, "spacing": 1.2, "delay": 5.1, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "purifier", "count": 22, "spacing": 0.7, "road": "north"}, {"kind": "purifier", "count": 22, "spacing": 0.7, "delay": 3.4, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 5, "spacing": 3.4, "road": "north"}, {"kind": "chaplain", "count": 4, "spacing": 4.2, "delay": 6.8, "road": "north"}, {"kind": "battle_sister", "count": 5, "spacing": 3.4, "road": "south"}, {"kind": "footman", "count": 12, "spacing": 1.2, "delay": 6.8, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "shieldbearer", "count": 17, "spacing": 1.2, "road": "south"}, {"kind": "banner_bearer", "count": 2, "spacing": 5.1, "delay": 10.2, "road": "south"}, {"kind": "halberdier", "count": 5, "spacing": 4.2, "road": "north"}, {"kind": "archer", "count": 17, "spacing": 0.7, "delay": 5.1, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "footman", "count": 20, "spacing": 1.2, "road": "north"}, {"kind": "chaplain", "count": 5, "spacing": 4.2, "delay": 5.1, "road": "north"}, {"kind": "footman", "count": 20, "spacing": 1.2, "road": "south"}, {"kind": "chaplain", "count": 5, "spacing": 4.2, "delay": 5.1, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "battle_sister", "count": 8, "spacing": 2.5, "road": "north"}, {"kind": "halberdier", "count": 5, "spacing": 4.2, "road": "south"}, {"kind": "shieldbearer", "count": 15, "spacing": 1.2, "delay": 5.1, "road": "south"}, {"kind": "banner_bearer", "count": 2, "spacing": 5.1, "delay": 13.6, "road": "south"}]},
		{"banner": "", "groups": [{"kind": "templar", "count": 8, "spacing": 2.7, "road": "north"}, {"kind": "templar", "count": 8, "spacing": 2.7, "road": "south"}, {"kind": "purifier", "count": 17, "spacing": 0.7, "delay": 8.5, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "shieldbearer", "count": 20, "spacing": 1.2, "road": "north"}, {"kind": "banner_bearer", "count": 4, "spacing": 4.2, "delay": 8.5, "road": "north"}, {"kind": "halberdier", "count": 6, "spacing": 3.4, "road": "south"}, {"kind": "chaplain", "count": 5, "spacing": 4.2, "delay": 6.8, "road": "south"}, {"kind": "battle_sister", "count": 5, "spacing": 3.4, "delay": 11.9, "road": "south"}]},
		{"banner": "The full muster of the March", "groups": [{"kind": "footman", "count": 22, "spacing": 1.2, "road": "north"}, {"kind": "templar", "count": 8, "spacing": 2.7, "road": "south"}, {"kind": "battle_sister", "count": 8, "spacing": 2.5, "delay": 6.8, "road": "north"}, {"kind": "chaplain", "count": 5, "spacing": 4.2, "delay": 6.8, "road": "south"}, {"kind": "banner_bearer", "count": 4, "spacing": 4.2, "delay": 13.6, "road": "north"}]},
		{"banner": "Marshal Vael leads the March!", "groups": [{"kind": "vael", "count": 1, "spacing": 1.2, "road": "north"}, {"kind": "shieldbearer", "count": 10, "spacing": 1.2, "delay": 5.1, "road": "north"}, {"kind": "footman", "count": 10, "spacing": 1.2, "delay": 3.4, "road": "south"}, {"kind": "banner_bearer", "count": 2, "spacing": 5.1, "delay": 10.2, "road": "south"}]},
	],
}
