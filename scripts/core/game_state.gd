## GameState: the small autoload that holds the command-line autotest options
## and the run choice handed from the menus to the map scene. The copied
## presentation layer (Settings, UiMotion, TouchSupport) reads `autotest`,
## `autotest_effects` and `autotest_coop_shots` from here, as in Necropathy.
## Gravewatch's own options are parsed once in _init() from the user args
## (after `--` on the command line, or `?gw_autotest=` on the Web, unused yet).
extends Node

## True when the game was started with --autotest (headless bot run).
var autotest: bool = false
## Effects quality forced for the autotest ("" = full; read by Settings).
var autotest_effects: String = ""
## --reduce-motion: Reduce motion forced on for this run (the Web visual check; visual only).
var autotest_reduce_motion: bool = false
## --damage-numbers: floating damage numbers forced on for this run (visual only).
var autotest_numbers: bool = false
## Kept for the copied TouchSupport (Necropathy's co-op shot mode); always "".
var autotest_coop_shots: String = ""
## Map id to play (MapRegistry id).
var map_id: String = MapRegistry.DEFAULT_ID
## Difficulty id (DifficultyData.LEVELS key).
var difficulty: String = DifficultyData.DEFAULT_ID
## Seed of the run's RNG (any int).
var run_seed: int = 1
## Autotest game speed: fixed simulation steps per rendered frame (1..64).
var autotest_speed: int = 8
## Autotest build order id (BuildOrderData.ORDERS key; "" = the map's default).
var autotest_build: String = ""
## Autotest: start the Reckoning endless mode after a cleared map (--reckoning).
var autotest_reckoning: bool = false
## Autotest meta profile: "" (the save under --meta-save, else none), "none" or "max" (every upgrade and mastery).
var autotest_meta: String = ""
## True with --meta-save: the autotest reads and writes the real save file.
var meta_save: bool = false
## Character id of the run (CharacterData key; --character= in the autotest).
var character: String = CharacterData.DEFAULT_ID
## Spells of the run in slot order (empty = SpellData.DEFAULT_LOADOUT).
var loadout: Array[String] = []


func _init() -> void:
	var args := OS.get_cmdline_user_args()  # The options after `--`.
	if OS.has_feature("web"):
		# Web debug: `?gw_autotest=--map=sanctum,--speed=8` runs the bot on screen.
		var q := String(JavaScriptBridge.eval("new URLSearchParams(location.search).get('gw_autotest') || ''", true))  # The query value.
		if q != "":
			args = PackedStringArray(["--autotest"]) + q.split(",", false)
	for arg: String in args:
		var kv := arg.split("=", true, 1)  # [name, value] or [flag].
		var v := kv[1] if kv.size() > 1 else ""  # Option value ("" for flags).
		match kv[0]:
			"--autotest": autotest = true
			"--map": map_id = v
			"--seed": run_seed = int(v)
			"--speed": autotest_speed = clampi(int(v), 1, 64)
			"--difficulty": difficulty = v
			"--build": autotest_build = v
			"--reckoning": autotest_reckoning = true
			"--effects": autotest_effects = v
			"--reduce-motion": autotest_reduce_motion = true
			"--damage-numbers": autotest_numbers = true
			"--meta": autotest_meta = v
			"--meta-save": meta_save = true
			"--character": character = v
