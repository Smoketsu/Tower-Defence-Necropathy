# Necropathy: Gravewatch

A fixed-path tower defense built from the art, audio and interface of
**Necropathy** (Godot 4.3, GDScript, GL Compatibility, 1280 x 720). You are a
necromancer holding a crypt: Covenant columns march down roads toward the
Ossuary gate and you raise undead on grave plots and road posts to stop them.
The design is `docs/GDD.md`; decisions it does not cover are in
`docs/DECISIONS.md`.

## How it plays

- **Title -> map select (map + difficulty) -> map.** One fixed screen per map.
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
- **Spells** (bottom bar, keys 1-3): tap the spell, then the target. Shadow Bolt
  (aimed shot from the necromancer at the gate), Bone Wall (blocks the road a few
  seconds; bosses walk through). Corpse Explosion / Plague Cloud are listed but
  not built yet. **Ultimate** (Space): Dread Rally, charged by kills, revives
  every fallen blocker and gives all towers +40% damage and attack speed for 8 s.
- **Lives:** fodder 1, elite 3, miniboss 5, a boss ends the map. The mid-map
  miniboss drops a **chest** = one free upgrade or evolution. The stage boss
  walks the road on the final wave. A win is rated 1-3 skulls by lives kept.
- **Speed** x1 / x2 / x3 (Tab), **Pause** (Esc), Call (Enter). Mouse and touch.

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
  ui/td/                 new screens: title_screen, title_backdrop, map_select, td_hud, spell_button,
                         spot_menu, pause_menu, results_screen
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
$G --headless --fixed-fps 60 --quit-after 40000 -- --autotest [--map=graveyard] [--seed=N] [--speed=N] [--difficulty=initiate|necromancer|lich|deathlord] [--build=ID]
```

| Option | Meaning |
|---|---|
| `--map=` | MapRegistry id (default `graveyard`) |
| `--seed=` | run seed (default 1) |
| `--speed=` | fixed steps per physics frame, 1-64 (default 8; the result does not depend on it) |
| `--difficulty=` | DifficultyData id (default `necromancer`) |
| `--build=` | BuildOrderData id (default: the map's `build_order`; `weak` = the bad placement order; `towers_a` = the four shooters to Lv 5 + Lich, Winter Revenant, Gravebow; `towers_b` = support / blockers to Lv 5 + Death Knight, Profane Bishop (loses to Alaric); `evolve_all` = test order with bonus souls, seven evolutions in one run) |

It prints a `TDAUTOTEST SUMMARY` (result, skulls, waves cleared, lives, souls
earned / spent, kills / leaks by kind, damage by source, every tower, wave
spawn / clear seconds, stuck enemies, evolutions reached and active synergies,
casts / damage per spell, blockers lost / respawned, Mender healing, Lich
Risen, Deep Freezes, shatters, Colossus shrapnel, corpses detonated) and exits 0 when the run completed
(1 on a timeout). It never touches `user://`. Same seed -> identical summary.

## Web build

```bash
mkdir -p build/web && touch build/.gdignore
$G --headless --export-release "Web" build/web/index.html
python3 tools/patch_web_audio.py build/web/index.js   # always; also runs the GL id patch
```

## Known limits

- Only the Graveyard is built; the Ossuary,
  Codex, Settings screen, character pick and saves are not (see CLAUDE.md "Status").
- The spot menu can cover a neighbouring spot (tap elsewhere to close it first).
- Balance is a first pass: the default build order clears the Graveyard with
  19-20 lives on seeds 1-2 and the result is sensitive to enemy HP.

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
