## TdVfxData: every number of the combat-effects pass (DECISIONS V1-V8): how
## big shots are drawn, their trails, muzzle flashes and impact bursts per
## tower class, the melee lunges and slashes, hit reactions, deaths, status
## marks, tower recoil and breathing, the leak flash and the screen shake.
## Purely visual: nothing here is read by the simulation, so a run plays out
## identically (same-seed summaries) whatever these values are. Read by TdVfx,
## TdProjectiles._draw(), TdEnemy, Tower and the blocker kits. Data only, no logic.
class_name TdVfxData
extends RefCounted

## --- Shots (TdProjectiles._draw) -------------------------------------------------

## Per tower class (TowerData id) shot look. Keys:
##   sprite   — SpriteData flat key drawn for its main shots ("" = the tower's own projectile).
##   scale    — drawn size multiplier on the sprite's art size (1 = art size).
##   tint     — Color of its trail, muzzle flash and impact burst.
##   trail    — trail length (px) at full speed; 0 = none.
##   trail_w  — trail thickness (px).
##   halo     — radius (px) of a pulsing glow disc under the shot (0 = none).
##   impact   — effect strip id (effects/<id>) of its impact burst ("" = none).
##   impact_d — that burst's diameter (px); 0 = twice the shot's real splash radius.
##   ring     — true: an expanding ring at the real splash radius on impact.
##   muzzle   — diameter (px) of the muzzle flash at the tower (0 = none).
const SHOTS: Dictionary = {
	"archer": {"sprite": "projectiles/bone_spear", "scale": 2.2, "tint": Color(0.5, 1.0, 0.55), "trail": 80.0, "trail_w": 11.0,
		"halo": 0.0, "impact": "volley_hit", "impact_d": 44.0, "ring": false, "muzzle": 34.0},  # TUNING (not in GDD) long bone arrow, pale green streak, splinter puff
	"mage": {"sprite": "projectiles/orb", "scale": 1.5, "tint": Color(0.78, 0.5, 1.0), "trail": 46.0, "trail_w": 14.0,
		"halo": 20.0, "impact": "bolt_impact", "impact_d": 0.0, "ring": true, "muzzle": 40.0},  # TUNING (not in GDD) glowing violet orb, burst = real splash
	"frost_wraith": {"sprite": "projectiles/frost_bolt", "scale": 2.4, "tint": Color(0.7, 0.9, 1.0), "trail": 64.0, "trail_w": 9.0,
		"halo": 9.0, "impact": "frost_shatter", "impact_d": 56.0, "ring": true, "muzzle": 34.0},  # TUNING (not in GDD) ice shard, blue-white trail, frost ring
	"corpse_catapult": {"sprite": "projectiles/corpse_boulder", "scale": 2.4, "tint": Color(0.85, 0.72, 0.55), "trail": 0.0, "trail_w": 0.0,
		"halo": 0.0, "impact": "bone_wall_burst", "impact_d": 0.0, "ring": true, "muzzle": 40.0},  # TUNING (not in GDD) tumbling boulder, dust ring + bone chips
}
## Look of a class missing from SHOTS (same keys).
const SHOT_DEFAULT: Dictionary = {"sprite": "", "scale": 2.0, "tint": Color(1.0, 1.0, 1.0), "trail": 40.0, "trail_w": 6.0,
	"halo": 0.0, "impact": "volley_hit", "impact_d": 36.0, "ring": false, "muzzle": 28.0}  # TUNING (not in GDD)
## Volley shots (Lv3+ bursts, volleys/<id> masks): drawn size multiplier.
const VOLLEY_SCALE: float = 1.5  # TUNING (not in GDD)
## Volley shots: trail length (px) and thickness (px).
const VOLLEY_TRAIL: float = 40.0  # TUNING (not in GDD)
## See VOLLEY_TRAIL.
const VOLLEY_TRAIL_W: float = 8.0  # TUNING (not in GDD)
## Volley shots: impact burst diameter (px).
const VOLLEY_IMPACT_D: float = 30.0  # TUNING (not in GDD)
## Volley shots: px a shot is pushed sideways at launch so a burst visibly fans
## out (the push fades to 0 by the target; drawn only).
const VOLLEY_FAN: float = 26.0  # TUNING (not in GDD)
## Evolved (tier 6) towers: multiplier on shot size, trail, halo and impact.
const EVOLVED_MULT: float = 1.35  # TUNING (not in GDD) "a louder version"
## Seconds an impact burst plays.
const IMPACT_TIME: float = 0.32  # TUNING (not in GDD)
## Seconds a splash ring expands, and its start / end radius as a fraction of the splash.
const RING_TIME: float = 0.3  # TUNING (not in GDD)
## See RING_TIME.
const RING_FROM: float = 0.35  # TUNING (not in GDD)
## See RING_TIME.
const RING_TO: float = 1.05  # TUNING (not in GDD)
## Seconds a muzzle flash plays.
const MUZZLE_TIME: float = 0.18  # TUNING (not in GDD)
## Px above a plot tower's spot centre where its shots leave (TdProjectiles uses 18).
const MUZZLE_LIFT: float = 18.0  # TUNING (not in GDD) matches TdProjectiles._take()
## Halo pulse: cycles per second and amplitude (fraction of the halo radius).
const HALO_HZ: float = 3.0  # TUNING (not in GDD)
## See HALO_HZ.
const HALO_PULSE: float = 0.25  # TUNING (not in GDD)
## Halo alpha (0..1).
const HALO_ALPHA: float = 0.55  # TUNING (not in GDD)
## Trail alpha at its head (0..1).
const TRAIL_ALPHA: float = 1.0  # TUNING (not in GDD)

## --- The Catapult ----------------------------------------------------------------

## Ground shadow under a lobbed boulder: radius (px) and alpha at launch; it
## grows to SHADOW_LAND x as the boulder comes down.
const LOB_SHADOW_R: float = 9.0  # TUNING (not in GDD)
## See LOB_SHADOW_R.
const LOB_SHADOW_A: float = 0.45  # TUNING (not in GDD)
## See LOB_SHADOW_R.
const LOB_SHADOW_LAND: float = 1.6  # TUNING (not in GDD)
## Turns a boulder tumbles over its flight.
const LOB_SPIN: float = 1.5  # TUNING (not in GDD)
## Boulder impact: screen shake (px; volley boulders shake none).
const LOB_SHAKE: float = 3.0  # TUNING (not in GDD) "small screen shake"
## Boulder impact: dust ring colour and the ground crack's life (s).
const DUST_TINT: Color = Color(0.78, 0.66, 0.5, 0.9)  # TUNING (not in GDD)
## See DUST_TINT.
const CRACK_TIME: float = 1.2  # TUNING (not in GDD)

## --- The Banshee and the Mender ------------------------------------------------

## Sound rings per wail rolling out one after another, and s between them.
const WAIL_RINGS: int = 3  # TUNING (not in GDD) "visible sound rings"
## See WAIL_RINGS.
const WAIL_RING_GAP: float = 0.09  # TUNING (not in GDD)
## Seconds each sound ring rolls out.
const WAIL_RING_LIFE: float = 0.45  # TUNING (not in GDD)
## Sound ring colour.
const WAIL_TINT: Color = Color(0.85, 0.6, 1.0, 0.95)  # TUNING (not in GDD)
## Mender soul-thread: colour, life (s) and thickness (px).
const THREAD_TINT: Color = Color(0.45, 1.0, 0.7, 0.95)  # TUNING (not in GDD)
## See THREAD_TINT.
const THREAD_TIME: float = 0.45  # TUNING (not in GDD)
## See THREAD_TINT.
const THREAD_W: float = 6.0  # TUNING (not in GDD)
## Diameter (px) of the sparkle on a healed body.
const HEAL_SPARKLE_D: float = 40.0  # TUNING (not in GDD)
## Pulse ring colour of the Mender (blockers) and of an enemy-hitting aura.
const MENDER_TINT: Color = Color(0.5, 1.0, 0.7, 0.8)  # TUNING (not in GDD)

## --- Melee (blocker posts) -----------------------------------------------------

## Body lunge toward its target: px at the peak and total s (out and back).
const LUNGE_PX: float = 6.0  # TUNING (not in GDD) "lunges a few px"
## See LUNGE_PX.
const LUNGE_TIME: float = 0.2  # TUNING (not in GDD)
## Fraction of LUNGE_TIME spent going out (the rest is the step back).
const LUNGE_OUT: float = 0.3  # TUNING (not in GDD)
## Warrior sword slash: diameter (px), seconds and colour; Death Knight colour.
const SLASH_D: float = 90.0  # TUNING (not in GDD)
## See SLASH_D.
const SLASH_TIME: float = 0.22  # TUNING (not in GDD)
## See SLASH_D.
const SLASH_TINT: Color = Color(1.0, 0.97, 0.82)  # TUNING (not in GDD) bright bone-white
## See SLASH_D.
const SLASH_TINT_EVOLVED: Color = Color(0.6, 1.0, 0.75)  # TUNING (not in GDD) Death Knight's soul-green blade
## Px the struck enemy is nudged back (drawn only) and for how long (s).
const NUDGE_PX: float = 2.0  # TUNING (not in GDD) "1-2 px"
## See NUDGE_PX.
const NUDGE_TIME: float = 0.12  # TUNING (not in GDD)
## Abomination smash: wind-up rise (fraction of its height), s, dust ring
## diameter (px) and screen shake (px).
const SMASH_RISE: float = 0.14  # TUNING (not in GDD)
## See SMASH_RISE.
const SMASH_TIME: float = 0.32  # TUNING (not in GDD)
## See SMASH_RISE.
const SMASH_RING_D: float = 96.0  # TUNING (not in GDD)
## See SMASH_RISE.
const SMASH_SHAKE: float = 1.5  # TUNING (not in GDD)
## Enemy blow on a blocker: enemy lunge (px), red slash diameter (px), colour,
## blocker flinch (px) and spark burst diameter (px).
const ENEMY_LUNGE_PX: float = 5.0  # TUNING (not in GDD)
## See ENEMY_LUNGE_PX.
const ENEMY_SLASH_D: float = 56.0  # TUNING (not in GDD)
## See ENEMY_LUNGE_PX.
const ENEMY_SLASH_TINT: Color = Color(1.0, 0.3, 0.25)  # TUNING (not in GDD)
## See ENEMY_LUNGE_PX.
const FLINCH_PX: float = 2.5  # TUNING (not in GDD)
## See ENEMY_LUNGE_PX.
const SPARK_D: float = 26.0  # TUNING (not in GDD)
## See ENEMY_LUNGE_PX.
const SPARK_TINT: Color = Color(1.0, 0.85, 0.45)  # TUNING (not in GDD) shield sparks
## Boss blow on a blocker: s the strike pose shows, cleave diameter (px), lunge (px), shake (px).
const BOSS_POSE_TIME: float = 0.3  # TUNING (not in GDD)
## See BOSS_POSE_TIME.
const BOSS_SLASH_D: float = 120.0  # TUNING (not in GDD)
## See BOSS_POSE_TIME.
const BOSS_LUNGE_PX: float = 9.0  # TUNING (not in GDD)
## See BOSS_POSE_TIME.
const BOSS_SHAKE: float = 2.0  # TUNING (not in GDD)
## Fallen body: bone pile decal key and its drawn scale; s a respawned body climbs out.
const BONE_PILE: String = "decals/corpse"  # TUNING (not in GDD)
## See BONE_PILE.
const BONE_PILE_SCALE: float = 1.6  # TUNING (not in GDD)
## See BONE_PILE.
const RISE_TIME: float = 0.5  # TUNING (not in GDD)

## --- Reactions (step 2) ------------------------------------------------------------

## Hit squash: amount (fraction) and s.
const HIT_SQUASH: float = 0.14  # TUNING (not in GDD) "tiny squash"
## See HIT_SQUASH.
const HIT_SQUASH_TIME: float = 0.1  # TUNING (not in GDD)
## Death burst diameter (px) by rank, and how long it plays (s).
const DEATH_D: Dictionary = {"fodder": 70.0, "elite": 120.0, "miniboss": 170.0, "boss": 260.0}  # TUNING (not in GDD)
## See DEATH_D.
const DEATH_TIME: float = 0.45  # TUNING (not in GDD)
## Elites and minibosses: extra ring burst colour.
const ELITE_TINT: Color = Color(1.0, 0.85, 0.5, 0.9)  # TUNING (not in GDD)
## Boss death sequence: bursts, s between them, white flash radius (px) and s, shake (px).
const BOSS_BURSTS: int = 5  # TUNING (not in GDD)
## See BOSS_BURSTS.
const BOSS_BURST_GAP: float = 0.22  # TUNING (not in GDD)
## See BOSS_BURSTS.
const BOSS_FLASH_R: float = 220.0  # TUNING (not in GDD)
## See BOSS_BURSTS.
const BOSS_FLASH_TIME: float = 0.6  # TUNING (not in GDD)
## See BOSS_BURSTS.
const BOSS_DEATH_SHAKE: float = 7.0  # TUNING (not in GDD)
## Soul wisp from a kill to the soul counter: flight s, radius (px), colour, arc height (px).
const WISP_TIME: float = 0.7  # TUNING (not in GDD)
## See WISP_TIME.
const WISP_R: float = 6.0  # TUNING (not in GDD)
## See WISP_TIME.
const WISP_TINT: Color = Color(0.45, 1.0, 0.9, 0.95)  # TUNING (not in GDD) soul-teal
## See WISP_TIME.
const WISP_ARC: float = 90.0  # TUNING (not in GDD)
## Most wisps in flight (more kills skip theirs).
const WISP_CAP: int = 24  # TUNING (not in GDD)

## Status marks, in priority order (the first present sets the body tint);
## each has its tint and its icon index in td/vfx_status.png.
const STATUS_ORDER: Array[String] = ["frozen", "burning", "rot", "cursed", "weakened", "slowed"]  # TUNING (not in GDD)
## Status -> body tint (components above 1 brighten).
const STATUS_TINT: Dictionary = {
	"frozen": Color(0.55, 0.85, 1.6),  # TUNING (not in GDD) clearly iced
	"burning": Color(1.35, 0.8, 0.55),  # TUNING (not in GDD)
	"rot": Color(0.8, 1.15, 0.65),  # TUNING (not in GDD)
	"cursed": Color(1.05, 0.75, 1.25),  # TUNING (not in GDD)
	"weakened": Color(1.0, 0.82, 1.15),  # TUNING (not in GDD)
	"slowed": Color(0.75, 0.92, 1.2),  # TUNING (not in GDD) chilled blue
}
## Status -> icon index (0..5) in td/vfx_status.png.
const STATUS_ICON: Dictionary = {"burning": 0, "rot": 1, "cursed": 2, "slowed": 3, "frozen": 4, "weakened": 5}  # TUNING (not in GDD)
## Icon size (px) and drawn scale; most icons shown over one enemy.
const STATUS_ICON_PX: int = 9  # TUNING (not in GDD) art size
## See STATUS_ICON_PX.
const STATUS_ICON_SCALE: float = 1.5  # TUNING (not in GDD)
## See STATUS_ICON_PX.
const STATUS_ICONS_MAX: int = 3  # TUNING (not in GDD)
## Seconds a field tick (burning shards, plague) keeps its status shown.
const FIELD_STATUS_TIME: float = 0.7  # TUNING (not in GDD)

## Tower firing: recoil (px, away from the target), its s, and the white flash s.
const RECOIL_PX: float = 3.0  # TUNING (not in GDD)
## See RECOIL_PX.
const RECOIL_TIME: float = 0.14  # TUNING (not in GDD)
## See RECOIL_PX.
const FIRE_FLASH_TIME: float = 0.06  # TUNING (not in GDD)
## Idle breathing: scale amplitude (fraction) and period (s, game time).
const BREATH_AMP: float = 0.025  # TUNING (not in GDD) "slight idle breathing"
## See BREATH_AMP.
const BREATH_PERIOD: float = 2.2  # TUNING (not in GDD)

## Leak: gate red flash s and colour, lives counter shake (px, s, real time).
const LEAK_FLASH_TIME: float = 0.5  # TUNING (not in GDD)
## See LEAK_FLASH_TIME.
const LEAK_TINT: Color = Color(1.0, 0.25, 0.2)  # TUNING (not in GDD)
## See LEAK_FLASH_TIME.
const LIVES_SHAKE_PX: float = 5.0  # TUNING (not in GDD)
## See LEAK_FLASH_TIME.
const LIVES_SHAKE_TIME: float = 0.4  # TUNING (not in GDD)

## --- Budget ------------------------------------------------------------------------

## Most TdVfx effects alive at once (Full / Reduced); the oldest is dropped beyond it.
const CAP: int = 160  # TUNING (not in GDD)
## See CAP.
const CAP_REDUCED: int = 70  # TUNING (not in GDD)
## Screen shake: largest offset (px) and how fast it decays (px per s).
const SHAKE_MAX: float = 8.0  # TUNING (not in GDD)
## See SHAKE_MAX.
const SHAKE_DECAY: float = 24.0  # TUNING (not in GDD)
