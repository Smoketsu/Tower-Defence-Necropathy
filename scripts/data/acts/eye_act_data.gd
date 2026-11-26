## Act XI, the Ancient Eye (ActData "eye"; GDD §7.3; Necropathy's Act II "the
## Ancient Eye", the stages harbour / archive / spire): its enemy kinds (KINDS,
## keys as TdEnemyData.KINDS), its build orders (ORDERS, keys as
## BuildOrderData.ORDERS), its three map moods (MOODS, keys as
## TdMoodData.MOODS), the numbers of its act rule, CLAIMS (RULE, read by
## scripts/maps/rules/eye/claims.gd) and the act's looks (LOOK). Every sprite is
## Necropathy's Eye art (assets/sprites/eye/, bosses/merrow*, archivist*,
## vhalneth*, summons/spawn_of_the_deep, leviathan, drowned_thrall_ally,
## player/brine_widow, heretic_scribe, tide_widow, structures, overlays). The
## Eye's colours: drowned teal and biolume magenta, never gold. The ids carry an
## "eye_" prefix (unique across acts). Data only.
extends RefCounted

## Enemy kinds of the Ancient Eye (keys: TdEnemyData.KINDS). Traits live in
## scripts/enemies/traits/eye/ and scripts/bosses/eye/ (each script documents
## its args). A kind whose args hold "claim_radius" (px) is a CLAIMER: a
## blocker body that falls within that reach of it rises as a Drowned Thrall
## (the act rule). A Scribe's curse makes any enemy a claimer for a while.
const KINDS: Dictionary = {
	# --- the Eye's shared kinds (every map) ---
	# The Act's Recruit: a robed, hunched cultist in big crowds (Necropathy "Initiate of the Eye").
	"eye_initiate": {
		"name": "Initiate of the Eye", "sprite": "eye/eye_initiate", "rank": "fodder", "souls": 5,  # TUNING (not in GDD) X2 fodder
		"hp": 70.0, "speed": 46.0, "armour": 0.0, "radius": 9.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# The squad leader: it CLAIMS the dead around it (Necropathy "Chanter of the Eye"; kill it first).
	"eye_chanter": {
		"name": "Chanter of the Eye", "sprite": "eye/eye_chanter", "rank": "elite",
		"hp": 320.0, "speed": 44.0, "armour": 1.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "",
		"args": {"claim_radius": 110.0},  # TUNING (not in GDD) px; Necropathy 90 (a squad's reach), a little wider for a road
	},
	# A claimed blocker body risen hostile for `life` s, wearing the body's sprite (the act rule sets it);
	# killed, it pays its souls and an elite's ultimate charge back (its soul comes home).
	"eye_thrall": {
		"name": "Drowned Thrall", "sprite": "summons/drowned_thrall_ally", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) paying back what was lost
		"hp": 120.0, "speed": 34.0, "armour": 0.0, "radius": 10.0,  # TUNING (not in GDD) HP floor; the rule sets RULE thrall_hp x the body's max HP
		"damage": 8.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "eye/thrall", "leak_lives": 1,
		"args": {"life": 16.0, "charge_rank": "elite"},  # TUNING (not in GDD) Necropathy "rises for 15 s"; SpellData ULTIMATE charge rank paid on its kill
	},
	# --- Gullhaven Harbour ---
	# A bruiser of the deep: a telegraphed LEAP onto the post ahead, clawing every body there.
	"eye_deep_kin": {
		"name": "Deep Kin", "sprite": "eye/deep_kin", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) soldier tier (X2)
		"hp": 160.0, "speed": 50.0, "armour": 2.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 7.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "eye/leap",
		"args": {"range": 120.0, "near": 30.0, "windup": 0.7, "radius": 40.0, "damage": 26.0, "cooldown": 9.0},  # TUNING (not in GDD) Necropathy: leap_telegraph 0.7 s onto the front rank
	},
	# Raises a WATER LINE over the towers near the road: telegraphed, it soaks them (stunned) and knocks the bodies there.
	"eye_tide_caller": {
		"name": "Tide Caller", "sprite": "eye/tide_caller", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) soldier tier
		"hp": 130.0, "speed": 44.0, "armour": 1.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 5.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "eye/water_line",
		"args": {"range": 160.0, "first": 3.0, "every": 9.0, "delay": 1.2, "radius": 46.0, "disable": 1.6, "body_damage": 14.0},  # TUNING (not in GDD) Necropathy wall_telegraph ~1 s
	},
	# Throws a NET over a tower (Act framework shooter): the tower is netted (stunned); a blocker in the way catches it.
	"eye_netcaster": {
		"name": "Netcaster", "sprite": "eye/netcaster", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) soldier tier
		"hp": 140.0, "speed": 46.0, "armour": 1.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.1,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "shooter",
		"args": {"range": 170.0, "interval": 9.0, "target": "tower", "damage": 10.0, "disable": 2.2, "cause": "netted",
			"speed": 260.0, "arc": false, "look": "net"},  # TUNING (not in GDD) Necropathy "pins one summon in place for 3 s"
	},
	# Gullhaven miniboss: the Harbourmaster, a hulking Deep Kin with a chained anchor.
	"eye_harbourmaster": {
		"name": "The Harbourmaster", "sprite": "eye/harbourmaster", "rank": "miniboss",
		"hp": 5000.0, "speed": 26.0, "armour": 6.0, "radius": 24.0,  # TUNING (not in GDD) X3: 4000-6000
		"damage": 24.0, "attack_interval": 1.4,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "eye/harbourmaster",
		"args": {"first": 3.0, "gap": 6.0, "hurl_range": 240.0, "hurl_windup": 0.9, "hurl_disable": 3.0, "hurl_damage": 40.0, "hurl_speed": 340.0,
			"sweep_windup": 1.0, "sweep_radius": 80.0, "sweep_damage": 44.0},  # TUNING (not in GDD) Necropathy HarbourmasterKit: anchor hurl / anchor sweep, alternating
	},
	# Gullhaven boss: Abbot Silas Merrow, the town's priest halfway through his change.
	"eye_merrow": {
		"name": "Abbot Merrow, Voice of the Deep", "sprite": "bosses/merrow", "rank": "boss",
		"hp": 12500.0, "speed": 22.0, "armour": 5.0, "radius": 26.0,  # TUNING (not in GDD) Part Three's first boss, above the Empyrean's Voice (12000)
		"damage": 30.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "eye/merrow",
		"args": {"sermon_first": 4.0, "sermon_every": 18.0, "sermon_time": 6.0, "sermon_radius": 170.0, "sermon_haste": 1.3, "sermon_ward": 0.7,
			"sermon_break": 0.08, "wave_every": 9.0, "wave_count": 2, "wave_range": 260.0, "wave_delay": 1.2, "wave_radius": 50.0,
			"wave_disable": 1.8, "wave_body": 30.0, "change_hp": 0.5, "change_time": 2.0, "change_speed": 1.5,
			"lash_every": 6.0, "lash_windup": 0.7, "lash_targets": 2, "lash_damage": 60.0,
			"whirl_every": 11.0, "whirl_windup": 1.0, "whirl_radius": 100.0, "whirl_damage": 50.0, "whirl_disable": 1.2,
			"pose_time": 0.7},  # TUNING (not in GDD) Necropathy BossMerrow: Sermon, Brine Wave, the Change, Limb Lash, Whirl
	},
	# --- the Hollow Archive ---
	# Inks a CURSE on the cultists near it: each becomes a claimer for a while (Necropathy "Scribe of the Unwritten").
	"eye_scribe": {
		"name": "Scribe of the Unwritten", "sprite": "eye/scribe", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) soldier tier
		"hp": 120.0, "speed": 44.0, "armour": 1.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "eye/scribe",
		"args": {"first": 2.0, "every": 10.0, "cast": 0.8, "range": 130.0, "count": 3, "time": 10.0},  # TUNING (not in GDD) Necropathy curse_cooldown / curse_count / curse_duration
	},
	# A flanker that DIVES into the ink: unseen by the towers and through the posts for a while, then it rises.
	"eye_ink_wraith": {
		"name": "Ink Wraith", "sprite": "eye/ink_wraith", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) soldier tier
		"hp": 110.0, "speed": 54.0, "armour": 0.0, "radius": 9.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "eye/ink_dive",
		"args": {"first": 5.0, "every": 11.0, "time": 2.2, "alpha": 0.3},  # TUNING (not in GDD) Necropathy sink / rise; alpha = drawn fade while under
	},
	# Leaves SPORE CLOUDS on the road behind it (the act rule chokes the bodies inside); bursts into a bigger one.
	"eye_spore_pilgrim": {
		"name": "Pilgrim of the Spore", "sprite": "eye/spore_pilgrim", "rank": "fodder", "souls": 8,  # TUNING (not in GDD) soldier tier
		"hp": 150.0, "speed": 40.0, "armour": 1.0, "radius": 10.0,  # TUNING (not in GDD)
		"damage": 5.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "eye/spores",
		"args": {"every": 3.0, "radius": 36.0, "life": 6.0, "dps": 6.0, "death_radius": 60.0, "death_life": 7.0},  # TUNING (not in GDD) Necropathy cloud_interval / cloud_life
	},
	# A tank that SPLITS when killed: two lesser masses, each splitting into two of the least.
	"eye_gibbering_mass": {
		"name": "Gibbering Mass", "sprite": "eye/gibbering_mass", "rank": "elite",
		"hp": 520.0, "speed": 32.0, "armour": 3.0, "radius": 14.0,  # TUNING (not in GDD)
		"damage": 12.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "eye/gibbering",
		"args": {"into": "eye_gibbering_lesser", "count": 2, "gap": 14.0},  # TUNING (not in GDD) Necropathy split_count 2
	},
	# The first split (same art, smaller).
	"eye_gibbering_lesser": {
		"name": "Lesser Mass", "sprite": "eye/gibbering_lesser", "rank": "fodder", "souls": 3,  # TUNING (not in GDD) a split pays little (X2)
		"hp": 180.0, "speed": 38.0, "armour": 2.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 7.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "eye/gibbering",
		"args": {"into": "eye_gibbering_least", "count": 2, "gap": 10.0},  # TUNING (not in GDD)
	},
	# The last split.
	"eye_gibbering_least": {
		"name": "Least Mass", "sprite": "eye/gibbering_least", "rank": "fodder", "souls": 1,  # TUNING (not in GDD)
		"hp": 60.0, "speed": 46.0, "armour": 0.0, "radius": 8.0,  # TUNING (not in GDD)
		"damage": 4.0, "attack_interval": 1.0,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "", "args": {},
	},
	# The Archive miniboss: the Librarian, a floating eye wrapped in tendrils.
	"eye_librarian": {
		"name": "The Librarian", "sprite": "eye/librarian", "rank": "miniboss",
		"hp": 4600.0, "speed": 28.0, "armour": 5.0, "radius": 22.0,  # TUNING (not in GDD) X3
		"damage": 22.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "eye/librarian",
		"args": {"first": 3.0, "gap": 6.0, "beam_range": 280.0, "beam_len": 300.0, "beam_w": 46.0, "beam_windup": 1.2, "beam_disable": 2.4, "beam_body": 30.0,
			"lash_windup": 0.9, "lash_radius": 84.0, "lash_damage": 40.0},  # TUNING (not in GDD) Necropathy LibrarianKit: the Index beam, the tendril lash
	},
	# The Archive boss: the Archivist, Keeper of the Unwritten, whose face is an open book.
	"eye_archivist": {
		"name": "The Archivist, Keeper of the Unwritten", "sprite": "bosses/archivist", "rank": "boss",
		"hp": 12000.0, "speed": 22.0, "armour": 5.0, "radius": 26.0,  # TUNING (not in GDD)
		"damage": 30.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "eye/archivist",
		"args": {"phase_hp": [0.66, 0.33], "recite_first": 3.0, "recite_every": 10.0, "recite_every_p3": 6.5, "recite_cast": 1.0,
			"pages": 3, "pages_p3": 5, "page_range": 300.0, "page_disable": 2.0, "page_damage": 24.0, "page_speed": 240.0,
			"foot_every": 16.0, "foot_cast": 0.9, "foot_time": 8.0, "foot_gap": 40.0, "copy_kind": "eye_archivist_copy",
			"erase_every": 12.0, "erase_range": 220.0, "erase_time": 4.0, "pose_time": 0.7},  # TUNING (not in GDD) Necropathy BossArchivist: Recitation, Footnotes, Erasure
	},
	# One of the Archivist's FOOTNOTES: a copy that walks beside her, takes no damage and fades; shots on it are wasted.
	"eye_archivist_copy": {
		"name": "A Footnote", "sprite": "bosses/archivist", "rank": "elite", "souls": 0, "leak_lives": 0,  # TUNING (not in GDD) a copy pays and costs nothing
		"hp": 1000.0, "speed": 22.0, "armour": 0.0, "radius": 26.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 9.0,  # it never attacks for real
		"flying": false, "ignores_walls": true, "trait": "eye/footnote", "tint": Color(0.75, 0.8, 1.0, 0.7),  # TUNING (not in GDD) a paler, see-through copy
		"args": {},
	},
	# --- Ul-Thalos, the Risen Spire ---
	# Her SONG charms the bodies of the post near her: they hold nothing and turn on their own post for a while.
	"eye_siren": {
		"name": "Siren of the Eye", "sprite": "eye/eye_siren", "rank": "elite",
		"hp": 330.0, "speed": 40.0, "armour": 1.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 6.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "eye/siren",
		"args": {"first": 3.0, "every": 12.0, "windup": 1.2, "radius": 110.0, "time": 3.0, "hit_mult": 0.5},  # TUNING (not in GDD) Necropathy song_telegraph / song_lure
	},
	# Tentacled and armoured: a tentacle GRABS a body of the post ahead and squeezes it.
	"eye_spawn": {
		"name": "Spawn of the Deep", "sprite": "eye/eye_spawn", "rank": "elite",
		"hp": 640.0, "speed": 34.0, "armour": 4.0, "radius": 14.0,  # TUNING (not in GDD)
		"damage": 14.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "eye/grab",
		"args": {"first": 2.0, "every": 9.0, "range": 90.0, "windup": 0.5, "hold": 2.4, "tick": 0.5, "damage": 9.0},  # TUNING (not in GDD) Necropathy SpawnKit grab_hold 2.4 s, a squeeze every 0.5 s
	},
	# Claims the dead like a Chanter, and its ASCENSION turns it into a Spawn of the Deep unless broken.
	"eye_hierophant": {
		"name": "Hierophant of the Eye", "sprite": "eye/eye_hierophant", "rank": "elite",
		"hp": 420.0, "speed": 40.0, "armour": 2.0, "radius": 11.0,  # TUNING (not in GDD)
		"damage": 7.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": false, "trait": "eye/hierophant",
		"args": {"claim_radius": 110.0, "first": 8.0, "channel": 4.0, "break": 0.25, "retry": 8.0, "into": "eye_spawn", "calls": 0},  # TUNING (not in GDD) Necropathy ascend_channel / ascend_break
	},
	# The Spire miniboss: the Grand Hierophant (Necropathy has none here: the Hierophant raised to a miniboss); his
	# Ascension calls Spawns of the Deep out of the sea instead of becoming one; he claims far.
	"eye_grand_hierophant": {
		"name": "The Grand Hierophant", "sprite": "eye/grand_hierophant", "rank": "miniboss", "tint": Color(0.95, 0.85, 1.0),  # TUNING (not in GDD) a biolume sheen
		"hp": 4400.0, "speed": 26.0, "armour": 5.0, "radius": 22.0,  # TUNING (not in GDD) X3
		"damage": 22.0, "attack_interval": 1.3,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "eye/hierophant",
		"args": {"claim_radius": 150.0, "first": 5.0, "channel": 4.0, "break": 0.08, "retry": 12.0, "into": "eye_spawn", "calls": 2, "call_gap": 36.0},  # TUNING (not in GDD)
	},
	# One of Vhal'Neth's arms: it stands where it rose and SLAMS a telegraphed lane toward the nearest tower.
	"eye_vhalneth_arm": {
		"name": "Arm of Vhal'Neth", "sprite": "eye/vhalneth_arm", "rank": "elite", "souls": 20, "leak_lives": 0,  # TUNING (not in GDD) it never walks
		"hp": 1500.0, "speed": 0.0, "armour": 4.0, "radius": 18.0,  # TUNING (not in GDD)
		"damage": 0.0, "attack_interval": 9.0,  # it never fights a post
		"flying": false, "ignores_walls": true, "trait": "eye/arm",
		"args": {"first": 4.0, "every": 10.0, "range": 260.0, "circles": 3, "step": 44.0, "radius": 34.0, "delay": 1.4, "disable": 2.0, "body_damage": 40.0},  # TUNING (not in GDD) Necropathy ArmKit: a telegraphed lane, then the crash
	},
	# The Spire boss: Vhal'Neth, the Dreaming Mother. She never walks: her face lies off the island's shore
	# `stand_dist` px down her road. Dreaming (out of reach) while her arms stand; Stirring (her Gaze); Waking (the roar).
	"eye_vhalneth": {
		"name": "Vhal'Neth, the Dreaming Mother", "sprite": "bosses/vhalneth_dreaming", "rank": "boss",
		"hp": 13000.0, "speed": 0.0, "armour": 5.0, "radius": 34.0,  # TUNING (not in GDD) the act's last boss
		"damage": 40.0, "attack_interval": 1.2,  # TUNING (not in GDD)
		"flying": false, "ignores_walls": true, "trait": "eye/vhalneth",
		"args": {"stand_dist": 1320.0, "arm_kind": "eye_vhalneth_arm", "arms": [[-150.0, -50.0], [-300.0, 50.0], [-450.0, -50.0]],
			"wound": 0.3, "stir_hp": 0.7, "wake_hp": 0.35, "regrow": [[-200.0, 50.0], [-380.0, -50.0]],
			"gaze_first": 4.0, "gaze_every": 12.0, "gaze_radius": 120.0, "gaze_mult": 0.6, "gaze_time": 6.0,
			"roar_every": 14.0, "roar_radius": 220.0, "roar_stun": 1.6,
			"call_every": 14.0, "call": [["eye_initiate", 6], ["eye_spawn", 1]], "call_gap": 18.0, "pose_time": 0.8},  # TUNING (not in GDD) Necropathy BossVhalneth: Dreaming / Stirring / Waking
	},
}

## Build orders of the Eye maps (keys: BuildOrderData.ORDERS): each map's
## default (must win on Necromancer) and weak order (must lose), and one kit
## order for every Act XI map ("eye_kit": the default with its Corpse
## Abomination a Spawn of the Deep, raised at once to its Leviathan, and the
## act spells).
const ORDERS: Dictionary = {
	"harbour_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:3", "tower": "archer"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:5", "tower": "archer"},
			{"do": "build", "spot": "plot:10", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "post:3", "tower": "warrior"},
			{"do": "build", "spot": "plot:4", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:4", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "build", "spot": "plot:13", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "build", "spot": "post:2", "tower": "abomination"},
			{"do": "build", "spot": "plot:2", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "plot:11", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:6", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "post:4", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:7", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:0", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:10"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:0"},
		],
	},
	"harbour_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:3", "tower": "archer"},
		],
	},
	"archive_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:2", "tower": "archer"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "build", "spot": "plot:6", "tower": "archer"},
			{"do": "build", "spot": "plot:13", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "post:2", "tower": "warrior"},
			{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:7", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "build", "spot": "plot:3", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "build", "spot": "post:4", "tower": "abomination"},
			{"do": "build", "spot": "plot:1", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "plot:5", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "build", "spot": "plot:12", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "build", "spot": "post:0", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "build", "spot": "plot:8", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:8", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "post:1"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "build", "spot": "plot:4", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:7"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:8"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "post:2"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:4"},
		],
	},
	"archive_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:2", "tower": "archer"},
		],
	},
	"spire_default": {
		"spells": true,
		"steps": [
			{"do": "build", "spot": "plot:5", "tower": "archer"},
			{"do": "build", "spot": "post:5", "tower": "warrior"},
			{"do": "build", "spot": "plot:11", "tower": "archer"},
			{"do": "build", "spot": "plot:3", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "build", "spot": "post:4", "tower": "warrior"},
			{"do": "build", "spot": "plot:4", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:4", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "build", "spot": "plot:12", "tower": "warder"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "build", "spot": "post:3", "tower": "abomination"},
			{"do": "build", "spot": "plot:2", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "plot:0", "tower": "archer"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:1", "tower": "frost_wraith"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "build", "spot": "post:1", "tower": "warrior"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:6", "tower": "corpse_catapult"},
			{"do": "target", "spot": "plot:6", "mode": "strongest"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "post:5"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "build", "spot": "plot:13", "tower": "mage"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:4"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:5"},
			{"do": "upgrade", "spot": "plot:11"},
			{"do": "upgrade", "spot": "plot:3"},
			{"do": "upgrade", "spot": "plot:2"},
			{"do": "upgrade", "spot": "plot:12"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:6"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "plot:0"},
			{"do": "upgrade", "spot": "plot:13"},
			{"do": "upgrade", "spot": "post:4"},
			{"do": "upgrade", "spot": "post:3"},
			{"do": "upgrade", "spot": "plot:1"},
			{"do": "upgrade", "spot": "plot:13"},
		],
	},
	"spire_weak": {
		"spells": false,
		"steps": [
			{"do": "build", "spot": "plot:5", "tower": "archer"},
		],
	},
	"eye_kit": {
		"spells": true,
		"loadout": ["undertow", "forbidden_verse", "call_of_the_drowned"],
		"steps_by_map": {
			"harbour": [
				{"do": "build", "spot": "plot:3", "tower": "archer"},
				{"do": "build", "spot": "post:1", "tower": "warrior"},
				{"do": "build", "spot": "plot:5", "tower": "archer"},
				{"do": "build", "spot": "plot:10", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "post:3", "tower": "warrior"},
				{"do": "build", "spot": "plot:4", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:4", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "build", "spot": "plot:13", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "build", "spot": "post:2", "tower": "spawn_of_the_deep"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "evolve", "spot": "post:2"},
				{"do": "build", "spot": "plot:2", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "plot:11", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:6", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "post:4", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:7", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "post:1"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:0", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:10"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:0"},
			],
			"archive": [
				{"do": "build", "spot": "plot:2", "tower": "archer"},
				{"do": "build", "spot": "post:1", "tower": "warrior"},
				{"do": "build", "spot": "plot:6", "tower": "archer"},
				{"do": "build", "spot": "plot:13", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "post:2", "tower": "warrior"},
				{"do": "build", "spot": "plot:7", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:7", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "build", "spot": "plot:3", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "build", "spot": "post:4", "tower": "spawn_of_the_deep"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "evolve", "spot": "post:4"},
				{"do": "build", "spot": "plot:1", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "plot:5", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "build", "spot": "plot:12", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "build", "spot": "post:0", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "build", "spot": "plot:8", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:8", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "post:1"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "build", "spot": "plot:4", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:7"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:8"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "post:2"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:4"},
			],
			"spire": [
				{"do": "build", "spot": "plot:5", "tower": "archer"},
				{"do": "build", "spot": "post:5", "tower": "warrior"},
				{"do": "build", "spot": "plot:11", "tower": "archer"},
				{"do": "build", "spot": "plot:3", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "build", "spot": "post:4", "tower": "warrior"},
				{"do": "build", "spot": "plot:4", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:4", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "build", "spot": "plot:12", "tower": "warder"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "build", "spot": "post:3", "tower": "spawn_of_the_deep"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "upgrade", "spot": "post:3"},
				{"do": "evolve", "spot": "post:3"},
				{"do": "build", "spot": "plot:2", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "plot:0", "tower": "archer"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:1", "tower": "frost_wraith"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "build", "spot": "post:1", "tower": "warrior"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:6", "tower": "corpse_catapult"},
				{"do": "target", "spot": "plot:6", "mode": "strongest"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "post:5"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "build", "spot": "plot:13", "tower": "mage"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:4"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:5"},
				{"do": "upgrade", "spot": "plot:11"},
				{"do": "upgrade", "spot": "plot:3"},
				{"do": "upgrade", "spot": "plot:2"},
				{"do": "upgrade", "spot": "plot:12"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:6"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "plot:0"},
				{"do": "upgrade", "spot": "plot:13"},
				{"do": "upgrade", "spot": "post:4"},
				{"do": "upgrade", "spot": "plot:1"},
				{"do": "upgrade", "spot": "plot:13"},
			],
		},
	},
}

## Battlefield moods of the three maps (keys: TdMoodData.MOODS). Drowned teal
## and biolume magenta under a drowned moon; the town's lamps the only warm light.
const MOODS: Dictionary = {
	"harbour": {
		"props": [{"sprite": "structures/bell_buoy", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(0.45, 0.95, 0.85, 0.5), "glow_r": 46.0,
			"glow_at": Vector2(0, -26), "flicker": 0.1, "flame": "", "flame_at": Vector2.ZERO, "sway": 1.5},  # TUNING (not in GDD) bell buoys rocking, a teal lamp in each cage
			{"art": "mood_candles", "frames": 1, "count": 4, "scale": 1.0, "glow": Color(1.0, 0.75, 0.45, 0.45), "glow_r": 40.0,
			"glow_at": Vector2(0, -18), "flicker": 0.15, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) the town's last lamps
		"fog": 3,  # TUNING (not in GDD) sea mist off the mudflats
		"pools": 2,  # TUNING (not in GDD) tide pools catching the moon
	},
	"archive": {
		"props": [{"sprite": "structures/forbidden_lectern", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(0.75, 0.45, 1.0, 0.5), "glow_r": 48.0,
			"glow_at": Vector2(0, -20), "flicker": 0.12, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0},  # TUNING (not in GDD) the forbidden tomes, glowing violet
			{"art": "mood_candles", "frames": 1, "count": 5, "scale": 1.0, "glow": Color(1.0, 0.8, 0.5, 0.45), "glow_r": 38.0,
			"glow_at": Vector2(0, -18), "flicker": 0.15, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) reading candles
		"fog": 1,  # TUNING (not in GDD) dust in the stacks
		"pools": 3,  # TUNING (not in GDD) pools of black ink
	},
	"spire": {
		"props": [{"sprite": "eye/dream_pillar", "frames": 1, "count": 3, "scale": 1.0, "glow": Color(0.75, 0.35, 0.95, 0.55), "glow_r": 60.0,
			"glow_at": Vector2(0, -40), "flicker": 0.1, "flame": "", "flame_at": Vector2.ZERO, "sway": 0.0}],  # TUNING (not in GDD) the dream pillars, veined with the god's light
		"fog": 3,  # TUNING (not in GDD) the sea rising round the island
		"pools": 2,  # TUNING (not in GDD)
	},
}

## Claims (scripts/maps/rules/eye/claims.gd; Necropathy's EyeClaims and
## EyeEnemyData.CLAIM). A blocker body (not a temporary Risen, not a wall)
## that falls within a claimer's reach rises as a Drowned Thrall walking the
## road past its post. Numbers of the simulation first, then the look.
const RULE: Dictionary = {
	"thrall_kind": "eye_thrall",  # KINDS id of the risen body
	"thrall_hp": 0.5,  # TUNING (not in GDD) Thrall max HP = this x the fallen body's max HP (at least the row's hp); Necropathy 0.6
	"curse_radius": 100.0,  # TUNING (not in GDD) px reach of a cultist a Scribe has cursed (vars "claimer_until")
	"max_thralls": 4,  # TUNING (not in GDD) most Thralls on the road at once (Necropathy 5: a fallen army must not flood the road with itself)
	"cloud_tick": 0.5,  # TUNING (not in GDD) s between two chokes of a spore cloud on the bodies inside
	# --- The look (drawing only) ---
	"aura_tint": Color(0.3, 0.85, 0.75, 0.22),  # TUNING (not in GDD) the drowned-teal disc of a claimer's reach on the ground
	"aura_ring": Color(0.4, 1.0, 0.85, 0.55),  # TUNING (not in GDD) its edge ring
	"curse_tint": Color(0.75, 0.4, 1.0, 0.85),  # TUNING (not in GDD) the Scribe's ink sigil over a cursed cultist
	"curse_px": 16.0,  # TUNING (not in GDD) sigil size (px)
	"cloud_tint": Color(0.55, 0.75, 0.35, 0.45),  # TUNING (not in GDD) a spore cloud
	"thrall_tint": Color(0.45, 0.85, 0.78),  # TUNING (not in GDD) drowned teal multiplied over the body's sprite (Necropathy CLAIM tint)
	"rise_tint": Color(0.3, 0.75, 0.68),  # TUNING (not in GDD) the rising burst
	"rise_d": 80.0,  # TUNING (not in GDD) its diameter (px)
	"cue_px": 30.0,  # TUNING (not in GDD) HUD cue icon size (px)
	"cue_margin": Vector2(10.0, 10.0),  # TUNING (not in GDD) px from the left edge / under the top bar (game.top_inset)
	"cue_color": Color(0.6, 1.0, 0.9),  # TUNING (not in GDD) the label: drowned teal
	"cue_hot": Color(1.0, 0.55, 0.6),  # TUNING (not in GDD) the label while a Thrall walks
}

## The act's looks (drawing only; read by its traits, bosses, spells and tower).
const LOOK: Dictionary = {
	"warn_tint": Color(0.4, 1.0, 0.85, 0.65),  # TUNING (not in GDD) a telegraph ring / line (biolume teal, never gold)
	"strike_tint": Color(0.55, 1.0, 0.9, 0.95),  # TUNING (not in GDD) the bright strike
	"line_w": 5.0,  # TUNING (not in GDD) px of a telegraph line
	"cut_w": 14.0,  # TUNING (not in GDD) px of the bright lash / beam
	"cut_time": 0.35,  # TUNING (not in GDD) s it shows
	"magenta": Color(0.85, 0.4, 1.0, 0.85),  # TUNING (not in GDD) the Hierophant's pillar, the Siren's song, the Gaze
	"pillar_d": 70.0,  # TUNING (not in GDD) px of the Ascension pillar glow
	"ink_tint": Color(0.35, 0.25, 0.55, 0.9),  # TUNING (not in GDD) ink bursts, the Index beam
	"tentacle_tint": Color(0.5, 0.9, 0.8, 0.95),  # TUNING (not in GDD) a grabbing tentacle (Spawn of the Deep, Vhal'Neth's arms)
	"tentacle_w": 9.0,  # TUNING (not in GDD) px
	"gaze_tint": Color(0.8, 0.45, 1.0, 0.8),  # TUNING (not in GDD) Vhal'Neth's Gaze
	# --- The act spells and tower ---
	"wave_w": 30.0,  # TUNING (not in GDD) px of Undertow's crest drawn
	"shallow_tint": Color(0.3, 0.75, 0.8, 0.35),  # TUNING (not in GDD) Undertow's shallows
	"page_px": 14.0,  # TUNING (not in GDD) px of a Forbidden Verse page
	"tendril_d": 90.0,  # TUNING (not in GDD) px of Call of the Drowned's burst
}
