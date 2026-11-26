## BossPoseData: which attack-pose sprite each stage boss shows in each attack
## pose (art pass: boss attack poses, GDD §15.0 "Boss attack poses"). The boss
## scripts already report a pose number from their attack phase (Alaric,
## Vael and Seraphine all use the same four): 0 walking, 1 winding up or
## casting, 2 the special stance (Alaric's charge, Vael's Shieldwall,
## Seraphine's teleport / transformation glow), 3 the strike just landed
## (recover). SpriteBank.draw_pose() draws "<still key>_<suffix>.png" for a
## pose listed here when that file exists, its feet on the still's feet, and
## the still otherwise, so every pose falls back on its own. Purely visual:
## poses never change timings, hitboxes or anything a run computes. Data only.
class_name BossPoseData
extends RefCounted

## Still sprite key -> {pose number -> file suffix}. A pose missing here (or
## whose PNG is missing) shows the still.
const POSES: Dictionary = {
	"bosses/alaric": {1: "windup", 2: "charge", 3: "strike"},  # TUNING (not in GDD) hammer raised / shoulder charge / hammer slammed down
	"bosses/vael": {1: "windup", 2: "guard", 3: "strike"},  # TUNING (not in GDD) flaming sword raised / Shieldwall / cleave follow-through
	"bosses/seraphine": {1: "cast", 3: "cast"},  # TUNING (not in GDD) relic staff raised in a cast (teleport and recover keep the still) Pose 3 (a strike on a blocker) reuses the same attack art (DECISIONS Z9).
	"bosses/seraphine_avatar": {1: "cast", 3: "cast"},  # TUNING (not in GDD) the Avatar's cast Pose 3 (a strike on a blocker) reuses the same attack art (DECISIONS Z9).
	# --- Act II: Gullhaven Harbour ---
	"bosses/merrow": {1: "sermon", 3: "sermon"},  # TUNING (not in GDD) preaching / casting with both arms raised Pose 3 (a strike on a blocker) reuses the same attack art (DECISIONS Z9).
	"bosses/merrow_changed": {3: "strike"},  # TUNING (not in GDD) the limbs lashing forward
	# --- Act II: the Hollow Archive ---
	"bosses/archivist": {1: "cast", 2: "split", 3: "strike"},  # TUNING (not in GDD) Recitation / Footnotes / the tome slammed down (BossArchivist)
	# --- Act III: the Assembly Halls ---
	"bosses/motherboard": {1: "windup", 3: "strike"},  # TUNING (not in GDD) crane arms raised for a special / claws slammed down (BossMotherboard)
	# --- Act III: the Scrap Wastes ---
	"bosses/kestrel": {1: "aim", 3: "aim"},  # TUNING (not in GDD) kneeling with the rifle raised on her perch (BossKestrel; the leap keeps the still; her blades are their own still, bosses/kestrel_blades) Pose 3 (a strike on a blocker) reuses the same attack art (DECISIONS Z9).
	# --- Act III: the Iron Citadel ---
	"bosses/deus_ex_machina": {1: "fire", 3: "fire"},  # TUNING (not in GDD) the Walker firing: chaingun spun up, missile pods open (BossDeusExMachina) Pose 3 (a strike on a blocker) reuses the same attack art (DECISIONS Z9).
	# --- Act IV: the Shores of Ilion ---
	"bosses/achilles": {3: "strike", 2: "rage"},  # TUNING (not in GDD) the low spear lunge (BossAchilles: the lunge's windup, run and recovery; his rage form is its own still, bosses/achilles_rage; Gravewatch w2c-pantheon: pose 2 = the rage)
	# --- Act IV: Mount Olympus ---
	"bosses/zeus": {1: "cast", 2: "colossus", 3: "cast"},  # TUNING (not in GDD) the thunderbolt raised to call a storm or the beam (BossZeus; his true form is its own still, bosses/zeus_colossus; Gravewatch w2c-pantheon: pose 2 = the true form) Pose 3 (a strike on a blocker) reuses the same attack art (DECISIONS Z9).
	# --- Act IV: the Asphodel Underworld ---
	"bosses/hades": {1: "bident", 3: "bident"},  # TUNING (not in GDD) the bident swept forward (BossHades: the sweep's windup and the phase changes) Pose 3 (a strike on a blocker) reuses the same attack art (DECISIONS Z9).
	# --- Act V: the Road to the Sun ---
	"bosses/amaterasu": {1: "mirror", 3: "mirror"},  # TUNING (not in GDD) the mirror raised to the sky (BossAmaterasu: her beams' windups and her crossings) Pose 3 (a strike on a blocker) reuses the same attack art (DECISIONS Z9).
	# --- Act V: Castle Kurogane ---
	"bosses/shogun": {3: "duel"},  # TUNING (not in GDD) the low iai stance with the blade drawn (BossShogun: the leap down and every cut he stands to draw in the duel)
	# --- Act IX: the Crash Site ---
	"bosses/hive_mother": {1: "cast", 3: "strike"},  # TUNING (not in GDD) her claws raised over the egg sac as she lays a wave / her claws thrust down as she bursts out of the ground (BossHiveMother; her Flight form is its own still, bosses/hive_mother_flight)
	# --- Act XIII: the Celestial Host ---
	"host/seraiel": {1: "raised", 3: "raised"},  # TUNING (not in GDD) the sword raised overhead (BossSeraiel: the sword's windup, the sweep and the Gate's cast) Pose 3 (a strike on a blocker) reuses the same attack art (DECISIONS Z9).
	"host/throne": {1: "open"},  # TUNING (not in GDD) the wheels parted, the Core open (BossThrone)
	# --- Act XIV (temporary number): the Fern Basin ---
	"primeval/scarmaw": {1: "leap", 3: "leap"},  # TUNING (not in GDD) crouched to spring / in the air (BossScarmaw: the leap's windup and flight, the ambush lunge) Pose 3 (a strike on a blocker) reuses the same attack art (DECISIONS Z9).
	# --- Act XIV (temporary number): the Great Plain ---
	"primeval/ironbrow": {1: "broken"},  # TUNING (not in GDD) one horn snapped off (BossIronbrow: every frame after the Break)
	# --- Act XIV (temporary number): the Last Day ---
	"primeval/gravejaw": {1: "roar", 3: "roar"},  # TUNING (not in GDD) jaws wide, head up (BossGravejaw: the Roar's windup, at the Mound) Pose 3 (a strike on a blocker) reuses the same attack art (DECISIONS Z9).
	# --- Act XV (temporary number): the Greenwood ---
	"wild/stag_king": {1: "horn"},  # TUNING (not in GDD) the hunting horn raised to his lips (BossStagKing: while a Hunt rides)
	# --- Act XV (temporary number): the Fae Court ---
	"wild/summer_queen": {1: "bargain"},  # TUNING (not in GDD) a hand held out with the bargain (BossSummerQueen: while an offer waits)
	# --- Act XV (temporary number): the World-Tree ---
	"wild/green_mother": {1: "cast", 2: "burial", 3: "cast"},  # TUNING (not in GDD) arms raised with a season (BossGreenMother: just after the Turning casts) / hands pressed into the earth (just after a burial) Pose 3 (a strike on a blocker) reuses the same attack art (DECISIONS Z9).
	# --- Gravewatch Act IV (w2b-city) ---
	"bosses/harrow": {2: "command"},  # TUNING (not in GDD) Command: the General in his command car (bosses/harrow_command)
	# --- Act IX: the Palace of Silk and Ash / Pandemonium (w2c-inferno): the second forms as pose 2 ---
	"bosses/lilith": {2: "demon"},  # TUNING (not in GDD) her true demon form (bosses/lilith_demon), held from the phase change
	"bosses/morning_star": {2: "beast"},  # TUNING (not in GDD) the Beast (bosses/morning_star_beast), held from the phase change
	# --- Gravewatch Act X (w2c-host) ---
	"host/voice": {1: "unveiled"},  # TUNING (not in GDD) the face wings lowered (Be Not Afraid: host/voice_unveiled)
}
