## The Great Plain (Act XIV map 2, the Age of Titans; Necropathy's
## "great_plain" stage, GDD §7.3): open dust flats under a hot sky, a canyon
## of red walls in the east and the watering hole in the middle. Two paths
## come in from the west, meet in the middle and wind east to the necromancer's
## gate at the canyon's mouth. Two herd trails cross the plain (off-road,
## exits): the long trail from the east to the watering hole and south, and the canyon
## trail north to south. At the WATERING HOLE herd beasts wade in to drink; a
## beast hurt there bolts its whole herd forward instead of turning it. Rocks
## beside the road stop a charge (MAP "rocks"): a Horncharger or Ironbrow that
## runs into one is stunned. Act rule: the Stampedes (rules/primeval/stampedes.gd).
## 16 plots, 5 posts, 23 waves; Mother Clubtail (miniboss) on wave 12, Old
## Ironbrow on wave 23. Keys as graveyard_map.gd plus "herd_trails", "hole",
## "rocks" (the act rule and its charge kit). Data only.
extends RefCounted

## The map (keys: graveyard_map.gd and stampedes.gd).
const MAP: Dictionary = {
	"id": "great_plain",
	"name": "The Great Plain",
	"floor": "tiles/great_plain_dust_flats",
	"decals": [],
	"obstacles": [
		["obstacles/primeval_rock_m", Vector2(400, 450)], ["obstacles/primeval_rock_m", Vector2(800, 470)],
		["obstacles/primeval_rock_m", Vector2(1160, 380)], ["obstacles/primeval_canyon_wall_m_v", Vector2(1250, 330)],
		["obstacles/primeval_canyon_wall_m", Vector2(1010, 120)], ["obstacles/primeval_canyon_wall_m_v", Vector2(1250, 560)],
		["obstacles/primeval_fossil_m", Vector2(120, 380)], ["obstacles/primeval_rock_m", Vector2(60, 690)],
		["obstacles/primeval_fossil_m_v", Vector2(660, 690)], ["obstacles/primeval_rock_m", Vector2(900, 662)],
	],
	"roads": {
		"main": {
			"points": [Vector2(-40, 600), Vector2(300, 600), Vector2(360, 540), Vector2(360, 380), Vector2(420, 320),
				Vector2(700, 320), Vector2(760, 380), Vector2(760, 560), Vector2(820, 620), Vector2(1060, 620),
				Vector2(1120, 560), Vector2(1120, 220), Vector2(1170, 170), Vector2(1190, 170)],
			"next": "", "next_at": 0.0, "entrance": true,
		},
		"north": {
			"points": [Vector2(-40, 170), Vector2(500, 170), Vector2(560, 230), Vector2(560, 320)],
			"next": "main", "next_at": 809.7, "entrance": true,
		},
		"long_trail": {
			"points": [Vector2(1320, 450), Vector2(980, 450), Vector2(820, 420), Vector2(560, 450), Vector2(560, 560), Vector2(600, 780)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
		"long_trail_back": {
			"points": [Vector2(600, 780), Vector2(560, 560), Vector2(560, 450), Vector2(820, 420), Vector2(980, 450), Vector2(1320, 450)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
		"canyon_trail": {
			"points": [Vector2(940, -40), Vector2(940, 200), Vector2(980, 330), Vector2(940, 560), Vector2(960, 780)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
		"canyon_trail_back": {
			"points": [Vector2(960, 780), Vector2(940, 560), Vector2(980, 330), Vector2(940, 200), Vector2(940, -40)],
			"next": "", "next_at": 0.0, "entrance": false, "off_road": true, "exit": true,
		},
	},
	"herd_trails": {"long_trail": "long_trail_back", "canyon_trail": "canyon_trail_back"},  # Herd trails and the roads a turned herd runs back along.
	"hole": [Vector2(560, 450), 56.0],  # TUNING (not in GDD) the watering hole: centre px, radius px
	"rocks": [Vector2(400, 450), Vector2(800, 470), Vector2(1160, 380), Vector2(900, 662)],  # The rocks beside the road a charge breaks on (the obstacles of the same place).
	"gate": Vector2(1218, 140),
	"plots": [
		Vector2(180, 520), Vector2(260, 260), Vector2(430, 250), Vector2(460, 540), Vector2(640, 250), Vector2(660, 540),
		Vector2(240, 680), Vector2(860, 250), Vector2(860, 540), Vector2(1030, 300), Vector2(1030, 520), Vector2(1200, 260),
		Vector2(1050, 690), Vector2(470, 390), Vector2(660, 400), Vector2(260, 100),
	],
	"posts": [Vector2(160, 600), Vector2(200, 170), Vector2(360, 460), Vector2(760, 470), Vector2(1120, 420)],
	"lives": 0,
	"souls": 300,  # TUNING (not in GDD) X2
	"wave_hp_end": 2.5,  # TUNING (not in GDD) its roster (charges, sweeps, herds) carries the difficulty; 2.6 still wins (cliff check)
	"rule": "",
	"act_rule": "primeval/stampedes",
	"build_order": "great_plain_default",
	"weak_order": "great_plain_weak",
	"waves": [
		{"banner": "The Dust Flats: the plain is alive", "groups": [{"kind": "prim_scuttler", "count": 12, "spacing": 0.5}, {"kind": "prim_razorclaw", "count": 4, "spacing": 1.3, "delay": 2.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "prim_razorclaw", "count": 6, "spacing": 1.0}, {"kind": "prim_frill_spitter", "count": 3, "spacing": 1.4, "delay": 3.0, "road": "north"}]},
		{"banner": "A herd on the long trail: hurt it before it reaches your plots and it turns back", "groups": [{"kind": "prim_duckbill", "count": 3, "spacing": 1.2, "delay": 5.0, "road": "long_trail"}, {"kind": "prim_scuttler", "count": 12, "spacing": 0.45}, {"kind": "prim_razorclaw", "count": 4, "spacing": 1.2, "delay": 3.0, "road": "north"}]},
		{"banner": "The watering hole: a beast hurt while it drinks sends its herd bolting on", "groups": [{"kind": "prim_frill_spitter", "count": 6, "spacing": 1.2}, {"kind": "prim_razorclaw", "count": 6, "spacing": 1.0, "delay": 2.0, "road": "north"}]},
		{"banner": "Hornchargers break through your posts, but a rock stops them cold", "groups": [{"kind": "prim_horncharger", "count": 2, "spacing": 5.0}, {"kind": "prim_scuttler", "count": 14, "spacing": 0.45, "delay": 2.0, "road": "north"}]},
		{"banner": "", "groups": [{"kind": "prim_skyraider", "count": 8, "spacing": 0.8}, {"kind": "prim_razorclaw", "count": 8, "spacing": 0.9, "delay": 2.0}, {"kind": "prim_duckbill", "count": 4, "spacing": 1.1, "delay": 5.0, "road": "canyon_trail"}]},
		{"banner": "Clubtails: armour plates and a tail that sweeps your posts", "groups": [{"kind": "prim_clubtail", "count": 2, "spacing": 5.0, "road": "north"}, {"kind": "prim_frill_spitter", "count": 6, "spacing": 1.1, "delay": 2.0}, {"kind": "prim_scuttler", "count": 12, "spacing": 0.4, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 10, "spacing": 0.8, "delay": 1.0}, {"kind": "prim_longneck", "count": 2, "spacing": 3.0, "delay": 5.0, "road": "long_trail"}]},
		{"banner": "", "groups": [{"kind": "prim_horncharger", "count": 2, "spacing": 4.0, "road": "north"}, {"kind": "prim_skyraider", "count": 8, "spacing": 0.8, "delay": 2.0}, {"kind": "prim_frill_spitter", "count": 6, "spacing": 1.1, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "prim_clubtail", "count": 2, "spacing": 4.0}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8, "delay": 2.0, "road": "north"}, {"kind": "prim_duckbill", "count": 5, "spacing": 1.0, "delay": 6.0, "road": "canyon_trail"}]},
		{"banner": "The Canyon", "groups": [{"kind": "prim_scuttler", "count": 20, "spacing": 0.35}, {"kind": "prim_horncharger", "count": 2, "spacing": 4.0, "delay": 3.0}, {"kind": "prim_frill_spitter", "count": 6, "spacing": 1.1, "delay": 5.0, "road": "north"}]},
		{"banner": "MOTHER CLUBTAIL! Her sweep stuns the towers round her", "groups": [{"kind": "prim_mother_clubtail", "count": 1, "spacing": 1.0}, {"kind": "prim_razorclaw", "count": 10, "spacing": 0.9, "delay": 3.0, "road": "north"}, {"kind": "prim_scuttler", "count": 12, "spacing": 0.45, "delay": 7.0}]},
		{"banner": "", "groups": [{"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0, "road": "north"}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8}, {"kind": "prim_longneck", "count": 2, "spacing": 3.0, "delay": 5.0, "road": "long_trail"}, {"kind": "prim_skyraider", "count": 6, "spacing": 0.9, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "prim_clubtail", "count": 2, "spacing": 4.0, "road": "north"}, {"kind": "prim_horncharger", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "prim_frill_spitter", "count": 8, "spacing": 1.0, "delay": 4.0}]},
		{"banner": "A Tyrant crosses the plain", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0}, {"kind": "prim_scuttler", "count": 18, "spacing": 0.35, "delay": 2.0, "road": "north"}, {"kind": "prim_duckbill", "count": 5, "spacing": 1.0, "delay": 6.0, "road": "canyon_trail"}]},
		{"banner": "", "groups": [{"kind": "prim_horncharger", "count": 3, "spacing": 3.5, "road": "north"}, {"kind": "prim_razorclaw", "count": 12, "spacing": 0.8, "delay": 2.0}, {"kind": "prim_skyraider", "count": 8, "spacing": 0.8, "delay": 5.0}]},
		{"banner": "", "groups": [{"kind": "prim_clubtail", "count": 3, "spacing": 3.5}, {"kind": "prim_razorclaw_alpha", "count": 1, "spacing": 1.0, "delay": 2.0, "road": "north"}, {"kind": "prim_frill_spitter", "count": 10, "spacing": 0.9, "delay": 3.0}, {"kind": "prim_longneck", "count": 3, "spacing": 2.5, "delay": 6.0, "road": "long_trail"}]},
		{"banner": "The Watering Hole", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0, "road": "north"}, {"kind": "prim_horncharger", "count": 2, "spacing": 4.0, "delay": 3.0}, {"kind": "prim_scuttler", "count": 20, "spacing": 0.35, "delay": 4.0}]},
		{"banner": "", "groups": [{"kind": "prim_razorclaw", "count": 14, "spacing": 0.7, "road": "north"}, {"kind": "prim_clubtail", "count": 2, "spacing": 4.0, "delay": 2.0}, {"kind": "prim_skyraider", "count": 10, "spacing": 0.7, "delay": 5.0}, {"kind": "prim_duckbill", "count": 6, "spacing": 0.9, "delay": 6.0, "road": "canyon_trail"}]},
		{"banner": "", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0}, {"kind": "prim_horncharger", "count": 3, "spacing": 3.5, "delay": 2.0, "road": "north"}, {"kind": "prim_frill_spitter", "count": 10, "spacing": 0.9, "delay": 4.0}]},
		{"banner": "The Bone Gate", "groups": [{"kind": "prim_clubtail", "count": 3, "spacing": 3.5, "road": "north"}, {"kind": "prim_razorclaw_alpha", "count": 2, "spacing": 3.0, "delay": 2.0}, {"kind": "prim_razorclaw", "count": 14, "spacing": 0.7, "delay": 3.0}, {"kind": "prim_longneck", "count": 3, "spacing": 2.5, "delay": 6.0, "road": "long_trail"}]},
		{"banner": "Every herd of the plain is running", "groups": [{"kind": "prim_tyrant", "count": 1, "spacing": 1.0, "road": "north"}, {"kind": "prim_horncharger", "count": 3, "spacing": 3.0, "delay": 2.0}, {"kind": "prim_skyraider", "count": 10, "spacing": 0.7, "delay": 4.0}, {"kind": "prim_duckbill", "count": 6, "spacing": 0.9, "delay": 6.0, "road": "canyon_trail"}]},
		{"banner": "OLD IRONBROW, THE HORNED TITAN, leads the herd!", "groups": [{"kind": "prim_ironbrow", "count": 1, "spacing": 1.0}, {"kind": "prim_horncharger", "count": 2, "spacing": 5.0, "delay": 8.0, "road": "north"}, {"kind": "prim_razorclaw", "count": 10, "spacing": 1.0, "delay": 12.0}]},
	],
}
