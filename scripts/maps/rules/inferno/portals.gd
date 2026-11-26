## The Portals: Act IX's act rule (the Inferno; Necropathy's InfernoRules,
## docs/act6/PROPOSAL.md "Shared rules"). Numbers in Acts.data("inferno")["RULE"].
##   portals    — map key "portals": hell portals that tear open at marked
##                points ON the road. Each is marked one wave ahead (a pink
##                ring and a banner), then opens on its wave as a structure
##                (`demon_portal`, the towers can break it) that pours a squad
##                onto the road every `every` s, past the defences upstream,
##                until it burns out after `squads` squads. SEALED at once (a
##                bounty, no squad) while a living blocker or Bone Wall body
##                stands within `seal_radius` px of it: build a post on the mark
##                before it opens, or drop a Bone Wall on it; a Brimstone volley
##                on it seals it too (seal_near()). open_portal() is the one
##                entry for portals opened mid-wave (Pit Cultists, the Morning Star).
##   Hell Pits  — map keys "pits" (map px on the road) and "pits_from" (wave):
##                fixed pits open in turn every `pit_every` s; traits and
##                bosses open more through open_pit() (the one pit path, capped
##                at `pit_max`). A pit glows its rim for its telegraph, then
##                burns: every blocker body in it takes `pit_dps` per s
##                (TdCombat.damage_body) and every damned soul (kind row
##                "damned") `damned_dps` (TdCombat.damage_enemy); demons pass.
##   Temptation — the charm itself is TdCombat.charm_body (a succubus's kiss:
##                the body fights its own post; a Mender heal or a Warder
##                barrier cleanses it); this rule only counts it in its summary.
## The look (InfernoLayer under the units, HellCue on the HUD; nothing
## headless): marks, seal rings, portal swirls, pits. autotest_tap(): the bot
## seals an open portal with Bone Wall or Brimstone when one is ready.
extends MapRule

## Portals: {at: Vector2 mark, road: String, dist: float px along it, wave: int
## (0 = opened mid-wave), squad: Array, every: float s, squads: int left,
## state: "wait" | "marked" | "open" | "sealed" | "broken" | "spent",
## e: TdEnemy (open) and gen: int, next: float game s of its next squad}.
var portals: Array[Dictionary] = []
## Pits: {pos: Vector2, radius: float px, start: float game s it was opened, burn: float game s it starts burning, until: float game s it closes}.
var pits: Array[Dictionary] = []
## Demons waiting to step out of a portal: [game s, kind, road id, dist px, lane px].
var _queue: Array = []
## Game s the next fixed pit opens (INF until "pits_from").
var _next_pit: float = INF
## Index of the next fixed pit (round robin).
var _pit_i: int = 0
## Counters for the summary.
var counts: Dictionary = {"marked": 0, "opened": 0, "sealed": 0, "spell_sealed": 0, "broken": 0, "spent": 0, "squads": 0, "demons": 0, "pits": 0}
## Blocker body damage dealt by the pits (summary).
var pit_body_damage: float = 0.0
## The drawing layer and the HUD cue (null headless).
var layer: Node2D = null
## See layer.
var cue: Control = null


## The RULE numbers.
static func r() -> Dictionary:
	return Acts.data("inferno")["RULE"]


func setup() -> void:
	for p: Dictionary in game.map.get("portals", []):
		_add(p["at"], int(p["wave"]), p["squad"], float(p["every"]), int(p["squads"]))
	if DisplayServer.get_name() == "headless":
		return
	layer = (load("res://scripts/maps/rules/inferno/inferno_layer.gd") as GDScript).new() as Node2D
	layer.set("rule", self)
	game.world.add_child(layer)
	cue = (load("res://scripts/maps/rules/inferno/hell_cue.gd") as GDScript).new() as Control
	cue.call("build", self)
	game.hud.root.add_child(cue)


## Adds portal entry at map px `at` (projected onto the nearest road).
func _add(at: Vector2, wave: int, squad: Array, every: float, squads: int) -> Dictionary:
	var road := game.nearest_road(at, INF)  # The road it opens on.
	var d := road.project(at)  # Px along it.
	var p := {"at": road.point_at(d), "road": road.id, "dist": d, "wave": wave, "squad": squad, "every": every,
		"squads": squads, "state": "wait", "e": null, "gen": 0, "next": 0.0}
	portals.append(p)
	return p


func on_wave_start(n: int) -> void:
	for p: Dictionary in portals:
		if String(p["state"]) == "wait" and int(p["wave"]) == n + 1:
			p["state"] = "marked"
			counts["marked"] = int(counts["marked"]) + 1
			game.banner("A hell portal will tear open on the road: put a post or a Bone Wall on its mark")
		if String(p["state"]) in ["wait", "marked"] and int(p["wave"]) == n:
			_open(p)
	if n == int(game.map.get("pits_from", 999)) and not (game.map.get("pits", []) as Array).is_empty():
		_next_pit = game.time + 1.0
		game.banner("The ground cracks: Hell Pits burn your blockers, and the damned in them")


## Opens portal `p` now, or seals it at once when a body stands on its mark.
func _open(p: Dictionary) -> void:
	if _guarded(p):
		_seal(p, false)  # Barred before it opened: no bounty, no squads.
		return
	game.extra_hp_mult = game.waves.hp_ramp(maxi(game.waves.current, 0))
	var e := game.spawn_at("demon_portal", String(p["road"]), 0, float(p["dist"]), 0.0)
	game.extra_hp_mult = 1.0
	p["state"] = "open"
	p["e"] = e
	p["gen"] = e.generation
	p["next"] = game.time + float(r()["first_squad"])
	counts["opened"] = int(counts["opened"]) + 1
	game.fx.spawn("summon_rise", p["at"], 110.0, 0.6, Acts.data("inferno")["LOOK"]["charm_tint"])
	Sfx.play("portal_open")


## Opens a portal mid-wave at map px `at` (Pit Cultists, the Morning Star):
## the one entry besides the map's schedule. Returns false when sealed at once.
func open_portal(at: Vector2, squad: Array, every: float, squads: int) -> bool:
	var p := _add(at, 0, squad, every, squads)
	_open(p)
	return String(p["state"]) == "open"


## True when a living blocker / Bone Wall body stands within seal_radius of portal `p`.
func _guarded(p: Dictionary) -> bool:
	return game.bodies_near(p["at"], float(r()["seal_radius"])).any(func(b: BlockBody) -> bool: return not b.temporary)  # A Risen does not seal.


## Seals portal `p` (`by_spell`: a Brimstone volley): it closes; an open one pays the bounty.
func _seal(p: Dictionary, by_spell: bool) -> void:
	var e: TdEnemy = p["e"]
	if e != null and TdEnemy.valid(e, int(p["gen"])):
		game.remove_enemy(e, false)
	p["state"] = "sealed"
	p["e"] = null
	counts["sealed"] = int(counts["sealed"]) + 1
	if by_spell:
		counts["spell_sealed"] = int(counts["spell_sealed"]) + 1
	if e != null:
		game.economy.earn(int(r()["seal_souls"]), "seals")  # The bounty: only for closing an open portal.
	game.fx.spawn("bone_wall_burst", p["at"], 110.0, 0.5)
	Sfx.play("portal_seal")


## Seals every open portal within `radius` px of `pos` (Brimstone); returns how many.
func seal_near(pos: Vector2, radius: float) -> int:
	var n := 0  # Portals sealed.
	for p: Dictionary in portals:
		if String(p["state"]) == "open" and Vector2(p["at"]).distance_to(pos) <= radius:
			_seal(p, true)
			n += 1
	return n


## Opens a Hell Pit at `pos` (the one pit path): its rim glows `telegraph` s,
## then it burns `life` s. False when RULE pit_max pits are already open.
func open_pit(pos: Vector2, radius: float, life: float, telegraph: float) -> bool:
	if pits.size() >= int(r()["pit_max"]):
		return false
	pits.append({"pos": pos, "radius": radius, "start": game.time, "burn": game.time + telegraph, "until": game.time + telegraph + life})
	counts["pits"] = int(counts["pits"]) + 1
	Sfx.play("pit_open")
	return true


func step(dt: float) -> void:
	_step_portals()
	while not _queue.is_empty() and game.time >= float(_queue[0][0]):
		var q: Array = _queue.pop_front()
		game.extra_hp_mult = game.waves.hp_ramp(maxi(game.waves.current, 0))
		game.waves.spawn_extra(String(q[1]), String(q[2]), float(q[3]), float(q[4]))
		game.extra_hp_mult = 1.0
		counts["demons"] = int(counts["demons"]) + 1
	_step_pits(dt)
	finish_structures()


## Seals guarded portals, notes broken ones, pours squads, burns spent ones out.
func _step_portals() -> void:
	var rr := r()
	for p: Dictionary in portals:
		if String(p["state"]) != "open":
			continue
		var e: TdEnemy = p["e"]
		if not TdEnemy.valid(e, int(p["gen"])):
			p["state"] = "broken"  # Broken by the towers (it paid its bounty), or cleared at the map's end.
			p["e"] = null
			counts["broken"] = int(counts["broken"]) + 1
			continue
		if _guarded(p):
			_seal(p, false)
			continue
		if game.time < float(p["next"]):
			continue
		if int(p["squads"]) <= 0:
			game.remove_enemy(e, false)
			p["state"] = "spent"
			p["e"] = null
			counts["spent"] = int(counts["spent"]) + 1
			game.fx.spawn("structure_break", p["at"], 90.0, 0.5)
			continue
		p["squads"] = int(p["squads"]) - 1
		p["next"] = game.time + float(p["every"])
		counts["squads"] = int(counts["squads"]) + 1
		var k := 0  # Demons queued so far in this squad.
		for g: Array in p["squad"]:
			for i in int(g[1]):
				var lane := (float(k % 3) - 1.0) * float(rr["squad_lane"])  # Fanned across the road.
				_queue.append([game.time + float(k) * float(rr["squad_gap"]), String(g[0]), String(p["road"]), float(p["dist"]) + 4.0, lane])
				k += 1
		_queue.sort_custom(func(a: Array, b: Array) -> bool: return float(a[0]) < float(b[0]))


## Opens the fixed pits in turn, burns bodies and the damned in burning pits, closes old pits.
func _step_pits(dt: float) -> void:
	var rr := r()
	var fixed: Array = game.map.get("pits", [])
	if game.time >= _next_pit and not fixed.is_empty():
		_next_pit = game.time + float(rr["pit_every"])
		open_pit(fixed[_pit_i % fixed.size()], float(rr["pit_radius"]), float(rr["pit_life"]), float(rr["pit_telegraph"]))
		_pit_i += 1
	for i in range(pits.size() - 1, -1, -1):
		var pit: Dictionary = pits[i]
		if game.time >= float(pit["until"]):
			pits.remove_at(i)
			continue
		if game.time < float(pit["burn"]):
			continue
		var rad := float(pit["radius"])  # Px.
		for b: BlockBody in game.bodies_near(pit["pos"], rad):
			if b.max_hp == INF:
				continue  # A Bone Wall does not burn.
			TdCombat.damage_body(game, b, float(rr["pit_dps"]) * dt)
			pit_body_damage += float(rr["pit_dps"]) * dt
		for e: TdEnemy in game.foes_near(pit["pos"], rad):
			if bool(e.row.get("damned", false)) and not bool(e.row.get("flying", false)):
				TdCombat.damage_enemy(game, e, float(rr["damned_dps"]) * dt, {"source": "hell_pit", "dot": true})
				e.vis_field_until = game.time + 0.2
				e.vis_field_look = "flame"


## The autotest bot's tap policy: seal an open portal with a ready Bone Wall or Brimstone.
func autotest_tap() -> void:
	for p: Dictionary in portals:
		if String(p["state"]) != "open":
			continue
		for i in game.caster.loadout.size():
			if game.caster.loadout[i] in ["bone_wall", "brimstone"] and game.caster.is_ready(i):
				game.cast_spell(i, p["at"])
				return


## Open portals now (the HUD cue).
func open_count() -> int:
	return portals.filter(func(p: Dictionary) -> bool: return String(p["state"]) == "open").size()


## Wave (1-based) of the next scheduled portal still to open, or 0.
func next_wave() -> int:
	for p: Dictionary in portals:
		if String(p["state"]) in ["wait", "marked"] and int(p["wave"]) > 0:
			return int(p["wave"])
	return 0


func summary() -> String:
	return "portals=marked:%d opened:%d sealed:%d spell_sealed:%d broken:%d spent:%d squads:%d demons:%d pits=%d pit_body_damage=%d charms=%d cleansed=%d" % [
		int(counts["marked"]), int(counts["opened"]), int(counts["sealed"]), int(counts["spell_sealed"]), int(counts["broken"]),
		int(counts["spent"]), int(counts["squads"]), int(counts["demons"]), int(counts["pits"]), int(pit_body_damage),
		int(game.stats.get("events", {}).get("bodies_charmed", 0)), int(game.stats.get("events", {}).get("charms_cleansed", 0))]
