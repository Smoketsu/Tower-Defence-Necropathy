## TdSoundData: which existing Necropathy sound (SoundData.SOUNDS id, played
## through Sfx.play) each Gravewatch event uses. GDD §11 asks for five new
## synthesized sounds (place, upgrade, sell, life lost, wave call); until they
## are made these map onto the closest existing ones. Data only, no logic.
class_name TdSoundData
extends RefCounted

## Event -> Sfx id.
const EVENTS: Dictionary = {
	"place": "summon_rise",  # TUNING (not in GDD) stand-in for GDD §11 "place"
	"upgrade": "purchase",  # TUNING (not in GDD) stand-in for GDD §11 "upgrade"
	"sell": "ui_back",  # TUNING (not in GDD) stand-in for GDD §11 "sell"
	"life_lost": "player_hurt",  # TUNING (not in GDD) stand-in for GDD §11 "life lost"
	"wave_call": "boss_telegraph",  # TUNING (not in GDD) stand-in for GDD §11 "wave call"
	"evolve": "level_up",  # TUNING (not in GDD)
	"chest": "chest_open",  # TUNING (not in GDD)
	"boss": "boss_arrive",  # TUNING (not in GDD)
	"denied": "denied",  # TUNING (not in GDD)
	"enemy_death": "enemy_death",  # TUNING (not in GDD)
	"rally": "ult_decree",  # TUNING (not in GDD)
}
## Tower class -> Sfx id of its shot / pulse / hit.
const FIRE: Dictionary = {
	"archer": "spear_cast", "mage": "mage_burst", "frost_wraith": "frost_bolt", "corpse_catapult": "catapult_launch",
	"banshee": "banshee_wail", "mender": "priest_ward", "warrior": "warrior_bash", "abomination": "abom_stomp",
}  # TUNING (not in GDD)
