## ActData: the acts of the campaign in play order (Necropathy's
## StageRegistry.ACT_ORDER, GDD §7.3), three maps each. ACTS is the ONE
## ordered list: the act number, the map order, the unlock chain (each map
## opens when the previous map's boss falls; the first map of an act when the
## previous act's last boss falls), the Soul Ash step (a map's position in its
## act) and the map-select / Codex tabs all derive from it (Acts). Data only.
##
## Adding an act needs NO edit here: its row is already listed. The act agent
## writes the map files named in its "maps" (scripts/maps/<map id>_map.gd, a
## map is playable once its file exists) and its data file (the "data" path,
## optional consts KINDS / ORDERS / MOODS, merged by Acts). See
## docs/ACT_TEMPLATE.md.
class_name ActData
extends RefCounted

## Default path of an act's data file ("%s" = act id); a row's "data" key overrides it.
const DATA_PATH: String = "res://scripts/data/acts/%s_act_data.gd"
## Act numerals by position (1-based act number - 1).
const NUMERALS: Array[String] = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIII", "XIV", "XV"]

## Act rows, in campaign order. Keys:
##   id      — act id (Necropathy's ACT_ORDER id; per-act folders and files use it).
##   name    — short title shown after "Act N:" (map select, Codex).
##   faction — the enemy faction (Codex act tab tooltip, map-select subtitle).
##   part    — Part 1..3 of the campaign (Necropathy's Parts; informational).
##   maps    — map ids in play order (Necropathy's stage ids); a map is registered
##             once scripts/maps/<id>_map.gd exists (Act I: MapRegistry.MAPS).
##   music   — run loop id: "" = the Act I loop, else a SoundData.SCORES id
##             (Sfx.run_mode_for(); a map's own "music" key overrides it).
##   floor   — default floor tile key for its maps that set no "floor" ("" = none).
##   mood    — default TdMoodData / act MOODS row id for its maps that have no row
##             of their own ("" = none).
##   rule    — default act rule id (scripts/maps/rules/<id>.gd, extends MapRule)
##             for its maps that set no "act_rule" key ("" = none).
##   hidden  — optional, true: shown nowhere unless --test-act (the framework's test act).
##   data    — optional path of its data file (default DATA_PATH with its id).
const ACTS: Array[Dictionary] = [
	# --- Part One: the living ---
	{"id": "covenant", "name": "the Covenant", "faction": "The Crimson Covenant", "part": 1,
		"maps": ["graveyard", "crimson_march", "sanctum"],
		"music": "", "floor": "tiles/graveyard", "mood": "", "rule": ""},

	{"id": "corsair", "name": "the Black Tide", "faction": "The Black Tide", "part": 1,
		"maps": ["cutter", "galleon", "maelstrom"],
		"music": "shanty", "floor": "tiles/corsair_cutter", "mood": "", "rule": ""},

	{"id": "court", "name": "the Sanguine Court", "faction": "The Sanguine Court", "part": 1,
		"maps": ["ravensmoor", "witchwood", "castle_sanguis"],
		"music": "sanguine", "floor": "tiles/ravensmoor_moor", "mood": "", "rule": ""},

	{"id": "city", "name": "the Last Line", "faction": "The Last Line", "part": 1,
		"maps": ["skid_row", "fort_kessler", "liberty_heights"],
		"music": "siren", "floor": "tiles/city_street", "mood": "", "rule": ""},

	{"id": "shogunate", "name": "the Shogunate", "faction": "The Shogunate of the Rising Sun", "part": 1,
		"maps": ["province", "kurogane", "sun_road"],
		"music": "sun", "floor": "tiles/province_paddies", "mood": "", "rule": ""},

	# --- Part Two: gods, hell and heaven ---
	{"id": "norse", "name": "the Hall of the Slain", "faction": "The Hall of the Slain", "part": 2,
		"maps": ["barrow_fields", "valgard", "vigrid"],
		"music": "valhall", "floor": "tiles/norse_snow", "mood": "", "rule": ""},

	{"id": "dynasty", "name": "the Necropolis Dynasty", "faction": "The Necropolis Dynasty", "part": 2,
		"maps": ["necropolis", "lioness_temple", "two_truths"],
		"music": "weighing", "floor": "tiles/necropolis_dunes", "mood": "", "rule": ""},

	{"id": "pantheon", "name": "the Olympian Republic", "faction": "The Olympian Republic", "part": 2,
		"maps": ["ilion", "olympus", "underworld"],
		"music": "bronze", "floor": "tiles/ilion_beach", "mood": "", "rule": ""},

	{"id": "inferno", "name": "the Inferno", "faction": "The Inferno", "part": 2,
		"maps": ["burning_gate", "silk_palace", "pandemonium"],
		"music": "brimstone", "floor": "tiles/burning_gate_ash_plain", "mood": "", "rule": ""},

	{"id": "host", "name": "the Celestial Host", "faction": "The Celestial Host", "part": 2,
		"maps": ["silver_stair", "wheel_of_thrones", "empyrean"],
		"music": "hosanna", "floor": "tiles/silver_stair_stair", "mood": "", "rule": ""},

	# --- Part Three: beyond and before ---
	{"id": "eye", "name": "the Ancient Eye", "faction": "The Ancient Eye", "part": 3,
		"maps": ["harbour", "archive", "spire"],
		"music": "tide", "floor": "tiles/harbour_market", "mood": "", "rule": ""},

	{"id": "empire", "name": "the Electronic Empire", "faction": "The Electronic Empire", "part": 3,
		"maps": ["wastes", "assembly", "citadel"],
		"music": "iron", "floor": "tiles/wastes_slag", "mood": "", "rule": ""},

	{"id": "concord", "name": "the Concord of Stars", "faction": "The Concord of Stars", "part": 3,
		"maps": ["crash_site", "proving_moon", "ark"],
		"music": "starsong", "floor": "tiles/crash_site_ruins", "mood": "", "rule": ""},

	{"id": "primeval", "name": "the Age of Titans", "faction": "The Age of Titans", "part": 3,
		"maps": ["fern_basin", "great_plain", "last_day"],
		"music": "primordial", "floor": "tiles/fern_basin_fern_floor", "mood": "", "rule": ""},

	{"id": "wild", "name": "the Turning Year", "faction": "The Turning Year", "part": 3,
		"maps": ["greenwood", "fae_court", "world_tree"],
		"music": "wildwood", "floor": "tiles/greenwood_glade", "mood": "", "rule": ""},

	# --- Hidden: the act framework's own test act (docs/ACT_TEMPLATE.md; --test-act) ---
	{"id": "test", "name": "the Proving Grounds", "faction": "Framework test", "part": 0,
		"maps": ["test_grounds"],
		"music": "", "floor": "tiles/graveyard", "mood": "graveyard", "rule": "test/proving", "hidden": true},
]
