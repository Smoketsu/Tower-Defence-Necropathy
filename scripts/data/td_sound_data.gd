## TdSoundData: which existing Necropathy sound (SoundData.SOUNDS id, played
## through Sfx.play) each Gravewatch event uses, and the five new synthesized
## sounds GDD §11 asks for (place, upgrade, sell, life lost, wave call) as
## SoundData-style recipes in SOUNDS, rendered by the Synth as Sfx's lazy
## "td" pack (TdGame asks for it; no audio files). Data only, no logic.
class_name TdSoundData
extends RefCounted

## Event -> Sfx id.
const EVENTS: Dictionary = {
	"place": "td_place",  # GDD §11 "place"
	"upgrade": "td_upgrade",  # GDD §11 "upgrade"
	"sell": "td_sell",  # GDD §11 "sell"
	"life_lost": "td_life_lost",  # GDD §11 "life lost"
	"wave_call": "td_wave_call",  # GDD §11 "wave call"
	"evolve": "level_up",  # TUNING (not in GDD)
	"chest": "chest_open",  # TUNING (not in GDD)
	"boss": "boss_arrive",  # TUNING (not in GDD)
	"denied": "denied",  # TUNING (not in GDD)
	"enemy_death": "enemy_death",  # TUNING (not in GDD)
	"rally": "ult_decree",  # TUNING (not in GDD)
	# Act IV (w2b-city): Necropathy's City pack (rendered with the "siren" score).
	"city_crash": "vehicle_wreck", "city_super": "super_arrive", "city_weak": "weakness_crack",  # TUNING (not in GDD)
	"city_tier": "tier_alarm", "city_gun": "gun_burst", "city_siren": "siren_wail",  # TUNING (not in GDD)
}
## Tower class -> Sfx id of its shot / pulse / hit.
const FIRE: Dictionary = {
	"archer": "spear_cast", "mage": "mage_burst", "frost_wraith": "frost_bolt", "corpse_catapult": "catapult_launch",
	"banshee": "banshee_wail", "mender": "priest_ward", "warrior": "warrior_bash", "abomination": "abom_stomp",
	# Later towers (gw2-kit): Necropathy's own class sounds where they exist, else a td pack recipe below.
	"warder": "priest_ward", "rogue": "rogue_dash", "gargoyle": "gargoyle_dive", "bone_hound": "td_hound_bite",
	"fallen_seraph": "td_seraph_feather", "bone_golem": "td_golem_slam",
	"powder_wraith": "fuse_hiss",  # w2b-tide: the Black Tide pack's lit fuse (its burst plays powder_blast)
	"blood_spawn": "td_blood_bite",  # w2b-court
	"fallen_hero": "abom_stomp",  # Act IV (w2b-city)
	"bound_oni": "oni_smash",  # Act V (w2b-shogun): Necropathy's oni club (shogunate pack)
	"draugr_thane": "frost_giant_stomp",  # Act VI (w2c-norse): the Norse pack's heavy stamp for its axe
	"ushabti_sentinel": "td_golem_slam",  # Act VII (w2c-dynasty): stone on stone
	"myrmidon_shade": "warrior_bash",  # Act VIII (w2c-pantheon): the Warrior's blow (a bank sound: heard on every map)
}  # TUNING (not in GDD)
## Spell / ultimate id -> Sfx id played on its cast (gw2-kit: the later spells; the
## launch spells keep their own sounds). Ultimates use their row's "sound".
const CAST: Dictionary = {
	"death_mark": "bolt_cast", "soul_chains": "td_soul_chains", "wither": "plague_cast", "raise_dead": "summon_rise",
	"chain_shot": "hook_throw", "cannonade": "cannon_fire", "anchor_drop": "splash",  # w2b-tide: the Black Tide pack
	"moonfang": "td_blood_bite", "witch_circle": "plague_cast", "night_swarm": "gargoyle_dive",  # w2b-court
	"hearse_run": "engine_rev", "bone_mines": "catapult_launch", "heros_fist": "weakness_crack",  # Act IV (w2b-city)
	"hundred_shadows": "kage_split", "banner_of_the_dead": "taiko_hit", "black_sun": "bolt_cast",  # Act V (w2b-shogun)
	"barrow_grasp": "summon_rise", "valkyrie_spear": "valkyrie_dive", "gungnir": "spear_cast",  # Act VI (w2c-norse)
	"linen_bind": "cartouche_chime", "burning_eye": "bolt_cast", "feathers_verdict": "scales_tip",  # Act VII (w2c-dynasty): the Dynasty pack
	"paris_arrow": "spear_cast", "stolen_thunder": "bolt_cast", "river_styx": "plague_cast",  # Act VIII (w2c-pantheon): bank sounds

}  # TUNING (not in GDD)

## The five Gravewatch sounds (GDD §11), id -> recipe; keys exactly as
## SoundData.SOUNDS (documented in its header: dur, volume_db, max_voices,
## min_interval ms, pitch_var, priority, layers of wave / f0 / f1 / start /
## dur / amp / attack / decay / lp0 / lp1 / vib_hz / vib_depth).
const SOUNDS: Dictionary = {  # TUNING (not in GDD)
	# Place: earth breaking and a low bone rattle as the undead rises from its grave.
	"td_place": {"dur": 0.42, "volume_db": -11.0, "max_voices": 2, "min_interval": 80, "pitch_var": 0.05, "priority": 2,
		"layers": [
			{"wave": "noise", "dur": 0.25, "amp": 0.5, "attack": 0.005, "decay": 0.07, "lp0": 1400.0, "lp1": 250.0},
			{"wave": "sine", "f0": 70.0, "f1": 110.0, "dur": 0.4, "amp": 0.6, "attack": 0.02, "decay": 0.15},
			{"wave": "square", "f0": 330.0, "f1": 300.0, "start": 0.12, "dur": 0.05, "amp": 0.15, "decay": 0.015, "lp0": 2500.0},
			{"wave": "square", "f0": 392.0, "f1": 360.0, "start": 0.2, "dur": 0.05, "amp": 0.12, "decay": 0.015, "lp0": 2500.0}]},
	# Upgrade: a rising dark arpeggio (minor triad) with a soul shimmer.
	"td_upgrade": {"dur": 0.5, "volume_db": -12.0, "max_voices": 2, "min_interval": 80, "pitch_var": 0.0, "priority": 2,
		"layers": [
			{"wave": "tri", "f0": 220.0, "dur": 0.14, "amp": 0.35, "attack": 0.005, "decay": 0.06},
			{"wave": "tri", "f0": 262.0, "start": 0.1, "dur": 0.14, "amp": 0.35, "attack": 0.005, "decay": 0.06},
			{"wave": "tri", "f0": 330.0, "start": 0.2, "dur": 0.3, "amp": 0.4, "attack": 0.005, "decay": 0.12},
			{"wave": "sine", "f0": 660.0, "f1": 990.0, "start": 0.2, "dur": 0.3, "amp": 0.12, "decay": 0.1, "vib_hz": 9.0, "vib_depth": 0.01}]},
	# Sell: the undead crumbles back to dust, a falling tone and a soft clink of returned souls.
	"td_sell": {"dur": 0.38, "volume_db": -13.0, "max_voices": 2, "min_interval": 80, "pitch_var": 0.04, "priority": 2,
		"layers": [
			{"wave": "noise", "dur": 0.32, "amp": 0.35, "attack": 0.01, "decay": 0.1, "lp0": 2200.0, "lp1": 300.0},
			{"wave": "saw", "f0": 260.0, "f1": 90.0, "dur": 0.3, "amp": 0.25, "decay": 0.1, "lp0": 1200.0, "lp1": 300.0},
			{"wave": "sine", "f0": 1175.0, "start": 0.16, "dur": 0.18, "amp": 0.14, "decay": 0.05}]},
	# Life lost: a heavy blow on the Ossuary gate, low and alarming.
	"td_life_lost": {"dur": 0.55, "volume_db": -9.0, "max_voices": 2, "min_interval": 120, "pitch_var": 0.03, "priority": 3,
		"layers": [
			{"wave": "sine", "f0": 90.0, "f1": 40.0, "dur": 0.5, "amp": 0.8, "decay": 0.16},
			{"wave": "noise", "dur": 0.12, "amp": 0.55, "decay": 0.03, "lp0": 3000.0, "lp1": 600.0},
			{"wave": "square", "f0": 185.0, "f1": 175.0, "start": 0.04, "dur": 0.4, "amp": 0.16, "decay": 0.14, "lp0": 900.0},
			{"wave": "square", "f0": 196.0, "f1": 185.0, "start": 0.04, "dur": 0.4, "amp": 0.14, "decay": 0.14, "lp0": 900.0}]},
	# Wave call: a Covenant war horn answered by a drum beat.
	"td_wave_call": {"dur": 1.0, "volume_db": -10.0, "max_voices": 1, "min_interval": 400, "pitch_var": 0.0, "priority": 3,
		"layers": [
			{"wave": "saw", "f0": 147.0, "f1": 165.0, "dur": 0.75, "amp": 0.4, "attack": 0.08, "decay": 0.5, "lp0": 700.0, "lp1": 1400.0, "vib_hz": 5.0, "vib_depth": 0.008},
			{"wave": "saw", "f0": 220.0, "f1": 247.0, "start": 0.05, "dur": 0.7, "amp": 0.22, "attack": 0.1, "decay": 0.5, "lp0": 900.0, "lp1": 1600.0},
			{"wave": "sine", "f0": 80.0, "f1": 45.0, "start": 0.7, "dur": 0.3, "amp": 0.7, "decay": 0.08},
			{"wave": "noise", "start": 0.7, "dur": 0.1, "amp": 0.3, "decay": 0.025, "lp0": 1500.0}]},
	# --- gw2-kit (appended at the END: the pack's earlier sounds keep their seeds) ---
	# Hound bite: a snapping crunch with a thud under it (Necropathy's hound_bite, lighter).
	"td_hound_bite": {"dur": 0.4, "volume_db": -14.0, "max_voices": 2, "min_interval": 120, "pitch_var": 0.1, "priority": 2,
		"layers": [
			{"wave": "noise", "dur": 0.08, "amp": 0.7, "decay": 0.02, "lp0": 7000.0, "lp1": 2000.0},
			{"wave": "sine", "f0": 120.0, "f1": 60.0, "dur": 0.3, "amp": 0.45, "decay": 0.1},
			{"wave": "square", "f0": 260.0, "f1": 150.0, "start": 0.02, "dur": 0.1, "amp": 0.08, "decay": 0.03, "lp0": 1500.0}]},
	# Golem slam: a deep stone thud with a rumble (Necropathy's brute_slam, shorter).
	"td_golem_slam": {"dur": 0.8, "volume_db": -11.0, "max_voices": 2, "min_interval": 200, "pitch_var": 0.05, "priority": 3,
		"layers": [
			{"wave": "sine", "f0": 70.0, "f1": 24.0, "dur": 0.7, "amp": 0.9, "attack": 0.002, "decay": 0.22},
			{"wave": "noise", "dur": 0.08, "amp": 0.7, "attack": 0.001, "decay": 0.02, "lp0": 5000.0, "lp1": 1000.0},
			{"wave": "noise", "start": 0.05, "dur": 0.6, "amp": 0.3, "attack": 0.03, "decay": 0.25, "lp0": 700.0, "lp1": 150.0}]},
	# Seraph feathers: a dark airy whoosh with a faint falling choir tone.
	"td_seraph_feather": {"dur": 0.35, "volume_db": -16.0, "max_voices": 2, "min_interval": 90, "pitch_var": 0.08, "priority": 1,
		"layers": [
			{"wave": "noise", "dur": 0.3, "amp": 0.45, "attack": 0.03, "decay": 0.12, "lp0": 4000.0, "lp1": 1200.0},
			{"wave": "sine", "f0": 880.0, "f1": 660.0, "dur": 0.3, "amp": 0.12, "attack": 0.02, "decay": 0.12, "vib_hz": 7.0, "vib_depth": 0.01}]},
	# Soul Chains: iron links rattling, then a crackle of soul lightning.
	"td_soul_chains": {"dur": 0.7, "volume_db": -12.0, "max_voices": 1, "min_interval": 200, "pitch_var": 0.04, "priority": 3,
		"layers": [
			{"wave": "noise", "dur": 0.15, "amp": 0.35, "attack": 0.02, "decay": 0.06, "lp0": 1500.0, "lp1": 6000.0},
			{"wave": "sine", "f0": 1900.0, "start": 0.1, "dur": 0.07, "amp": 0.1, "decay": 0.025},
			{"wave": "sine", "f0": 2300.0, "start": 0.18, "dur": 0.07, "amp": 0.09, "decay": 0.025},
			{"wave": "saw", "f0": 120.0, "f1": 90.0, "start": 0.2, "dur": 0.45, "amp": 0.2, "decay": 0.18, "lp0": 3000.0, "vib_hz": 30.0, "vib_depth": 0.08}]},
	# --- w2b-court (appended at the END) ---
	# Blood bite: a wet snap of fangs and a short drink (the Blood Spawn's strikes, Moonfang's jaws).
	"td_blood_bite": {"dur": 0.38, "volume_db": -14.0, "max_voices": 2, "min_interval": 110, "pitch_var": 0.1, "priority": 2,
		"layers": [
			{"wave": "noise", "dur": 0.07, "amp": 0.65, "decay": 0.02, "lp0": 6000.0, "lp1": 1800.0},
			{"wave": "sine", "f0": 160.0, "f1": 70.0, "dur": 0.25, "amp": 0.4, "decay": 0.08},
			{"wave": "noise", "start": 0.08, "dur": 0.25, "amp": 0.2, "attack": 0.03, "decay": 0.1, "lp0": 900.0, "lp1": 400.0}]},
}
