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
- **Blockers** (Skeleton Warrior, Corpse Abomination) stand on the road and hold
  enemies; a fallen body returns for free after its respawn time.
- **Spells** (bottom bar, or a left column on wide phones; keys 1-4): tap the
  spell, then the target. Shadow Bolt (aimed shot from the necromancer at the
  gate), Bone Wall (blocks the road a few seconds; bosses walk through), Corpse
  Explosion (detonates the corpses near the tap), Plague Cloud (Rot along the
  road). Three are brought; the Ossuary's Fourth Rite adds a slot. **Ultimate** (Space): Dread Rally, charged by kills, revives
  every fallen blocker and gives all towers +40% damage and attack speed for 8 s.
- **Lives:** fodder 1, elite 3, miniboss 5, a boss ends the map. The mid-map
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
  audio/                 copied as is: sfx (run_mode_for trimmed to Act I), synth, startup/run-loop/menu synths
  fx/                    copied: sharp_pixel.gdshader, unit_layer.gd (a draw-callback layer, reused everywhere)
  ui/                    copied: ui_theme, kit_style_box, ui_motion, confirm_dialog, input_hints, touch_support,
                         rotate_overlay (+ chamfer() from Necropathy's TouchControls)
  ui/td/                 new screens: menu_screen (shared frame), title_screen, title_backdrop, map_select,
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
                         meta_modifiers, td_art, td_autotest
  towers/                tower_behavior.gd (base) + projectile.gd, aura.gd, blocker.gd
  enemies/               enemy_trait.gd (base) + traits/templar_charge, healer, banner_aura
  bosses/                alaric.gd (an EnemyTrait)
  spells/                td_spell.gd (base) + shadow_bolt, bone_wall, dread_rally
assets/                  only the Act I art copied from Necropathy (~7 MB) + assets/sprites/td/ (Gravewatch art)
tools/                   patch_web_audio.py, patch_web_gl.py (copied)
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
$G --headless --fixed-fps 60 --quit-after 60000 -- --autotest [--map=graveyard|crimson_march|sanctum] [--seed=N] [--speed=N] [--difficulty=initiate|necromancer|lich|deathlord] [--build=ID]
```

| Option | Meaning |
|---|---|
| `--map=` | MapRegistry id (default `graveyard`) |
| `--seed=` | run seed (default 1) |
| `--speed=` | fixed steps per physics frame, 1-64 (default 8; the result does not depend on it) |
| `--difficulty=` | DifficultyData id (default `necromancer`) |
| `--build=` | BuildOrderData id (default: the map's `build_order`; `weak` = the bad placement order; `towers_a` = the four shooters to Lv 5 + Lich, Winter Revenant, Gravebow; `towers_b` = support / blockers to Lv 5 + Death Knight, Profane Bishop (loses to Alaric); `evolve_all` = test order with bonus souls, seven evolutions in one run; `weak` / `march_weak` / `sanctum_weak` = the losing orders) |
| `--reckoning` | after a cleared map, start the Reckoning endless mode and run until the gate falls |
| `--meta=` | `none` (default without a save) or `max` (every Ossuary upgrade and Mastery) |
| `--meta-save` | read and write the real save (records the run, Codex, masteries) |
| `--character=` | CharacterData id (default `gravecaller`; its spell goes to slot 1) |

The summary's `meta=` line names the meta profile, character, loadout, the Soul
Ash the run would pay and the active bonuses. `godot --headless tools/meta_check.tscn -- --autotest`
self-checks the Ossuary, unlocks and character paths.

It prints a `TDAUTOTEST SUMMARY` (result, skulls, waves cleared, lives, souls
earned / spent, kills / leaks by kind, damage by source, every tower, wave
spawn / clear seconds, stuck enemies, evolutions reached and active synergies,
casts / damage per spell, blockers lost / respawned, Mender healing, Lich
Risen, Deep Freezes, shatters, Colossus shrapnel, corpses detonated, the Reckoning
wave and tower-seconds suppressed, trait / boss `events=`, the map rule's `rule=` line) and exits 0 when the run completed
(1 on a timeout). It never touches `user://`. Same seed -> identical summary.

## Web build

```bash
mkdir -p build/web && touch build/.gdignore
$G --headless --export-release "Web" build/web/index.html
python3 tools/patch_web_audio.py build/web/index.js   # always; also runs the GL id patch
```

CI (`.github/workflows/ci.yml`) runs the import, the towers / meta self-checks,
one autotest job per map (default and losing orders) and exports the Web build
as the artifact `Gravewatch-web`. It does not publish: pushing the build to the
public play repository (Gravewatch-Play, GitHub Pages) needs a token secret
`PAGES_TOKEN` that only the owner can create; until then the build is pushed by
hand. Debug: `index.html?gw_autotest=--map=sanctum,--speed=8` runs the bot on
screen.

## Known limits

- The spot menu can cover a neighbouring spot (tap elsewhere to close it first).
- The gamepad cursor is untested on real hardware (no pad in the test browser).
- Balance (`docs/BALANCE.md`) comes from the autotest bot's fixed build orders;
  the owner's playtests come first. Lich on the Sanctum is the sharpest spike.
- All new art (Gravewatch-only pieces, ward structures, character portraits) is
  drawn with Pillow; it waits for a regeneration pass when the image key works again.

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
  (`TdSoundData.SOUNDS`, Sfx pack "td").
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
