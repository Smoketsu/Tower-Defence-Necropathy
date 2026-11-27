# Necropathy: Gravewatch

A fixed-path tower defense built from the art, audio and interface of
**Necropathy** (Godot 4.3, GDScript, GL Compatibility, 1280 x 720). You are a
necromancer holding a crypt: Covenant columns march down roads toward the
Ossuary gate and you raise undead on grave plots and road posts to stop them.
The design is `docs/GDD.md`; decisions it does not cover are in
`docs/DECISIONS.md`.

## How it plays

- **Title -> map select -> pre-map setup -> map.** One fixed screen per map. The
  title also opens the Codex, the Ossuary, Settings and Credits. The map select
  shows each map's lock, best skulls per difficulty and best Reckoning wave; the
  setup picks the character, the spells (3, or 4 with the Fourth Rite), the
  ultimate and the difficulty (with its Soul Ash multiplier).
- **Meta (GDD §8.2):** Soul Ash from every run (by skulls and difficulty on a
  clear, by waves on a defeat) buys Ossuary upgrades; a class at Lv 5 opens its
  Mastery; a map's boss opens the next map. Saved in `user://gravewatch_save.cfg`
  (Settings -> Save gives a backup code).
- **Waves stream in back to back** (owner decision): enemies are tightly spaced
  inside a wave and the next wave starts by itself `TdRulesData.AUTO_GAP` (5 s)
  after the previous wave's last spawn. The first wave waits for **Call**; Call
  during a gap starts the next wave at once and pays 1 soul per second skipped.
- **Build while they come.** Tap / click a spot: an empty **grave plot** offers
  the ranged and support towers, an empty **road post** the blockers (with costs,
  and the synergies each would join there). An occupied spot offers **Upgrade**
  (levels 1-5), **Target** (First / Last / Strongest / Nearest), **Sell** (70%
  back) and **Evolve** only once a hidden recipe is met (tier 6).
- **Level 3** switches on the class's volley (extra tinted shots / pulse look).
- **Blockers** (Skeleton Warrior, Corpse Abomination, Bone Golem) stand on the road and hold
  enemies; bodies fall several times a map and return for free after their respawn time.
- **Later towers** open as Act I is cleared (DECISIONS K2): Crypt Warder (barriers on
  blockers), Grave Rogue (dashes at elites), Crypt Gargoyle (swoops, flyers first), Bone
  Hounds (a pack running the road), Fallen Seraph (three feathers) and Bone Golem (slams,
  plants). The build menu is one strip of six tiles (icon, short name, cost) with < and > page
  buttons at its ends and page dots when a spot offers more; a built tower's panel shows its
  level, stats and the next level's gains. Selling asks first (DECISIONS M7-M8).
- **Acts:** the map select has one tab per act (fifteen, Necropathy's act order). Acts I-V
  are playable, fifteen maps in one unlock chain (each boss opens the next map): Act I the
  Covenant (Graveyard, Crimson March, Sanctum), Act II the Black Tide (Cutter, Galleon,
  Maelstrom; Broadsides shell plots), Act III the Sanguine Court (Ravensmoor, Witchwood,
  Castle Sanguis; the Blood Moon), Act IV the Last Line (Skid Row, Fort Kessler, Liberty
  Heights; Escalation), Act V the Shogunate (Province, Kurogane, Road to the Sun; the Sun's
  Course: night hides foes outside lantern light); Part Two: Act VI the Hall of the Slain
  (Barrow Fields, Valgard, Vigrid; the Long Winter chills towers away from lit braziers),
  Act VII the Necropolis Dynasty (Necropolis of Sand, Temple of the Lioness, Hall of Two
  Truths; Rebirth: the fallen leave Names that rise again unless smashed, the Sandstorm, the
  Scales), Act VIII the Olympian Republic (Shores of Ilion, Mount Olympus, Asphodel Underworld;
  the Phalanx's shield fronts and the Wrath of the Gods), Act IX the Inferno (Burning Gate,
  Palace of Silk and Ash, Pandemonium; Portals to bar or seal, Hell Pits, Temptation) and Act
  X the Celestial Host (Silver Stair, Wheel of Thrones, Empyrean; the Hallowed Light weakens
  towers out of the shade, Judgment returns lost bodies as Judges); Part Three: Act XI the
  Ancient Eye (Gullhaven Harbour, the Hollow Archive, Ul-Thalos; Claims: a body felled near a
  claimer rises as a Drowned Thrall), Act XII the Electronic Empire (Scrap Wastes, Assembly
  Halls, Iron Citadel; the Line of Fire: Empire guns disable towers, posts in the line stop the
  shots), Act XIII the Concord of Stars (Crash Site, Proving Moon, Ark of the Concord;
  Abduction: saucers on sky lanes lift posts and towers), Act XIV the Age of Titans (Fern
  Basin, Great Plain, the Last Day; Stampedes trample plots and turn back when hurt) and Act
  XV the Turning Year (Greenwood, Fae Court, the World-Tree, the campaign's last map; the
  seasons turn). Forty-five maps in one unlock chain. Each later act opens its own tower
  (Powder Wraith, Blood Spawn, Fallen Hero, Bound Oni, Draugr Thane, Ushabti Sentinel,
  Myrmidon Shades, Bound Succubus and Archfiend, Bound Ophan, Spawn of the Deep, Grave Drone
  and Iron Revenant, Ghost Saucer, Bonehorn, Ossuary Oak), three spells and three characters.
- **Spells** (bottom bar, or a left column on wide phones; keys 1-4): tap the
  spell, then the target. Shadow Bolt (aimed shot from the necromancer at the
  gate), Bone Wall (blocks the road a few seconds; bosses walk through), Corpse
  Explosion (detonates the corpses near the tap), Plague Cloud (Rot along the
  road); later Death Mark, Soul Chains, Wither and Raise Dead. Three are brought; the Ossuary's Fourth Rite adds a slot.
  **Ultimate** (Space), charged by kills, picked before the map: Dread Rally (revives every fallen
  blocker, all towers +40% damage and attack speed for 8 s), later Sovereign's Decree, Eclipse, Grave Tide.
- **Lives:** fodder 1, elite 3, miniboss 5, boss 10 (a row may set its own). A miniboss
  meeting a full post pushes a lesser enemy out of a body and is held itself. The mid-map
  miniboss drops a **chest** = one free upgrade or evolution. The stage boss
  walks the road on the final wave. A win is rated 1-3 skulls by lives kept.
- **Speed** x1 / x2 / x3 (Tab), **Pause** (Esc), Call (Enter). Mouse, touch
  and gamepad (stick jumps between spots, A selects, X / Y / B spells, LB
  ultimate, RB call, Start pause). Keys are rebindable in Settings.

## Architecture

```
project.godot            1280x720, canvas_items/expand, GL Compatibility; autoloads GameState, Sfx, Settings
export_presets.cfg       "Web" preset (no threads) + web/mobile_shell.html (copied from Necropathy)
scenes/main.tscn         -> scripts/main.gd
scripts/
  main.gd                title -> map select -> TdGame; --autotest -> TdAutotest
  core/                  copied: sprite_bank, spatial_hash, settings (trimmed); new: game_state (CLI options)
  audio/                 copied as is: sfx (run_mode_for reads the map registry; Necropathy's audio overhaul:
                         sampled takes, per-map songs), synth, startup/run-loop/menu synths
  fx/                    copied: sharp_pixel.gdshader, unit_layer.gd (a draw-callback layer, reused everywhere)
  ui/                    copied: ui_theme, kit_style_box, ui_motion, confirm_dialog, input_hints, touch_support,
                         rotate_overlay (+ chamfer() from Necropathy's TouchControls)
  ui/                    + menu_backdrop (Necropathy's living menu diorama), mask_icon (pixel icons)
  ui/td/                 new screens: menu_screen (shared frame: header, Back, Ash pill, hint strip), title_screen, map_select + map_card,
                         prerun_setup, ossuary_screen, codex_screen, settings_screen, credits_screen,
                         td_hud, spell_button, spot_menu, spot_cursor (gamepad), map_hints (range /
                         synergy preview), pause_menu, results_screen
  core/meta.gd           the save file and records (Soul Ash, Ossuary, masteries, clears, skulls, Codex);
                         core/run_watch.gd records a run's Codex entries and masteries; core/save_backup.gd
  data/                  copied Necropathy data (sprite/ui/sound/menu-theme/touch/input/effects/walk/idle/boss-pose)
                         new Gravewatch data, no logic:
                           td_art_data (art role -> PNG), td_rules_data (clock, lives, pacing, skulls),
                           economy_data (GDD §8.1 souls), tower_data, evolution_data, synergy_data,
                           td_enemy_data, spell_data, difficulty_data, build_order_data, td_sound_data, td_ui_data
  maps/                  map_registry.gd, graveyard_map.gd (const MAP), rules/map_rule.gd (base)
  td/                    the core: td_game (run root, clock, actions), map_loader, map_view, road, path_follower,
                         road_block, block_body, td_enemy, wave_director, tower, spot, td_projectiles, td_fx,
                         td_combat, soul_economy, spell_caster, synergies, evolutions, difficulty_modifiers,
                         meta_modifiers, td_art, td_autotest, td_vfx (combat effects, visual only)
  towers/                tower_behavior.gd (base) + projectile.gd, aura.gd, blocker.gd
  enemies/               enemy_trait.gd (base) + traits/templar_charge, healer, banner_aura
  bosses/                alaric.gd (an EnemyTrait)
  spells/                td_spell.gd (base) + shadow_bolt, bone_wall, dread_rally
assets/                  only the Act I art copied from Necropathy (~7 MB) + assets/sprites/td/ (Gravewatch art)
tools/                   patch_web_audio.py, patch_web_gl.py (copied); web_music.sh (songs beside the Web page), gw_phone.js (phone probe)
```

One path per concern: all damage, statuses, heals, kills and leaks go through
`TdCombat`; all souls through `SoulEconomy`; tower stats through
`Tower.recompute()`; difficulty through `DifficultyModifiers`; meta through
`MetaModifiers`. Determinism: one seeded RNG in `TdGame`, a fixed-step game
clock (60 ticks per game second, `speed` ticks per physics frame), no wall time.

## Autotest

```bash
G=/home/user/tools/godot/Godot_v4.3-stable_linux.x86_64
$G --headless --import
$G --headless --fixed-fps 60 --quit-after 60000 -- --autotest [--map=<any of the 45 map ids>] [--seed=N] [--speed=N] [--difficulty=initiate|necromancer|lich|deathlord] [--build=ID]
```

| Option | Meaning |
|---|---|
| `--map=` | any registered map id (ActData / MapRegistry; default `graveyard`; `test_grounds` = the hidden framework test map) |
| `--seed=` | run seed (default 1) |
| `--speed=` | fixed steps per physics frame, 1-64 (default 8; the result does not depend on it) |
| `--difficulty=` | DifficultyData id (default `necromancer`) |
| `--build=` | BuildOrderData id (default: the map's `build_order`; `weak` = the bad placement order; `towers_a` = the four shooters to Lv 5 + Lich, Winter Revenant, Gravebow; `towers_b` = support / blockers to Lv 5 + Death Knight, Profane Bishop (loses to Alaric); `evolve_all` = test order with bonus souls, seven evolutions in one run; `weak` / `march_weak` / `sanctum_weak` = the losing orders) |
| `--hp-end=X` | balance probe: overrides the map's `wave_hp_end` (cliff checks; 0 = the map's own) |
| `--reckoning` | after a cleared map, start the Reckoning endless mode and run until the gate falls |
| `--meta=` | `none` (default without a save) or `max` (every Ossuary upgrade and Mastery) |
| `--meta-save` | read and write the real save (records the run, Codex, masteries) |
| `--character=` | CharacterData id (default `gravecaller`; its spell goes to slot 1) |
| `--test-act` | shows the hidden test act on the map select and in the Codex (debug only); its map `test_grounds` runs with `--build=test_default` / `test_kit` / `test_weak` |
| `--build=kit_a` / `kit_b` / `kit_evolve` | gw2-kit orders: any Act I map's default order with the later towers in some slots and the later spells / ultimates; `kit_evolve` (Graveyard) = all six later evolutions. Kit runs add the `tower_value=` and `kit=` lines |
| `--ultimate=` | SpellData.ULTIMATES id (`sovereigns_decree`, `eclipse`, `grave_tide`; default Dread Rally) |
| `--swap=from:to` | A/B strength check: the order's first build of `from` builds `to` (e.g. `archer:fallen_seraph`) |
| `--perf-wave=N` | from wave N the run drops to speed 1 and prints a `PERF` line every game second (the Web frame-time probe `tools/gw_perf.js` and `tools/gw_wave_shot.js` use it) |
| `--build=<map>_default` / `<map>_weak` / `tide_kit` / `court_kit` / `shogunate_kit` | later acts' orders (in their act data files) |
| `?gw_flags=--unlock-all` | Web only, no bot: every later tower, spell, ultimate and character shows open in the menus (visual checks) |
| `?gw_flags=--menu=<id>` | Web (and desktop) look checks: opens `play`, `codex`, `ossuary`, `settings`, `credits`, `setup`, `pause`, `won` or `lost` at start (DECISIONS M1; `tools/gw_menu_shot.js`) |

Every registered map at once: `tools/run_all_maps.sh` (2 at a time, one line per map; `WEAK=1` adds the weak orders, `SEED=N`). Act framework self-check: `tools/acts_check.tscn -- --autotest`. Adding an act: `docs/ACT_TEMPLATE.md`.

The summary's `meta=` line names the meta profile, character, loadout, the Soul
Ash the run would pay and the active bonuses. `godot --headless tools/meta_check.tscn -- --autotest`
self-checks the Ossuary, unlocks and character paths.

It prints a `TDAUTOTEST SUMMARY` (result, skulls, waves cleared, lives, souls
earned / spent, kills / leaks by kind, damage by source, every tower, wave
spawn / clear seconds, stuck enemies, evolutions reached and active synergies,
casts / damage per spell, blockers lost / respawned, Mender healing, Lich
Risen, Deep Freezes, shatters, Colossus shrapnel, corpses detonated, the Reckoning
wave and tower-seconds suppressed, trait / boss `events=`, the map rule's `rule=` line, the act rule's `act_rule=` and
hostile fire's `hostile=` lines when used, `minibosses=` (each miniboss: spawn s, max HP, seconds held, killed or gone) and `leak_curve=`: first leak wave, end wave, lives lost, permanent body
deaths, lives lost within 15 s of a body death and per death) and exits 0 when the run completed
(1 on a timeout). It never touches `user://`. Same seed -> identical summary.

## Web build

```bash
mkdir -p build/web && touch build/.gdignore
$G --headless --export-release "Web" build/web/index.html
python3 tools/patch_web_audio.py build/web/index.js   # always; also runs the GL id patch
sh tools/web_music.sh build/web                       # always: songs beside the page (music/<map>.ogg; publish it too)
```

CI (`.github/workflows/ci.yml`) runs the import, the towers / meta self-checks,
one autotest job per map (default and losing orders) and exports the Web build
as the artifact `Gravewatch-web`. It does not publish: pushing the build to the
public play repository (Gravewatch-Play, GitHub Pages) needs a token secret
`PAGES_TOKEN` that only the owner can create; until then the build is pushed by
hand. Debug: `index.html?gw_autotest=--map=sanctum,--speed=8` runs the bot on
screen.

## Combat effects (visual only)

`TdVfx` (`scripts/td/td_vfx.gd`, numbers in `scripts/data/td_vfx_data.gd`) draws
what combat events look like: shots 1.5-2.4x their art size with streak trails,
muzzle flashes and impact bursts per tower (archer bone arrows, mage orbs with a
halo and a splash-sized burst, frost shards and rings, tumbling boulders with a
shadow, dust ring, crack and a small screen shake), fanned volleys, Warrior lunges
and sword slashes, the Abomination's smash, enemy blows with a red slash and shield
sparks, boss strike poses, bone piles and the climb back out, Banshee sound rings,
Mender soul-threads, hit squash, death bursts by rank, the boss death sequence,
soul wisps flying to the soul counter, status tints and icons, tower recoil,
firing flash and breathing, and the gate's red flash and lives shake on a leak.
It only reads the run and uses its own RNG; it is off headless, so the same-seed
autotest summaries are byte-identical with or without it. Settings > Reduced
effects (default on phones) drops trails, wisps, breathing and extra rings;
Reduce motion drops lunges, shake and breathing. Its new pixel art
(`assets/sprites/td/vfx_*.png`) is drawn by `tools/vfx_art.py`.

Battlefield dressing (`MapMood`, `TdMoodData`): lanterns and fog on the
Graveyard, campfires and banners on the Crimson March, candles and stained-glass
light pools in the Sanctum, worn road edges, pulsing empty plots, marked road
posts and a soft edge vignette; spell casts flash and land bigger bursts. On
Reduced effects the props stay and the glows, fog, pools and vignette go.
Settings > Video has Screen shake and Damage numbers (off by default). The Web
autotest query also takes `--reduce-motion` and `--damage-numbers`.

## Known limits

- The spot menu can cover a neighbouring spot when every side is crowded (it avoids roads and the
  spell bar first; tap elsewhere to close it). The spell bar moves to the bottom slot (or phone
  column) with the least road under it.
- `tools/map_list.tscn` prints each map's `INCOME` (souls it can pay with no leaks) and fails a later
  map outside 3700-5600.
- The gamepad cursor is untested on real hardware (no pad in the test browser).
- Balance (`docs/BALANCE.md`) comes from the autotest bot's fixed build orders;
  the owner's playtests come first. Since the blocker HP fix (wave 2a) Lich wins about one run in four on
  every map. The default orders lean on Dread Rally: with another ultimate the bot often loses.
- Gravewatch-only art is mostly drawn with Pillow (`tools/vfx_art.py`, `art_source/td_pillow/` keeps the
  originals); the road tiles and the Sanctum candles were regenerated with the image API (DECISIONS V17).
  How: `tools/gw_gen.sh NAME SUFFIX QUALITY "prompt" refs...` (calls `tools/gen_image.py`, logs the cost to
  `docs/art/generation_ledger.csv`), then `tools/gw_tile.py` (seamless tiles through `make_tile.py`) or
  `tools/prepare_sprite.py --art-height N --out FILE` (sprites), `tools/gw_art.py install`, and
  `tools/gw_sheet.py` for the before / after sheet. Prompts and raw images: `art_source/td_gen/`.

## Tower kits, evolutions, synergies, spells (gw-towers)

- Each class has its kit in `scripts/towers/<class>.gd` (extends projectile /
  aura / blocker): Frost Wraith Deep Freeze (packs), Catapult lobbed boulders
  on a landing telegraph aimed at the densest pack, Banshee telegraphed Dirge,
  Mender heals, Abomination stomp stagger, blocker volleys from Lv 3.
- Evolutions are real tier-6 kits (special numbers in `EvolutionData` "set"):
  Gravebow split + curse, Lich Risen road blockers, Winter Revenant shatter,
  Ossuary Engine three boulders + burning fields, Keening Lady three waves +
  silence, Profane Bishop burn + faster respawns, Death Knight cleave +
  lifesteal, Bone Colossus taunt + shrapnel.
- Synergies have conditional effects through `Synergies.hit_mult()` (called
  from `TdCombat.damage_enemy()`), `extend_weaken` and `aim`.
- Corpse Explosion (corpse markers from kills) and Plague Cloud (Rot fields
  along the road) are built; the five GDD §11 sounds are synthesized
  (`TdSoundData.SOUNDS`, Sfx pack "td"); since DECISIONS N1 place / sell /
  life lost play Necropathy's sampled `summon_rise` / `summon_death` /
  `player_hurt` instead.
- **Audio overhaul (DECISIONS N1, from Necropathy, Nov 2026):** every Necropathy
  bank sound with a file in `assets/audio/sfx/` (57 ids, 87 takes, built from
  Kenney's CC0 packs) plays the sample instead of its synth render, and every
  one of the 45 maps plays its Necropathy stage's song (`assets/audio/music/<map
  id>.ogg`, loop points `SongData.LOOPS`). Never loaded headless for songs;
  same-seed summaries unchanged. Sources: `assets/audio/LICENSES.md`. The act
  packs, the td pack's own sounds, the menu theme and every fallback stay
  synthesized.
- Self-check: `$G --headless tools/towers_check.tscn` (prints `TOWERS CHECK PASS`).
## Act I maps and the Covenant (gw-maps)

- **The Desecrated Graveyard** (22 waves, Inquisitor miniboss, Sir Alaric charges through
  a post at intervals). **The Crimson March** (`crimson_march`, opens after the Graveyard):
  two roads merge into a trunk; Holy Ward Generators beside the roads halve the damage
  enemies near them take until destroyed; Templar Commander miniboss; Marshal Vael calls
  squads in by two side lanes and raises a Shieldwall. **The Sanctum of Judgment**
  (`sanctum`, opens after the March): one long road through two chambers where towers deal
  25% less until the chamber's ward crystals break; Cathedral Guardian miniboss; Grand
  Inquisitor Seraphine blinks down the road, suppresses towers where she lands and is
  healed by her Confessor Attendants.
- Enemy traits (`scripts/enemies/traits/`): shield_front (Shieldbearer), banner_aura,
  halberd_reach, lash (Sister), templar_charge, healer (Chaplain), holy_zone (Radiant
  Inquisitor), confessor (High Confessor), sun_ward (Sun Paladin), guardian, ward_structure
  (generators / crystals). Bosses in `scripts/bosses/`. Shared per-run ground state
  (zones, recent deaths) in `scripts/enemies/covenant_field.gd`; map rules and their
  numbers in `scripts/maps/rules/` and `scripts/data/act1_rule_data.gd`.
- **Reckoning** (`TdGame.start_reckoning()`, `game.reckoning_wave`; numbers in
  `reckoning_data.gd`): after a cleared map, escalating waves made from the map's own
  table until the gate falls.
