## The Hallowed Light: Act X's act rule (GDD §7.3; Necropathy's HallowedLight,
## Grace, CloudShade and Judgment, docs/host/). Numbers in
## Acts.data("host")["RULE"] (its "maps" row for this map).
##   shafts    — bands of light sweep slowly across the map, one direction each
##               (RULE maps angles, cycled). A new shaft shows a TELEGRAPH for
##               `warn` s (a thin line where it enters, nothing burns), then it
##               burns and sweeps at `speed` px/s until it leaves the far side.
##               At most `live_at`.size() shafts by wave (index i + 1 from wave
##               live_at[i]). Width grows each wave (`widen`) and, with `choir`,
##               with every live Choir Angel (the Empyrean). Bosses lay still
##               shafts through add_shaft() (Seraiel's Gate, the Throne's Gaze).
##   grace     — every `tick` s each angel inside a burning shaft is hasted
##               (`haste`, TdCombat.haste_enemy) and regains `grace` of its max HP
##               per s (TdCombat.heal_enemy).
##   weakening — every tower inside a burning shaft and out of the SHADE deals
##               `weaken` damage (TdCombat.suppress_tower, the one weakening
##               path; the Fallen Herald's innate light_cut softens it). Shade:
##               the map's cloud banks (MAP key "clouds": [[centre px, radius
##               px], ...], drifting `cloud_drift` px over `cloud_period` s) and
##               the shade of a Crypt Warder or Bound Ophan (RULE shade_towers).
##   judgment  — the sins: every blocker body lost (not Risen, not walls).
##               When the stage boss arrives every `per_judge` sins return as a
##               Judge (at most `boss_cap`); bosses call send_judges() for more.
##               Judges walk in from the entrances `gap` s apart.
## The look: HostLayer (shafts, telegraphs, cloud shadows, glare under weakened
## towers; drawing only) and HostDial (the HUD scales: sins and the Light's
## width), both null headless.
extends MapRule

## This map's RULE "maps" row.
var cfg: Dictionary = {}
## Shafts: {s: px of its centre line along `n` from the map centre, n: Vector2
## sweep direction (unit), speed: px/s (0 = still), born: game s, live_at: game s
## it starts burning, end: game s it goes out (INF = when it leaves the map),
## width: px (still shafts; 0 = the map width now)}.
var shafts: Array[Dictionary] = []
## Wave now (1-based; 0 before the first).
var wave: int = 0
## Game s the next sweeping shaft appears.
var next_shaft: float = 0.0
## Sweeping shafts made so far (cycles the angles).
var made: int = 0
## Game s of the next application of the Light.
var next_tick: float = 0.0
## Sins of the run (blocker bodies lost, minus the ones returned as Judges).
var sins: int = 0
## Every sin counted this run (summary).
var sins_total: int = 0
## Judges waiting to walk in.
var judge_queue: int = 0
## Game s the next queued Judge walks in.
var next_judge: float = 0.0
## True once the boss's arrival sent its Judges.
var boss_judged: bool = false
## Towers weakened at the last tick (drawn: glare), and the ones saved by shade (drawn: cool ring).
var lit: Array[Tower] = []
## See lit.
var saved: Array[Tower] = []
## Counters for the summary.
var counts: Dictionary = {"shafts": 0, "still": 0, "graced": 0, "lit_ticks": 0, "shade_saves": 0, "judges_sent": 0, "judges_slain": 0}
## Extra width share from bosses (the Voice's Holy), multiplied in.
var boss_width: float = 1.0
## Extra live shafts allowed by bosses (the Voice's Holy).
var boss_live: int = 0
## The drawing layer and the HUD dial (null headless).
var layer: Node2D = null
## See layer.
var dial: Control = null


## The RULE numbers.
static func r() -> Dictionary:
	return Acts.data("host")["RULE"]


## The Hallowed Light of this run, or null on another act's map (kinds and spells ask).
static func of(game: TdGame) -> MapRule:
	return game.act_rule if game.act_rule != null and game.act_rule.has_method("send_judges") else null


func setup() -> void:
	cfg = r()["maps"].get(game.map_id, r()["maps"]["silver_stair"])
	next_shaft = float(cfg["first"])
	if DisplayServer.get_name() == "headless":
		return
	layer = (load("res://scripts/maps/rules/host/host_layer.gd") as GDScript).new() as Node2D
	layer.set("rule", self)
	game.world.add_child(layer)
	dial = (load("res://scripts/maps/rules/host/host_dial.gd") as GDScript).new() as Control
	dial.set("rule", self)
	game.hud.root.add_child(dial)


func on_wave_start(n: int) -> void:
	wave = n
	var la: Array = cfg["live_at"]
	if la.has(n) and la.find(n) > 0:
		game.banner("The Light widens: %d shafts sweep the field" % (la.find(n) + 1))


## Most sweeping shafts at once now.
func max_live() -> int:
	var n := 0  # Shafts allowed.
	for w: int in cfg["live_at"]:
		if wave >= w:
			n += 1
	return maxi(n, 1) + boss_live


## Width (px) of a sweeping shaft now (the wave's widening, the Choir, the bosses).
func width() -> float:
	var w := float(cfg["width"]) * (1.0 + float(cfg["widen"]) * float(maxi(wave - 1, 0)))  # Px.
	if float(cfg["choir"]) > 0.0:
		var c := 0  # Live Choir Angels.
		for e: TdEnemy in game.enemies:
			if e.kind == "host_choir_angel":
				c += 1
		w *= 1.0 + float(cfg["choir"]) * float(c)
	return w * boss_width


## Half the map's extent along direction `n` (px from the centre to the far edge).
static func half_extent(n: Vector2) -> float:
	return absf(n.x) * MapView.SIZE.x * 0.5 + absf(n.y) * MapView.SIZE.y * 0.5


## Lays a STILL shaft (bosses): centred on map px `at`, its band across direction
## `n`, `w` px wide, burning after the telegraph for `life` s.
func add_shaft(at: Vector2, n: Vector2, w: float, life: float) -> void:
	var warn := float(r()["warn"]) * 0.5  # Still shafts warn faster.
	shafts.append({"s": (at - MapView.SIZE * 0.5).dot(n), "n": n, "speed": 0.0, "born": game.time,
		"live_at": game.time + warn, "end": game.time + warn + life, "width": w})
	counts["still"] = int(counts["still"]) + 1
	Sfx.play("light_warn")


## Width (px) of shaft `sh` now.
func shaft_width(sh: Dictionary) -> float:
	return float(sh["width"]) if float(sh["width"]) > 0.0 else width()


## Centre line (px along n) of shaft `sh` now.
func shaft_s(sh: Dictionary) -> float:
	return float(sh["s"]) + float(sh["speed"]) * maxf(game.time - float(sh["live_at"]), 0.0)


## True when shaft `sh` burns now (past its telegraph).
func burning(sh: Dictionary) -> bool:
	return game.time >= float(sh["live_at"])


## True when map px `p` lies inside a burning shaft.
func in_light(p: Vector2) -> bool:
	var c := MapView.SIZE * 0.5  # Map centre.
	for sh: Dictionary in shafts:
		if burning(sh) and absf((p - c).dot(sh["n"]) - shaft_s(sh)) <= shaft_width(sh) * 0.5:
			return true
	return false


## Cloud bank centres now ([centre, radius] pairs; drifting, game time only).
func clouds() -> Array:
	var out: Array = []  # [Vector2, float] pairs.
	var cl: Array = game.map.get("clouds", [])
	for i in cl.size():
		var ph := game.time / float(r()["cloud_period"]) * TAU + float(i) * 1.7  # Drift phase.
		out.append([Vector2(cl[i][0]) + Vector2(sin(ph) * float(r()["cloud_drift"]), 0.0), float(cl[i][1])])
	return out


## True when map px `p` lies in shade (a cloud bank, or a Warder's / Bound Ophan's shade).
func shaded(p: Vector2) -> bool:
	for c: Array in clouds():
		if p.distance_squared_to(c[0]) <= float(c[1]) * float(c[1]):
			return true
	var st: Dictionary = r()["shade_towers"]
	for t: Tower in game.towers:
		if st.has(t.tower_id) and p.distance_squared_to(t.position) <= float(st[t.tower_id]) * float(st[t.tower_id]):
			return true
	return false


## Damage x of a tower in the Light (the Fallen Herald's light_cut softens it).
func weaken_mult() -> float:
	return 1.0 - (1.0 - float(r()["weaken"])) * (1.0 - float(CharacterModifiers.innate("light_cut", 0.0)))


func step(_dt: float) -> void:
	# New sweeping shafts.
	if game.time >= next_shaft and wave > 0:
		next_shaft = game.time + float(cfg["every"])
		var live := 0  # Sweeping shafts on the map.
		for sh: Dictionary in shafts:
			live += 1 if float(sh["speed"]) > 0.0 else 0
		if live < max_live():
			var ang: Array = cfg["angles"]
			var n := Vector2.from_angle(deg_to_rad(float(ang[made % ang.size()])))  # Sweep direction.
			made += 1
			var w := width()  # Px now.
			shafts.append({"s": -half_extent(n) - w * 0.5, "n": n, "speed": float(cfg["speed"]), "born": game.time,
				"live_at": game.time + float(r()["warn"]), "end": INF, "width": 0.0})
			counts["shafts"] = int(counts["shafts"]) + 1
			if made == 1:
				game.banner("Hallowed Light: angels in a shaft are hasted and healed, towers in it are weakened. Shade saves them")
			Sfx.play("light_warn")
	# Shafts that went out.
	for i in range(shafts.size() - 1, -1, -1):
		var sh: Dictionary = shafts[i]
		if game.time >= float(sh["end"]) or (float(sh["speed"]) > 0.0 and shaft_s(sh) > half_extent(sh["n"]) + shaft_width(sh)):
			shafts.remove_at(i)
	# Judges walking in.
	if judge_queue > 0 and game.time >= next_judge:
		judge_queue -= 1
		next_judge = game.time + float(r()["judgment"]["gap"])
		_send_one()
	if game.time < next_tick:
		return
	next_tick = game.time + float(r()["tick"])
	_apply()


## One application of the Light (every RULE tick s).
func _apply() -> void:
	var tick := float(r()["tick"])  # S since the last.
	lit.clear()
	saved.clear()
	var any := false  # Any shaft burning.
	for sh: Dictionary in shafts:
		any = any or burning(sh)
	if not any:
		return
	for e: TdEnemy in game.enemies:
		if e.alive and not bool(e.row.get("structure", false)) and in_light(e.position):
			TdCombat.haste_enemy(game, e, float(r()["haste"]), tick * 1.5)
			if e.hp < e.max_hp:
				TdCombat.heal_enemy(game, e, e.max_hp * float(r()["grace"]) * tick)
			counts["graced"] = int(counts["graced"]) + 1
	var m := weaken_mult()  # Damage x in the Light.
	for t: Tower in game.towers:
		if not in_light(t.position):
			continue
		if shaded(t.position):
			saved.append(t)
			counts["shade_saves"] = int(counts["shade_saves"]) + 1
			continue
		TdCombat.suppress_tower(game, t, m, tick * 1.5)
		lit.append(t)
		counts["lit_ticks"] = int(counts["lit_ticks"]) + 1


func on_body_fallen(b: BlockBody, _by: TdEnemy) -> void:
	if b.temporary:
		return
	sins += 1
	sins_total += 1
	if dial != null:
		dial.queue_redraw()


func on_spawn(e: TdEnemy) -> void:
	if String(e.row["rank"]) != "boss" or boss_judged:
		return
	boss_judged = true
	var n := mini(int(r()["judgment"]["boss_cap"]), sins / int(r()["judgment"]["per_judge"]))  # Judges due.
	if n > 0:
		game.banner("Judgment: %d of your sins return as Judges" % n)
		send_judges(n)


func on_kill(e: TdEnemy, _tower: Tower) -> void:
	if e.kind == String(r()["judgment"]["kind"]):
		counts["judges_slain"] = int(counts["judges_slain"]) + 1


## Queues `n` Judges (each takes `per_judge` sins while any are left); returns how many.
func send_judges(n: int) -> int:
	if n <= 0:
		return 0
	sins = maxi(sins - n * int(r()["judgment"]["per_judge"]), 0)
	judge_queue += n
	next_judge = maxf(next_judge, game.time)
	if dial != null:
		dial.queue_redraw()
	return n


## Judges a boss may call now from the sins (`cap` at most).
func judges_due(cap: int) -> int:
	return mini(cap, sins / int(r()["judgment"]["per_judge"]))


## One Judge descends at an entrance (round robin over the entrance roads).
func _send_one() -> void:
	var ents: Array[String] = []  # Entrance roads, sorted for a stable order.
	for id: String in game.roads:
		var rd: Road = game.roads[id]
		if rd.entrance and not rd.off_road:
			ents.append(id)
	ents.sort()
	var road := ents[int(counts["judges_sent"]) % ents.size()]  # Its road.
	var e := game.waves.spawn_extra(String(r()["judgment"]["kind"]), road, 30.0, 0.0)
	counts["judges_sent"] = int(counts["judges_sent"]) + 1
	game.fx.spawn("holy_impact", e.position, 90.0, 0.5, Acts.data("host")["LOOK"]["judge_tint"])
	Sfx.play("judge_descend")


func summary() -> String:
	var keys := counts.keys()  # Sorted for a stable line.
	keys.sort()
	var parts: Array[String] = ["sins:%d" % sins_total, "sins_left:%d" % sins, "width:%.1f" % width()]
	for k: Variant in keys:
		parts.append("%s:%d" % [k, int(counts[k])])
	return ",".join(parts)
