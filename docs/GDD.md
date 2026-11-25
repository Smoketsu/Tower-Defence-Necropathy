# Necropathy: Gravewatch — Game Design Document
2026-11-25 · Nate DeMarino

## 1. Overview
**Necropathy: Gravewatch** (working title) is a tower defense game built from Necropathy's existing art, audio, data tables and interface. The player is a necromancer holding a crypt: Covenant columns march down roads toward the Ossuary gate, and the player raises undead on grave plots beside the road to stop them.
|  |  | 
| Genre | Fixed-path tower defense with active spells | 
| Engine | Godot 4.3, GDScript, GL Compatibility renderer (same as Necropathy) | 
| Platforms | Desktop (Windows, Linux), Web, phones and tablets in the browser | 
| Session length | 8 to 12 minutes per map | 
| First release | Act I, the Covenant: 3 maps, 8 towers, 4 spells, 3 bosses | 
| Full game | Up to 15 acts and 45 maps, added one act per update | 
| Relation to Necropathy | A separate game in a separate repository; Necropathy itself is not changed | The project is an asset flip in the literal sense: Necropathy already holds about 3,000 sprites, 15 summon classes, 12 spells, 45 stage floors, a full interface kit and synthesized music. The design below reuses them with as few new assets and as little new code as possible.
The fit is natural, not forced. Necropathy's own rules already say that enemies always advance, that undead never dodge and that Warriors block bodies. Those are tower defense rules.

## 2. Design pillars
Every later decision is checked against these five rules.
- 
**The dead hold the line.** Towers are undead, not buildings. Ranged classes shoot from grave plots; blocker classes stand on the road and physically stop the column.
- 
**The necromancer is on the field.** Spells and the ultimate give the player something to do in every wave. A map can't be won by placement alone, and can't be won by spells alone.
- 
**Every kill feeds the army.** Kills pay souls, souls raise and upgrade undead. Selling returns most of the cost, so re-planning mid-map is cheap.
- 
**Discovery stays.** Evolutions are still not hinted. A tower that meets a hidden recipe shows a new top-tier upgrade, and the Codex records it afterwards.
- 
**Reuse before create.** A feature that needs new art, new audio or a new system must justify it. If an existing Necropathy asset or data row does the job, it is used as it stands.

## 3. Core loop
A map is 20 to 30 waves and ends when the last wave is dead or the gate's life counter reaches zero.
**One wave**
- 
**Build phase.** The next wave's enemy kinds are shown on the road's entrance. The player raises, upgrades, moves or sells undead. No timer on the first wave; later waves start after 15 s or when the player calls them early for a soul bonus.
- 
**Wave.** Enemies walk the road. Towers fire on their own; the player casts spells and may build during the wave.
- 
**Payout.** Each kill pays souls at once. A wave with no leaks pays a small bonus.
**One map**
- 
Start with 20 lives and enough souls for two or three towers.
- 
An enemy that reaches the gate costs 1 life; an elite 3; a boss ends the map.
- 
A miniboss arrives at about the half-way wave and drops a chest: one free upgrade or an evolution if a recipe is met.
- 
The stage boss walks the road on the final wave, using a cut-down version of its Necropathy kit.
- 
The map is rated 1 to 3 skulls by lives kept.
**One campaign session**
- 
Pick a map and a difficulty, play it, earn Soul Ash by rating and difficulty.
- 
Spend Soul Ash in the Ossuary on permanent upgrades.
- 
Beating a map's boss opens the next map; beating an act's third boss opens the next act.
Numbers in this section are starting values for the prototype, not tuned balance.

## 4. Towers
Towers are Necropathy's summon classes, placed on two kinds of spot: **grave plots** beside the road for ranged and support classes, and **road posts** on the road for blockers.

### 4.1 Launch roster (Act I)
| Tower | Spot | Role | Reused behaviour | Evolution (hidden) | 
| Skeleton Archer | Plot | Fast single-target damage, long range | Arrow projectile | Gravebow: piercing, splitting, cursing arrows | 
| Bone Mage | Plot | Splash damage, medium range | Mage bolt and burst | Lich | 
| Frost Wraith | Plot | Slows, then freezes packs | Chill and Deep Freeze | Winter Revenant: frozen enemies shatter | 
| Corpse Catapult | Plot | Very long range, slow, heavy area hits | Bone Barrage with landing telegraph | Ossuary Engine: three boulders, burning fields | 
| Banshee | Plot | Debuff: enemies in range move slower and hit weaker | Dirge | Keening Lady: three waves, silences healers | 
| Grave Mender | Plot | Support: heals blockers in range | Mender heal | Profane Bishop (needs a Warder adjacent) | 
| Skeleton Warrior | Road | Cheap blocker, holds 2 enemies | Body block | Death Knight | 
| Corpse Abomination | Road | Heavy blocker, holds 4, stomp staggers | Stomp | Bone Colossus: taunt, shrapnel on death | ### 4.2 Later towers
Each later act adds one or two classes that already exist in Necropathy: Crypt Warder (barriers on blockers), Grave Rogue (leaves its plot to dash at elites), Crypt Gargoyle (patrols a circle, the answer to flyers), Bone Hounds (a pack that chases leaks down the road), Bone Golem, and the act finale classes (Spawn of the Deep, Bound Oni, Bonehorn, Ossuary Oak and others).

### 4.3 Upgrades
- 
Each tower has **levels 1 to 5**, bought with souls. Levels raise damage, range or rate using the class's existing level table as the starting point.
- 
**Level 3** adds the class's volley from Necropathy's bullet heaven pass, a visible burst that makes an upgraded tower look upgraded.
- 
**Evolution** is the sixth tier. It appears only when the tower is level 5 and its hidden recipe is met, then costs souls like any upgrade. Recipes are placement conditions in place of Necropathy's paired passives, for example "a Frost Wraith within two plots of the tower" or "this tower has 200 kills".
- 
**Targeting** per tower: First, Last, Strongest, Nearest. Shadow Bolt's Nearest / Strongest toggle already exists as a pattern.
- 
**Sell** returns 70% of souls spent. Blockers that die return after a cooldown at no cost; they are not lost.

### 4.4 Synergies
Necropathy's setter and finisher pairs become **adjacency bonuses**, shown on the plot before placing. Examples carried over by name: Shatterfall (Frost Wraith + Catapult: frozen targets take more boulder damage), Flesh Rampart (Abomination + Warrior: the blockers hold more), Killing Field (Abomination + Catapult: boulders aim at stomped packs), Requiem (Banshee + Mage: the Dirge lasts longer on enemies the Mage hits). Synergies stay hinted, never secret, as in Necropathy.

## 5. Spells and the ultimate
The necromancer brings **three spells and one ultimate** into a map, chosen before it starts. Spells have cooldowns and no soul cost, so casting never competes with building.
| Spell | Tower defense use | Launch | 
| Shadow Bolt | Aimed single-target shot, short cooldown; the finisher for leaks | Yes | 
| Bone Wall | Blocks the road for a few seconds; bosses and minibosses walk through | Yes | 
| Corpse Explosion | Detonates corpses on the road; rewards killing in one place | Yes | 
| Plague Cloud | Rot over a stretch of road; damage over time | Yes | 
| Death Mark | Marked enemy takes a damage-over-time brand and raises a temporary Risen on death | Later | 
| Soul Chains | Chains a pack together; slows and arcs damage | Later | 
| Wither | Aura on a chosen plot that shreds armour | Later | 
| Raise Dead | Temporary blockers anywhere on the road | Later | The remaining Necropathy spells (Orb Shield, Shadow Blast, Bone Spear, Soul Siphon, and each act's own spell) come in with their acts.
**Ultimate.** Dread Rally keeps its kill-charged soul meter. In Gravewatch it revives every fallen blocker at once and gives all towers +40% damage and attack speed for 8 s. Sovereign's Decree, Eclipse and Grave Tide are later unlocks on the same meter.
**Characters.** Necropathy's playable characters carry over as the pre-map pick: each starts with its own spell at a higher level and keeps its one innate passive. The Gravecaller remains the default with no innate.

## 6. Enemies, waves and bosses
Enemies are Necropathy's existing kinds with their sprites, walk strips, HP and speed rows. Each gets one tower defense trait drawn from what its kit already does.

### 6.1 Act I roster
| Enemy | Trait on the road | Countered by | 
| Covenant soldier | Baseline fodder | Anything | 
| Templar | Charges: brief speed burst after the first hit | Slows, blockers | 
| Shieldbearer | Takes less damage from the front | Catapult, towers placed past a bend | 
| Banner Bearer | Nearby enemies move faster | Strongest-first targeting | 
| Halberdier | Hits blockers hard, long reach | Mender support, ranged focus | 
| Sister of the Scourge | Lash hits two blockers in a line | Spread blockers | 
| Sanctified Sentinel | Flat armour 6 | Mage, Catapult, Wither | 
| Radiant Inquisitor | Holy zone suppresses towers in a small radius | Kill first, or reposition | 
| High Confessor | Heals and revives nearby enemies | Banshee's silence, burst damage | 
| Sun Paladin | 20% ward aura on nearby enemies | Strongest-first, Death Mark | ### 6.2 Wave design
- 
Waves are data rows: kind, count, spacing, lane, delay. One table per map, in the style of Necropathy's stage timelines.
- 
Each map introduces one or two new kinds and announces them before the wave.
- 
Difficulty comes from combinations (healer behind armour, banner behind shields), not from raw HP growth.
- 
After the last wave of a cleared map, an optional **Reckoning** endless mode keeps escalating until the gate falls, with a best-wave record per map.

### 6.3 Bosses
| Map | Boss | Road version of the fight | 
| Desecrated Graveyard | Sir Alaric | Walks the road, charges through one blocker post at intervals | 
| Crimson March | Marshal Vael | Calls reinforcement squads from side lanes while advancing | 
| Sanctum of Judgment | Grand Inquisitor Seraphine | Teleports forward along the road, suppresses towers with beams, is healed by High Confessor attendants | Each map also has a mid-map miniboss that drops the chest; on the Sanctum it is the Cathedral Guardian. The Graveyard and Crimson March minibosses are picked from existing elite kinds during the vertical slice.

## 7. Maps and act rules

### 7.1 Map structure
- 
A map is one screen, **1280 x 720**, no scrolling. This keeps the phone layout simple and matches Necropathy's fixed layout size.
- 
Each map has 1 to 3 entrances, one gate, **12 to 20 grave plots** and **3 to 6 road posts**.
- 
Roads are fixed. There is no free placement and no mazing: spots are authored so every map has a few strong positions (bends, crossings) worth fighting over.
- 
A map is a data file: road polylines, spot positions, the floor and obstacle set to draw, and the wave table. No per-map scripts unless the map has a rule of its own.
- 
The floor, obstacles and decals are the matching Necropathy stage's art. Only the road itself is new art.

### 7.2 Act I maps
| Map | Layout | Rule of its own | 
| The Desecrated Graveyard | One winding road, one entrance | None: the teaching map | 
| The Crimson March | Two roads that merge before the gate | Holy Ward Generators beside the road shield enemies until destroyed | 
| The Sanctum of Judgment | One long road through two sanctified chambers | Towers inside a chamber deal 25% less until its ward crystals are broken | ### 7.3 Later acts
Each Necropathy act already has shared rules. In Gravewatch one of them becomes that act's map gimmick, so every act plays differently without new systems being invented.
| Act | Faction | Map gimmick, from the existing rule | 
| II | The Black Tide | Broadsides: deck cannons shell plots on a telegraph | 
| III | The Sanguine Court | Blood Moon: every few waves enemies heal on kills; bats fly over the road | 
| IV | The Last Line | Vehicles and armour; the escalation clock sets each wave's tier | 
| V | The Shogunate | Day, dusk and night: at night towers see only inside lantern light | 
| VIII | The Olympian Republic | Phalanx: shield fronts must be hit from behind, so plots past a bend matter | 
| XI | The Ancient Eye | Claims: a blocker that dies near a claimer rises as a hostile thrall | 
| XII | The Electronic Empire | Line of Fire: ranged enemies shoot towers; blockers and Bone Walls stop the shots | 
| XIV | The Age of Titans | Stampedes: herds cross the map off-road and trample plots in their path | The other acts follow the same pattern and are specified when their turn comes.

## 8. Economy and meta progression

### 8.1 In a map: souls
| Source or sink | Starting value | 
| Starting souls | 150 | 
| Kill, fodder / elite / miniboss | 3 / 12 / 80 | 
| No-leak wave bonus | 10 + 2 per wave number | 
| Calling the next wave early | 1 soul per second skipped | 
| Cheapest tower (Warrior) / dearest (Catapult) | 40 / 140 | 
| Upgrade cost per level | 60%, 90%, 130%, 180% of the tower's base cost | 
| Evolution | 300% of base cost | 
| Sell refund | 70% of souls spent | These are prototype values, tagged as tuning numbers in the data files. Balance targets are set after the Phase 0 spike shows how long a wave actually takes.

### 8.2 Between maps: Soul Ash and the Ossuary
- 
A cleared map pays Soul Ash by skulls earned and difficulty. A failed map pays a smaller amount by waves survived, so Soul Ash is still kept on defeat.
- 
The **Ossuary** screen is reused with a new, smaller upgrade table: starting souls, gate lives, sell refund, spell cooldowns, a fourth spell slot, blocker respawn time, and one tree per tower family.
- 
**Masteries** carry over as they stand: taking a class to level 5 in any map opens a permanent bonus for that class.
- 
**Difficulty levels** keep their names: Initiate, Necromancer, Lich, Deathlord. They scale enemy HP and count and multiply Soul Ash.
- 
**Not at launch:** Relics, Grave Offerings, Recolour Caskets, the Profane Pact and Oath, Hyper mode, run modifiers. All are existing systems that can be switched on later if the base game holds up.

### 8.3 Collection
- 
The **Codex** is reused: enemies, towers, spells and bosses fill in as the player meets them; evolution recipes appear only once found.
- 
Each map shows its best skull rating per difficulty and its best Reckoning wave.
- 
Saves are separate from Necropathy's. Nothing carries between the two games at launch.

## 9. Interface, controls and platforms
Gravewatch follows Necropathy's interface rules unchanged: cut corners, Jersey 10 and Jacquard 24 at the fixed type tiers, one-word buttons, input chips in place of key names, and colour that carries meaning (gold for evolution and victory, crimson for danger, soul-teal for affordable).

### 9.1 In a map
| Element | Position | Content | 
| Top bar | Top | Lives, souls, wave number of total, next-wave preview, Call button | 
| Spell bar | Bottom centre | Three spell buttons with cooldown sweeps, the ultimate with its meter | 
| Speed and pause | Top right | x1 / x2 / x3, Pause | 
| Spot menu | Around the tapped spot | Empty spot: the towers that fit it, with costs. Occupied spot: Upgrade, Target, Sell, and Evolve when a recipe is met | 
| Range ring | Around the selected spot | Range, and a line to each tower it would form a synergy with | 
| Banners | Upper centre | Wave start, new enemy kind, boss arrival (the existing banner queue) | ### 9.2 Controls
| Action | Mouse and keyboard | Gamepad | Touch | 
| Select a spot | Click | Stick moves a cursor between spots, A | Tap | 
| Choose from the spot menu | Click | Stick direction, A | Tap | 
| Cast a spell | 1 / 2 / 3, then click the target | X / Y / B, then aim and A | Tap the spell, tap the target | 
| Ultimate | Space | LB | Button | 
| Call the next wave | Enter | RB | Button | 
| Speed, pause | Tab, Esc | Triggers, Start | Buttons | All bindings are rebindable through the existing Settings screen.

### 9.3 Platforms
- 
**Phones are the best fit, not the compromise.** Tap to place is more natural than Necropathy's joystick. The existing touch scaling, portrait overlay, audio unlock and save-backup code are reused.
- 
**Performance should be lighter than Necropathy.** A map holds at most 20 towers and a few hundred enemies on a fixed camera, well under Necropathy's late-game load. The Web export keeps both existing patches (audio buffers and WebGL ids).
- 
**Screens kept:** title, map select with Part and act tabs, pre-map setup (character, spells, ultimate, difficulty), pause, results, Ossuary, Codex, Settings, Credits.
- 
**Not at launch:** co-op, the illustrated epilogue, skins and titles.

## 10. Technical architecture
Gravewatch is a **new Godot 4.3 project in its own repository**. Presentation code and data are copied from Necropathy; the simulation core is written fresh and kept small.
The reason for a separate project: Necropathy's simulation is guarded by same-seed gates on 45 stages and a co-op lockstep check. A tower defense mode inside that codebase would put all of them at risk for no gain.

### 10.1 What is copied, adapted and written new
Coupling was measured by counting references to the Game object in each file.
| System | Necropathy source | Game references | Plan | 
| Sprites and sharp-pixel drawing | assets/ (3,015 PNGs, 47 MB), sprite_bank.gd | 0 | Copy as is | 
| UI theme, kit and motion | ui_theme.gd, ui_motion.gd, confirm_dialog.gd, kit art | 0 | Copy as is | 
| Sound and music | sfx.gd and the synth scripts | 0 | Copy as is | 
| Spatial hash | spatial_hash.gd (78 lines) | 0 | Copy as is | 
| Settings, input chips, touch scaling | settings.gd, input_hints.gd, touch_support.gd | 0 to 1 | Copy, trim | 
| Menu shell and Codex | main_menu.gd, codex_screen.gd | 0 to 1 | Copy, re-point at new data | 
| Enemy, class and spell data | scripts/data/*.gd | data only | Copy the rows needed; add tower defense fields beside them | 
| Meta save and Ossuary screen | meta_progress.gd, Ossuary scripts | not measured | Adapt to the smaller upgrade table | 
| Web export, patches, CI | tools/patch_web_*.py, export presets, workflow | none | Copy, cut to one test job per map | 
| Damage and status rules | combat_resolver.gd (1,277 lines) | 274 | **Write new**, small; reuse its formulas, not its file | 
| Enemy behaviour | enemy.gd (1,403 lines) | 83 | **Write new**: a path follower with a trait hook | 
| Army behaviour | horde_director.gd (1,065 lines) | 83 | **Write new**: a stationary tower with targeting | 
| Arena, stage directors, co-op | arena.gd and the rest | 22 and up | Not carried over | ### 10.2 New core, estimated under 3,000 lines
| Script | Job | 
| map_def data + MapLoader | Road polylines, spots, floor set, wave table | 
| PathFollower | Moves an enemy along a road by distance travelled; blockers stop it | 
| WaveDirector | Spawns from the wave table on the game clock | 
| Tower and Blocker | Targeting, firing, levels, evolution, hold slots | 
| TdCombat | One path for all damage, slows, armour and kills, as in Necropathy | 
| SoulEconomy | Souls, costs, refunds, wave bonuses | 
| SpellCaster | Cooldowns and targeting for the spells | 
| TdHud and SpotMenu | The in-map interface | 
| TdAutotest | A headless bot that plays a map from a fixed build order | ### 10.3 Conventions kept from Necropathy
- 
Every script has a header comment, and every variable, constant and exported field is documented with units and ranges.
- 
All tunable numbers live in data files with no logic, each tagged by source.
- 
Static typing everywhere. Pooled enemies and projectiles. No physics engine for units.
- 
Deterministic per seed: seeded RNG only, no wall-clock time in gameplay. A given map, build order and seed must always give the same result, which is what makes the autotest and later balance batches possible.
- 
One path per concern for modifiers: meta upgrades, difficulty, tower stats, damage.

## 11. New art and audio needed
About 25 new sprites cover the launch game. Everything else on screen already exists.
| Asset | Count | Notes | 
| Road tiles (straight, bend, crossing, ends) | 1 set of about 8 per act | Act I: worn flagstone. Drawn over the existing floors | 
| Grave plot, empty and occupied | 2 | Open grave with headstone; reads as "build here" | 
| Road post marker | 1 | Bone stakes across the road | 
| Ossuary gate, intact and damaged states | 3 | The thing being defended | 
| Entrance marker | 1 | Covenant banner arch | 
| Range ring and synergy link | 2 | Textures, not drawn polygons, for the Web build | 
| HUD icons: lives, souls, wave, speed, call, sell, target modes | about 10 | In the existing icon style | 
| Logo lockup with the subtitle | 1 | Existing NECROPATHY logo plus "Gravewatch" in Jacquard 24 | **Made with the existing pipeline.** tools/gen_image.py, prepare_sprite.py, make_tile.py and the palette ramps are copied with the project, so new art matches the old.
**Known art limits.** Units have walk strips and idle strips but no attack poses, so a tower's attack is shown by its projectile, a muzzle flash from the existing effect strips and a short squash. Whether units have more than one facing has not been checked; see the risks in section 13.
**Audio.** No new music at launch: the menu theme and each act's run loop are reused as they stand. Five new synthesized sounds are needed (place, upgrade, sell, life lost, wave call), built with the existing sound synth so no audio files are added.

## 12. Roadmap and milestones
Phases run left to right; each diamond is a gate that must pass before the next phase starts. Only the first gate can end the project, and it costs about a day to reach.
**Gate criteria**
- 
**Is it fun?** One Graveyard map is playable start to finish with placeholder interface. The owner plays it and decides. Placement choices should matter by wave 5, and a wave should take 20 to 40 s.
- 
**Owner plays Act I.** Three maps, all eight towers with upgrades and one evolution each, four spells, three boss waves, real interface. Import and autotest runs show no errors; the autotest bot clears each map on Necromancer with a fixed build order.
- 
**Public Web build.** Meta progression saves and reloads, the Web build runs a full map on a phone without a reload, and CI runs one test job per map plus the exports.
**How it is built.** Same method as Necropathy's acts: a foundation branch first, then parallel agents in worktrees for independent pieces (maps, towers, interface), merged on an integration branch and verified before main moves.
**Estimates** are agent working time, not calendar time, and assume the owner reviews at each gate. They are based on how long comparable Necropathy pieces took, not on a measured prototype.

## 13. Risks and open decisions

### 13.1 Risks
| Risk | Why it matters | Mitigation | 
| The art reads as a reskin | Sprites were drawn for a moving army, with no attack poses and no tower bases | Grave plots frame each unit; volleys and effect strips carry the attack. Judge it at the first gate | 
| Sprite facing on vertical roads | Not yet checked whether units have only side views | Check in Phase 0; if so, author Act I roads to run mostly left to right | 
| Fixed towers feel passive after Necropathy | The source game is about motion | Spells every wave, blockers that fight and fall, early-call bonus, x3 speed | 
| Balance from scratch | None of Necropathy's balance work transfers | Deterministic autotest from day one; difficulty by enemy combinations before HP scaling | 
| Scope creep toward 45 maps | The content exists, so adding it is tempting | Ship Act I as a whole game; each later act is its own gated update | 
| Two games to maintain | Shared code drifts once copied | Copy once and accept the drift; shared art fixes are ported by hand | 
| Copied code is more tangled than measured | Only Game references were counted, not autoloads or data lookups | Phase 0 copies the presentation layer first and reports what broke | ### 13.2 Decisions for the owner
- 
**Name.** Necropathy: Gravewatch is a placeholder.
- 
**Repository.** A new private repository is needed; this session can reach only the two existing ones.
- 
**Roads.** Fixed roads with authored spots (recommended) or free placement with mazing.
- 
**Launch scope.** Act I only (recommended) or more acts before the first public build.
- 
**Blockers.** Keep road-post blockers (recommended, it is the game's identity) or ranged towers only for a simpler first version.
- 
**Where it is published.** A second GitHub Pages site beside Necropathy's, or a mode link from Necropathy's title screen to the new page.
- 
**Progress link.** Whether owning Necropathy progress should unlock anything in Gravewatch. Not planned for launch.
