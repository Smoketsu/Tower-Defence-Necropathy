# Adding an act to Gravewatch

The checklist an act agent follows. An act is three maps, its enemy kinds,
minibosses and bosses, one act gimmick (GDD §7.3) and its look. Everything
goes in **new files**; the only shared tables you may append to are named
below (append rows only, never reorder or reformat). The worked example is
the hidden test act (`test`, map `test_grounds`): read its four files first.

| Test act file | What it shows |
|---|---|
| `scripts/data/acts/test_act_data.gd` | an act data file: `KINDS`, `ORDERS`, `RULE` (and `MOODS` if needed) |
| `scripts/maps/test_grounds_map.gd` | a map: roads, an off-road exit trail, plots, posts, waves, `weak_order` |
| `scripts/maps/rules/test/proving.gd` | an act rule using every hook |
| `tools/acts_check.gd` | a self-check of each hook |

## 0. What already exists (do not edit)

- **Your act row is already in `ActData.ACTS`** (`scripts/data/act_data.gd`) with
  its id, name, faction, map ids (Necropathy's stage ids), music (a
  `SoundData.SCORES` id that is already synthesized), a floor default, `mood`
  and `rule` defaults (`""`). The map select shows your act's tab as soon as
  one of its maps exists, and "Coming soon" before.
  If you need a different default floor / mood / rule for all three maps, set
  the key on each map instead (map keys beat the act row).
- The unlock chain, Soul Ash step, map select, Codex act tab, CI matrix and
  `tools/run_all_maps.sh` all pick your maps up by themselves.

## 1. Files to create

Replace `<act>` with your ActData id (`corsair`, `court`, `city`, `shogunate`, ...).

1. **Act data file** `scripts/data/acts/<act>_act_data.gd` (`extends RefCounted`,
   no `class_name`, header comment, every key commented and tagged):
   - `const KINDS: Dictionary` — your enemy kinds, same keys as
     `TdEnemyData.KINDS` (documented there). Kind ids must be unique across all
     acts (Acts pushes an error on a duplicate): prefix new generic names
     (`tide_gunner`, not `gunner`). Bosses are rank `"boss"`, minibosses
     `"miniboss"` (their death drops the chest).
   - `const ORDERS: Dictionary` — two build orders per map (same keys as
     `BuildOrderData.ORDERS`): `<map>_default` (must win on Necromancer with
     seeds 1 and 2) and `<map>_weak` (must lose or end cleanly).
   - `const MOODS: Dictionary` — one mood row per map keyed by map id (same keys
     as `TdMoodData.MOODS`; props with glows, ambient fog / pools).
   - `const RULE: Dictionary` (or any other const) — your act rule's numbers.
     Read them with `Acts.data("<act>")["RULE"]`.
   Never read `TdEnemyData.KINDS` / `BuildOrderData.ORDERS` directly: use
   `Acts.kinds()` / `Acts.orders()` (the merged tables).
2. **Three maps** `scripts/maps/<map id>_map.gd` with `const MAP` (keys in
   `graveyard_map.gd`). Use exactly the map ids listed in your ActData row; the
   file name makes the map playable (no registry edit). Required keys besides
   the Act I ones: `build_order`, `weak_order`. Optional: `act_rule` (else the
   act row's `rule`), `music`, `mood`, `floor`, and road keys `off_road` /
   `exit`. The final wave must hold the boss. GDD §7.1: 12-20 plots, 3-6 posts,
   1-3 entrances.
3. **Traits** `scripts/enemies/traits/<act>/<trait>.gd` (`extends EnemyTrait`),
   named in a kind's `"trait"` as `"<act>/<trait>"`. **Bosses**
   `scripts/bosses/<act>/<boss>.gd`, named `"<act>/<boss>"`. Numbers in the
   kind's `args` row. Reuse the generic traits first:
   - `shooter` — ranged fire at towers (disable) or blockers (damage) through
     `game.hostile.fire()`; straight shots are stopped by blockers and Bone Walls,
     `arc: true` flies over (args documented in the script).
   - `trampler` — disables every tower it passes within a radius (for off-road herds).
   - the ten Act I traits (`healer`, `banner_aura`, `shield_front`, ...).
4. **Act rule** `scripts/maps/rules/<act>/<rule>.gd` (`extends MapRule`), set as
   each map's `"act_rule": "<act>/<rule>"` (or ask the lead to fill the act row's
   `rule`). It runs beside the map's own `rule`. Hooks (all optional):

   | Hook | Use it for |
   |---|---|
   | `setup()` | build nodes under `game.world` (darkness layers, decks, lanterns) |
   | `step(dt)` | clocks: shell a spot (`game.hostile.shell()`), day / night |
   | `on_wave_start(n)` | per-wave modifiers: Blood Moon waves, escalation tier |
   | `on_spawn(e)` | wave tier: `TdCombat.empower_enemy(game, e, hp_mult, speed_mult)` |
   | `on_kill(e, tower)` | heal on kill: `TdCombat.heal_enemy()` on `game.foes_near()` |
   | `on_body_fallen(b, by)` | claims: `game.spawn_from_body(kind, b)` raises a hostile unit where the blocker fell (`by` = the enemy whose blow felled it, null for other causes) |
   | `can_target(t, e) -> bool` | visibility: false hides `e` from tower `t` (night, fog, lantern light) |
   | `tower_damage_mult(t)` | towers weaker / stronger somewhere |
   | `summary() -> String` | its counters, printed as the autotest's `act_rule=` line |

5. **Art.** Copy the Necropathy sprite folders you need (with their
   `SpriteData` rows: append only) and the floor tiles / obstacles / decals of
   your stages. Reuse Necropathy's sprites by key; do not invent new looks when
   one exists.

## 2. One path per concern (use these, never write HP or timers yourself)

- **Stop a tower** (shelled, trampled, blinded, stunned): `TdCombat.disable_tower(game, t, seconds, cause)`.
  `cause` is a `HostileData.CAUSE_TINT` key (`shelled`, `shot`, `trampled`,
  `blinded`, `stunned`; add a row for a new cause). The tower makes no attack,
  pulse or block step while disabled. Weaken a tower instead: `TdCombat.suppress_tower()`.
- **Enemy fire at towers / blockers:** `game.hostile.fire(from, target, args)`
  (target = a `Tower` or a `BlockBody`). Straight shots stop on the first
  living blocker / Bone Wall body on their path. Telegraphed area strike:
  `game.hostile.shell(pos, radius, delay, disable, cause, body_damage)`.
- **Flyers:** kind row `"flying": true`. Blockers and Bone Walls never hold
  them; every tower and spell hits them, except a tower whose row says
  `"ground_only": true` (then `Tower.pick_target()` skips flyers). They follow
  the road and are drawn lifted with a ground shadow.
- **Off-road movers:** a road with `"off_road": true` is drawn as a faint trail,
  takes no post, no spell, no block. With `"exit": true` an enemy reaching its
  end leaves with no lives lost (counted as `crossed`); without it, its end
  must reach the gate (or join a road with `next`). Spawn on it with the wave
  group's `"road"`.
- **A dead blocker turned hostile:** `on_body_fallen` + `game.spawn_from_body()`.
- **Enemy rows:** `Acts.kinds()`. **Build orders:** `Acts.orders()`.
  **Mood:** `Acts.mood_for(map)`. **Map data:** `MapRegistry.get_map(id)`.

## 3. The look (CLAUDE.md "Visual conventions": not done without it)

- Every map: a mood row in your data file's `MOODS` (props with glows).
- Every kind: walk strip if Necropathy has one; bosses get a strike pose
  (`BossPoseData`). Blows on blockers already go through `game.vfx.enemy_blow()`.
- Your gimmick must read in one still frame:
  - disabled towers already show (darkened body, pulsing ring in the cause's
    colour, a burst when hit) and hostile shots / shells already draw (sprite,
    trail, telegraph, impact); pick a `look` in `HostileData.LOOKS` (append a row
    for a new projectile sprite);
  - a visibility rule must DRAW its darkness / light (edge bands or textured
    light pools on a layer under the units; no full-screen overlay, no shader
    reading the screen) so the player sees why a tower holds fire;
  - per-wave modifiers announce themselves with a banner (`game.banner()`);
  - all visual numbers in `TdVfxData` / `TdMoodData` / `HostileData` or your
    data file, tagged; visuals never write run state or use `game.rng`.
- Effects Full / Reduced, Reduce motion and Screen shake must keep working.

## 4. Tests (all must pass before you hand back)

```bash
G=/home/user/tools/godot/Godot_v4.3-stable_linux.x86_64
$G --headless --import                                   # no errors
$G --headless tools/map_list.tscn                        # lists your maps, validates them (exit 0)
for m in <map1> <map2> <map3>; do for s in 1 2; do
  $G --headless --fixed-fps 60 --quit-after 200000 -- --autotest --map=$m --seed=$s
  $G --headless --fixed-fps 60 --quit-after 200000 -- --autotest --map=$m --seed=$s --build=<map>_weak
done; done
WEAK=1 tools/run_all_maps.sh                             # every map: won / lives / errors
$G --headless res://tools/acts_check.tscn -- --autotest  # ACTS CHECK PASS
$G --headless res://tools/towers_check.tscn              # TOWERS CHECK PASS
$G --headless res://tools/meta_check.tscn -- --autotest  # META CHECK OK
```

- Zero `SCRIPT ERROR` / `ERROR:` / `WARNING:` lines, `stuck_enemies=0`, the same
  seed twice gives the same summary, and your default orders win.
- **Act I unchanged:** the default summaries of
  `--map=graveyard|crimson_march|sanctum --seed=1|2` are byte-identical
  before and after (record them first; ignore the `[audio]` timing line).
- Web: build it (CLAUDE.md), run `?gw_autotest=--map=<map>,--speed=1` in
  Playwright at 1280x720 and 844x390, look at the screenshots.
- Append your decisions to `docs/DECISIONS.md` with your prefix and a status
  line in `CLAUDE.md`.
