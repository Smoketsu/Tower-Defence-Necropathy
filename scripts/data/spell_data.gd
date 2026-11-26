## SpellData: the necromancer's spells and the ultimate (GDD §5). Spells cost no
## souls, only cooldowns. Each row is cast by scripts/spells/<id>.gd (extends
## TdSpell), loaded by name by SpellCaster. Data only, no logic.
##
## To add a spell: add a SPELLS row and write scripts/spells/<id>.gd.
class_name SpellData
extends RefCounted

## Spells brought into a map when none are chosen (GDD §5: three spells).
const DEFAULT_LOADOUT: Array[String] = ["shadow_bolt", "bone_wall", "corpse_explosion"]

## Spell rows. Common keys:
##   name     — UI name; icon — icons/<id>.
##   cooldown — s between casts (before meta).
##   target   — "enemy" (nearest enemy to the tap), "road" (nearest road point), "point".
##   ready    — false: listed but not built yet (its script is missing); the slot shows it dimmed.
##   unlock   — optional Unlocks spec (gw2-kit): the pre-map pick offers it only once met.
##   desc     — optional one line for the pre-map pick and the Codex.
## The rest are the spell's own numbers (see its script).
const SPELLS: Dictionary = {
	"shadow_bolt": {
		"name": "Shadow Bolt", "icon": "shadow_bolt", "cooldown": 4.0, "target": "enemy", "ready": true,  # TUNING (not in GDD)
		"damage": 140.0,  # TUNING (not in GDD) the finisher for leaks
		"pick_radius": 90.0,  # px around the tap searched for the target
		"speed": 700.0,  # px/s of the bolt (flies from the necromancer at the gate)
		"projectile": "projectiles/shadow_bolt",
	},
	"bone_wall": {
		"name": "Bone Wall", "icon": "bone_wall", "cooldown": 18.0, "target": "road", "ready": true,  # TUNING (not in GDD)
		"duration": 5.0,  # s the wall blocks the road (GDD §5 "a few seconds")
		"segments": 3,  # wall segments drawn across the road
		"max_snap": 60.0,  # px: a tap farther than this from any road does nothing
	},
	"corpse_explosion": {
		"name": "Corpse Explosion", "icon": "corpse_explosion", "cooldown": 14.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"damage": 45.0,  # TUNING (not in GDD) per corpse to each enemy in its blast
		"blast_radius": 55.0,  # TUNING (not in GDD) px around each corpse
		"pick_radius": 110.0,  # TUNING (not in GDD) px around the tap searched for corpses
		"max_detonate": 10,  # TUNING (not in GDD) corpses detonated per cast
		"max_corpses": 40,  # TUNING (not in GDD) corpse markers kept at once (pool cap; oldest dropped)
		"corpse_life": 25.0,  # TUNING (not in GDD) s a corpse lies on the road
	},
	"plague_cloud": {
		"name": "Plague Cloud", "icon": "plague_cloud", "cooldown": 16.0, "target": "road", "ready": true,  # TUNING (not in GDD)
		"length": 192.0,  # TUNING (not in GDD) px of road covered (GDD §5 "a stretch of road")
		"puffs": 4,  # TUNING (not in GDD) fields along it (spaced length / (puffs - 1) px)
		"radius": 32.0,  # TUNING (not in GDD) px of each field
		"duration": 6.0,  # TUNING (not in GDD) s the cloud lasts
		"tick": 0.5,  # TUNING (not in GDD) s between Rot ticks
		"rot": 9.0,  # TUNING (not in GDD) Rot damage per tick (damage over time, no armour)
		"max_snap": 60.0,  # px: a tap farther than this from any road does nothing
	},
	# --- Later spells (GDD §5 "Later", gw2-kit) ---
	"death_mark": {
		"name": "Death Mark", "icon": "death_mark", "cooldown": 9.0, "target": "enemy", "ready": true,  # TUNING (not in GDD)
		"desc": "Brands a foe; if it dies branded, a Risen rises there",
		"unlock": {"map": "graveyard"},  # TUNING (not in GDD)
		"pick_radius": 90.0,  # px around the tap searched for the target
		"dps": 26.0,  # TUNING (not in GDD) brand damage per second (damage over time)
		"duration": 6.0,  # TUNING (not in GDD) s the brand burns
		"risen_hp": 120.0,  # TUNING (not in GDD) HP of the Risen a branded death raises
		"risen_hold": 1,  # TUNING (not in GDD) enemies it holds
		"risen_damage": 14.0,  # TUNING (not in GDD) per hit
		"risen_interval": 1.0,  # TUNING (not in GDD) s between hits
		"risen_time": 8.0,  # TUNING (not in GDD) s before it crumbles
		"risen_max": 4,  # TUNING (not in GDD) Risen of this spell standing at once
	},
	"soul_chains": {
		"name": "Soul Chains", "icon": "soul_chains", "cooldown": 15.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "Chains a pack: slows it and arcs soul lightning through it",
		"unlock": {"map": "crimson_march"},  # TUNING (not in GDD)
		"pick_radius": 110.0,  # TUNING (not in GDD) px around the tap searched for the first link
		"links": 6,  # TUNING (not in GDD) enemies chained
		"link_reach": 90.0,  # TUNING (not in GDD) px from one link to the next
		"damage": 40.0,  # TUNING (not in GDD) the first arc, to every link
		"slow": 0.5, "duration": 3.5,  # TUNING (not in GDD) GDD §5 "slows"
		"pulse": 12.0, "tick": 0.7,  # TUNING (not in GDD) arc damage to every link each tick while chained
	},
	"wither": {
		"name": "Wither", "icon": "wither", "cooldown": 20.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "A withering aura on a plot: shreds armour around it",
		"unlock": {"map": "crimson_march"},  # TUNING (not in GDD)
		"pick_radius": 90.0,  # TUNING (not in GDD) px around the tap searched for a spot (GDD §5 "a chosen plot")
		"radius": 120.0,  # TUNING (not in GDD) px of the aura
		"duration": 9.0,  # TUNING (not in GDD) s it lasts
		"tick": 0.5,  # TUNING (not in GDD) s between pulses
		"shred": 5.0,  # TUNING (not in GDD) flat armour removed while inside (refreshed each pulse)
		"dps": 6.0,  # TUNING (not in GDD) wither damage per second (damage over time)
		"rot_dps": 0.0,  # Wither Witch's Creeping Rot adds its own (CharacterModifiers)
	},
	"raise_dead": {
		"name": "Raise Dead", "icon": "raise_dead", "cooldown": 22.0, "target": "road", "ready": true,  # TUNING (not in GDD)
		"desc": "Three Risen climb out of the road and hold it",
		"unlock": {"map": "sanctum"},  # TUNING (not in GDD)
		"max_snap": 60.0,  # px: a tap farther than this from any road does nothing
		"count": 3,  # TUNING (not in GDD) GDD §5 "temporary blockers"
		"hp": 100.0,  # TUNING (not in GDD)
		"hold": 1,  # TUNING (not in GDD)
		"damage": 12.0,  # TUNING (not in GDD)
		"interval": 1.0,  # TUNING (not in GDD)
		"duration": 10.0,  # TUNING (not in GDD)
	},
	# --- Act II, the Black Tide (w2b-tide): Necropathy's Crow / Marrec / Vandermere rewards ---
	"chain_shot": {
		"name": "Chain Shot", "icon": "chain_shot", "cooldown": 10.0, "target": "road", "ready": true,  # TUNING (not in GDD)
		"desc": "Spectral chain-shot rakes the road back and forth, knocking foes back",
		"unlock": {"map": "cutter"},  # Necropathy: Captain Crow's reward
		"max_snap": 60.0,  # px: a tap farther than this from any road does nothing
		"length": 260.0,  # TUNING (not in GDD) px of road raked back toward the entrance (Necropathy 230-320 px)
		"speed": 520.0,  # TUNING (not in GDD) px/s of a shot along the road
		"width": 22.0,  # TUNING (not in GDD) px from the shot within which a foe is struck (Necropathy 14-18)
		"damage": 34.0,  # TUNING (not in GDD) per foe each way (out and back)
		"knock": 50.0,  # TUNING (not in GDD) px a foe struck on the way out is knocked back (Necropathy Keelhauler 80)
		"shots": 1,  # TUNING (not in GDD) chain-shots per cast (Necropathy 1 -> 3)
		"stagger": 0.35,  # TUNING (not in GDD) s between two shots of one cast
	},
	"cannonade": {
		"name": "Cannonade", "icon": "cannonade", "cooldown": 14.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "Marks the densest packs; spectral cannonballs fall on them",
		"unlock": {"map": "galleon"},  # Necropathy: Admiral Marrec's reward
		"reach": 200.0,  # TUNING (not in GDD) px around the tap searched for packs (Necropathy 340-360 around the necromancer)
		"marks": 3,  # Necropathy up to 3 marks (4 from Lv 4)
		"delay": 0.75,  # Necropathy "a soul-lit ring shows 0.75 s"
		"radius": 40.0,  # TUNING (not in GDD) px of a ball's blast (Necropathy 30-38)
		"damage": 60.0,  # TUNING (not in GDD) per ball to every foe in it
		"spread": 70.0,  # TUNING (not in GDD) px two marks keep apart
	},
	"anchor_drop": {
		"name": "Anchor Drop", "icon": "anchor_drop", "cooldown": 12.0, "target": "enemy", "ready": true,  # TUNING (not in GDD)
		"desc": "A spectral anchor slams the strongest foe, stuns it and shocks those around",
		"unlock": {"map": "maelstrom"},  # Necropathy: Captain Vandermere's reward
		"pick_radius": 120.0,  # TUNING (not in GDD) px around the tap searched for the strongest foe
		"fall": 0.4,  # Necropathy the anchor falls 0.4 s
		"damage": 150.0,  # TUNING (not in GDD) to the anchored foe (Necropathy 34 -> 72 on the open deck)
		"stun": 1.2,  # Necropathy 0.8 -> 1.2 s (TdCombat.freeze_enemy: rank multipliers apply)
		"shock": 0.35,  # Necropathy 30-40% of it to the foes around
		"shock_radius": 64.0,  # Necropathy 48 -> 64 px
	},
	# --- Act III: the Sanguine Court (w2b-court; Necropathy's Act VII spells) ---
	"moonfang": {
		"name": "Moonfang", "icon": "moonfang", "cooldown": 12.0, "target": "enemy", "ready": true,  # TUNING (not in GDD)
		"desc": "Spectral wolf jaws snap at the nearest packs and leave them bleeding",
		"unlock": {"map": "ravensmoor"},  # Necropathy: unlocked by slaying Vargr
		"pick_radius": 110.0,  # TUNING (not in GDD) px around the tap searched for the first pack
		"jaws": 2,  # TUNING (not in GDD) packs snapped per cast (+ the Moon-Cursed Huntress's innate "moonfang_jaws")
		"jaw_gap": 90.0,  # TUNING (not in GDD) px a further jaw's pack keeps from the others (Necropathy JAW_GAP)
		"jaw_reach": 260.0,  # TUNING (not in GDD) px from the tap searched for the further packs
		"jaw_radius": 50.0,  # TUNING (not in GDD) px of each jaw's bite
		"damage": 55.0,  # TUNING (not in GDD) per enemy in a jaw
		"bleed_dps": 12.0, "bleed_time": 4.0,  # TUNING (not in GDD) the bleed (damage over time)
		"snap_time": 0.25,  # Necropathy SNAP_TIME: s the jaws take to close
	},
	"witch_circle": {
		"name": "Hex Circle", "icon": "witch_circle", "cooldown": 18.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "A crimson circle drains every foe inside and feeds your blockers",
		"unlock": {"map": "witchwood"},  # Necropathy: unlocked by slaying Isolde
		"radius": 80.0,  # TUNING (not in GDD) px (+ the Hedge Witch's innate "circle_radius" share)
		"duration": 7.0,  # TUNING (not in GDD) s
		"tick": 0.5,  # TUNING (not in GDD) s between drains
		"drain": 10.0,  # TUNING (not in GDD) damage per tick to every foe inside (damage over time)
		"heal_share": 0.5,  # TUNING (not in GDD) share of the drain healed to the blocker bodies inside, split between them
	},
	"night_swarm": {
		"name": "Night Swarm", "icon": "night_swarm", "cooldown": 20.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "Spectral bats circle a spot and dart at every foe near it",
		"unlock": {"map": "castle_sanguis"},  # Necropathy: unlocked by Carmilla and the Elder
		"bats": 4,  # TUNING (not in GDD) Necropathy `bats` (+ the Dhampir's innate "swarm_bats")
		"orbit": 46.0,  # TUNING (not in GDD) px the swarm circles the spot
		"orbit_speed": 2.4,  # TUNING (not in GDD) rad/s
		"aim": 150.0,  # TUNING (not in GDD) px from the spot a bat darts to
		"bite_every": 1.2,  # TUNING (not in GDD) s between one bat's bites (staggered round the swarm)
		"damage": 8.0,  # TUNING (not in GDD) per bite
		"dart_time": 0.25,  # TUNING (not in GDD) s a dart takes (drawn only: the bite lands at once)
		"duration": 7.0,  # TUNING (not in GDD) s the swarm stays
	},
	# --- Act IV, the Last Line (w2b-city; Necropathy's Act VIII spells) ---
	"hearse_run": {
		"name": "Hearse Run", "icon": "hearse_run", "cooldown": 16.0, "target": "road", "ready": true,  # TUNING (not in GDD)
		"desc": "A spectral hearse drives back up the road through the enemy",
		"unlock": {"map": "skid_row"},  # Necropathy: slaying Don Marrow unlocks Hearse Run
		"max_snap": 60.0,  # px: a tap farther than this from any road does nothing
		"length": 260.0,  # TUNING (not in GDD) px of road it drives, from the tap back toward the entrance
		"drive_time": 1.1,  # TUNING (not in GDD) s it takes
		"damage": 75.0,  # TUNING (not in GDD) to each enemy it runs over (once per hearse)
		"stagger": 1.0,  # TUNING (not in GDD) s each one makes no attack
		"hit_radius": 26.0,  # TUNING (not in GDD) px from the hearse that counts as run over
		"hearses": 1,  # Necropathy one hearse a cast (the Undertaker's Last Ride adds one)
		"hearse_gap": 0.35,  # TUNING (not in GDD) s between two hearses of one cast
	},
	"bone_mines": {
		"name": "Bone Mines", "icon": "bone_mines", "cooldown": 14.0, "target": "road", "ready": true,  # TUNING (not in GDD)
		"desc": "Bone mines along the road go off under the enemy",
		"unlock": {"map": "fort_kessler"},  # Necropathy: slaying General Harrow unlocks Bone Mines
		"max_snap": 60.0,  # px: a tap farther than this from any road does nothing
		"mines": 3,  # TUNING (not in GDD) mines laid per cast (the Fallen Sergeant's Sapper's Hands adds one)
		"spacing": 42.0,  # TUNING (not in GDD) px between mines along the road
		"arm": 0.5,  # Necropathy ARM_TIME 0.5 s
		"trigger": 18.0,  # TUNING (not in GDD) px: an enemy's body within this of a mine sets it off (flyers never do)
		"body_pad": 30.0,  # px added to the trigger search (>= the largest walking body radius)
		"blast_radius": 52.0,  # TUNING (not in GDD) px
		"damage": 85.0,  # TUNING (not in GDD) to every enemy in the blast (armour applies; it goes round shields)
		"life": 30.0,  # TUNING (not in GDD) s an unexploded mine lies there
		"max_mines": 15,  # TUNING (not in GDD) mines on the road at once (oldest dropped)
	},
	"heros_fist": {
		"name": "Hero's Fist", "icon": "heros_fist", "cooldown": 12.0, "target": "enemy", "ready": true,  # TUNING (not in GDD)
		"desc": "A spectral fist slams the strongest foe and flings it through the rest",
		"unlock": {"map": "liberty_heights"},  # Necropathy: defeating Paragon unlocks Hero's Fist
		"pick_radius": 130.0,  # TUNING (not in GDD) px around the tap searched for the strongest foe
		"damage": 230.0,  # TUNING (not in GDD) the slam
		"stun": 1.0,  # TUNING (not in GDD) s the struck foe is frozen (rank multipliers apply)
		"fling_radius": 70.0,  # TUNING (not in GDD) px round it where the flung foe strikes the others
		"fling_damage": 60.0,  # TUNING (not in GDD) to each of those
		"fists": 1,  # Necropathy one fist (the Revenant Heroine adds one, at the next strongest)
	},
	# --- Act V spells (w2b-shogun; Necropathy's Shogunate rewards) ---
	"hundred_shadows": {
		"name": "Hundred Shadows", "icon": "hundred_shadows", "cooldown": 18.0, "target": "road", "ready": true,  # TUNING (not in GDD)
		"desc": "Shadow clones step out of the road and cut down what comes near",
		"unlock": {"map": "province"},  # Kage's reward
		"max_snap": 60.0,  # px: a tap farther than this from any road does nothing
		"count": 3,  # TUNING (not in GDD) clones per cast
		"damage": 22.0,  # TUNING (not in GDD) per strike
		"tick": 0.6,  # TUNING (not in GDD) s between one clone's strikes
		"radius": 110.0,  # TUNING (not in GDD) px a clone reaches
		"duration": 7.0,  # TUNING (not in GDD) s they fight
		"sprite": "player/grave_kunoichi",  # the clones' look
	},
	"banner_of_the_dead": {
		"name": "Banner of the Dead", "short": "Banner", "icon": "banner_of_the_dead", "cooldown": 24.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "A war banner: towers near it attack faster for a while",
		"unlock": {"map": "kurogane"},  # Shogun Kurogane's reward
		"radius": 170.0,  # TUNING (not in GDD) px of towers rallied
		"rate_mult": 1.3,  # TUNING (not in GDD) attack speed x
		"duration": 9.0,  # TUNING (not in GDD) s
	},
	"black_sun": {
		"name": "Black Sun", "icon": "black_sun", "cooldown": 20.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "A dark sun hangs over the road and beams the thickest pack",
		"unlock": {"map": "sun_road"},  # Amaterasu's reward
		"radius": 150.0,  # TUNING (not in GDD) px it reaches
		"damage": 34.0,  # TUNING (not in GDD) per beam to each foe in the splash
		"splash": 40.0,  # TUNING (not in GDD) px around the beamed foe
		"tick": 0.8,  # TUNING (not in GDD) s between beams
		"duration": 8.0,  # TUNING (not in GDD) s it hangs
	},
	# --- Act VI spells (w2c-norse; Necropathy's Hall of the Slain rewards) ---
	"barrow_grasp": {
		"name": "Barrow Grasp", "short": "Grasp", "icon": "barrow_grasp", "cooldown": 20.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "Cold hands burst from the ground in a ring and hold what they grab",
		"unlock": {"map": "barrow_fields"},  # Hrimgar's reward
		"hands": 5,  # TUNING (not in GDD) hands per cast (Necropathy hands)
		"ring": 55.0,  # TUNING (not in GDD) px from the tap the hands burst
		"radius": 40.0,  # TUNING (not in GDD) px each hand grabs
		"damage": 40.0,  # TUNING (not in GDD) per grab
		"hold": 1.8,  # TUNING (not in GDD) s each grab freezes (TdCombat.freeze_enemy, by rank)
	},
	"valkyrie_spear": {
		"name": "Valkyrie Spear", "short": "Valkyrie", "icon": "valkyrie_spear", "cooldown": 14.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "A spectral spear dives on the strongest foe near the tap and leaps to the next",
		"unlock": {"map": "valgard"},  # Sigrun's reward
		"range": 160.0,  # TUNING (not in GDD) px from the tap it seeks the strongest foe
		"damage": 120.0,  # TUNING (not in GDD) first strike
		"jumps": 3,  # TUNING (not in GDD) leaps after the first strike (Necropathy jumps)
		"chain": 130.0,  # TUNING (not in GDD) px a leap reaches
		"falloff": 0.8,  # TUNING (not in GDD) each strike x this of the last
		"gap": 0.15,  # TUNING (not in GDD) s between two strikes
	},
	"gungnir": {
		"name": "Gungnir", "icon": "gungnir", "cooldown": 22.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "The All-Father's spear flies through the strongest foe near the tap and everything in its line",
		"unlock": {"map": "vigrid"},  # Odin's reward
		"aim": 180.0,  # TUNING (not in GDD) px from the tap it seeks the strongest foe
		"spears": 1,  # TUNING (not in GDD) spears per cast (the next strongest for each more)
		"length": 900.0,  # TUNING (not in GDD) px the spear flies from the necromancer's gate
		"width": 26.0,  # TUNING (not in GDD) px each side of its line it strikes (Necropathy spear_width)
		"damage": 160.0,  # TUNING (not in GDD) per foe struck
	},
	# --- Act VII spells (w2c-dynasty; Necropathy's Dynasty rewards) ---
	"linen_bind": {
		"name": "Linen Bind", "short": "Linen", "icon": "linen_bind", "cooldown": 20.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "Bandages hold the foes near the tap; the bound leave no Name and rise as your Mummies",
		"unlock": {"map": "necropolis"},  # Anubis' reward
		"radius": 120.0,  # TUNING (not in GDD) px around the tap
		"targets": 5,  # Necropathy "up to 5 enemies"
		"damage": 30.0,  # TUNING (not in GDD) per wrapped foe
		"hold": 1.6,  # TUNING (not in GDD) s held (x rank)
		"mark": 6.0,  # TUNING (not in GDD) s a wrapped foe that dies still rises
		"cap": 4,  # TUNING (not in GDD) Mummies standing at once
		"mummy_hp": 120.0,  # TUNING (not in GDD)
		"mummy_hold": 2,  # TUNING (not in GDD)
		"mummy_damage": 12.0,  # TUNING (not in GDD)
		"mummy_interval": 1.0,  # TUNING (not in GDD)
		"mummy_life": 8.0,  # TUNING (not in GDD) s
	},
	"burning_eye": {
		"name": "Burning Eye", "short": "Eye", "icon": "burning_eye", "cooldown": 18.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "A solar eye opens and sweeps its burning beam across the road",
		"unlock": {"map": "lioness_temple"},  # Sekhmet's reward
		"range": 210.0,  # TUNING (not in GDD) px the beam reaches
		"width": 26.0,  # TUNING (not in GDD) px
		"damage": 26.0,  # TUNING (not in GDD) per tick to each foe on the beam
		"tick": 0.35,  # TUNING (not in GDD) s
		"turn": 0.9,  # TUNING (not in GDD) rad/s it sweeps (Necropathy: a 90 degree arc)
		"duration": 5.0,  # TUNING (not in GDD) s it stays open
	},
	"feathers_verdict": {
		"name": "Feather's Verdict", "short": "Verdict", "icon": "feathers_verdict", "cooldown": 22.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "A gold feather falls on the strongest foe and executes the weak around it",
		"unlock": {"map": "two_truths"},  # Osiris and Ammit's reward
		"radius": 160.0,  # TUNING (not in GDD) px around the tap it looks for the strongest
		"fall_time": 0.8,  # TUNING (not in GDD) s
		"damage": 160.0,  # TUNING (not in GDD) to the judged foe
		"ring": 110.0,  # TUNING (not in GDD) px of the execution ring
		"execute": 0.3,  # TUNING (not in GDD) share of max HP at or under which a foe is executed
	},
	# --- Act VIII spells (w2c-pantheon; Necropathy's Olympian Republic rewards) ---
	"paris_arrow": {
		"name": "Paris's Arrow", "short": "Paris's Arrow", "icon": "paris_arrow", "cooldown": 14.0, "target": "enemy", "ready": true,  # TUNING (not in GDD)
		"desc": "A ghost arrow from behind: through any shield, and it finds a hero's heel",
		"unlock": {"map": "ilion"},  # Achilles' reward
		"pick_radius": 90.0,  # px around the tap searched for targets
		"arrows": 1,  # TUNING (not in GDD) arrows per cast (each at the next strongest foe)
		"damage": 320.0,  # TUNING (not in GDD) per arrow
		"fated_mult": 1.8,  # TUNING (not in GDD) x on bosses and minibosses
		"behind": 120.0,  # px behind the foe its origin lies (the arrow's flight drawn from there)
		"streak_w": 10.0,  # px wide streak (drawn only)
		"impact_d": 70.0,  # px impact burst (drawn only)
	},
	"stolen_thunder": {
		"name": "Stolen Thunder", "short": "Thunder", "icon": "stolen_thunder", "cooldown": 20.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "A stolen storm strikes the toughest foe and chains to the next",
		"unlock": {"map": "olympus"},  # Zeus's reward
		"radius": 150.0,  # TUNING (not in GDD) px the storm reaches
		"duration": 4.0,  # TUNING (not in GDD) s it hangs
		"tick": 0.8,  # TUNING (not in GDD) s between bolts
		"damage": 75.0,  # TUNING (not in GDD) first strike of a bolt
		"armour_bonus": 1.3,  # TUNING (not in GDD) Necropathy: armoured foes take more
		"chains": 2,  # TUNING (not in GDD) hops after the first strike
		"chain_range": 90.0,  # TUNING (not in GDD) px a hop reaches
		"chain_falloff": 0.7,  # TUNING (not in GDD) x per hop
		"cloud_lift": 70.0,  # px the cloud hangs above the tap (drawn only)
		"cloud_d": 70.0,  # px the cloud is wide (drawn only)
		"bolt_w": 9.0,  # px wide bolt streak (drawn only)
		"impact_d": 64.0,  # px strike burst (drawn only)
	},
	"river_styx": {
		"name": "River Styx", "short": "Styx", "icon": "river_styx", "cooldown": 22.0, "target": "road", "ready": true,  # TUNING (not in GDD)
		"desc": "Black water floods the road: it hurts and slows all that wade through",
		"unlock": {"map": "underworld"},  # Hades' reward
		"max_snap": 60.0,  # px: a tap farther than this from any road does nothing
		"length": 180.0,  # TUNING (not in GDD) px of road it covers
		"radius": 30.0,  # TUNING (not in GDD) px from its course a foe is in the water
		"duration": 7.0,  # TUNING (not in GDD) s it flows
		"tick": 0.5,  # TUNING (not in GDD) s between ticks
		"damage": 11.0,  # TUNING (not in GDD) per tick (damage over time: no armour, no shield)
		"slow": 0.5,  # TUNING (not in GDD) speed x in the water
		"slow_time": 0.8,  # TUNING (not in GDD) s the slow lasts after a tick
		"risen_hp": 90.0, "risen_damage": 10.0, "risen_interval": 1.0, "risen_time": 5.0,  # TUNING (not in GDD) the Ferrywoman's Ferry of Souls Risen
		"blob_step": 22.0,  # px between drawn water blobs (drawn only)
	},
	# --- Act IX spells (w2c-inferno; Necropathy's Inferno rewards) ---
	"brimstone": {
		"name": "Brimstone", "icon": "brimstone", "cooldown": 16.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "Burning stones fall on the thickest crowd and leave fire; cast on a portal, it seals it",
		"unlock": {"map": "burning_gate"},  # Moloch's reward
		"radius": 140.0,  # TUNING (not in GDD) px around the tap searched for crowds
		"stones": 3,  # TUNING (not in GDD) stones per cast (Necropathy Lv 4-5: 3)
		"damage": 60.0,  # TUNING (not in GDD) per stone to each foe in its blast
		"blast": 42.0,  # TUNING (not in GDD) px (Necropathy Lv 5: 42)
		"fall_time": 0.6,  # TUNING (not in GDD) s a stone falls (its landing circle shows)
		"field_radius": 36.0,  # TUNING (not in GDD) px of the fire it leaves
		"field_life": 3.0,  # TUNING (not in GDD) s it burns
		"field_dps": 16.0,  # TUNING (not in GDD) damage per s in it
		"field_tick": 0.5,  # TUNING (not in GDD) s between two burns
	},
	"tempt": {
		"name": "Temptation", "icon": "tempt", "cooldown": 18.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "The strongest foes near the tap are charmed: they turn and fight their own",
		"unlock": {"map": "silk_palace"},  # Lilith's reward
		"radius": 150.0,  # TUNING (not in GDD) px around the tap
		"charms": 2,  # TUNING (not in GDD) foes charmed (the most HP first; never a boss)
		"charm_time": 6.0,  # Necropathy "fights for you for 6 s"
		"damage": 30.0,  # TUNING (not in GDD) each thrall's blow
		"reach": 60.0,  # TUNING (not in GDD) px a thrall reaches
	},
	"fall_from_grace": {
		"name": "Fall from Grace", "short": "Grace", "icon": "fall_from_grace", "cooldown": 14.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "A fallen star crashes down on the strongest foe near the tap",
		"unlock": {"map": "pandemonium"},  # The Morning Star's reward
		"radius": 170.0,  # TUNING (not in GDD) px around the tap
		"damage": 320.0,  # TUNING (not in GDD) to the strongest foe (a single-target finisher)
		"splash": 0.4,  # Necropathy splash 0.4
		"crash": 50.0,  # TUNING (not in GDD) px of the splash
		"fall_time": 0.6,  # Necropathy fall_time 0.6
	},
	# --- Act X spells (w2c-host; Necropathy's Celestial Host rewards) ---
	"flaming_sword": {
		"name": "Flaming Sword", "short": "Sword", "icon": "flaming_sword", "cooldown": 14.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "A sword of white fire sweeps round the tap and sets the foes there burning",
		"unlock": {"map": "silver_stair"},  # Seraiel's reward
		"radius": 90.0,  # TUNING (not in GDD) px the sweep reaches
		"damage": 70.0,  # TUNING (not in GDD) per sweep to each foe in it
		"burn_dps": 12.0,  # TUNING (not in GDD) damage per s of the burn
		"burn_time": 4.0,  # TUNING (not in GDD) s
		"sweeps": 1,  # TUNING (not in GDD) per cast (the Fallen Herald's boost adds one)
		"sweep_gap": 0.5,  # TUNING (not in GDD) s between two sweeps
	},
	"wheel_of_eyes": {
		"name": "Wheel of Eyes", "short": "Wheel", "icon": "wheel_of_eyes", "cooldown": 16.0, "target": "road", "ready": true,  # TUNING (not in GDD)
		"desc": "A burning wheel rolls back down the road and rebounds, striking all it passes",
		"unlock": {"map": "wheel_of_thrones"},  # the Throne's reward
		"max_snap": 60.0,  # px: a tap farther than this from any road does nothing
		"speed": 260.0,  # TUNING (not in GDD) px/s it rolls
		"length": 260.0,  # TUNING (not in GDD) px of one pass
		"width": 26.0,  # TUNING (not in GDD) px it strikes round its centre
		"damage": 55.0,  # TUNING (not in GDD) per foe per pass
		"rebounds": 1,  # TUNING (not in GDD) passes back after the first
	},
	"revelation": {
		"name": "Revelation", "icon": "revelation", "cooldown": 24.0, "target": "point", "ready": true,  # TUNING (not in GDD)
		"desc": "A flash of unbearable light: the foes near the tap freeze and are weakened",
		"unlock": {"map": "empyrean"},  # the Voice's reward
		"radius": 170.0,  # TUNING (not in GDD) px of the flash (Necropathy: the whole screen; a TD map is one screen)
		"stun": 1.2,  # TUNING (not in GDD) s frozen (Necropathy 1 s; rank multipliers apply)
		"weaken": 0.6,  # TUNING (not in GDD) damage x of the foes it weakens
		"weaken_time": 6.0,  # TUNING (not in GDD) s
	},
}

## The ultimate (GDD §5 Dread Rally), cast through SpellCaster like a spell
## (scripts/spells/dread_rally.gd) but charged by kills instead of a cooldown.
const ULTIMATE: Dictionary = {
	"id": "dread_rally", "name": "Dread Rally", "icon": "dread_rally",
	"meter_max": 100.0,  # TUNING (not in GDD) meter units for a full charge
	"charge": {"fodder": 1.0, "elite": 4.0, "miniboss": 20.0, "boss": 0.0},  # TUNING (not in GDD) per kill by rank
	"duration": 8.0,  # GDD §5 "for 8 s"
	"damage_mult": 1.4,  # GDD §5 "+40% damage"
	"rate_mult": 1.4,  # GDD §5 "+40% attack speed"
}

## The later ultimates (GDD §5 "Sovereign's Decree, Eclipse and Grave Tide are
## later unlocks on the same meter"; gw2-kit). Each is cast by
## scripts/spells/<id>.gd on the Dread Rally meter (ULTIMATE meter_max / charge);
## chosen in the pre-map pick (SpellCaster.ultimate_id). Common keys: name,
## short (optional tile name when the name is too long),
## icon, desc, unlock (Unlocks spec), sound (Sfx id); the rest are its own numbers.
const ULTIMATES: Dictionary = {
	"sovereigns_decree": {
		"name": "Sovereign's Decree", "short": "Decree", "icon": "sovereigns_decree", "sound": "ult_decree",
		"desc": "Revives every blocker; barriers on all of them, held foes weakened",
		"unlock": {"map": "graveyard", "skulls": 3},  # TUNING (not in GDD)
		"duration": 8.0,  # Necropathy "for 8 s"
		"barrier_frac": 0.5,  # TUNING (not in GDD) barrier HP as a fraction of each body's max HP (Necropathy "50% less damage")
		"weaken": 0.5,  # TUNING (not in GDD) damage multiplier on enemies held meanwhile
	},
	"eclipse": {
		"name": "Eclipse", "icon": "eclipse", "sound": "ult_eclipse",
		"desc": "Darkness: every foe freezes, then takes more damage",
		"unlock": {"map": "crimson_march", "skulls": 3},  # TUNING (not in GDD)
		"freeze": 3.0,  # TUNING (not in GDD) Necropathy 4 s (rank multipliers apply)
		"curse_mult": 1.3,  # Necropathy "+30% damage"
		"curse_time": 9.0,  # TUNING (not in GDD) freeze + Necropathy's 6 s
	},
	"grave_tide": {
		"name": "Grave Tide", "icon": "grave_tide", "sound": "ult_tide",
		"desc": "For a while every foe that dies rises as a Risen for you",
		"unlock": {"map": "sanctum", "skulls": 3},  # TUNING (not in GDD)
		"duration": 10.0,  # Necropathy "for 10 s"
		"risen_hp": 80.0,  # TUNING (not in GDD)
		"risen_damage": 12.0,  # TUNING (not in GDD)
		"risen_interval": 1.0,  # TUNING (not in GDD)
		"risen_time": 8.0,  # TUNING (not in GDD) Necropathy 12 s
		"risen_max": 10,  # TUNING (not in GDD) Risen standing at once
	},
}
