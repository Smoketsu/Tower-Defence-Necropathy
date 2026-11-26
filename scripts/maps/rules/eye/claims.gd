## Claims: Act XI's act rule (GDD §7.3 "Claims: a blocker that dies near a
## claimer rises as a hostile thrall"; Necropathy's EyeClaims). Numbers in
## Acts.data("eye")["RULE"].
##   claims  — a blocker body (not a temporary Risen, not a Bone Wall) that
##             falls within a CLAIMER's reach rises as a Drowned Thrall
##             (RULE thrall_kind) just past its post (game.spawn_from_body()),
##             wearing that body's sprite tinted drowned teal (vars "sprite" /
##             "tint", the one look path), with RULE thrall_hp x the body's max
##             HP (TdCombat.empower_enemy). A claimer is a live enemy whose row
##             args hold "claim_radius" (Chanters, Hierophants, the Grand
##             Hierophant) or one a Scribe has cursed (vars "claimer_until" >
##             now, reach RULE curse_radius). At most RULE max_thralls walk at
##             once. The Thrall's trait (traits/eye/thrall.gd) counts its life
##             down and, killed, pays its souls and ultimate charge back.
##   clouds  — the Pilgrims' spore clouds (add_cloud()): every RULE cloud_tick s
##             each body inside chokes (TdCombat.damage_body, `dps` per s).
## The per-map twist is who claims: Chanters on the Harbour, the Scribes'
## curses in the Archive, the Hierophants and the Grand Hierophant on the Spire.
## The look: EyeLayer (claimer reach discs, curse sigils, spore clouds; drawing
## only) and EyeCue (the HUD cue top-left: claims and Thralls walking), both
## null headless.
extends MapRule

## Spore clouds: [map px, radius px, end game s, damage per s].
var clouds: Array = []
## Game s of the next cloud choke.
var next_cloud: float = 0.0
## Live Thralls: [TdEnemy, generation].
var thralls: Array = []
## Counters for the summary.
var counts: Dictionary = {"claims": 0, "refused": 0, "freed": 0, "slipped": 0, "most": 0, "clouds": 0, "cloud_dmg": 0.0}
## The drawing layer and the HUD cue (null headless).
var layer: Node2D = null
## See layer.
var cue: Control = null


## The RULE numbers.
static func r() -> Dictionary:
	return Acts.data("eye")["RULE"]


## Claims of this run, or null on another act's map (kinds ask).
static func of(game: TdGame) -> MapRule:
	return game.act_rule if game.act_rule != null and game.act_rule.has_method("add_cloud") else null


func setup() -> void:
	if DisplayServer.get_name() == "headless":
		return
	layer = (load("res://scripts/maps/rules/eye/eye_layer.gd") as GDScript).new() as Node2D
	layer.set("rule", self)
	game.world.add_child(layer)
	cue = (load("res://scripts/maps/rules/eye/eye_cue.gd") as GDScript).new() as Control
	cue.set("rule", self)
	game.hud.root.add_child(cue)


## Reach (px) within which `e` claims a fallen body now (0 = not a claimer).
func claim_reach(e: TdEnemy) -> float:
	var rr := float((e.row["args"] as Dictionary).get("claim_radius", 0.0))  # Its own reach.
	if game.time < float(e.vars.get("claimer_until", 0.0)):
		rr = maxf(rr, float(r()["curse_radius"]))
	return rr


## Thralls on the road now (drops the gone ones).
func live_thralls() -> int:
	for i in range(thralls.size() - 1, -1, -1):
		if not TdEnemy.valid(thralls[i][0], int(thralls[i][1])):
			thralls.remove_at(i)
	return thralls.size()


func on_body_fallen(b: BlockBody, _by: TdEnemy) -> void:
	if b.temporary or b.block == null or not game.roads.has(b.block.road_id):
		return
	var claimer: TdEnemy = null  # The nearest claimer in reach.
	for e: TdEnemy in game.enemies:
		var rr := claim_reach(e)  # Its reach (px).
		if rr > 0.0 and e.position.distance_squared_to(b.pos) <= rr * rr:
			claimer = e
			break
	if claimer == null:
		return
	if live_thralls() >= int(r()["max_thralls"]):
		counts["refused"] = int(counts["refused"]) + 1
		return
	var th := game.spawn_from_body(String(r()["thrall_kind"]), b)  # The risen body.
	if th == null:
		return
	var want := maxf(b.max_hp * float(r()["thrall_hp"]), float(th.row["hp"]))  # Its HP.
	TdCombat.empower_enemy(game, th, want / th.max_hp)
	th.vars["sprite"] = _body_sprite(b)
	th.vars["tint"] = r()["thrall_tint"]
	thralls.append([th, th.generation])
	counts["claims"] = int(counts["claims"]) + 1
	counts["most"] = maxi(int(counts["most"]), thralls.size())
	game.fx.spawn("drowned_tendrils", b.pos, float(r()["rise_d"]), 0.6, r()["rise_tint"])
	if game.vfx.on:
		var lk: Dictionary = Acts.data("eye")["LOOK"]
		var f := game.vfx.add(TdVfx.Kind.STREAK, b.pos, float(lk["tentacle_w"]), 0.5, lk["tentacle_tint"])
		if f != null:
			f.ang = (b.pos - claimer.position).angle()
			f.size0 = claimer.position.distance_to(b.pos)
	if int(counts["claims"]) == 1:
		game.banner("The Eye CLAIMS your dead: kill the claimers first, free the Thralls")
	Sfx.play("summon_rise")


## The sprite of the blocker class body `b` belonged to (a Drowned Thrall wears it).
func _body_sprite(b: BlockBody) -> String:
	for t: Tower in game.towers:
		if t.block == b.block:
			return String(t.stats["sprite"])
	return String(Acts.kinds()[String(r()["thrall_kind"])]["sprite"])


## A spore cloud at `pos` (`radius` px) for `life` s, choking bodies for `dps` per s.
func add_cloud(pos: Vector2, radius: float, life: float, dps: float) -> void:
	clouds.append([pos, radius, game.time + life, dps])
	counts["clouds"] = int(counts["clouds"]) + 1


func step(_dt: float) -> void:
	if game.time < next_cloud:
		return
	var tick := float(r()["cloud_tick"])  # s between chokes.
	next_cloud = game.time + tick
	for i in range(clouds.size() - 1, -1, -1):
		var c: Array = clouds[i]
		if game.time >= float(c[2]):
			clouds.remove_at(i)
			continue
		for b: BlockBody in game.bodies_near(c[0], float(c[1])):
			TdCombat.damage_body(game, b, float(c[3]) * tick, null)
			counts["cloud_dmg"] = float(counts["cloud_dmg"]) + float(c[3]) * tick


func summary() -> String:
	var ev: Dictionary = game.stats.get("events", {})  # Trait counters.
	counts["freed"] = int(ev.get("thralls_freed", 0.0))
	counts["slipped"] = int(ev.get("thralls_slipped", 0.0))
	var parts: Array[String] = []
	for k: String in ["claims", "refused", "freed", "slipped", "most", "clouds"]:
		parts.append("%s:%d" % [k, int(counts[k])])
	parts.append("cloud_dmg:%d" % int(counts["cloud_dmg"]))
	for k: String in ["curses", "leaps", "water_lines", "dives", "splits", "songs", "grabs", "ascensions", "ascensions_broken", "arm_slams", "arms_severed"]:
		parts.append("%s:%d" % [k, int(ev.get("eye_" + k, 0.0))])
	return ",".join(parts)
