## Act IV, the Last Line (ActData "city"; Necropathy's Act VIII, GDD §7.3
## "Vehicles and armour; the escalation clock sets each wave's tier"): the last
## cities of the living answer the dead in rising order, gangs -> police ->
## SWAT -> army -> heroes. Acts merges KINDS (keys: TdEnemyData.KINDS, plus
## the row key below), ORDERS (keys: BuildOrderData.ORDERS) and MOODS (keys:
## TdMoodData.MOODS); the act rule (rules/city/escalation.gd) reads RULE and
## the HUD meter (rules/city/escalation_meter.gd) reads RULE "tiers". Sprites
## are Necropathy's city/ art. Data only, no logic.
##
## Extra kind row key (this act only):
##   tier — "gangs" | "police" | "swat" | "army" | "heroes" | "" (bosses and
##          structures): the escalation tier the kind belongs to (the Codex
##          grouping and the meter's colour for its banner; informational).
## Traits of this act (scripts/enemies/traits/city/, args documented there):
##   city/vehicle — armoured: light blockers cannot hold it (it crashes through
##                  and hurts the post), heavy ones can; optional telegraphed shells.
##   city/super   — one power and one weakness each.
##   city/big_sal — the Skid Row miniboss (calls the gang, enrages).
## Bosses (scripts/bosses/city/): don_marrow, harrow, paragon.
extends RefCounted

## Enemy kinds of the Last Line (keys: TdEnemyData.KINDS + "tier").
const KINDS: Dictionary = {
	# ---------------------------------------------------------------- gangs
	# Necropathy street_thug: gang fodder with a bat.
	"street_thug": {
		"name": "Street Thug", "sprite": "city/street_thug", "rank": "fodder", "souls": 5, "tier": "gangs",  # TUNING (not in GDD) X2: later acts' fodder pays 5 (income curve)
		"hp": 42.0, "speed": 54.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Necropathy gang_gunner: two pistols; on the road it shoots blocker bodies (game.hostile).
	"gang_gunner": {
		"name": "Gang Gunner", "sprite": "city/gang_gunner", "rank": "fodder", "souls": 5, "tier": "gangs",  # TUNING (not in GDD) X2: later acts' fodder pays 5 (income curve)
		"hp": 48.0, "speed": 52.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 150.0, "interval": 2.4, "target": "body", "damage": 7.0, "disable": 0.0, "cause": "shot", "speed": 420.0, "arc": false, "look": "bullet"},  # TUNING (not in GDD)
	},
	# ---------------------------------------------------------------- police
	# Necropathy riot_cop: armour_front 0.7 behind a tall shield (shield_front; boulders, mines and shells go round it).
	"riot_cop": {
		"name": "Riot Cop", "sprite": "city/riot_cop", "rank": "elite", "tier": "police",
		"hp": 200.0, "speed": 44.0, "armour": 2.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 7.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shield_front",
		"args": {"front_mult": 0.65, "ignore": ["corpse_catapult", "bone_mines", "fallen_hero"]},  # TUNING (not in GDD) GDD §7.3 armour rewards arcs and slams
	},
	# Necropathy squad_car: a light vehicle; Warriors below crush_hp are run over.
	"squad_car": {
		"name": "Squad Car", "sprite": "city/squad_car", "rank": "elite", "tier": "police",
		"hp": 240.0, "speed": 58.0, "armour": 3.0, "radius": 16.0,  # TUNING (not in GDD)
		"damage": 10.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "city/vehicle",
		"args": {"crush_hp": 240.0, "crush_damage": 45.0, "pass_time": 0.8, "shell_every": 0.0},  # TUNING (not in GDD) GDD §7.3 light blockers cannot hold vehicles
	},
	# ---------------------------------------------------------------- SWAT
	# Necropathy swat_breacher: a flashbang over the blockers that blinds a tower.
	"swat_breacher": {
		"name": "SWAT Breacher", "sprite": "city/swat_breacher", "rank": "elite", "tier": "swat",
		"hp": 260.0, "speed": 44.0, "armour": 3.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 9.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 150.0, "interval": 13.0, "target": "tower", "damage": 0.0, "disable": 1.6, "cause": "blinded", "speed": 260.0, "arc": true, "look": "flashbang"},  # TUNING (not in GDD) Necropathy flashbang every 12 s
	},
	# Necropathy field_medic: heals the squad (healer; silenced by the Banshee).
	"field_medic": {
		"name": "Field Medic", "sprite": "city/field_medic", "rank": "elite", "tier": "swat",
		"hp": 160.0, "speed": 44.0, "armour": 1.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 3.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "healer",
		"args": {"heal": 16.0, "interval": 2.4, "radius": 110.0},  # Necropathy 14 HP every 2.4 s within 130 px; TUNING (not in GDD)
	},
	# ---------------------------------------------------------------- army
	# Liberty Heights' Conscript: army fodder with a bayonet.
	"city_conscript": {
		"name": "Conscript", "sprite": "city/conscript", "rank": "fodder", "souls": 5, "tier": "army",  # TUNING (not in GDD) X2: later acts' fodder pays 5 (income curve)
		"hp": 55.0, "speed": 54.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD) Necropathy 22 HP: cheap army fodder
		"damage": 7.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# Necropathy rifleman: bursts at blocker bodies from range.
	"city_rifleman": {
		"name": "Rifleman", "sprite": "city/rifleman", "rank": "elite", "tier": "army",
		"hp": 220.0, "speed": 46.0, "armour": 2.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 170.0, "interval": 2.0, "target": "body", "damage": 12.0, "disable": 0.0, "cause": "shot", "speed": 480.0, "arc": false, "look": "bullet"},  # TUNING (not in GDD)
	},
	# Fort Kessler's Machine Gunner: a belt-fed gun that pins a tower down.
	"city_machine_gunner": {
		"name": "Machine Gunner", "sprite": "city/machine_gunner", "rank": "elite", "tier": "army",
		"hp": 340.0, "speed": 38.0, "armour": 3.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 8.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 160.0, "interval": 1.0, "target": "body", "damage": 7.0, "disable": 0.0, "cause": "shot", "speed": 520.0, "arc": false, "look": "bullet"},  # TUNING (not in GDD)
	},
	# Necropathy tank: armour 7, only heavy blockers hold it, and it shells towers.
	"city_tank": {
		"name": "Tank", "sprite": "city/tank", "rank": "elite", "tier": "army",
		"hp": 1000.0, "speed": 30.0, "armour": 6.0, "radius": 20.0,  # TUNING (not in GDD) Necropathy flat_armor 4 + armour_front
		"damage": 18.0, "attack_interval": 1.5,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "city/vehicle",
		"args": {"crush_hp": 520.0, "crush_damage": 80.0, "pass_time": 1.0,  # TUNING (not in GDD)
			"shell_every": 11.0, "shell_range": 230.0, "shell_radius": 46.0, "shell_delay": 1.3, "shell_disable": 1.6, "shell_damage": 30.0},  # Necropathy shell every 8 s landing 1.3 s later; TUNING (not in GDD)
	},
	# Fort Kessler's Attack Helicopter: a flyer that strafes towers.
	"attack_helicopter": {
		"name": "Attack Helicopter", "sprite": "city/attack_helicopter", "rank": "elite", "tier": "army",
		"hp": 320.0, "speed": 50.0, "armour": 2.0, "radius": 16.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": true, "ignores_walls": true, "trait": "shooter",
		"args": {"range": 180.0, "interval": 6.0, "target": "tower", "damage": 0.0, "disable": 1.2, "cause": "shot", "speed": 520.0, "arc": false, "look": "bullet"},  # TUNING (not in GDD)
	},
	# ---------------------------------------------------------------- heroes (Supers: one power, one weakness)
	# Blitz, the speedster: dashes past the posts; weakness: a blocker that catches him exposes him.
	"blitz": {
		"name": "Blitz", "sprite": "city/blitz", "rank": "elite", "tier": "heroes",
		"hp": 700.0, "speed": 60.0, "armour": 2.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 14.0, "attack_interval": 0.7,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "city/super",
		"args": {"power": "dash", "every": 6.0, "dash_mult": 2.6, "dash_time": 1.0,  # TUNING (not in GDD) Necropathy's sprint
			"weakness": "held", "weak_mult": 2.0},  # Necropathy: blockers expose Blitz
	},
	# Aurora, the flier: wards the heroes around her; weakness: cold (slowed or frozen she takes double).
	"aurora": {
		"name": "Aurora", "sprite": "city/aurora", "rank": "elite", "tier": "heroes",
		"hp": 650.0, "speed": 46.0, "armour": 1.0, "radius": 12.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": true, "ignores_walls": true, "trait": "city/super",
		"args": {"power": "ward", "every": 0.3, "radius": 110.0, "ward_mult": 0.7,  # TUNING (not in GDD) her light shield
			"weakness": "cold", "weak_mult": 2.0},  # TUNING (not in GDD)
	},
	# Atlas, the strongman: throws cars at towers; weakness: a shredded hide (Wither, the Fallen Hero).
	"atlas": {
		"name": "Atlas", "sprite": "city/atlas", "rank": "miniboss", "tier": "heroes",
		"hp": 5400.0, "speed": 28.0, "armour": 8.0, "radius": 16.0,  # TUNING (not in GDD) X3: was 3200.0
		"damage": 26.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "city/super",
		"args": {"power": "throw", "every": 8.0, "range": 240.0, "radius": 52.0, "delay": 1.4, "disable": 3.0, "body_damage": 40.0,  # TUNING (not in GDD) Necropathy: Atlas throws cars
			"weakness": "shred", "weak_mult": 2.0},  # TUNING (not in GDD)
	},
	# Nightjar, the vigilante: smoke bombs blind the towers round him; weakness: loud blasts (splash, explosions).
	"nightjar": {
		"name": "Nightjar", "sprite": "city/nightjar", "rank": "elite", "tier": "heroes",
		"hp": 700.0, "speed": 50.0, "armour": 3.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 16.0, "attack_interval": 0.9,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "city/super",
		"args": {"power": "smoke", "every": 7.0, "radius": 130.0, "disable": 2.0,  # TUNING (not in GDD)
			"weakness": "loud", "weak_mult": 2.0, "loud": ["mage", "corpse_catapult", "corpse_explosion", "bone_mines", "heros_fist", "fallen_hero"]},  # TUNING (not in GDD)
	},
	# ---------------------------------------------------------------- minibosses and bosses
	# Skid Row's miniboss (Necropathy big_sal): calls his gang, rages when hurt.
	"big_sal": {
		"name": "Big Sal", "sprite": "city/big_sal", "rank": "miniboss", "tier": "gangs",
		"hp": 4600.0, "speed": 28.0, "armour": 4.0, "radius": 16.0,  # TUNING (not in GDD) X3: was 2200.0
		"damage": 22.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "city/big_sal",
		"args": {"call_first": 3.0, "call_every": 12.0, "squad": "street_thug", "squad_n": 3, "squad_gap": 16.0,  # TUNING (not in GDD)
			"rage_hp": 0.5, "rage_mult": 1.35},  # TUNING (not in GDD)
	},
	# Big Sal's armoured limo (Necropathy armoured_limo): a heavier car.
	"armoured_limo": {
		"name": "Armoured Limo", "sprite": "city/armoured_limo", "rank": "elite", "tier": "gangs",
		"hp": 650.0, "speed": 36.0, "armour": 5.0, "radius": 18.0,  # TUNING (not in GDD)
		"damage": 14.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "city/vehicle",
		"args": {"crush_hp": 380.0, "crush_damage": 60.0, "pass_time": 0.9, "shell_every": 0.0},  # TUNING (not in GDD)
	},
	# Fort Kessler's miniboss (Necropathy mammoth): the super-heavy tank, two turrets.
	"mammoth": {
		"name": "The Mammoth", "sprite": "city/mammoth", "rank": "miniboss", "tier": "army",
		"hp": 3600.0, "speed": 20.0, "armour": 8.0, "radius": 24.0,  # TUNING (not in GDD) X3: was 3400.0
		"damage": 30.0, "attack_interval": 1.5,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "city/vehicle",
		"args": {"crush_hp": 800.0, "crush_damage": 120.0, "pass_time": 1.2,  # TUNING (not in GDD) only a big Golem or Abomination holds it
			"shell_every": 7.0, "shell_range": 260.0, "shell_radius": 50.0, "shell_delay": 1.3, "shell_disable": 1.8, "shell_damage": 35.0},  # TUNING (not in GDD) two turrets: twice the tank's rate
	},
	# The Bounty Board Don Marrow raises beside the road: while it stands, he calls a gang squad (structure).
	"bounty_board": {
		"name": "Bounty Board", "sprite": "structures/bounty_board", "rank": "elite", "tier": "",
		"hp": 1000.0, "speed": 0.0, "armour": 2.0, "radius": 16.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 1.0,
		"flying": true, "ignores_walls": true, "trait": "", "structure": true, "args": {},
	},
	# GDD §7.3 Skid Row's boss (Necropathy Don Marrow, the Kingpin): the Bounty, the Call, the Last Stand.
	"don_marrow": {
		"name": "Don Marrow, the Kingpin", "sprite": "bosses/don_marrow", "rank": "boss", "tier": "",
		"hp": 8500.0, "speed": 22.0, "armour": 5.0, "radius": 22.0,  # TUNING (not in GDD)
		"damage": 30.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "city/don_marrow",
		"args": {
			"board_after": 3.0,  # s after he arrives before he raises his Bounty Board
			"board_ahead": 220.0,  # px ahead of him on his road where the board stands
			"board_lane": 46.0,  # px beside the road centre (off the road)
			"bounty_every": 9.0,  # s between gang squads while the board stands
			"bounty_squad": ["street_thug", "street_thug", "gang_gunner"],  # one squad
			"call_hp": 0.66,  # HP share where the Call starts (police and SWAT squads)
			"call_every": 12.0,  # s between Call squads
			"call_squad": ["riot_cop", "riot_cop", "swat_breacher"],  # one squad
			"squad_gap": 18.0,  # px between two members of a squad (behind him)
			"stand_hp": 0.33,  # HP share where the Last Stand starts
			"cover_mult": 0.6,  # share of each hit that gets through his limo's cover in the Last Stand
			"sweep_every": 7.0,  # s between minigun sweeps
			"sweep_windup": 1.0,  # s the sweep's lane telegraphs before it fires
			"sweep_reach": 260.0,  # px of road ahead the sweep covers
			"sweep_marks": 5,  # telegraphed circles along it
			"sweep_radius": 44.0,  # px of each
			"sweep_disable": 1.5,  # s a tower in it is pinned down
			"sweep_damage": 45.0,  # to every blocker body in it
			"pose_time": 0.8,  # s his cast pose shows
		},  # TUNING (not in GDD)
	},
	# GDD §7.3 Fort Kessler's boss (Necropathy General Vance Harrow, the Hammer): Command, the Hammer, Broken Arrow.
	"harrow": {
		"name": "General Harrow, the Hammer", "sprite": "bosses/harrow", "rank": "boss", "tier": "",
		"hp": 9500.0, "speed": 22.0, "armour": 7.0, "radius": 22.0,  # TUNING (not in GDD)
		"damage": 34.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "city/harrow",
		"args": {
			"carpet_first": 4.0,  # s before his first carpet-bombing line
			"carpet_every": 11.0,  # s between lines (Command)
			"carpet_marks": 4,  # landing circles per line (on the towers nearest him, then plots)
			"carpet_radius": 48.0,  # px
			"carpet_delay": 1.4,  # s of telegraph (each mark 0.2 s after the last)
			"carpet_disable": 2.5,  # s a shelled tower is disabled
			"carpet_damage": 30.0,  # to bodies in a circle
			"carpet_range": 340.0,  # px around him the line is laid
			"carpet_step": 0.2,  # s between two marks of one line (the bombs fall in a row)
			"squad_every": 13.0,  # s between rifle squads (Command)
			"squad": ["city_rifleman", "city_rifleman", "city_rifleman"],  # one squad
			"squad_gap": 18.0,  # px between two members
			"hammer_hp": 0.6,  # HP share where the Hammer starts (power armour)
			"hammer_armour": 4.0,  # extra flat armour in the power armour
			"slam_every": 5.0,  # s between hammer slams on the post holding him
			"slam_damage": 80.0,  # to every body of that post
			"column_every": 18.0,  # s between tank columns (the Hammer)
			"column": ["city_tank"],  # one column
			"column_gap": 36.0,  # px between two vehicles of a column
			"arrow_hp": 0.25,  # HP share where Broken Arrow starts
			"arrow_time": 30.0,  # s of the countdown (Necropathy 30 s)
			"arrow_banner_every": 10.0,  # s between countdown banners (Necropathy "a banner every 10 s")
			"strike_radius": 300.0,  # px around him the strike lands
			"strike_disable": 6.0,  # s every tower in it is disabled
			"strike_damage": 200.0,  # to every body in it
			"strike_self": 0.15,  # share of his max HP the strike costs him
			"pose_time": 0.8,  # s his windup pose shows
		},  # TUNING (not in GDD)
	},
	# GDD §7.3 Liberty Heights' boss (Necropathy Paragon, the Last Hero): the Hero, Hope, No Restraint.
	"paragon": {
		"name": "Paragon, the Last Hero", "sprite": "bosses/paragon", "rank": "boss", "tier": "",
		"hp": 12500.0, "speed": 26.0, "armour": 6.0, "radius": 20.0,  # TUNING (not in GDD)
		"damage": 36.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "city/paragon",
		"args": {
			"heat_first": 4.0,  # s before his first heat vision
			"heat_every": 9.0,  # s between heat visions
			"heat_windup": 1.0,  # s his eyes burn before the beam
			"heat_range": 300.0,  # px: the beam runs from him to the farthest tower within it
			"heat_width": 34.0,  # px: towers within it of the beam line are hit
			"heat_disable": 2.5,  # s a tower in the beam is disabled
			"punch_every": 6.0,  # s between punches on the body holding him
			"punch_damage": 160.0,  # to that body
			"hope_hp": 0.66,  # HP share where Hope starts
			"hope_ward": 0.5,  # share of each hit he takes while any Super stands
			"hope_radius": 9999.0,  # px: Supers counted (the whole map)
			"hope_heal": 60.0,  # HP healed to each Super every hope_every s
			"hope_every": 3.0,  # s
			"restraint_hp": 0.33,  # HP share where No Restraint starts
			"dive_every": 10.0,  # s between dives from orbit
			"dive_dist": 170.0,  # px he lands down the road (never past keep_away from the gate)
			"keep_away": 520.0,  # px of road before the gate he never dives into
			"dive_radius": 120.0,  # px around the landing point: towers disabled, bodies hit
			"dive_disable": 3.0,  # s
			"dive_damage": 90.0,  # to bodies
			"dive_delay": 1.2,  # s of the crater's telegraph before he lands
			"pose_time": 0.8,  # s his windup pose shows
		},  # TUNING (not in GDD)
	},
}

## The escalation (act rule) and the HUD meter's numbers.
const RULE: Dictionary = {
	"tiers": ["gangs", "police", "swat", "army", "heroes"],  # GDD §7.3 the escalation order
	"names": {"gangs": "Gangs", "police": "Police", "swat": "SWAT", "army": "Army", "heroes": "Heroes"},  # meter / banner words
	"colours": {"gangs": Color(1.0, 0.31, 0.66), "police": Color(0.18, 0.37, 0.82), "swat": Color(0.48, 0.5, 0.53),
		"army": Color(0.42, 0.46, 0.27), "heroes": Color(0.94, 0.48, 0.12)},  # Necropathy CITY palette: neon pink, police blue, concrete, olive, hero orange
	"tier_hp": 0.05,  # TUNING (not in GDD) enemy HP x(1 + tier_hp x tier index) on spawn (bosses and structures excepted)
	"default": [[1, "gangs"]],  # TUNING (not in GDD) when a map names no "escalation": [first wave, tier] pairs
	"meter_pos": Vector2(8, 6),  # TUNING (not in GDD) px of the meter under the HUD's top bar (left edge)
	"pip": Vector2(22, 8),  # TUNING (not in GDD) px of one tier pip
	"street_extra": 10.0,  # TUNING (not in GDD) px the asphalt is drawn wider than the road (covers the flagstone kerbs)
	"sidewalk_px": 14.0,  # TUNING (not in GDD) px of the sidewalk strip on each side of a street
	"dash_tint": Color(0.92, 0.85, 0.55, 0.55),  # TUNING (not in GDD) the street's centre dashes
	"dash_len": 14.0,  # TUNING (not in GDD) px of one dash; gaps as long again
	"dash_w": 2.0,  # TUNING (not in GDD) px thickness of a dash
	"asphalt_v": 0.06,  # TUNING (not in GDD) v offset (tile fraction) of the plain asphalt rows of tiles/city_street (clear of its own dashes)
}

## Mood rows of the three maps (keys: TdMoodData.MOODS): burning wrecks, neon
## stalls and red antenna lamps (Necropathy's city props), sodium haze.
const MOODS: Dictionary = {
	"skid_row": {
		"props": [
			{"sprite": "structures/city_wreck", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(1.0, 0.55, 0.2, 0.55), "glow_r": 46.0,
				"glow_at": Vector2(0, -16), "flicker": 0.2, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) burning wrecks
			{"sprite": "decals/skid_row_stall", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(1.0, 0.31, 0.66, 0.45), "glow_r": 38.0,
				"glow_at": Vector2(0, -6), "flicker": 0.05, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) neon market stalls
		],
		"fog": 0, "pools": 0,
	},
	"fort_kessler": {
		"props": [
			{"sprite": "decals/fk_sandbags", "frames": 1, "count": 5, "scale": 1.0, "glow": Color(0.91, 0.64, 0.23, 0.3), "glow_r": 30.0,
				"glow_at": Vector2(0, -4), "flicker": 0.0, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) sandbag nests under sodium lamps
			{"sprite": "structures/city_wreck_burnt", "frames": 1, "count": 2, "scale": 1.0, "glow": Color(1.0, 0.45, 0.2, 0.35), "glow_r": 36.0,
				"glow_at": Vector2(0, -10), "flicker": 0.25, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) smouldering wrecks
		],
		"fog": 1, "pools": 0,
	},
	"liberty_heights": {
		"props": [
			{"sprite": "decals/city_antenna", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(0.85, 0.16, 0.16, 0.5), "glow_r": 22.0,
				"glow_at": Vector2(0, -12), "flicker": 0.3, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) rooftop antenna lamps
			{"sprite": "structures/city_wreck", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(1.0, 0.55, 0.2, 0.55), "glow_r": 46.0,
				"glow_at": Vector2(0, -16), "flicker": 0.2, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) cars the heroes threw
		],
		"fog": 0, "pools": 0,
	},
}

## Build orders (keys: BuildOrderData.ORDERS): a default (wins on
## Necromancer, builds the Fallen Hero and casts the act spells) and a weak
## one (loses) per map.
const ORDERS: Dictionary = {
	"skid_row_default": {
		"spells": true,
		"loadout": ["shadow_bolt", "bone_wall", "hearse_run"],
		"steps": [
			{"do": "build", "spot": "plot:4", "tower": "archer"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:1", "tower": "archer"},
			{"do": "build", "spot": "plot:3", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "build", "spot": "plot:12", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:12", "mode": "strongest"},
			{"do": "build", "spot": "post:4", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:8", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "build", "spot": "plot:9", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "build", "spot": "plot:2", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "build", "spot": "plot:10", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:10", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:13", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "evolve", "spot": "plot:4"},
			{"do": "evolve", "spot": "plot:3"},
			{"do": "evolve", "spot": "plot:1"},
		],
	},
	"skid_row_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:0", "tower": "archer"},
			{"do": "build", "spot": "plot:15", "tower": "archer"},
		],
	},
	"fort_kessler_default": {
		"spells": true,
		"loadout": ["shadow_bolt", "corpse_explosion", "bone_mines"],
		"steps": [
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "build", "spot": "plot:6", "tower": "archer"},
			{"do": "build", "spot": "plot:1", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:7", "mode": "strongest"},
			{"do": "build", "spot": "post:4", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "build", "spot": "plot:8", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:12", "tower": "archer"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:9", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:9", "mode": "strongest"},
			{"do": "build", "spot": "plot:5", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "build", "spot": "plot:10", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "evolve", "spot": "plot:2"},
			{"do": "evolve", "spot": "plot:1"},
			{"do": "evolve", "spot": "plot:6"},
		],
	},
	"fort_kessler_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:13", "tower": "archer"},
			{"do": "build", "spot": "plot:14", "tower": "archer"},
		],
	},
	# The act order (ACT_TEMPLATE §1.10): the Fallen Hero (to Black Paragon) and Hero's Fist.
	"liberty_heights_default": {
		"spells": true,
		"loadout": ["shadow_bolt", "corpse_explosion", "heros_fist"],
		"steps": [
			{"do": "build", "spot": "plot:7", "tower": "archer"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "build", "spot": "plot:8", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:9", "tower": "fallen_hero"},
			{"do": "build", "spot": "post:5", "tower": "abomination"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "build", "spot": "plot:1", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:1", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:10", "tower": "mage"},
			{"do": "upgrade", "spot": "post:5"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "build", "spot": "plot:3", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "build", "spot": "plot:6", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "post:5"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "plot:11", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:11", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "evolve", "spot": "plot:9"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "evolve", "spot": "plot:7"},
			{"do": "evolve", "spot": "plot:8"},
			{"do": "evolve", "spot": "plot:2"},
		],
	},
	"liberty_heights_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:14", "tower": "archer"},
			{"do": "build", "spot": "plot:13", "tower": "archer"},
		],
	},
}
