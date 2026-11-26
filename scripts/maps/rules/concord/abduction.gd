## Abduction: Act XIII's act rule (GDD §7.3 names no gimmick for the Concord;
## lead's choice, DECISIONS T13; Necropathy's Abduction / Saucer kit, the
## Harvesters' tractor beams). Numbers in Acts.data("concord")["RULE"] (its
## "maps" row for this map).
##   flights — from wave `first` on, every `every` s a flight of saucers
##             (RULE kind) crosses the map on one of its sky lanes (map roads
##             with "sky", "off_road" and "exit"; `lanes` cycled), `per` saucers
##             a flight by wave, `gap` s apart, spawned at the wave's HP
##             (WaveDirector.hp_ramp()). The HUD cue counts the next flight down
##             `warn` s ahead. Flights stop once every wave has spawned.
##   the lift — each saucer's own trait (traits/concord/saucer.gd) stops it
##             over the strongest post or plot in its reach, grows a light cone
##             for its windup and LIFTS it: a blocker body is taken (it comes
##             back by its normal respawn), a plot tower is lifted out of the
##             fight (TdCombat.disable_tower(), cause "abducted"). Shooting the
##             saucer down while it hovers (any tower that hits flyers, any
##             spell) cancels the lift. The Harvester's reap emitters use the
##             same trait standing still.
## The look: ConcordLayer (sky lanes, cones, lifted columns, burrow mounds;
## drawing only) and ConcordCue (the HUD cue, top-right), both null headless.
extends MapRule

## This map's RULE "maps" row.
var cfg: Dictionary = {}
## Wave now (1-based; 0 before the first).
var wave: int = 0
## Game s of the next flight (INF until wave `first`).
var next_flight: float = INF
## Flights sent so far (cycles the lanes).
var flights: int = 0
## Saucers waiting to take off: [game s, lane road id].
var queue: Array = []
## Towers lifted out of the fight and the game s they come back (drawn: the column).
var lifted: Array = []
## Counters for the summary.
var counts: Dictionary = {"flights": 0, "saucers": 0, "lift_towers": 0, "lift_bodies": 0, "downed": 0, "downed_beaming": 0, "cancelled": 0, "escaped": 0}
## The drawing layer and the HUD cue (null headless).
var layer: Node2D = null
## See layer.
var cue: Control = null


## The RULE numbers.
static func r() -> Dictionary:
	return Acts.data("concord")["RULE"]


## The Abduction rule of this run, or null on another act's map (kinds ask).
static func of(game: TdGame) -> MapRule:
	return game.act_rule if game.act_rule != null and game.act_rule.has_method("call_saucers") else null


func setup() -> void:
	cfg = r()["maps"].get(game.map_id, r()["maps"]["crash_site"])
	if DisplayServer.get_name() == "headless":
		return
	layer = (load("res://scripts/maps/rules/concord/concord_layer.gd") as GDScript).new() as Node2D
	layer.set("rule", self)
	game.world.add_child(layer)
	cue = (load("res://scripts/maps/rules/concord/concord_cue.gd") as GDScript).new() as Control
	cue.set("rule", self)
	game.hud.root.add_child(cue)


func on_wave_start(n: int) -> void:
	wave = n
	if n >= int(cfg["first"]) and next_flight == INF:
		next_flight = game.time + float(r()["warn"])
		game.banner("Saucers inbound: they lift what they hover over. Shoot them down while they beam")


## Saucers a flight sends at the wave now.
func per_flight() -> int:
	var n := 0  # The last row reached.
	for row: Array in cfg["per"]:
		if wave >= int(row[0]):
			n = int(row[1])
	return n


## Queues a flight of `n` saucers now on the next lane (the Harvester's Gardener calls it too).
func call_saucers(n: int) -> void:
	var lanes: Array = cfg["lanes"]
	var lane := String(lanes[flights % lanes.size()])  # This flight's sky lane.
	flights += 1
	counts["flights"] = int(counts["flights"]) + 1
	for i in n:
		queue.append([game.time + float(cfg["gap"]) * float(i), lane])
	Sfx.play("saucer_down")


func step(_dt: float) -> void:
	if game.time >= next_flight:
		if game.waves.all_spawned():
			next_flight = INF
		else:
			next_flight = game.time + float(cfg["every"])
			call_saucers(per_flight())
	for i in range(queue.size() - 1, -1, -1):
		if game.time >= float(queue[i][0]):
			var lane := String(queue[i][1])
			queue.remove_at(i)
			game.extra_hp_mult = game.waves.hp_ramp(maxi(game.waves.current, 0))
			game.waves.spawn_extra(String(r()["kind"]), lane, 0.0, 0.0)
			game.extra_hp_mult = 1.0
			counts["saucers"] = int(counts["saucers"]) + 1
	for i in range(lifted.size() - 1, -1, -1):
		if game.time >= float(lifted[i][1]) or not is_instance_valid(lifted[i][0]):
			lifted.remove_at(i)


## A saucer (or reap emitter) lifted tower `t` for `time` s (a plot tower) or took a body of it (`body`).
func note_lift(t: Tower, body: bool, time: float) -> void:
	if body:
		counts["lift_bodies"] = int(counts["lift_bodies"]) + 1
	else:
		counts["lift_towers"] = int(counts["lift_towers"]) + 1
		lifted.append([t, game.time + time])


## A beam was cut off before it lifted (its saucer frozen, staggered or its target gone).
func note_cancel() -> void:
	counts["cancelled"] = int(counts["cancelled"]) + 1


func on_kill(e: TdEnemy, _tower: Tower) -> void:
	if e.kind != String(r()["kind"]):
		return
	counts["downed"] = int(counts["downed"]) + 1
	if float(e.vars.get("beam_at", 0.0)) > 0.0:
		counts["downed_beaming"] = int(counts["downed_beaming"]) + 1
		Sfx.play("saucer_down")


## Saucers in the sky now, and how many of them are beaming.
func overhead() -> Vector2i:
	var n := 0  # Saucers alive.
	var b := 0  # Beaming.
	for e: TdEnemy in game.enemies:
		if e.kind == String(r()["kind"]):
			n += 1
			b += 1 if float(e.vars.get("beam_at", 0.0)) > 0.0 else 0
	return Vector2i(n, b)


func summary() -> String:
	counts["escaped"] = int(game.stats.get("events", {}).get("crossed", 0))
	var keys := counts.keys()  # Sorted for a stable line.
	keys.sort()
	var parts: Array[String] = []
	for k: Variant in keys:
		parts.append("%s:%d" % [k, int(counts[k])])
	return ",".join(parts)
