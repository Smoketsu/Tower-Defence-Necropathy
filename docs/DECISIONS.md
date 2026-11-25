# Design decisions not covered by the GDD

Every decision made while building that `docs/GDD.md` does not settle. Owner
decisions given with the foundation brief are listed first. Append new rows.

| # | Area | Decision |
|---|---|---|
| O1 | Pacing (owner) | Back-to-back waves: the next wave starts `AUTO_GAP` = 5 s after the previous wave's last spawn, not after it is dead; no 15 s build phase. The first wave waits for Call. Overrides GDD §3 "Build phase". |
| O2 | Scope (owner) | Fixed roads with authored spots, road-post blockers kept, working name kept, saves separate, speed x1/x2/x3 + pause. |
| 1 | Call | Call is available before wave 1 and during a gap (after the current wave's last spawn). Bonus = whole seconds of the gap skipped x `CALL_PER_SECOND`. Wave 1's Call pays nothing. |
| 2 | Lives | A miniboss leak costs 5 lives (GDD lists fodder / elite / boss only). |
| 3 | Souls | A boss kill pays 0 souls (the map ends). Kill souls are by rank only, no per-kind override. |
| 4 | Chest | The miniboss chest is a free-upgrade credit (`free_upgrades`): the next Upgrade or Evolve costs nothing. Collected automatically at the miniboss's death (no tap needed). |
| 5 | Armour | Armour is flat damage off each hit (GDD §6.1 "flat armour 6"), never below 20% of the hit (`ARMOUR_MIN_FRACTION`); damage over time ignores armour. Mage and Catapult have `armour_pierce`. |
| 6 | Freeze | Freezes on minibosses / bosses last 60% / 40% as long (`FREEZE_MULT`). Slows never drop below 30% speed. The strongest slow / weaken wins; durations extend. |
| 7 | Blocking | A blocker body holds `hold` enemies; when every body of a post is full or dead the rest walk past. Held enemies attack their body; a dead body releases them and returns free after `respawn` s. Warrior: 2 bodies x 1 hold at Lv1 (3 at Lv3, 4 at Lv5); Abomination: 1 body x 4, hits all held (stomp). Blockers can hold bosses; Bone Wall cannot (`ignores_walls`). |
| 8 | Blocking limit | A block only catches enemies on its own road (a block right at a merge point does not catch enemies still on the joining road). |
| 9 | Targeting | First = least road distance left to the gate (through merges); Strongest = highest current HP; Nearest = to the tower. Default mode per class row (Catapult: Strongest). |
| 10 | Volley (Lv3) | From level 3, every `every` shots a tower fires `count` extra shots at other enemies in range at a fraction of its damage, drawn with Necropathy's grey volley masks tinted per class. Volley shots never freeze. Auras show a bigger pulse strip from Lv3 instead. |
| 11 | Evolution recipes | First pass: Gravebow 150 kills; Lich: a Frost Wraith within 180 px; Winter Revenant: a Catapult within 220 px; Ossuary Engine 120 kills; Keening Lady: a Mage within 180 px; Profane Bishop: a Crypt Warder within 150 px (GDD; the Warder is a later tower, so not reachable yet); Death Knight: a Mender Lv3+ within 160 px; Bone Colossus: a Warrior within 200 px. Evolution = level-5 stats x the row's multipliers + replaced keys; specials come later. |
| 12 | Synergies | Shatterfall = Catapult damage x1.25 (flat until a behaviour reads frozen targets), Flesh Rampart = +1 hold on both blockers, Killing Field = Catapult rate x1.15, Requiem = Banshee range x1.1 and Mage damage x1.15. Radius-based (px), not plot-count based. The spot menu names the synergies a build would form there (soul-teal button) and lists all of a class's synergies in the tooltip. |
| 13 | Sell | Refund = 70% of all souls spent on the tower (build + upgrades + evolution); chest-paid levels count as 0 spent. |
| 14 | Spells | Spells target by row `target`: Shadow Bolt = enemy nearest the tap within 90 px (no target = no cast, no cooldown), flying from the necromancer drawn beside the gate; Bone Wall = road point nearest the tap within 60 px, 5 s, holds unlimited non-boss enemies. Default loadout Shadow Bolt / Bone Wall / Corpse Explosion until a pre-map pick exists. Tap the spell, then the target; tapping it again disarms. |
| 15 | Ultimate | Dread Rally meter: 100 points; +1 fodder, +4 elite, +20 miniboss per kill. Cast anywhere (Space / button). |
| 16 | Difficulty | Initiate HP x0.75 count x0.85; Lich HP x1.35 count x1.15; Deathlord HP x1.8 count x1.3 (counts rounded, at least 1 per group). |
| 17 | Skulls | 3 skulls at >= 90% of start lives kept, 2 at >= 50%, else 1; 0 on a loss. |
| 18 | Graveyard | 22 waves, Inquisitor (Necropathy's elite Inquisitor sprite) as the wave-11 miniboss, Sir Alaric on wave 22 with a Templar / Footman escort. Alaric: held by blockers, 9 s after he is first held he winds up 0.9 s then charges through the post (160 to each body), running x4 for 1.2 s unholdable. |
| 19 | Sprite facing (GDD §13 risk) | Every unit sprite is a single right-facing 3/4 side view (walk strips too, no up / down views). Enemies mirror by the horizontal part of their road direction and keep their last facing on vertical stretches; plot towers face their target; blockers face the oncoming column. Act I roads should run mostly left to right with short vertical links, as the Graveyard does. |
| 20 | Map fit | The 1280 x 720 map is scaled to fit and centred in the window (`canvas_items` / `expand` stretch can make the viewport wider); taps convert through the world transform. |
| 21 | Enemy traits | Chaplain: heals others within 90 px by 14 every 3 s. Templar: one 1.6 s x2.4 speed burst after its first hit. Banner Bearer (ready for map 2): x1.3 speed aura in 90 px. |
| 22 | Fallback art | Every Gravewatch art role falls back to a plain code rect when its PNG is missing; the final art from the art pipeline is in `assets/sprites/td/`. |
| 23 | Sounds | The five new GDD §11 sounds are stand-ins mapped to existing Necropathy sounds in `TdSoundData` until synthesized. |
| 24 | Spot menu | Building closes the menu; tapping a built spot opens Upgrade / Target / Sell / Evolve. Blockers have no Target button. |
| 25 | Stuck check | An enemy that is not held or frozen and has not moved for 5 s counts as stuck in the autotest summary. |

## gw-maps (maps, enemies, bosses, waves, Reckoning)

| # | Area | Decision |
|---|---|---|
| M1 | Shieldbearer | "Front" = the hit's origin lies ahead of it along its walking direction; the origin is the dealing tower's spot when a tower dealt it (projectile impacts carry the target's own position), else the hit's `origin`. Frontal hits deal 50%; damage over time, origin-less hits (auras) and Catapult boulders (arcing) go around. |
| M2 | Halberdier | "Long reach" = it strikes the first living body of a post up to 60 px ahead on its road on its own cadence while still walking; once held it fights normally with a high damage row (24). |
| M3 | Sister | Each attack on her holder also hits the nearest other living blocker body within 40 px (a Warrior post's second body: spreading blockers over posts avoids it). New EnemyTrait hook `on_attack(e, game, body)`. |
| M4 | Suppression | One path: `TdCombat.suppress_tower(game, t, mult, time)` sets `Tower.suppress_mult / suppress_until`, read in `Tower.recompute()` (damage only); `Tower.step()` recomputes when it ends. Radiant Inquisitor zone: 100 px, 5 s, x0.5, every 8 s, only cast when a tower is inside. Seraphine's beam: 130 px, 5 s, x0.4. Cathedral Guardian beam: 150 px, 4 s, x0.5. |
| M5 | Wards | One path: `TdCombat.ward_enemy()` (`TdEnemy.ward_mult / ward_until`, applied in `damage_enemy` after the trait, before armour; the strongest ward wins, no stacking). Sun Paladin 100 px x0.8; Holy Ward Generator 120 px x0.5. |
| M6 | Silence | `TdEnemy.silenced_until` (+ `TdCombat.silence_enemy()`); every healer (Chaplain, High Confessor, attendants) checks `EnemyTrait.can_heal()`. The Banshee side belongs to the towers agent. |
| M7 | Confessor | Heals 18 HP every 3 s within 110 px (x3 on a boss); revives the most recent fodder / elite (not a Confessor) that died within 140 px in the last 20 s, every 12 s from 6 s, at 60% HP, max 3 (Necropathy's owner-approved numbers). Deaths are recorded by `CovenantField` (one node per run, made only on maps with such kinds). |
| M8 | Structures | Ward generators and crystals are enemies with row key `structure` (speed 0, wave 0, standing on the nearest road's edge): towers target them only when no real enemy is in range, except on Strongest; never warded; never revived; `MapRule.finish_structures()` removes leftovers so the map can end. Rank "elite" (12 souls). |
| M9 | Crimson March | Two entrance roads (north, south) wind twice and join a trunk to the gate; two side lanes near the gate (no arch) are used only by Vael's squads. 16 plots, 5 posts, 250 starting souls (two roads to cover). 6 generators: 2 at the start, then waves 8, 14, 19 (x2). New kinds: Shieldbearer, Banner Bearer, Halberdier, Sister of the Scourge (Necropathy's March roster). Miniboss: Templar Commander (Templar art, banner haste aura) on wave 12. |
| M10 | Vael | Every 14 s (x0.6 below half HP) a squad of 3 Footmen + 2 Shieldbearers enters at each side lane; every 11 s a 4 s Shieldwall halves frontal hits (same front test as the Shieldbearer). 12000 HP. |
| M11 | Sanctum | One 4100 px road, four runs, entering top right; two chambers (rects) cover 8 of 15 plots; two ward crystals each (650 HP); x0.75 tower damage inside until both of its crystals break. 250 starting souls. New kinds: Sentinel, Radiant Inquisitor, High Confessor, Sun Paladin (plus Halberdiers and Sisters later). |
| M12 | Seraphine | Arrives with 3 Confessor Attendants (her pace, heal her x4); every 14 s (9 s below half HP) breaks free and blinks 150 px down the road (never within 700 px of the gate); unheld attendants blink behind her; a beam suppresses towers where she lands. 16000 HP. |
| M13 | Cathedral Guardian | Wave-13 miniboss, 5600 HP, armour 6: while held, slams every body of the post for 60 every 5 s; every 12 s a beam suppresses towers within 150 px. |
| M14 | Alaric | Charges at intervals instead of only after 9 s held: from 4 s after arrival, whenever a post with a living body is within 90 px ahead (or one holds him) and 10 s have passed since his last charge, he stops for a 1 s wind-up, then deals 220 to every body of that post and runs through it unholdable for 1.6 s at x3.5. |
| M15 | Unlocks | MAP key `unlock_after` (map id whose boss opens it): graveyard "", crimson_march "graveyard", sanctum "crimson_march". The menu agent reads it. |
| M16 | Reckoning | `TdGame.start_reckoning()` after a win resumes the run; WaveDirector appends waves cycling the map's last 6 plain waves with count x(1 + 0.15k), HP x1.15^k, spacing x0.85, the miniboss every 5th wave. Ends when the gate falls (`ended` again, `won` stays true, skulls from `lives_at_clear`). `game.reckoning_wave` = Reckoning waves reached (the menu stores the best). |
| M17 | Pacing | Wave spacing on all three maps raised so a map takes 8-11 min (Graveyard x1.35: 490 s; March 666 s; Sanctum 676 s). The long roads make a wave's start-to-clear 40-70 s on the March and Sanctum (walk time included); battles per wave stay short. |
| M18 | Events line | `EnemyTrait.note(game, key)` counts trait / boss events (`game.stats["events"]`) for the autotest `events=` line; maps add `MapRule.summary()` for the `rule=` line. |
