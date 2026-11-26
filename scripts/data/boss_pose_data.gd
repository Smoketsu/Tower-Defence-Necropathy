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
	"bosses/seraphine": {1: "cast"},  # TUNING (not in GDD) relic staff raised in a cast (teleport and recover keep the still)
	"bosses/seraphine_avatar": {1: "cast"},  # TUNING (not in GDD) the Avatar's cast
	# --- Act II: Gullhaven Harbour ---
	"bosses/merrow": {1: "sermon"},  # TUNING (not in GDD) preaching / casting with both arms raised
	"bosses/merrow_changed": {3: "strike"},  # TUNING (not in GDD) the limbs lashing forward
	# --- Act II: the Hollow Archive ---
	"bosses/archivist": {1: "cast", 2: "split", 3: "strike"},  # TUNING (not in GDD) Recitation / Footnotes / the tome slammed down (BossArchivist)
	# --- Act III: the Assembly Halls ---
	"bosses/motherboard": {1: "windup", 3: "strike"},  # TUNING (not in GDD) crane arms raised for a special / claws slammed down (BossMotherboard)
	# --- Act III: the Scrap Wastes ---
	"bosses/kestrel": {1: "aim"},  # TUNING (not in GDD) kneeling with the rifle raised on her perch (BossKestrel; the leap keeps the still; her blades are their own still, bosses/kestrel_blades)
	# --- Act III: the Iron Citadel ---
	"bosses/deus_ex_machina": {1: "fire"},  # TUNING (not in GDD) the Walker firing: chaingun spun up, missile pods open (BossDeusExMachina)
	# --- Act IV: the Shores of Ilion ---
	"bosses/achilles": {3: "strike", 2: "rage"},  # TUNING (not in GDD) the low spear lunge (BossAchilles: the lunge's windup, run and recovery; his rage form is its own still, bosses/achilles_rage; Gravewatch w2c-pantheon: pose 2 = the rage)
	# --- Act IV: Mount Olympus ---
	"bosses/zeus": {1: "cast", 2: "colossus"},  # TUNING (not in GDD) the thunderbolt raised to call a storm or the beam (BossZeus; his true form is its own still, bosses/zeus_colossus; Gravewatch w2c-pantheon: pose 2 = the true form)
	# --- Act IV: the Asphodel Underworld ---
	"bosses/hades": {1: "bident"},  # TUNING (not in GDD) the bident swept forward (BossHades: the sweep's windup and the phase changes)
	# --- Act V: the Road to the Sun ---
	"bosses/amaterasu": {1: "mirror"},  # TUNING (not in GDD) the mirror raised to the sky (BossAmaterasu: her beams' windups and her crossings)
	# --- Act V: Castle Kurogane ---
	"bosses/shogun": {3: "duel"},  # TUNING (not in GDD) the low iai stance with the blade drawn (BossShogun: the leap down and every cut he stands to draw in the duel)
	# --- Act IX: the Crash Site ---
	"bosses/hive_mother": {1: "cast", 3: "strike"},  # TUNING (not in GDD) her claws raised over the egg sac as she lays a wave / her claws thrust down as she bursts out of the ground (BossHiveMother; her Flight form is its own still, bosses/hive_mother_flight)
	# --- Act XIII: the Celestial Host ---
	"host/seraiel": {1: "raised"},  # TUNING (not in GDD) the sword raised overhead (BossSeraiel: the sword's windup, the sweep and the Gate's cast)
	"host/throne": {1: "open", 3: "strike"},  # TUNING (not in GDD) the wheels parted, the Core open (BossThrone) / strike: its wheels spun hard and thrusting forward in a crushing lunge (the Throne)
	# --- Act XIV (temporary number): the Fern Basin ---
	"primeval/scarmaw": {1: "leap"},  # TUNING (not in GDD) crouched to spring / in the air (BossScarmaw: the leap's windup and flight, the ambush lunge)
	# --- Act XIV (temporary number): the Great Plain ---
	"primeval/ironbrow": {1: "broken", 3: "strike"},  # TUNING (not in GDD) one horn snapped off (BossIronbrow: every frame after the Break) / strike: head lowered and horns thrust forward in a ramming gore (Old Ironbrow)
	# --- Act XIV (temporary number): the Last Day ---
	"primeval/gravejaw": {1: "roar"},  # TUNING (not in GDD) jaws wide, head up (BossGravejaw: the Roar's windup, at the Mound)
	# --- Act XV (temporary number): the Greenwood ---
	"wild/stag_king": {1: "horn", 3: "strike"},  # TUNING (not in GDD) the hunting horn raised to his lips (BossStagKing: while a Hunt rides) / strike: lowering his antlers and thrusting forward in a goring charge (the Stag King)
	# --- Act XV (temporary number): the Fae Court ---
	"wild/summer_queen": {1: "bargain", 3: "strike"},  # TUNING (not in GDD) a hand held out with the bargain (BossSummerQueen: while an offer waits) / strike: sweeping one arm forward in a blooming burst of petals (the Summer Queen)
	# --- Act XV (temporary number): the World-Tree ---
	"wild/green_mother": {1: "cast", 2: "burial"},  # TUNING (not in GDD) arms raised with a season (BossGreenMother: just after the Turning casts) / hands pressed into the earth (just after a burial)
	# --- Gravewatch Act IV (w2b-city) ---
	"bosses/harrow": {2: "command", 3: "strike"},  # TUNING (not in GDD) Command: the General in his command car (bosses/harrow_command) / strike: bringing his huge hammer down in a crushing overhead blow (General Harrow)
	# --- Act IX: the Palace of Silk and Ash / Pandemonium (w2c-inferno): the second forms as pose 2 ---
	"bosses/lilith": {2: "demon", 3: "strike"},  # TUNING (not in GDD) her true demon form (bosses/lilith_demon), held from the phase change / strike: lashing one hand forward in a whip-like clawed swipe (Lilith)
	"bosses/morning_star": {2: "beast", 3: "strike"},  # TUNING (not in GDD) the Beast (bosses/morning_star_beast), held from the phase change / strike: sweeping his blade forward in a wide burning slash (the Morning Star)
	# --- Gravewatch Act X (w2c-host) ---
	"host/voice": {1: "unveiled", 3: "strike"},  # TUNING (not in GDD) the face wings lowered (Be Not Afraid: host/voice_unveiled) / strike: wings snapped wide and flung forward in a blasting burst (the Voice)
	"corsair/crow": {3: "strike"},  # TUNING (not in GDD) strike pose, Captain Crow: swinging his cutlass in a wide slash across his body (Gravewatch boss-poses)
	"corsair/marrec": {3: "strike"},  # TUNING (not in GDD) strike pose, Admiral Marrec: bringing his sabre down in a hard overhead chop (Gravewatch boss-poses)
	"corsair/vandermere": {3: "strike"},  # TUNING (not in GDD) strike pose, Captain Vandermere: a ghostly arm and spectral cutlass lunging forward out of the helm in a stab (Gravewatch boss-poses)
	"bosses/vargr": {3: "strike"},  # TUNING (not in GDD) strike pose, Vargr: mid-lunge (Gravewatch boss-poses)
	"bosses/isolde": {3: "strike"},  # TUNING (not in GDD) strike pose, Isolde Vane: thrusting one hand forward and casting a hex (Gravewatch boss-poses)
	"bosses/carmilla": {3: "strike"},  # TUNING (not in GDD) strike pose, Queen Carmilla: one clawed hand raked forward in a vicious swipe (Gravewatch boss-poses)
	"bosses/don_marrow": {3: "strike"},  # TUNING (not in GDD) strike pose, Don Marrow: firing his big rotary gun forward in a blazing burst with a muzzle flash (Gravewatch boss-poses)
	"bosses/paragon": {3: "strike"},  # TUNING (not in GDD) strike pose, Paragon: throwing a powerful punch forward (Gravewatch boss-poses)
	"bosses/kage": {3: "strike"},  # TUNING (not in GDD) strike pose, Kage: mid-slash lunging forward with a blade thrust out in a quick cut (Gravewatch boss-poses)
	"norse/hrimgar": {3: "strike"},  # TUNING (not in GDD) strike pose, Hrimgar: swinging his greatsword in a heavy diagonal chop (Gravewatch boss-poses)
	"norse/sigrun": {3: "strike"},  # TUNING (not in GDD) strike pose, Sigrun: thrusting her spear forward in a lunge (Gravewatch boss-poses)
	"norse/odin": {3: "strike"},  # TUNING (not in GDD) strike pose, Odin: thrusting his spear Gungnir forward in a lunge (Gravewatch boss-poses)
	"norse/fenrir": {3: "strike"},  # TUNING (not in GDD) strike pose, Fenrir: lunging forward with jaws wide open to bite and one front paw raked forward (Gravewatch boss-poses)
	"dynasty/anubis": {3: "strike"},  # TUNING (not in GDD) strike pose, Anubis: swinging his weapon in a hard downward strike (Gravewatch boss-poses)
	"dynasty/sekhmet": {3: "strike"},  # TUNING (not in GDD) strike pose, Sekhmet: slashing forward with a clawed hand or blade (Gravewatch boss-poses)
	"dynasty/osiris": {3: "strike"},  # TUNING (not in GDD) strike pose, Osiris: staying seated on his throne but leaning forward (Gravewatch boss-poses)
	"dynasty/ammit": {3: "strike"},  # TUNING (not in GDD) strike pose, Ammit: lunging forward with jaws wide open in a snapping bite (Gravewatch boss-poses)
	"bosses/moloch": {3: "strike"},  # TUNING (not in GDD) strike pose, Moloch: slamming a massive fist or weapon down (Gravewatch boss-poses)
	"bosses/vhalneth": {3: "strike"},  # TUNING (not in GDD) strike pose, Vhal'Neth: her head lunging forward and her tentacle hair lashing forward in a crushing whip (Gravewatch boss-poses)
	"bosses/vrask_tal": {3: "strike"},  # TUNING (not in GDD) strike pose, Vrask'Tal: thrusting a long weapon forward in a lunging stab (Gravewatch boss-poses)
	"bosses/harvester": {3: "strike"},  # TUNING (not in GDD) strike pose, the Harvester: one long thin arm sweeping forward in a wide reaping slash (Gravewatch boss-poses)
}
