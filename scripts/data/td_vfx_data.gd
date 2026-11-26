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
	"archer": {"sprite": "projectiles/bone_spear", "scale": 2.0, "tint": Color(0.45, 1.0, 0.5), "trail": 85.0, "trail_w": 14.0,
		"halo": 7.0, "impact": "volley_hit", "impact_d": 64.0, "ring": false, "muzzle": 48.0},  # TUNING (not in GDD) 52 px bone arrow, bright green additive streak, splinter puff
	"mage": {"sprite": "projectiles/orb", "scale": 1.6, "tint": Color(0.78, 0.45, 1.0), "trail": 90.0, "trail_w": 18.0,
		"halo": 22.0, "impact": "bolt_impact", "impact_d": 0.0, "ring": true, "muzzle": 52.0},  # TUNING (not in GDD) glowing violet orb with a long spark trail, burst = real splash
	"frost_wraith": {"sprite": "projectiles/frost_bolt", "scale": 2.2, "tint": Color(0.5, 0.85, 1.0), "trail": 80.0, "trail_w": 14.0,
		"halo": 9.0, "impact": "frost_shatter", "impact_d": 80.0, "ring": true, "muzzle": 48.0},  # TUNING (not in GDD) 48 px ice shard, ice-blue streak, frost ring
	"corpse_catapult": {"sprite": "projectiles/corpse_boulder", "scale": 3.6, "tint": Color(0.95, 0.72, 0.45), "trail": 0.0, "trail_w": 0.0,
		"halo": 0.0, "impact": "bone_wall_burst", "impact_d": 0.0, "ring": true, "muzzle": 56.0},  # TUNING (not in GDD) 58 px tumbling boulder, dust ring + bone chips
	# --- Later towers (gw2-kit): one colour per class ---
	"warder": {"sprite": "projectiles/bone_spear", "scale": 1.7, "tint": Color(0.55, 0.95, 1.0), "trail": 70.0, "trail_w": 12.0,
		"halo": 8.0, "impact": "volley_hit", "impact_d": 56.0, "ring": false, "muzzle": 48.0},  # TUNING (not in GDD) ward-teal darts
	"rogue": {"sprite": "projectiles/bone_spear", "scale": 1.6, "tint": Color(1.0, 0.3, 0.38), "trail": 70.0, "trail_w": 12.0,
		"halo": 6.0, "impact": "volley_hit", "impact_d": 60.0, "ring": false, "muzzle": 40.0},  # TUNING (not in GDD) blood-red daggers
	"gargoyle": {"sprite": "projectiles/seraph_feather", "scale": 3.0, "tint": Color(0.72, 0.68, 1.0), "trail": 65.0, "trail_w": 12.0,
		"halo": 6.0, "impact": "volley_hit", "impact_d": 56.0, "ring": false, "muzzle": 44.0},  # TUNING (not in GDD) stone-violet shards
	"bone_hound": {"sprite": "projectiles/bone_spear", "scale": 1.6, "tint": Color(1.0, 0.82, 0.45), "trail": 60.0, "trail_w": 12.0,
		"halo": 6.0, "impact": "volley_hit", "impact_d": 56.0, "ring": false, "muzzle": 44.0},  # TUNING (not in GDD) bone-amber howl
	"fallen_seraph": {"sprite": "projectiles/seraph_feather", "scale": 3.2, "tint": Color(0.85, 0.4, 1.0), "trail": 80.0, "trail_w": 13.0,
		"halo": 9.0, "impact": "volley_hit", "impact_d": 60.0, "ring": false, "muzzle": 50.0},  # TUNING (not in GDD) 45 px black feathers, violet streaks
	"bone_golem": {"sprite": "projectiles/bone_spear", "scale": 1.6, "tint": Color(0.95, 0.9, 0.72), "trail": 60.0, "trail_w": 11.0,
		"halo": 0.0, "impact": "volley_hit", "impact_d": 52.0, "ring": false, "muzzle": 0.0},  # TUNING (not in GDD) its Lv3 bone shards
	# --- Act II, the Black Tide (w2b-tide) ---
	"powder_wraith": {"sprite": "projectiles/mortar_shell", "scale": 2.0, "tint": Color(1.0, 0.6, 0.25), "trail": 70.0, "trail_w": 12.0,
		"halo": 10.0, "impact": "corpse_explosion", "impact_d": 56.0, "ring": true, "muzzle": 0.0},  # TUNING (not in GDD) powder orange: its blasts (real radius ring) and burning shrapnel streaks
	"blood_spawn": {"sprite": "projectiles/bone_spear", "scale": 1.6, "tint": Color(1.0, 0.22, 0.3), "trail": 70.0, "trail_w": 12.0,
		"halo": 7.0, "impact": "volley_hit", "impact_d": 56.0, "ring": false, "muzzle": 0.0},  # TUNING (not in GDD) w2b-court: its Lv3 blood darts, crimson
	"fallen_hero": {"sprite": "volleys/wave", "scale": 2.0, "tint": Color(0.45, 0.65, 1.0), "trail": 70.0, "trail_w": 12.0,
		"halo": 8.0, "impact": "volley_hit", "impact_d": 60.0, "ring": false, "muzzle": 48.0},  # TUNING (not in GDD) hero-blue shockwaves (its slam draws golem_slam + a ring at the real radius)
	"bound_oni": {"sprite": "projectiles/bone_spear", "scale": 1.6, "tint": Color(1.0, 0.55, 0.4), "trail": 62.0, "trail_w": 11.0,
		"halo": 0.0, "impact": "volley_hit", "impact_d": 52.0, "ring": false, "muzzle": 0.0},  # TUNING (not in GDD) Act V: its Lv3 iron-red shards
	"draugr_thane": {"sprite": "projectiles/bone_spear", "scale": 1.6, "tint": Color(0.6, 0.85, 1.0), "trail": 62.0, "trail_w": 11.0,
		"halo": 0.0, "impact": "volley_hit", "impact_d": 52.0, "ring": false, "muzzle": 0.0},  # TUNING (not in GDD) Act VI: its Lv3 rime shards
	"ushabti_sentinel": {"sprite": "projectiles/bone_spear", "scale": 1.6, "tint": Color(0.95, 0.82, 0.5), "trail": 62.0, "trail_w": 11.0,
		"halo": 0.0, "impact": "volley_hit", "impact_d": 52.0, "ring": false, "muzzle": 0.0},  # TUNING (not in GDD) Act VII: its Lv3 sandstone shards
	"myrmidon_shade": {"sprite": "projectiles/bone_spear", "scale": 1.7, "tint": Color(0.55, 0.95, 0.85), "trail": 66.0, "trail_w": 10.0,
		"halo": 0.0, "impact": "volley_hit", "impact_d": 50.0, "ring": false, "muzzle": 0.0},  # TUNING (not in GDD) Act VIII: soul-teal spears (its Lv3 volley and the spear run-through streak)
	"bound_succubus": {"sprite": "projectiles/priest_bolt", "scale": 1.8, "tint": Color(1.0, 0.45, 0.8), "trail": 70.0, "trail_w": 10.0,
		"halo": 8.0, "impact": "volley_flash", "impact_d": 52.0, "ring": false, "muzzle": 44.0},  # TUNING (not in GDD) Act IX: charm-pink kisses
	"archfiend": {"sprite": "projectiles/bone_spear", "scale": 1.6, "tint": Color(1.0, 0.5, 0.2), "trail": 62.0, "trail_w": 11.0,
		"halo": 0.0, "impact": "volley_hit", "impact_d": 52.0, "ring": false, "muzzle": 0.0},  # TUNING (not in GDD) Act IX: its Lv3 hellfire shards
	"bound_ophan": {"sprite": "volleys/shard", "scale": 1.8, "tint": Color(0.55, 0.95, 0.9), "trail": 66.0, "trail_w": 11.0,
		"halo": 6.0, "impact": "volley_hit", "impact_d": 54.0, "ring": false, "muzzle": 44.0},  # TUNING (not in GDD) Act X: soul-teal (its roll draws a streak, golem_slam and a ring at the real width)
	# --- Act XI (w2d-eye) ---
	"spawn_of_the_deep": {"sprite": "volleys/shard", "scale": 1.7, "tint": Color(0.4, 0.9, 0.8), "trail": 64.0, "trail_w": 11.0,
		"halo": 0.0, "impact": "volley_hit", "impact_d": 52.0, "ring": false, "muzzle": 0.0},  # TUNING (not in GDD) drowned-teal barbs (its Grasp draws a tentacle streak and drowned_tendrils)
	# --- Act XII (w2d-empire) ---
	"grave_drone": {"sprite": "projectiles/scrap_bolt", "scale": 3.0, "tint": Color(0.7, 1.0, 0.75), "trail": 64.0, "trail_w": 8.0,
		"halo": 5.0, "impact": "volley_hit", "impact_d": 44.0, "ring": false, "muzzle": 40.0},  # TUNING (not in GDD) pale bone-green darts
	"iron_revenant": {"sprite": "projectiles/iron_shell", "scale": 2.2, "tint": Color(0.45, 1.0, 0.9), "trail": 80.0, "trail_w": 11.0,
		"halo": 7.0, "impact": "volley_hit", "impact_d": 60.0, "ring": false, "muzzle": 52.0},  # TUNING (not in GDD) soul-teal shells (Necropathy: "a soul-teal trail")
	# --- Act XIII, the Concord of Stars (w2d-concord) ---
	"ghost_saucer": {"sprite": "projectiles/radiant_bolt", "scale": 1.8, "tint": Color(1.0, 0.92, 0.55), "trail": 70.0, "trail_w": 11.0,
		"halo": 6.0, "impact": "beam_hit", "impact_d": 48.0, "ring": false, "muzzle": 46.0},  # TUNING (not in GDD) Act XIII: tractor gold (its beams draw a streak their real length, beam_hit on each foe)
	# --- Act XIV (w2d-titans) ---
	"bonehorn": {"sprite": "volleys/shard", "scale": 1.8, "tint": Color(0.95, 0.88, 0.7), "trail": 66.0, "trail_w": 11.0,
		"halo": 6.0, "impact": "volley_hit", "impact_d": 54.0, "ring": false, "muzzle": 44.0},  # TUNING (not in GDD) Act XIV: bone ochre (its charge draws a streak, golem_slam and a ring at the real width)
}
## Look of a class missing from SHOTS (same keys).
const SHOT_DEFAULT: Dictionary = {"sprite": "", "scale": 2.0, "tint": Color(1.0, 1.0, 1.0), "trail": 40.0, "trail_w": 6.0,
	"halo": 0.0, "impact": "volley_hit", "impact_d": 36.0, "ring": false, "muzzle": 28.0}  # TUNING (not in GDD)
## Volley shots (Lv3+ bursts, volleys/<id> masks): drawn size multiplier.
const VOLLEY_SCALE: float = 1.5  # TUNING (not in GDD)
## Volley shots: trail length (px) and thickness (px).
const VOLLEY_TRAIL: float = 60.0  # TUNING (not in GDD)
## See VOLLEY_TRAIL.
const VOLLEY_TRAIL_W: float = 11.0  # TUNING (not in GDD)
## Volley shots: impact burst diameter (px).
const VOLLEY_IMPACT_D: float = 44.0  # TUNING (not in GDD)
## Volley shots: px a shot is pushed sideways at launch so a burst visibly fans
## out (the push fades to 0 by the target; drawn only).
const VOLLEY_FAN: float = 26.0  # TUNING (not in GDD)
## Evolved (tier 6) towers: multiplier on shot size, trail, halo and impact.
const EVOLVED_MULT: float = 1.35  # TUNING (not in GDD) "a louder version"
## Seconds an impact burst plays.
const IMPACT_TIME: float = 0.45  # TUNING (not in GDD)
## Seconds a splash ring expands, and its start / end radius as a fraction of the splash.
const RING_TIME: float = 0.3  # TUNING (not in GDD)
## See RING_TIME.
const RING_FROM: float = 0.35  # TUNING (not in GDD)
## See RING_TIME.
const RING_TO: float = 1.05  # TUNING (not in GDD)
## Seconds a muzzle flash plays.
const MUZZLE_TIME: float = 0.22  # TUNING (not in GDD)
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
const LOB_SHADOW_R: float = 13.0  # TUNING (not in GDD)
## See LOB_SHADOW_R.
const LOB_SHADOW_A: float = 0.7  # TUNING (not in GDD)
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
const THREAD_TIME: float = 0.7  # TUNING (not in GDD)
## See THREAD_TINT.
const THREAD_W: float = 10.0  # TUNING (not in GDD)
## Diameter (px) of the sparkle on a healed body.
const HEAL_SPARKLE_D: float = 40.0  # TUNING (not in GDD)
## Pulse ring colour of the Mender (blockers) and of an enemy-hitting aura.
const MENDER_TINT: Color = Color(0.5, 1.0, 0.7, 0.8)  # TUNING (not in GDD)

## --- Melee (blocker posts) -----------------------------------------------------

## Body lunge toward its target: px at the peak and total s (out and back).
const LUNGE_PX: float = 9.0  # TUNING (not in GDD) lead review: 8-10 px
## See LUNGE_PX.
const LUNGE_TIME: float = 0.26  # TUNING (not in GDD)
## Fraction of LUNGE_TIME spent going out (the rest is the step back).
const LUNGE_OUT: float = 0.3  # TUNING (not in GDD)
## Warrior sword slash: diameter (px), seconds and colour; Death Knight colour.
const SLASH_D: float = 104.0  # TUNING (not in GDD)
## See SLASH_D.
const SLASH_TIME: float = 0.34  # TUNING (not in GDD)
## See SLASH_D.
const SLASH_TINT: Color = Color(1.0, 0.96, 0.72)  # TUNING (not in GDD) bright white-gold core
## See SLASH_D.
const SLASH_TINT_EVOLVED: Color = Color(0.6, 1.0, 0.75)  # TUNING (not in GDD) Death Knight's soul-green blade
## Coloured edge of the slash (drawn additively under the core, SLASH_EDGE_SCALE
## x the core's size); Death Knight edge.
const SLASH_EDGE: Color = Color(1.0, 0.55, 0.15, 0.95)  # TUNING (not in GDD) gold-orange rim
## See SLASH_EDGE.
const SLASH_EDGE_EVOLVED: Color = Color(0.3, 1.0, 0.55, 0.95)  # TUNING (not in GDD)
## See SLASH_EDGE.
const SLASH_EDGE_SCALE: float = 1.18  # TUNING (not in GDD)
## Slash timing: fraction of SLASH_TIME the crescent sweeps in, and the fraction
## it is held fully drawn (lead review: held ~0.15-0.2 s); the rest fades out.
const SLASH_SWEEP: float = 0.2  # TUNING (not in GDD)
## See SLASH_SWEEP.
const SLASH_HOLD: float = 0.5  # TUNING (not in GDD) 0.17 s of 0.34
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
const ENEMY_SLASH_D: float = 66.0  # TUNING (not in GDD)
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

## Status marks, in priority order (the first present sets the body tint;
## TdEnemy._status_mask() uses the same order for its bits);
## each has its tint and its icon index in td/vfx_status.png.
const STATUS_ORDER: Array[String] = ["frozen", "burning", "rot", "cursed", "weakened", "slowed", "charmed"]  # TUNING (not in GDD)
## Status -> body tint (components above 1 brighten).
const STATUS_TINT: Dictionary = {
	"frozen": Color(0.55, 0.85, 1.6),  # TUNING (not in GDD) clearly iced
	"burning": Color(1.35, 0.8, 0.55),  # TUNING (not in GDD)
	"rot": Color(0.8, 1.15, 0.65),  # TUNING (not in GDD)
	"cursed": Color(1.05, 0.75, 1.25),  # TUNING (not in GDD)
	"weakened": Color(1.0, 0.82, 1.15),  # TUNING (not in GDD)
	"slowed": Color(0.75, 0.92, 1.2),  # TUNING (not in GDD) chilled blue
	"charmed": Color(1.45, 0.7, 1.25),  # TUNING (not in GDD) w2c-inferno: charm pink (enemies and tempted blocker bodies)
}
## Status -> icon index (0..6) in td/vfx_status.png (7 icons of STATUS_ICON_PX).
const STATUS_ICON: Dictionary = {"burning": 0, "rot": 1, "cursed": 2, "slowed": 3, "frozen": 4, "weakened": 5, "charmed": 6}  # TUNING (not in GDD)
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
const LEAK_FLASH_TIME: float = 0.9  # TUNING (not in GDD)
## See LEAK_FLASH_TIME.
const LEAK_TINT: Color = Color(1.0, 0.25, 0.2)  # TUNING (not in GDD)
## See LEAK_FLASH_TIME.
const LIVES_SHAKE_PX: float = 5.0  # TUNING (not in GDD)
## See LEAK_FLASH_TIME.
const LIVES_SHAKE_TIME: float = 0.8  # TUNING (not in GDD)

## Trails: the white core streak drawn over the coloured one (fraction of the
## width and of the length) and its alpha.
const TRAIL_CORE_W: float = 0.35  # TUNING (not in GDD)
## See TRAIL_CORE_W.
const TRAIL_CORE_LEN: float = 0.6  # TUNING (not in GDD)
## See TRAIL_CORE_W.
const TRAIL_CORE_A: float = 0.9  # TUNING (not in GDD)
## Seconds a shot's trail lingers and fades where it landed (so a still frame
## catches more of them; drawn only).
const TRAIL_LINGER: float = 0.22  # TUNING (not in GDD)
## Additive glow at the head of a shot: radius as a multiple of the trail width.
const HEAD_GLOW: float = 0.9  # TUNING (not in GDD)
## Effect strips that are grey masks (drawn additively, tinted); the others
## are coloured art drawn normally.
const MASK_STRIPS: Array[String] = ["volley_hit", "volley_flash"]  # TUNING (not in GDD)

## --- Spells (TdVfx.cast) ------------------------------------------------------------

## Per spell id: tint, cast flash diameter (px) at the necromancer, target
## strip (effects/<id>, "" = none) and its diameter (px), target ring end
## radius (px; 0 = none), shake (px).
const SPELLS: Dictionary = {
	"shadow_bolt": {"tint": Color(0.75, 0.45, 1.0), "flash": 96.0, "strip": "", "strip_d": 0.0, "ring": 0.0, "shake": 0.0},  # TUNING (not in GDD)
	"bone_wall": {"tint": Color(0.95, 0.9, 0.75), "flash": 96.0, "strip": "bone_wall_burst", "strip_d": 140.0, "ring": 70.0, "shake": 2.0},  # TUNING (not in GDD)
	"corpse_explosion": {"tint": Color(1.0, 0.35, 0.3), "flash": 96.0, "strip": "volley_flash", "strip_d": 120.0, "ring": 90.0, "shake": 3.0},  # TUNING (not in GDD)
	"plague_cloud": {"tint": Color(0.6, 1.0, 0.35), "flash": 96.0, "strip": "volley_hit", "strip_d": 150.0, "ring": 100.0, "shake": 0.0},  # TUNING (not in GDD)
	"dread_rally": {"tint": Color(0.5, 1.0, 0.85), "flash": 180.0, "strip": "evolution", "strip_d": 260.0, "ring": 320.0, "shake": 5.0},  # TUNING (not in GDD)
	# --- Later spells and ultimates (gw2-kit; Necropathy effect strips) ---
	"death_mark": {"tint": Color(1.0, 0.3, 0.25), "flash": 96.0, "strip": "doom_burst", "strip_d": 110.0, "ring": 60.0, "shake": 0.0},  # TUNING (not in GDD)
	"soul_chains": {"tint": Color(0.45, 0.9, 1.0), "flash": 96.0, "strip": "soul_lightning", "strip_d": 140.0, "ring": 110.0, "shake": 1.5},  # TUNING (not in GDD)
	"wither": {"tint": Color(0.7, 0.95, 0.35), "flash": 96.0, "strip": "wither_aura", "strip_d": 240.0, "ring": 120.0, "shake": 0.0},  # TUNING (not in GDD) ring = the aura's real radius
	"raise_dead": {"tint": Color(0.6, 1.0, 0.75), "flash": 96.0, "strip": "raise_dead", "strip_d": 130.0, "ring": 60.0, "shake": 2.0},  # TUNING (not in GDD)
	"sovereigns_decree": {"tint": Color(1.0, 0.85, 0.4), "flash": 180.0, "strip": "sovereigns_decree", "strip_d": 300.0, "ring": 320.0, "shake": 4.0},  # TUNING (not in GDD)
	"eclipse": {"tint": Color(0.55, 0.4, 1.0), "flash": 180.0, "strip": "eclipse", "strip_d": 360.0, "ring": 420.0, "shake": 5.0},  # TUNING (not in GDD)
	"grave_tide": {"tint": Color(0.45, 1.0, 0.7), "flash": 180.0, "strip": "grave_tide", "strip_d": 300.0, "ring": 320.0, "shake": 4.0},  # TUNING (not in GDD)
	# --- Act II, the Black Tide (w2b-tide) ---
	"chain_shot": {"tint": Color(0.55, 1.0, 0.8), "flash": 96.0, "strip": "volley_hit", "strip_d": 90.0, "ring": 50.0, "shake": 1.5},  # TUNING (not in GDD) pale spectral green (Necropathy's chain-shot)
	"cannonade": {"tint": Color(1.0, 0.65, 0.25), "flash": 96.0, "strip": "volley_flash", "strip_d": 100.0, "ring": 70.0, "shake": 2.0},  # TUNING (not in GDD) cannon fire amber
	"anchor_drop": {"tint": Color(0.5, 0.95, 0.85), "flash": 96.0, "strip": "tide_splash", "strip_d": 130.0, "ring": 64.0, "shake": 3.0},  # TUNING (not in GDD) ring = the shock's real radius
	# --- Act III spells (w2b-court) ---
	"moonfang": {"tint": Color(0.82, 0.86, 1.0), "flash": 96.0, "strip": "volley_flash", "strip_d": 110.0, "ring": 50.0, "shake": 2.0},  # TUNING (not in GDD) moon-silver; ring = a jaw's real radius
	"witch_circle": {"tint": Color(1.0, 0.2, 0.35), "flash": 96.0, "strip": "volley_hit", "strip_d": 170.0, "ring": 80.0, "shake": 0.0},  # TUNING (not in GDD) crimson; ring = the circle's real radius
	"night_swarm": {"tint": Color(0.5, 1.0, 0.9), "flash": 96.0, "strip": "volley_flash", "strip_d": 120.0, "ring": 46.0, "shake": 0.0},  # TUNING (not in GDD) spectral soul-teal bats
	# --- Act IV spells (w2b-city) ---
	"hearse_run": {"tint": Color(0.55, 0.95, 0.9), "flash": 96.0, "strip": "summon_rise", "strip_d": 110.0, "ring": 50.0, "shake": 1.0},  # TUNING (not in GDD) spectral teal
	"bone_mines": {"tint": Color(0.8, 0.5, 1.0), "flash": 96.0, "strip": "bone_wall_rise", "strip_d": 90.0, "ring": 50.0, "shake": 0.0},  # TUNING (not in GDD) violet lamps
	"heros_fist": {"tint": Color(0.45, 0.65, 1.0), "flash": 96.0, "strip": "", "strip_d": 0.0, "ring": 0.0, "shake": 0.0},  # TUNING (not in GDD) its own fist, slam and ring
	# --- Act V spells (w2b-shogun) ---
	"hundred_shadows": {"tint": Color(0.7, 0.45, 1.0), "flash": 96.0, "strip": "spore_cloud", "strip_d": 120.0, "ring": 60.0, "shake": 0.0},  # TUNING (not in GDD) violet shadow strikes
	"banner_of_the_dead": {"tint": Color(1.0, 0.35, 0.3), "flash": 96.0, "strip": "volley_flash", "strip_d": 120.0, "ring": 170.0, "shake": 1.5},  # TUNING (not in GDD) ring = its real reach
	"black_sun": {"tint": Color(0.75, 0.35, 1.0), "flash": 120.0, "strip": "eclipse", "strip_d": 160.0, "ring": 150.0, "shake": 2.0},  # TUNING (not in GDD) ring = its real reach
	# --- Act VI spells (w2c-norse) ---
	"barrow_grasp": {"tint": Color(0.55, 0.85, 1.0), "flash": 110.0, "strip": "frost_nova", "strip_d": 150.0, "ring": 95.0, "shake": 1.5},  # TUNING (not in GDD) ring = the hands' real reach (ring + radius)
	"valkyrie_spear": {"tint": Color(1.0, 0.88, 0.5), "flash": 96.0, "strip": "volley_flash", "strip_d": 110.0, "ring": 160.0, "shake": 1.0},  # TUNING (not in GDD) ring = its real seek range
	"gungnir": {"tint": Color(0.8, 0.95, 1.0), "flash": 120.0, "strip": "soul_lightning", "strip_d": 140.0, "ring": 180.0, "shake": 3.0},  # TUNING (not in GDD) ring = its real aim radius
	# --- Act VII spells (w2c-dynasty) ---
	"linen_bind": {"tint": Color(0.92, 0.88, 0.75), "flash": 96.0, "strip": "summon_rise", "strip_d": 120.0, "ring": 120.0, "shake": 0.0},  # TUNING (not in GDD) linen white; ring = its real reach
	"burning_eye": {"tint": Color(1.0, 0.7, 0.25), "flash": 120.0, "strip": "holy_impact", "strip_d": 120.0, "ring": 0.0, "shake": 1.0},  # TUNING (not in GDD) solar orange (its beam draws itself)
	"feathers_verdict": {"tint": Color(1.0, 0.86, 0.35), "flash": 96.0, "strip": "", "strip_d": 0.0, "ring": 160.0, "shake": 0.0},  # TUNING (not in GDD) true gold; ring = its search reach
	# --- Act VIII spells (w2c-pantheon) ---
	"paris_arrow": {"tint": Color(1.0, 0.85, 0.45), "flash": 80.0, "strip": "volley_flash", "strip_d": 90.0, "ring": 90.0, "shake": 1.0},  # TUNING (not in GDD) gold fated arrow; ring = its pick reach
	"stolen_thunder": {"tint": Color(0.75, 0.85, 1.0), "flash": 120.0, "strip": "soul_lightning", "strip_d": 160.0, "ring": 150.0, "shake": 2.5},  # TUNING (not in GDD) ring = its real reach
	"river_styx": {"tint": Color(0.35, 0.75, 0.85), "flash": 90.0, "strip": "tide_splash", "strip_d": 160.0, "ring": 60.0, "shake": 0.0},  # TUNING (not in GDD) Styx teal
	# --- Act IX spells (w2c-inferno) ---
	"brimstone": {"tint": Color(1.0, 0.5, 0.15), "flash": 110.0, "strip": "corpse_explosion", "strip_d": 140.0, "ring": 140.0, "shake": 2.0},  # TUNING (not in GDD) ring = its real reach
	"tempt": {"tint": Color(1.0, 0.45, 0.8), "flash": 96.0, "strip": "volley_flash", "strip_d": 120.0, "ring": 150.0, "shake": 0.0},  # TUNING (not in GDD) charm pink, ring = its real reach
	"fall_from_grace": {"tint": Color(1.0, 0.9, 0.55), "flash": 120.0, "strip": "holy_impact", "strip_d": 140.0, "ring": 170.0, "shake": 1.5},  # TUNING (not in GDD) fallen gold, ring = its real reach
	# --- Act X spells (w2c-host) ---
	"flaming_sword": {"tint": Color(0.92, 0.96, 1.0), "flash": 96.0, "strip": "", "strip_d": 0.0, "ring": 90.0, "shake": 1.0},  # TUNING (not in GDD) white fire; ring = its real reach (the sweep draws itself)
	"wheel_of_eyes": {"tint": Color(0.55, 0.8, 1.0), "flash": 96.0, "strip": "volley_flash", "strip_d": 70.0, "ring": 0.0, "shake": 0.0},  # TUNING (not in GDD) cerulean fire (the wheel draws itself)
	"revelation": {"tint": Color(1.0, 1.0, 0.95), "flash": 120.0, "strip": "holy_impact", "strip_d": 200.0, "ring": 170.0, "shake": 2.0},  # TUNING (not in GDD) ring = its real reach
	# --- Act XI spells (w2d-eye) ---
	"undertow": {"tint": Color(0.4, 0.9, 0.95), "flash": 96.0, "strip": "tide_splash", "strip_d": 90.0, "ring": 0.0, "shake": 1.0},  # TUNING (not in GDD) sea teal (the crest draws itself)
	"forbidden_verse": {"tint": Color(0.75, 0.45, 1.0), "flash": 96.0, "strip": "ink_burst", "strip_d": 120.0, "ring": 110.0, "shake": 0.0},  # TUNING (not in GDD) ink violet; ring = its real reach
	"call_of_the_drowned": {"tint": Color(0.35, 0.95, 0.8), "flash": 96.0, "strip": "drowned_tendrils", "strip_d": 100.0, "ring": 150.0, "shake": 1.5},  # TUNING (not in GDD) drowned teal; ring = its real reach
	# --- Act XII spells (w2d-empire) ---
	"death_ray": {"tint": Color(0.75, 0.55, 1.0), "flash": 96.0, "strip": "beam_hit", "strip_d": 90.0, "ring": 150.0, "shake": 1.0},  # TUNING (not in GDD) violet soul laser; ring = its real reach (the beam draws itself)
	"hollow_puppet": {"tint": Color(0.74, 0.46, 0.96), "flash": 80.0, "strip": "volley_flash", "strip_d": 90.0, "ring": 130.0, "shake": 0.0},  # TUNING (not in GDD) soul-string violet; ring = its real reach
	"scrap_swarm": {"tint": Color(0.8, 0.6, 1.0), "flash": 80.0, "strip": "empire_blast_chrome", "strip_d": 90.0, "ring": 70.0, "shake": 0.0},  # TUNING (not in GDD) the drones' orbit ring
	# --- Act XIII, the Concord of Stars (w2d-concord) ---
	"bone_beetles": {"tint": Color(0.85, 0.95, 0.7), "flash": 80.0, "strip": "spore_cloud", "strip_d": 90.0, "ring": 0.0, "shake": 0.0},  # TUNING (not in GDD) bone-white beetles (they draw themselves)
	"soul_caster": {"tint": Color(0.45, 1.0, 0.9), "flash": 90.0, "strip": "beam_hit", "strip_d": 70.0, "ring": 0.0, "shake": 1.0},  # TUNING (not in GDD) soul-teal locks and shots
	"tractor_lift": {"tint": Color(0.75, 1.0, 0.85), "flash": 100.0, "strip": "golem_slam", "strip_d": 120.0, "ring": 60.0, "shake": 2.0},  # TUNING (not in GDD) ring = the slam's real reach
	# --- Act XIV spells (w2d-titans) ---
	"pack_leap": {"tint": Color(0.75, 1.0, 0.9), "flash": 90.0, "strip": "volley_hit", "strip_d": 90.0, "ring": 130.0, "shake": 1.0},  # TUNING (not in GDD) soul-teal raptors; ring = its real reach
	"stampede": {"tint": Color(0.95, 0.85, 0.6), "flash": 90.0, "strip": "golem_slam", "strip_d": 80.0, "ring": 0.0, "shake": 1.5},  # TUNING (not in GDD) bone ochre (the herd draws itself)
	"meteor_call": {"tint": Color(1.0, 0.55, 0.25), "flash": 110.0, "strip": "", "strip_d": 0.0, "ring": 0.0, "shake": 0.0},  # TUNING (not in GDD) the meteor's own circle and impact draw themselves
}
## Act III spells' own looks (w2b-court; drawn only): Moonfang's jaw strip
## diameter as a multiple of its bite radius; Hex Circle's disc alpha and pulse
## period (s); Night Swarm's bat tint, drawn size multiplier and dart streak width (px).
const COURT_JAW_D: float = 2.4  # TUNING (not in GDD)
## See COURT_JAW_D.
const COURT_CIRCLE_A: float = 0.45  # TUNING (not in GDD)
## See COURT_JAW_D.
const COURT_CIRCLE_PERIOD: float = 0.5  # TUNING (not in GDD) one pulse per drain tick
## See COURT_JAW_D.
const COURT_BAT_TINT: Color = Color(0.55, 1.1, 1.0, 0.9)  # TUNING (not in GDD) spectral bats
## See COURT_JAW_D.
const COURT_BAT_SCALE: float = 0.8  # TUNING (not in GDD)
## See COURT_JAW_D.
const COURT_DART_W: float = 8.0  # TUNING (not in GDD)
## Blood Spawn: the drink sparkle's diameter (px) and tint on the striking body (Nosferatu's spill thread too).
const COURT_DRINK_D: float = 40.0  # TUNING (not in GDD)
## See COURT_DRINK_D.
const COURT_DRINK_TINT: Color = Color(1.0, 0.2, 0.3)  # TUNING (not in GDD)
## Seconds a cast flash and its target ring play.
const CAST_TIME: float = 0.45  # TUNING (not in GDD)
## Shadow Bolt in flight: drawn scale, trail length (px) and width (px); its impact burst diameter (px).
const BOLT_SCALE: float = 2.2  # TUNING (not in GDD)
## See BOLT_SCALE.
const BOLT_TRAIL: float = 90.0  # TUNING (not in GDD)
## See BOLT_SCALE.
const BOLT_TRAIL_W: float = 16.0  # TUNING (not in GDD)
## See BOLT_SCALE.
const BOLT_IMPACT_D: float = 120.0  # TUNING (not in GDD)

## --- Damage numbers (Settings > Damage numbers, off by default) ----------------------

## Most numbers on screen (pooled; the oldest is reused).
const NUMBERS_MAX: int = 24  # TUNING (not in GDD)
## Seconds a number floats and px it rises.
const NUMBER_TIME: float = 0.7  # TUNING (not in GDD)
## See NUMBER_TIME.
const NUMBER_RISE: float = 26.0  # TUNING (not in GDD)
## Font size (px; a UiTheme tier) and colours: normal, big (>= NUMBER_BIG damage).
const NUMBER_FONT: int = 19  # TUNING (not in GDD) UiTheme BODY tier
## See NUMBER_FONT.
const NUMBER_TINT: Color = Color(1.0, 0.95, 0.85)  # TUNING (not in GDD)
## See NUMBER_FONT.
const NUMBER_BIG_TINT: Color = Color(1.0, 0.75, 0.3)  # TUNING (not in GDD)
## See NUMBER_FONT.
const NUMBER_BIG: float = 40.0  # TUNING (not in GDD)
## Hits below this damage show no number (chip damage would only clutter).
const NUMBER_MIN: float = 1.0  # TUNING (not in GDD)

## --- Budget ------------------------------------------------------------------------

## Most TdVfx effects alive at once (Full / Reduced); the oldest is dropped beyond it.
const CAP: int = 160  # TUNING (not in GDD)
## See CAP.
const CAP_REDUCED: int = 70  # TUNING (not in GDD)
## Screen shake: largest offset (px) and how fast it decays (px per s).
const SHAKE_MAX: float = 8.0  # TUNING (not in GDD)
## See SHAKE_MAX.
const SHAKE_DECAY: float = 24.0  # TUNING (not in GDD)

## --- Later towers, spells and ultimates (gw2-kit, DECISIONS K12) -------------------

## Temporary Risen (TempBlockers): slash diameter (px), slash tint, body tint.
const KIT_RISEN_SLASH_D: float = 78.0  # TUNING (not in GDD)
## See KIT_RISEN_SLASH_D.
const KIT_RISEN_TINT: Color = Color(0.6, 1.0, 0.75)  # TUNING (not in GDD) soul-green (the Lich's Risen look)
## See KIT_RISEN_SLASH_D.
const KIT_RISEN_BODY: Color = Color(0.85, 1.05, 0.9)  # TUNING (not in GDD)
## Warder barrier: shell sprite drawn over a warded body, its tint (alpha = strength) and size (px).
const KIT_BARRIER_TINT: Color = Color(0.55, 0.95, 1.0, 0.8)  # TUNING (not in GDD) ward-teal
## See KIT_BARRIER_TINT.
const KIT_BARRIER_D: float = 46.0  # TUNING (not in GDD)
## Warder ward thread width (px) and how long it shows (s).
const KIT_WARD_THREAD_W: float = 9.0  # TUNING (not in GDD)
## See KIT_WARD_THREAD_W.
const KIT_WARD_THREAD_T: float = 0.6  # TUNING (not in GDD)
## Rogue dash: trail width (px), slash diameter (px) at the victim, tint (blood red).
const KIT_DASH_W: float = 18.0  # TUNING (not in GDD)
## See KIT_DASH_W.
const KIT_DASH_SLASH_D: float = 96.0  # TUNING (not in GDD)
## See KIT_DASH_W.
const KIT_DASH_TINT: Color = Color(1.0, 0.3, 0.38)  # TUNING (not in GDD)
## Rogue: drawn scale of the body while it dashes (a stretched lunge; visual only).
const KIT_DASH_STRETCH: float = 1.25  # TUNING (not in GDD)
## Gargoyle: px it flies above its circle (shadow below), landing ring tint, dive trail width (px).
const KIT_FLY_LIFT: float = 22.0  # TUNING (not in GDD)
## See KIT_FLY_LIFT.
const KIT_SWOOP_TINT: Color = Color(0.72, 0.68, 1.0)  # TUNING (not in GDD) stone-violet
## See KIT_FLY_LIFT.
const KIT_SWOOP_W: float = 20.0  # TUNING (not in GDD)
## Gargoyle / any flyer: ground shadow radius (px) and alpha.
const KIT_SHADOW_R: float = 12.0  # TUNING (not in GDD)
## See KIT_SHADOW_R.
const KIT_SHADOW_A: float = 0.55  # TUNING (not in GDD)
## Bone Hounds: bite slash diameter (px) and tint; Hellhound fire tint; trail width (px).
const KIT_BITE_D: float = 58.0  # TUNING (not in GDD)
## See KIT_BITE_D.
const KIT_BITE_TINT: Color = Color(1.0, 0.85, 0.5)  # TUNING (not in GDD) bone amber
## See KIT_BITE_D.
const KIT_HELL_TINT: Color = Color(1.0, 0.45, 0.15)  # TUNING (not in GDD)
## See KIT_BITE_D.
const KIT_HOUND_TRAIL_W: float = 10.0  # TUNING (not in GDD)
## Fallen Seraph (Seraph of Ruin): ruin dive burst diameter (x its real radius) tint.
const KIT_RUIN_TINT: Color = Color(1.0, 0.5, 0.3)  # TUNING (not in GDD)
## Bone Golem: slam strip diameter (px), planted tint on its body.
const KIT_SLAM_D: float = 130.0  # TUNING (not in GDD)
## See KIT_SLAM_D.
const KIT_PLANT_TINT: Color = Color(0.85, 0.9, 1.25)  # TUNING (not in GDD) a grey-blue set stone
## Death Mark: brand sigil size (px) over a branded foe; Soul Chains link thread width (px).
const KIT_BRAND_PX: float = 18.0  # TUNING (not in GDD)
## See KIT_BRAND_PX.
const KIT_CHAIN_W: float = 10.0  # TUNING (not in GDD)
## Wither: aura strip loop period (s) and alpha.
const KIT_WITHER_PERIOD: float = 1.2  # TUNING (not in GDD)
## See KIT_WITHER_PERIOD.
const KIT_WITHER_A: float = 0.6  # TUNING (not in GDD)

## --- Act II, the Black Tide (w2b-tide): spell and act-tower looks ---------------------
## Chain Shot: impact burst (px), the balls' whirl speed (rad/s) and half-chain (px),
## trail length / width (px), chain width (px), balls' draw scale and tint.
const TIDE_CHAIN_HIT_D: float = 56.0  # TUNING (not in GDD)
## See TIDE_CHAIN_HIT_D.
const TIDE_CHAIN_SPIN: float = 18.0  # TUNING (not in GDD)
## See TIDE_CHAIN_HIT_D.
const TIDE_CHAIN_ARM: float = 12.0  # TUNING (not in GDD)
## See TIDE_CHAIN_HIT_D.
const TIDE_CHAIN_TRAIL: float = 70.0  # TUNING (not in GDD)
## See TIDE_CHAIN_HIT_D.
const TIDE_CHAIN_TRAIL_W: float = 14.0  # TUNING (not in GDD)
## See TIDE_CHAIN_HIT_D.
const TIDE_CHAIN_LINK_W: float = 5.0  # TUNING (not in GDD)
## See TIDE_CHAIN_HIT_D.
const TIDE_BALL_SCALE: float = 1.2  # TUNING (not in GDD)
## See TIDE_CHAIN_HIT_D.
const TIDE_BALL_TINT: Color = Color(0.8, 1.0, 0.9)  # TUNING (not in GDD) spectral iron
## Cannonade / Anchor Drop: px the ball / anchor falls from (drawn only) and their draw scales.
const TIDE_FALL_H: float = 260.0  # TUNING (not in GDD)
## See TIDE_FALL_H.
const TIDE_CANNONBALL_SCALE: float = 2.0  # TUNING (not in GDD)
## See TIDE_FALL_H.
const TIDE_ANCHOR_SCALE: float = 1.6  # TUNING (not in GDD)
## Powder Wraith: shrapnel flash (px), fuse flicker rate (Hz) and its lit tint.
const TIDE_SHRAPNEL_FLASH: float = 48.0  # TUNING (not in GDD)
## See TIDE_SHRAPNEL_FLASH.
const TIDE_FUSE_HZ: float = 12.0  # TUNING (not in GDD)
## See TIDE_SHRAPNEL_FLASH.
const TIDE_FUSE_TINT: Color = Color(1.7, 1.3, 0.9)  # TUNING (not in GDD)
## --- Act IV, the Last Line (w2b-city): vehicles, Supers, bosses, the Fallen Hero, the act spells ---

## A vehicle crashing through a post: burst diameter (px), its s, the shake (px).
const CITY_CRASH_D: float = 96.0  # TUNING (not in GDD)
## See CITY_CRASH_D.
const CITY_CRASH_TIME: float = 0.4  # TUNING (not in GDD)
## See CITY_CRASH_D.
const CITY_CRASH_SHAKE: float = 2.0  # TUNING (not in GDD)
## A Super's power / a boss's call: burst diameter (px) and s.
const CITY_POWER_D: float = 90.0  # TUNING (not in GDD)
## See CITY_POWER_D.
const CITY_POWER_TIME: float = 0.45  # TUNING (not in GDD)
## Blitz's dash flash (hero orange) and Big Sal's whistle (gang neon pink).
const CITY_HERO_TINT: Color = Color(0.94, 0.48, 0.12)  # TUNING (not in GDD) Necropathy CITY_HERO_ORANGE
## See CITY_HERO_TINT.
const CITY_GANG_TINT: Color = Color(1.0, 0.31, 0.66)  # TUNING (not in GDD) Necropathy CITY_NEON_PINK
## Nightjar's smoke bomb: s and tint of its cloud (drawn at the real radius).
const CITY_SMOKE_TIME: float = 1.2  # TUNING (not in GDD)
## See CITY_SMOKE_TIME.
const CITY_SMOKE_TINT: Color = Color(0.55, 0.55, 0.62)  # TUNING (not in GDD)
## Broken Arrow's strike: s of its blast and the shake (px).
const CITY_STRIKE_TIME: float = 0.8  # TUNING (not in GDD)
## See CITY_STRIKE_TIME.
const CITY_STRIKE_SHAKE: float = 6.0  # TUNING (not in GDD)
## Paragon's eyes above his feet (px), the aim line width (px) and tint, the
## beam width (px), its s and tint; his landing crack's scale.
const CITY_EYES: Vector2 = Vector2(0, -42)  # TUNING (not in GDD)
## See CITY_EYES.
const CITY_HEAT_AIM_W: float = 3.0  # TUNING (not in GDD)
## See CITY_EYES.
const CITY_HEAT_AIM_TINT: Color = Color(1.0, 0.25, 0.15, 0.6)  # TUNING (not in GDD)
## See CITY_EYES.
const CITY_HEAT_W: float = 16.0  # TUNING (not in GDD)
## See CITY_EYES.
const CITY_HEAT_TIME: float = 0.45  # TUNING (not in GDD)
## See CITY_EYES.
const CITY_HEAT_TINT: Color = Color(1.0, 0.35, 0.2)  # TUNING (not in GDD)
## See CITY_EYES.
const CITY_CRATER: float = 1.2  # TUNING (not in GDD)
## The Fallen Hero's colour (trail, rings, chain line), the chain line width (px) and s.
const KIT_HERO_TINT: Color = Color(0.45, 0.65, 1.0)  # TUNING (not in GDD) hero blue (not the Gargoyle's violet)
## See KIT_HERO_TINT.
const KIT_HERO_CHAIN_W: float = 8.0  # TUNING (not in GDD)
## See KIT_HERO_TINT.
const KIT_HERO_CHAIN_TIME: float = 0.4  # TUNING (not in GDD)
## Hearse Run: its sprite, hit burst diameter (px), fade-in / out fraction of
## the drive, drawn offset (px) and alpha.
const CITY_HEARSE_SPRITE: String = "projectiles/spectral_hearse"
## See CITY_HEARSE_SPRITE.
const CITY_HEARSE_HIT_D: float = 56.0  # TUNING (not in GDD)
## See CITY_HEARSE_SPRITE.
const CITY_HEARSE_FADE: float = 0.15  # TUNING (not in GDD)
## See CITY_HEARSE_SPRITE.
const CITY_HEARSE_LIFT: float = -6.0  # TUNING (not in GDD)
## See CITY_HEARSE_SPRITE.
const CITY_HEARSE_ALPHA: float = 0.85  # TUNING (not in GDD) Necropathy draws it faded
## Bone Mines: its sprite, the lamp's blink (Hz) and radius (px).
const CITY_MINE_SPRITE: String = "spells/bone_mine"
## See CITY_MINE_SPRITE.
const CITY_MINE_BLINK_HZ: float = 0.8  # TUNING (not in GDD)
## See CITY_MINE_SPRITE.
const CITY_MINE_LAMP_R: float = 3.0  # TUNING (not in GDD)
## Hero's Fist: s it falls, s it lingers after landing, px it falls from, half size (px).
const CITY_FIST_FALL: float = 0.22  # TUNING (not in GDD)
## See CITY_FIST_FALL.
const CITY_FIST_LINGER: float = 0.3  # TUNING (not in GDD)
## See CITY_FIST_FALL.
const CITY_FIST_DROP: float = 140.0  # TUNING (not in GDD)
## See CITY_FIST_FALL.
const CITY_FIST_PX: float = 24.0  # TUNING (not in GDD)
