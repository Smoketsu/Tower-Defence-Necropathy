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

### gw-towers

| # | Area | Decision |
|---|---|---|
| T1 | Class kits | One kit script per class (`scripts/towers/<class>.gd`), evolution specials read from the evolution row's "set" keys; a tower keeps its kit when it evolves. |
| T2 | Frost Wraith | Every 6th bolt is a Deep Freeze: freezes every enemy within 60 px of the impact (Revenant 80 px, every 3rd). |
| T3 | Catapult | Lobbed boulders land after 1.1 s on a `telegraphs/target` telegraph, aimed at the enemy with the most others within its splash (the targeting mode breaks ties), leading walkers by their speed. Its Lv3 volley is two smaller lobbed boulders. |
| T4 | Banshee | Dirge: 0.45 s wind-up (closing violet ring) then the wail; it only starts when an enemy is in range. |
| T5 | Blockers | Lv3 volley for blockers: every 3rd (Warrior) / 2nd (Abomination) strike throws dagger / shard volleys at enemies within 110 / 120 px. Abomination stomp staggers held enemies 0.8 s (no attacks). |
| T6 | Blockers matter | Body HP Warrior 50, Abomination 200 and `BLOCKER_HIT_MULT` 4 on held enemies' hits (enemy rows untouched): ~8-12 bodies fall per default Graveyard run, which still wins with 20 lives. Default order's Frost Wraith and Mender swapped (plot 8 / plot 9) so the Mender stands by posts 1 and 2. |
| T7 | Gravebow | Pierce 2; every 4th shot 2 split arrows at 70%; hits curse for 4 s: tower hits on a cursed enemy x1.15. Recipe 90 kills. |
| T8 | Lich | Every 3rd kill by its (non-volley) bolts rises as a Risen: a temporary road block, 1 body 90 HP, holds 1, hits 12/s, 8 s, max 3. Deterministic (no chance roll). A Risen's fall is not a "blocker lost". Recipe: Frost Wraith within 200 px. |
| T9 | Winter Revenant | An enemy that dies frozen (any killer, not a boss) shatters: 22% of its max HP to enemies within 56 px + slow 0.6 for 2 s. No chains, one shatter per death. Recipe: Catapult within 220 px. |
| T10 | Ossuary Engine | 3 boulders spread 36 px; each leaves a burning field 30 px, 3 s, 12% of the boulder damage every 0.5 s. Recipe changed to a damage record (4000): splash rarely lands the killing blow, so 60 kills was out of reach. |
| T11 | Keening Lady | 3 wails 0.35 s apart, radius x1 / x1.3 / x1.6; each silences 3 s (`TdEnemy.silenced_until`, query `TdCombat.is_silenced()`; healer traits must respect it). Recipe: Mage within 210 px. |
| T12 | Profane Bishop | Recipe: the Mender's healing record, 1500 HP (GDD wants a Warder, not a launch tower). Bishop pulses also burn enemies in range for 10 and take 2 s off each fallen body's respawn in range. |
| T13 | Death Knight | Cleave: 50% to every other enemy its post holds; lifesteal 15% of damage dealt heals the striking body. |
| T14 | Bone Colossus | Taunt: other (non-temporary) blocker bodies within 210 px send their attackers' hits to it (`BlockBody.taunt_by`). Shrapnel when a body falls: 3x its stomp damage within 90 px. |
| T15 | Synergies | Shatterfall: Catapult hits x1.6 on frozen enemies (flat bonus removed). Killing Field: boulders aim at staggered packs (they count double) and hit staggered enemies x1.3 (rate bonus removed). Requiem: radius 210; Banshee range x1.1 kept; Mage hits keep a Dirge on for at least 1.5 s more and deal x1.15 to weakened enemies (flat Mage damage removed). Flesh Rampart unchanged (+1 hold). One hit bonus per hit, the highest. |
| T16 | Corpse Explosion | Kills leave corpse markers (max 40, 25 s, not bosses). A cast detonates up to 10 corpses within 110 px of the tap: 45 damage to every enemy within 55 px of each. No corpse = no cast. |
| T17 | Plague Cloud | 192 px of road around the tap's road point as 4 non-overlapping Rot fields (32 px), 6 s, 9 damage over time every 0.5 s. |
| T18 | Sounds | Five synthesized recipes in `TdSoundData.SOUNDS` rendered lazily as the Sfx pack "td" (asked for by TdGame); replaces stand-ins (decision 23). |
| T19 | Autotest | Build orders may name a `loadout` and (test orders only) `bonus_souls`. The bot casts Corpse Explosion and Plague Cloud at the enemy nearest the gate. |
