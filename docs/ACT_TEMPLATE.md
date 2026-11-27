# Adding an act to Gravewatch

The one checklist an act agent follows. An act is: three maps, its enemy
kinds and traits, minibosses and bosses, one act rule (its gimmick, GDD §7.3),
its act tower with an evolution and a synergy, its act spell if it has one,
its look, and its tests. Everything goes in **new files**; the only shared
tables you may append to are named below (append rows only, never reorder or
reformat). The worked example is
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
   1-3 entrances. Place the spots so `tools/spot_audit.tscn -- --autotest` prints
   `SPOT AUDIT OK` (DECISIONS S1: every plot within the Banshee's reach of a road,
   clear of the road, posts, other spots, the HUD corners and props; `--fix` proposes
   places). `MapLoader.validate()` fails a map with a bad spot.
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

6. **Act tower** (owner rule, DECISIONS K9: each act's unlockable summon class
   becomes a tower unlocked by its act's boss; the worked examples are the six
   wave 2a kit towers, e.g. `scripts/towers/bone_golem.gd`, `rogue.gd`):
   - append one `TowerData.TOWERS` row (keys documented there) with
     `"unlock": {"map": "<your finale map>"}` (one reader: `Unlocks`; `{"map",
     "skulls": n}` also works), `"ground_only": true` if it cannot hit flyers,
     `"family"` if it belongs to an Ossuary tree; five `TowerData.LEVELS` rows;
     its id appended to `TowerData.ORDER`;
   - its kit `scripts/towers/<id>.gd` extending `projectile.gd` / `aura.gd` /
     `blocker.gd` / `TowerBehavior` (hooks in CLAUDE.md "Tower class"); every
     target it picks itself must pass `t.can_hit(e)` (ground_only + rule
     visibility) and its specials go through the `TdCombat` helpers;
   - it must react to `TdCombat.disable_tower()` (nothing to do: a disabled
     tower's `step` is not called, so keep signal-driven effects behind
     `t.game.time < t.disabled_until`, as the Golem's Ossuary Hunger does);
   - a blocker kit keeps `blocker.gd`'s body handling (fresh bodies start at
     `body_hp`; `towers_check` checks every blocker class);
   - look: a `TdVfxData.SHOTS` row (its own tint, shot 40+ px, trail, muzzle,
     impact; real radius for area hits) or `game.vfx.melee()` for a blocker;
     its sound in `TdSoundData.FIRE`; its sprite / icon copied from Necropathy;
   - nothing else: the build menu pages (`TdUiData.MENU_PAGE`), the Codex,
     masteries and the Ossuary badges pick it up.
7. **Its evolution**: one `EvolutionData.EVOLUTIONS` row (from, name, sprite,
   icon, stats, set, recipe; recipe types in `Evolutions.recipe_met()`, a new
   type is one `match` branch), named by the tower row's `evolution`. Never
   hinted.
8. **Its synergy**: one `SynergyData.SYNERGIES` row pairing it with an existing
   class (effects, optional `hit` vs a status, `hint`) and its badge icon.
9. **Act spell** (only if your act has one): a `SpellData.SPELLS` row with
   `unlock`, `scripts/spells/<id>.gd` (`extends TdSpell`), a `TdVfxData.SPELLS`
   row and a cast look (`game.vfx.cast(id, pos)`); Risen go through
   `TempBlockers.raise()`.
10. **Autotest**: one build order per act (in your data file's `ORDERS`) that
   builds the act tower, reaches its evolution where it can and casts the act
   spell, so its kit lines (`tower_value=` / `kit=`) print; extend
   `tools/towers_check.gd` with a check of its special.

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

- A road style for the act (DECISIONS R1-R3): `"road": "<style>"` on its `ActData` row, a fill + kerb pair from
  `tools/gw_road_art.py` (clearly lighter / differently hued than the floor, not noisy, kerb distinct), wear colours in
  `TdRoadData.STYLES` if the default dark ruts clash; a finale that differs goes in `TdRoadData.MAP_STYLES`.
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
$G --headless tools/spot_audit.tscn -- --autotest        # SPOT AUDIT OK (no dead / weak / covered plot)
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
  `--map=graveyard|crimson_march|sanctum --seed=1|2` are byte-identical to the
  baseline in `docs/BALANCE.md` (the lines from `TDAUTOTEST SUMMARY`).
- Your act tower: its build order wins its map, `towers_check` passes with its
  new check, and its evolution and synergy show in a run's summary.
- Web: build it (CLAUDE.md), run `?gw_autotest=--map=<map>,--speed=1` in
  Playwright at 1280x720 and 844x390, look at the screenshots.
- Append your decisions to `docs/DECISIONS.md` with your prefix and a status
  line in `CLAUDE.md`.

## 5. Lessons from wave 2b (Acts II-V; DECISIONS X rows): do these from the start

- **Income (X2): one rule.** A kill pays its kind row's `"souls"` if set, else
  its rank's `EconomyData.KILL_SOULS`. From Act II on every wave-roster fodder
  kind sets `"souls": 5` (tougher soldier tiers up to 10, illusions / summoned
  shadows 0); elites 12, minibosses 80 and bosses 0 stay the rank defaults;
  every map starts with `"souls": 300`. `tools/map_list.tscn` prints an
  `INCOME <map> start= kills= no_leak= total=` line per map (MapLoader.income():
  start + scripted kills + no-leak bonuses) and FAILS a map from Act II on
  outside `EconomyData.INCOME_MIN..INCOME_MAX` (3700-5600; the Sanctum pays
  ~4240). Tune difficulty with `wave_hp_end`, never with start souls.
- **Minibosses (X3).** A miniboss's row HP is its real HP (no wave HP ramp, like
  bosses): aim for 4000-6000 from Act II on. Towers on "first" add
  `TdRulesData.FIRST_RANK_BONUS` (260 px) to a miniboss's / boss's progress, so
  one in range is shot before the fodder around it; a held miniboss's blows on
  its body are x`BLOCKER_HIT_RANK` 0.6, so posts hold it longer. Every run prints
  `minibosses=kind:spawn s:max HP:held s:killed@t|gone@t`: the default order
  should kill it in most seeds. A miniboss that is never held (vehicles,
  chargers) needs less HP. One miniboss spawn per map (each spawn pays a chest:
  never put a miniboss kind in the boss wave as an escort).
- **No scripted always-leak.** A structure or spawner that releases a unit near
  the gate (a coffin beside the last stretch) leaks the same lives on every
  seed: keep such spawn points upstream of the last two posts.
- **Build orders (X4).** An `evolve` step whose recipe is not met yet no longer
  blocks the order: the bot skips it and retries it every tick. Still list it
  right after the tower's last upgrade.
- **Layout (X6).** Nothing may sit under the HUD at 1280 x 720 or 844 x 390:
  keep roads, entrances and plots below y 64 (top bar 44 px + banner). The spell
  bar (~300 x 80 px) takes the bottom slot (centre, left, right) with the least
  road under it (`TdHud._place_spell_bar`), so leave at least one of those
  three free; keep your act's HUD widget in a corner no road uses (Act IV meter
  top-left, Act V dial bottom-left, the Blood Moon cue picks right or left). An
  entrance starts off-screen on a side. The spot menu avoids roads by itself
  (`TdUiData.MENU_ROAD_*`) but needs ~300 px of road-free room beside a spot.
  Check with `tools/gw_wave_shot.js` at 1280x720 and 844x390t.
- **Performance (X5).** `node tools/gw_perf.js build/web <map>:<wave> ...`
  measures the late-map frame time (bot hurries to the wave, then x1); your
  heaviest map must stay within ~1.3x the Sanctum's. Draw act overlays once
  into a cached texture or as a few textured rects, never per-frame polygons /
  circles per unit; cap simultaneous hostile shots; prefer fewer, tougher
  late-wave enemies over long columns.
- **Merging.** Append each table row as its own line group and each ORDER id at
  the END of the list on its own line, so four acts merge without hand work.
  `acts_check`'s "hidden act open" check already allows later acts.

## 6. Lessons from wave 2c (Acts VI-X; DECISIONS Y rows): do these for Acts XI-XV

- **Leaks and full posts (Y3).** A boss leak costs 10 lives, a miniboss 5 (row
  `leak_lives` overrides: a companion boss like Fenrir 5). Never design a fight
  that is lost the moment one unit reaches the gate. A miniboss at a full post
  pushes a lesser enemy out (`BUMPING_RANKS`); a boss does not, so a boss that
  must be held needs posts with room on its road, or a kit that stops on its own
  (Voice-style stand points, Hades-style claims).
- **Hiding (Y2).** A trait hides an enemy only through one of the vars
  `TdEnemy.hidden_from_towers()` reads (`mist_until`, `hidden_until`,
  `cloak_until`, `untargetable`, `k_charm_until`); add a new var there, not a
  check in your act rule. A "harder to hit" state that towers still hit is NOT
  one of them (the Bastet Hunter's `dive_until`). A drawn fade is vars
  `vis_alpha`, a form change vars `sprite`, a tint vars `tint`; never `modulate`
  (enemy nodes are pooled).
- **Act towers (Y4).** Before you hand back, run `--swap=<nearest Act I
  class>:<your tower>` against `--swap=x:x` on your three maps (seeds 1-2) and
  compare lives and `tower_value` damage per soul: a post tower should hold
  about as many enemies per soul as the Abomination (4 for 110), a plot tower
  deal about the Catapult's / Mage's damage per soul. Both Part Two misses were
  plot towers whose special (the keg march, the roll) fired too rarely.
- **Kit orders (Y5).** A kit order that buys several dear act towers starves its
  damage and loses. Start from the map's default order with the act tower in one
  spot (`{"base": "<map>_default", "swap": [from, to]}`) and add only what wins.
- **Cliffs (Y6).** Several units with a stun / stomp arriving together (two
  fire giants plus a miniboss) turn a map into a cliff: one fallen post cascades.
  Space such units across waves, keep elite-heavy late waves short, and check a
  map at its `wave_hp_end` and +0.2: the loss rate should rise gradually. A
  run-wide feedback meter (the Scales) must not feed itself.
- **Frame time (Y7).** Part Two's heaviest maps were the Norse ones (the Winter
  layer, 1.12x the Sanctum at 44 enemies) and the Host's (the Light's shafts, 1.05x
  at 18-42 enemies): both draw cached textures in pieces, which is the budget to
  copy. `gw_perf.js` takes ~5 min a map on software GL; measure only your maps
  and the Sanctum.
- **HUD widgets (Y8).** Corners: top-left under the bar (Escalation, Wrath, Hell
  cue, Host dial), top-right (Blood Moon cue, Scales), bottom-left (Sun dial,
  Winter meter). Pick a free corner of your maps; position it from
  `game.top_inset` (the bar is taller on touch). The build menu is now one strip
  of six tiles (~660 x 80 px): leave a road-free band that tall beside your
  spots.
- **Merging.** Shared `.gd` tables merged cleanly only where every act appended
  one row group at the very end; `LEVELS` and `towers_check` were mis-merged by
  git (similar rows aligned). Keep each act's check in its own function at the
  end of `towers_check.gd`, and give your table rows a leading comment line.

## 7. Lessons from wave 2d (Acts XI-XV; DECISIONS Z rows)

- **Self-feeding mechanics make cliffs.** Every narrow band in Part Three came
  from a unit whose effect grows with how long it lives: ten Line Troopers all
  firing at the front tower (each 0.7 s disable), Gibbering splits born late and
  faster than their parent, a boss calling a Treant every 15 s, a flock of
  fast flyers. Cap the uptime (shorter disables, slower splits, rarer calls),
  never just lower `wave_hp_end`. Check `--hp-end=<value + 0.2>` on 4 seeds: no
  map may be lost there (the `--hp-end` autotest probe needs no file edit).
- **Bosses leak 10 lives.** A boss or miniboss that leaks in half the seeds is
  the loss pattern, not the map's difficulty: lower its row HP first (the
  Harvester, the Hive Mother, Vrask'Tal, Scarmaw, the Archon, the Beta Build,
  Valkyrie 2.0, the Gardener all lost HP at the integration).
- **One helper per job across acts.** Before writing `nearest_tower()`,
  `line()` or a charge, look in the earlier acts' kits (CLAUDE.md "Shared hooks");
  the Eye's `nearest_tower()` now calls the Black Tide's.
- **Moods.** Every map needs a mood row (the Concord shipped without any), and
  `pools` stay 0 outside a stained-glass interior (the pool art is coloured glass).
- **Autotest phone shots are blind.** Under `?gw_autotest=` the page keeps the
  desktop layout (`TouchSupport._autotest_blind()`), so a spell bar over a road in
  an 844 x 390 autotest shot is not what a phone shows (the phone puts the spells
  in a left column); check the real phone layout without the autotest.
