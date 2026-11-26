## The Last Day (Act XIV map 3, the Age of Titans' finale; Necropathy's
## "last_day" stage, GDD §7.3): a scorched plain under a white sky, lava
## fields and an ash forest, the meteor already burning overhead. Two paths
## come in from the west and the east along the bottom of the plain, climb
## either side of the impact rim and meet below the necromancer's gate at the
## top. The ash trail crosses the whole plain west to east (off-road, an exit):
## the last herds run for their lives over it. FIRE FROM THE SKY: meteorites
## fall on telegraphed circles, on your towers half the time and on the road
## ahead of the foes otherwise, striking both armies. Act rule: the Stampedes
## (rules/primeval/stampedes.gd). 16 plots, 5 posts, 24 waves; Thunderwing,
## the Sky King (miniboss) on wave 12, Old Gravejaw on wave 24. Beating him
## unlocks the Bonehorn. Keys as graveyard_map.gd plus "herd_trails",
## "meteors" (the act rule). Data only.
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
		["obstacles/primeval_rock_m", Vector2(740, 690)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 620), Vector2(300, 620), Vector2(360, 560), Vector2(360, 300), Vector2(420, 240),
				Vector2(580, 240), Vector2(640, 180), Vector2(640, 130)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"east": {
			"points": [Vector2(1320, 620), Vector2(980, 620), Vector2(920, 560), Vector2(920, 300), Vector2(860, 240),
				Vector2(700, 240), Vector2(640, 180)],
			"next": "main", "next_at": 1014.6, "entrance": true,
		},
		"ash_trail": {
			"points": [Vector2(-60, 470), Vector2(220, 470), Vector2(480, 410), Vector2(640, 470), Vector2(800, 410), Vector2(1060, 470), Vector2(1340, 450)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
		"ash_trail_back": {
			"points": [Vector2(1340, 450), Vector2(1060, 470), Vector2(800, 410), Vector2(640, 470), Vector2(480, 410), Vector2(220, 470), Vector2(-60, 470)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
	},
	"herd_trails": {"ash_trail": "ash_trail_back"},  # The herd trail and the road a turned herd runs back along.
	"meteors": true,  # Fire from the Sky (the act rule's RULE "meteor").
	"gate": Vector2(640, 108),
	"plots": [
		Vector2(220, 540), Vector2(270, 330), Vector2(480, 340), Vector2(480, 540), Vector2(580, 330), Vector2(700, 330),
		Vector2(800, 340), Vector2(800, 540), Vector2(1060, 540), Vector2(1010, 330), Vector2(500, 150), Vector2(780, 150),
		Vector2(1100, 700), Vector2(180, 700), Vector2(360, 700), Vector2(1160, 520),
	],
	"posts": [Vector2(160, 620), Vector2(360, 370), Vector2(920, 370), Vector2(1120, 620), Vector2(640, 160)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 3.6,  # TUNING (not in GDD) the act's finale presses hardest
	"rule": "",
	"act_rule": "primeval/stampedes",
	"build_order": "last_day_default",
	"weak_order": "last_day_weak",
	"waves": [
		{"banner": "The Scorched Plain: the sky is falling", "groups": [{"kind": "prim_scuttler", "count": 10, "spacing": 0.5}, {"kind": "prim_scuttler", "count": 10, "spacing": 0.5, "delay": 2.0, "road": "east"}, {"kind": "prim_razorclaw", "count": 4, "spacing": 1.3, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "prim_razorclaw", "count": 6, "spacing": 1.1}, {"kind": "prim_razorclaw", "count": 6, "spacing": 1.1, "delay": 2.0, "road": "east"}]},
		{"banner": "Fire from the Sky: a meteor strikes both armies inside its circle", "groups": [{"kind": "prim_frill_spitter", "count": 6, "spacing": 1.2, "road": "east"}, {"kind": "prim_razorclaw", "count": 8, "spacing": 1.0, "delay": 2.0}]},
		{"banner": "The last herds run over the ash trail", "groups": [{"kind": "prim_duckbill", "count": 5, "spacing": 1.0, "delay": 5.0, "road": "ash_trail"}, {"kind": "prim_scuttler", "count": 16, "spacing": 0.4}, {"kind": "prim_frill_spitter", "count": 4, "spacing": 1.3, "delay": 3.0, "road": "east"}]},
		{"banner": "Stormwings: a wing gust stops your towers, then she lands; hit her then", "groups": [{"kind": "prim_stormwing", "count": 1, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 10, "spacing": 0.9, "delay": 2.0, "road": "east"}]},
		{"banner": "", "groups": [{"kind": "prim_skyraider", "count": 10, "spacing": 0.7, "road": "east"}, {"kind": "prim_horncharger", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "prim_scuttler", "count": 12, "spacing": 0.4, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "prim_clubtail", "count": 2, "spacing": 4.0}, {"kind": "prim_frill_spitter", "count": 8, "spacing": 1.0, "delay": 2.0, "road": "east"}, {"kind": "prim_longneck", "count": 2, "spacing": 3.0, "delay": 5.0, "road": "ash_trail"}]},
		{"banner": "The Ash Forest", "groups": [{"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0, "road": "east"}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8, "delay": 1.0, "road": "east"}, {"kind": "prim_stormwing", "count": 1, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0}, {"kind": "prim_scuttler", "count": 18, "spacing": 0.35, "delay": 2.0, "road": "east"}, {"kind": "prim_duckbill", "count": 5, "spacing": 1.0, "delay": 6.0, "road": "ash_trail"}]},
		{"banner": "", "groups": [{"kind": "prim_horncharger", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "prim_skyraider", "count": 10, "spacing": 0.7, "delay": 2.0}, {"kind": "prim_frill_spitter", "count": 8, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "prim_clubtail", "count": 2, "spacing": 4.0, "road": "east"}, {"kind": "prim_stormwing", "count": 2, "spacing": 6.0, "delay": 2.0}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8, "delay": 3.0}]},
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
