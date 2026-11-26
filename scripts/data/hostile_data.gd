## HostileData: numbers and looks of enemy fire at the necromancer's side
## (HostileFire: hostile shots stopped by blockers and Bone Walls, telegraphed
## shelling of spots) and of the tower disable path (TdCombat.disable_tower).
## Used by later acts' gimmicks (GDD §7.3: Broadsides, Line of Fire,
## Stampedes). Data only, no logic.
class_name HostileData
extends RefCounted

## --- Hostile shots ---------------------------------------------------------------
## Default shot speed (px/s) when the firer's args give none.
const SHOT_SPEED: float = 300.0  # TUNING (not in GDD)
## Px from a shot's path within which a living blocker / Bone Wall body stops it.
const BLOCK_RADIUS: float = 16.0  # TUNING (not in GDD)
## Most hostile shots in flight at once (pool size; extra shots are not fired).
const SHOT_CAP: int = 96  # TUNING (not in GDD)
## Shot looks: look id -> {sprite: SpriteData key (drawn flat, rotated), tint:
## trail / impact Color (enemy fire reads red-orange), scale: drawn size x,
## trail: trail length px, impact: burst diameter px}.
const LOOKS: Dictionary = {
	"arrow": {"sprite": "projectiles/enemy_arrow", "tint": Color(1.0, 0.45, 0.3), "scale": 2.0, "trail": 64.0, "impact": 56.0},  # TUNING (not in GDD)
	"bolt": {"sprite": "projectiles/radiant_bolt", "tint": Color(1.0, 0.3, 0.25), "scale": 2.2, "trail": 72.0, "impact": 64.0},  # TUNING (not in GDD)
	"shell": {"sprite": "projectiles/corpse_boulder", "tint": Color(1.0, 0.55, 0.25), "scale": 1.6, "trail": 0.0, "impact": 90.0},  # TUNING (not in GDD)
	# --- Act II, the Black Tide (w2b-tide) ---
	"musket": {"sprite": "projectiles/iron_shell", "scale": 1.0, "tint": Color(1.0, 0.55, 0.3), "trail": 60.0, "impact": 48.0},  # TUNING (not in GDD) a musket ball
	"hook": {"sprite": "corsair/grapple_hook", "scale": 1.0, "tint": Color(0.85, 0.7, 0.45), "trail": 70.0, "impact": 56.0},  # TUNING (not in GDD) the Grappler's hook, a rope-tan trail
	"grenado": {"sprite": "projectiles/mortar_shell", "scale": 1.4, "tint": Color(1.0, 0.6, 0.25), "trail": 0.0, "impact": 80.0},  # TUNING (not in GDD) the Gunnery Mate's lob
	"cannon": {"sprite": "projectiles/iron_shell", "scale": 1.8, "tint": Color(1.0, 0.5, 0.25), "trail": 0.0, "impact": 90.0},  # TUNING (not in GDD) a gunboat's shell
	"spit": {"sprite": "projectiles/radiant_bolt", "scale": 2.2, "tint": Color(0.4, 0.85, 0.75), "trail": 72.0, "impact": 64.0},  # TUNING (not in GDD) the sea serpent's spit (serpent teal)
	"spectral": {"sprite": "projectiles/radiant_bolt", "scale": 2.0, "tint": Color(0.45, 1.0, 0.8), "trail": 72.0, "impact": 60.0},  # TUNING (not in GDD) the ghost crew's and Vandermere's lantern shots
	"bullet": {"sprite": "projectiles/priest_bolt", "tint": Color(0.91, 0.64, 0.23), "scale": 1.4, "trail": 60.0, "impact": 44.0},  # TUNING (not in GDD) Act IV gunfire, sodium yellow
	"flashbang": {"sprite": "projectiles/mortar_shell", "tint": Color(0.85, 0.85, 1.0), "scale": 2.0, "trail": 0.0, "impact": 110.0},  # TUNING (not in GDD) Act IV SWAT flashbang, a white pop
	"gaze": {"sprite": "projectiles/radiant_bolt", "tint": Color(0.55, 0.95, 0.45), "scale": 2.0, "trail": 80.0, "impact": 60.0},  # TUNING (not in GDD) Act VIII: the Gorgon's gaze, a venom-green streak
	"ghost_arrow": {"sprite": "projectiles/enemy_arrow", "tint": Color(0.55, 0.85, 1.0), "scale": 2.0, "trail": 70.0, "impact": 52.0},  # TUNING (not in GDD) Act VIII: the Shade Archer's pale arrow
	"teppo": {"sprite": "projectiles/priest_bolt", "tint": Color(1.0, 0.85, 0.55), "scale": 1.6, "trail": 80.0, "impact": 48.0},  # TUNING (not in GDD) Act V arquebus ball, a powder-white streak
	"boulder": {"sprite": "projectiles/corpse_boulder", "tint": Color(0.75, 0.9, 1.0), "scale": 1.9, "trail": 0.0, "impact": 96.0},  # TUNING (not in GDD) Act VI frost giant's ice-crusted boulder
	"gungnir": {"sprite": "projectiles/bone_spear", "tint": Color(0.8, 0.95, 1.0), "scale": 2.6, "trail": 90.0, "impact": 80.0},  # TUNING (not in GDD) Act VI Odin's spear of soul-light
	"feather": {"sprite": "projectiles/seraph_feather", "tint": Color(1.0, 0.55, 0.25), "scale": 1.6, "trail": 70.0, "impact": 52.0},  # TUNING (not in GDD) w2c-inferno: the Seraph General's burnt feathers
	# --- Act XI, the Ancient Eye (w2d-eye) ---
	"anchor": {"sprite": "projectiles/harbour_anchor", "tint": Color(0.55, 0.9, 0.85), "scale": 1.6, "trail": 80.0, "impact": 80.0},  # TUNING (not in GDD) the Harbourmaster's chained anchor (drowned teal)
	"net": {"sprite": "overlays/harbour_net", "tint": Color(0.6, 0.95, 0.85), "scale": 1.0, "trail": 50.0, "impact": 60.0},  # TUNING (not in GDD) a Netcaster's net
	"page": {"sprite": "projectiles/archive_page", "tint": Color(0.75, 0.45, 1.0), "scale": 1.8, "trail": 64.0, "impact": 56.0},  # TUNING (not in GDD) the Archivist's flying pages (ink violet)
	# --- Act XII, the Electronic Empire (w2d-empire): signal amber, the Lock-On slugs red ---
	"zap": {"sprite": "projectiles/radiant_bolt", "tint": Color(1.0, 0.78, 0.25), "scale": 1.4, "trail": 50.0, "impact": 40.0},  # TUNING (not in GDD) a drone's zap
	"rifle": {"sprite": "projectiles/priest_bolt", "tint": Color(1.0, 0.68, 0.1), "scale": 1.6, "trail": 70.0, "impact": 44.0},  # TUNING (not in GDD) a Line Trooper's round
	"bolt_amber": {"sprite": "projectiles/radiant_bolt", "tint": Color(1.0, 0.6, 0.15), "scale": 2.0, "trail": 70.0, "impact": 56.0},  # TUNING (not in GDD) a turret bolt
	"rail": {"sprite": "projectiles/empire_rail", "tint": Color(1.0, 0.25, 0.15), "scale": 1.4, "trail": 110.0, "impact": 72.0},  # TUNING (not in GDD) the Lock-On rail slug
	"rocket": {"sprite": "projectiles/trojan_rocket", "tint": Color(1.0, 0.55, 0.2), "scale": 1.6, "trail": 60.0, "impact": 80.0},  # TUNING (not in GDD) the Trojan Horse's Swarm Rocket
	"rivet": {"sprite": "projectiles/iron_shell", "tint": Color(1.0, 0.7, 0.4), "scale": 0.9, "trail": 60.0, "impact": 44.0},  # TUNING (not in GDD) the Beta Build's rivet
	"missile": {"sprite": "projectiles/empire_missile", "tint": Color(1.0, 0.4, 0.2), "scale": 1.6, "trail": 80.0, "impact": 90.0},  # TUNING (not in GDD) Deus Ex Machina's missile
	"lance": {"sprite": "projectiles/empire_rail", "tint": Color(1.0, 0.85, 0.5), "scale": 2.8, "trail": 160.0, "impact": 120.0},  # TUNING (not in GDD) the Judgment Lance
}
## Trail width (px) of hostile shots.
const TRAIL_W: float = 10.0  # TUNING (not in GDD)
## Height (px, x the flight distance) of an arcing shot's arc (drawn only).
const ARC_LIFT: float = 0.3  # TUNING (not in GDD)

## --- Telegraphed shelling --------------------------------------------------------
## Telegraph tint (the closing target circle on the ground).
const TELEGRAPH_TINT: Color = Color(1.0, 0.35, 0.25, 0.75)  # TUNING (not in GDD)
## Screen shake (px) when a shell lands.
const SHELL_SHAKE: float = 4.0  # TUNING (not in GDD)

## --- Disabled towers -------------------------------------------------------------
## Body modulate of a disabled tower (darkened).
const DISABLED_DIM: Color = Color(0.45, 0.42, 0.5)  # TUNING (not in GDD)
## Ring colour per disable cause (TdCombat.disable_tower `cause`; unknown causes use "shelled").
const CAUSE_TINT: Dictionary = {
	"shelled": Color(1.0, 0.45, 0.2),  # TUNING (not in GDD) shells, cannon fire
	"shot": Color(1.0, 0.3, 0.25),  # TUNING (not in GDD) ranged enemy fire
	"trampled": Color(0.85, 0.65, 0.35),  # TUNING (not in GDD) stampedes
	"blinded": Color(0.75, 0.7, 1.0),  # TUNING (not in GDD) light / darkness
	"stunned": Color(1.0, 0.9, 0.4),  # TUNING (not in GDD) anything else
	"hooked": Color(0.85, 0.7, 0.45),  # TUNING (not in GDD) w2b-tide: a Grappler's hook (rope tan)
	"grabbed": Color(0.7, 0.45, 0.9),  # TUNING (not in GDD) w2b-tide: a tentacle from the deep (kraken purple)
	"frozen": Color(0.6, 0.85, 1.0),  # TUNING (not in GDD) w2c-norse: frost mist, boulders of ice, the Barrow-Wight's howl (ice blue)
	"petrified": Color(0.6, 0.85, 0.5),  # TUNING (not in GDD) w2c-pantheon: the Gorgon's gaze (stone green)
	"chained": Color(0.75, 0.6, 0.45),  # TUNING (not in GDD) w2c-inferno: the Gatekeeper's chains (iron)
	# --- Act XI, the Ancient Eye (w2d-eye) ---
	"soaked": Color(0.35, 0.85, 0.9),  # TUNING (not in GDD) a Tide Caller's water line, Merrow's Brine Wave (sea teal)
	"netted": Color(0.6, 0.9, 0.75),  # TUNING (not in GDD) a Netcaster's net (rope green)
	"inked": Color(0.6, 0.4, 0.95),  # TUNING (not in GDD) the Librarian's Index, the Archivist's pages and Erasure (ink violet)
	# --- Act XII (w2d-empire) ---
	"jammed": Color(0.55, 0.8, 1.0),  # TUNING (not in GDD) an Arc Engineer's static, Varn's overload pulse (arc blue)
}
## Diameter (px) of the disabled ring around a tower's base, and its pulse period (s).
const DISABLED_RING: float = 52.0  # TUNING (not in GDD)
## See DISABLED_RING.
const DISABLED_PULSE: float = 0.6  # TUNING (not in GDD)
## Burst diameter (px) when a tower is disabled.
const DISABLED_BURST: float = 70.0  # TUNING (not in GDD)

## --- Flyers (drawn only) ---------------------------------------------------------
## Px a flying enemy's body is drawn above its road position (its shadow stays on the road).
const FLY_LIFT: float = 22.0  # TUNING (not in GDD)
## Shadow size (px) and alpha under a flyer.
const FLY_SHADOW: Vector2 = Vector2(26.0, 9.0)  # TUNING (not in GDD)
## See FLY_SHADOW.
const FLY_SHADOW_A: float = 0.35  # TUNING (not in GDD)
