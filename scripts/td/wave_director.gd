## WaveDirector: spawns the map's wave table on the game clock with the
## owner's back-to-back pacing: enemies tightly spaced inside a wave, and the
## next wave starting by itself TdRulesData.AUTO_GAP s after the current
## wave's LAST SPAWN (not after it is dead). The first wave waits for Call;
## Call during a gap starts the next wave at once and pays the seconds
## skipped (EconomyData.CALL_PER_SECOND). Also tracks each wave's alive
## count and leaks for the no-leak bonus and the autotest's wave durations.
class_name WaveDirector
extends RefCounted

## The run.
var game: TdGame = null
## The map's wave rows.
var waves: Array = []
## Index of the latest started wave (-1 = waiting for the first Call).
var current: int = -1
## Game time (s) the latest wave started.
var wave_start: float = 0.0
## Pending spawns of the latest wave: [time after wave start, kind, road id], sorted.
var _queue: Array = []
## Game time (s) the next wave starts by itself (INF until the current wave's last spawn is known).
var next_start: float = INF
## Per wave (index): {alive, leaked, spawned_all, start, last_spawn, cleared, paid}.
var records: Array[Dictionary] = []
## Waves of the map's own table (the Reckoning appends after them).
var map_waves: int = 0


func _init(p_game: TdGame, p_waves: Array) -> void:
	game = p_game
	waves = p_waves.duplicate()  # The map's table is constant; the Reckoning appends to this copy.
	map_waves = waves.size()
	for i in waves.size():
		_add_record()


## Appends an empty wave record.
func _add_record() -> void:
	records.append({"alive": 0, "leaked": false, "spawned_all": false, "start": -1.0, "last_spawn": -1.0, "cleared": -1.0, "paid": false})


## Total waves on the map.
func total() -> int:
	return waves.size()


## True once every wave has started and finished spawning.
func all_spawned() -> bool:
	return not game.reckoning and current == waves.size() - 1 and _queue.is_empty()


## True when Call would start the next wave now (before wave 1, or in a gap).
func can_call() -> bool:
	return current + 1 < waves.size() and _queue.is_empty()


## Seconds left until the next wave starts by itself (INF before wave 1 / after the last).
func time_to_next() -> float:
	return maxf(next_start - game.time, 0.0) if current + 1 < waves.size() else INF


## Call (GDD §3): starts the next wave now; pays one soul per whole second skipped.
func call_next() -> void:
	if not can_call():
		return
	if current >= 0 and next_start < INF:
		game.economy.earn(floori(maxf(next_start - game.time, 0.0) * EconomyData.CALL_PER_SECOND), "call")
	_start(current + 1)


## Starts wave `i`: builds its spawn queue (difficulty-scaled counts).
func _start(i: int) -> void:
	current = i
	wave_start = game.time
	next_start = INF
	records[i]["start"] = game.time
	_queue.clear()
	var first_road := game.first_entrance()  # Default road for groups that name none.
	var hp_end := float(game.map.get("wave_hp_end", 0.0))  # The map's last-wave HP multiplier (0 = default).
	var ramp := lerpf(TdRulesData.WAVE_HP_START, hp_end if hp_end > 0.0 else TdRulesData.WAVE_HP_END,
			minf(float(i) / float(maxi(map_waves - 1, 1)), 1.0))  # Wave HP ramp (TdRulesData).
	for g: Dictionary in waves[i]["groups"]:
		var n := DifficultyModifiers.group_count(game.difficulty, int(g["count"]))  # Enemies in this group.
		var sp := float(g.get("spacing", TdRulesData.DEFAULT_SPACING))  # Seconds between two.
		var hp := float(g.get("hp_mult", 1.0)) * ramp  # Extra HP multiplier (wave ramp x Reckoning rows).
		if String(Acts.kinds()[String(g["kind"])]["rank"]) in ["boss", "miniboss"]:
			hp = float(g.get("hp_mult", 1.0))  # Bosses and minibosses keep their row HP (no ramp; DECISIONS X3).
		for k in n:
			_queue.append([float(g.get("delay", 0.0)) + sp * float(k), String(g["kind"]), String(g.get("road", first_road)), hp])
	_queue.sort_custom(func(a: Array, b: Array) -> bool: return float(a[0]) < float(b[0]))
	var text := String(waves[i].get("banner", ""))  # The wave's announcement.
	game.banner(text if text != "" else "Wave %d" % (i + 1))
	if i >= map_waves:
		game.reckoning_wave = i - map_waves + 1
	game.wave_started.emit(i + 1)


## One fixed step: spawns what is due, starts the next wave when its time comes.
func step() -> void:
	if current < 0:
		return
	var t := game.time - wave_start  # Time into the latest wave.
	while not _queue.is_empty() and float(_queue[0][0]) <= t:
		var s: Array = _queue.pop_front()
		game.extra_hp_mult = float(s[3])
		game.spawn_enemy(String(s[1]), String(s[2]), current + 1)
		game.extra_hp_mult = 1.0
		records[current]["alive"] = int(records[current]["alive"]) + 1
		if _queue.is_empty():
			records[current]["spawned_all"] = true
			records[current]["last_spawn"] = game.time
			if game.reckoning and current + 1 >= waves.size():
				_append_reckoning_wave()
			if current + 1 < waves.size():
				next_start = game.time + TdRulesData.AUTO_GAP
	if _queue.is_empty() and game.time >= next_start:
		_start(current + 1)


## An enemy of wave `w` (1-based) left the road (`leaked` = reached the gate).
## Pays the no-leak bonus when the wave's last enemy is gone without a leak.
func enemy_gone(w: int, leaked: bool) -> void:
	if w <= 0:
		return  # Structures belong to no wave.
	var r := records[w - 1]  # The wave's record.
	r["alive"] = int(r["alive"]) - 1
	if leaked:
		r["leaked"] = true
	if bool(r["spawned_all"]) and int(r["alive"]) <= 0 and not bool(r["paid"]):
		r["paid"] = true
		r["cleared"] = game.time
		if not bool(r["leaked"]):
			game.economy.earn(EconomyData.NO_LEAK_BASE + EconomyData.NO_LEAK_PER_WAVE * w, "no_leak")


## Number of waves fully cleared (all their enemies gone).
func cleared_count() -> int:
	var n := 0  # Running count.
	for r: Dictionary in records:
		if float(r["cleared"]) >= 0.0:
			n += 1
	return n


## The kinds and counts of the next wave, [[kind, count], ...] (top bar preview).
func next_preview() -> Array:
	var out: Array = []  # [kind, count] in group order.
	if current + 1 >= waves.size():
		return out
	for g: Dictionary in waves[current + 1]["groups"]:
		out.append([String(g["kind"]), DifficultyModifiers.group_count(game.difficulty, int(g["count"]))])
	return out


## Spawns kind `kind` for the latest wave at distance `dist` px on road
## `road_id` (lateral `lane` px): boss reinforcements, revivals. Counted in
## that wave's record like its own spawns; returns the enemy.
func spawn_extra(kind: String, road_id: String, dist: float, lane: float) -> TdEnemy:
	var w := maxi(current, 0)  # Index of the latest wave.
	var e := game.spawn_at(kind, road_id, w + 1, dist, lane)
	records[w]["alive"] = int(records[w]["alive"]) + 1
	return e


## Starts the Reckoning (GDD §6.2) after the map's last wave: appends its first
## wave and starts it after the usual gap (TdGame.start_reckoning() calls this).
func start_reckoning() -> void:
	_append_reckoning_wave()
	next_start = game.time + TdRulesData.AUTO_GAP


## Appends the next Reckoning wave: one of the map's last
## ReckoningData.RECENT_WAVES non-boss waves, cycled, with more enemies, more
## HP (compounding) and tighter spacing; every MINIBOSS_EVERY waves the map's
## miniboss leads it.
func _append_reckoning_wave() -> void:
	var pool: Array = []  # The map's waves without a boss or miniboss.
	var mini := ""  # The map's miniboss kind.
	for i in map_waves:
		var plain := true  # No boss / miniboss in it.
		for g: Dictionary in waves[i]["groups"]:
			var rank := String(Acts.kinds()[g["kind"]]["rank"])  # Its rank.
			if rank == "miniboss":
				mini = String(g["kind"])
			if rank == "boss" or rank == "miniboss":
				plain = false
		if plain:
			pool.append(waves[i])
	var k := waves.size() - map_waves + 1  # This Reckoning wave's number (1-based).
	var n := mini_i(ReckoningData.RECENT_WAVES, pool.size())  # Waves cycled.
	var base: Dictionary = pool[pool.size() - n + (k - 1) % n]  # The wave it copies.
	var groups: Array = []  # Its escalated groups.
	var hp := pow(ReckoningData.HP_GROWTH, float(k))  # HP multiplier.
	if mini != "" and ReckoningData.MINIBOSS_EVERY > 0 and k % ReckoningData.MINIBOSS_EVERY == 0:
		groups.append({"kind": mini, "count": 1, "hp_mult": hp})
	for g: Dictionary in base["groups"]:
		var c := g.duplicate()  # Escalated copy.
		c["count"] = ceili(float(g["count"]) * (1.0 + ReckoningData.COUNT_GROWTH * float(k)))
		c["spacing"] = float(g.get("spacing", TdRulesData.DEFAULT_SPACING)) * ReckoningData.SPACING_MULT
		c["hp_mult"] = hp
		groups.append(c)
	waves.append({"banner": "Reckoning wave %d" % k, "groups": groups})
	_add_record()


## The smaller of two ints, at least 1.
static func mini_i(a: int, b: int) -> int:
	return maxi(mini(a, b), 1)
