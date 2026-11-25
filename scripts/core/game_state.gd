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


func _init() -> void:
	for arg: String in OS.get_cmdline_user_args():
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
