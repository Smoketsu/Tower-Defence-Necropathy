## Line of Fire: Act XII's act rule (GDD §7.3 "ranged enemies shoot towers;
## blockers and Bone Walls stop the shots"; Necropathy's EmpireShots and
## LockOn, docs/act3/). Numbers in Acts.data("empire")["RULE"].
##   shots    — about 60% of the Empire's kinds shoot towers from the road
##              (generic `shooter`, empire/* traits) through the one hostile-fire
##              path game.hostile.fire(): a hit disables the tower for a moment
##              (TdCombat.disable_tower(), towers have no HP); a straight shot
##              stops on the first blocker / Bone Wall / Risen body on its path.
##              The answer is placement: posts in front of plots.
##   Lock-On  — Spotters, Kestrel, Deus Ex Machina and Valkyrie 2.0 PAINT a tower
##              (paint(): a red line from the shooter to it, `lock_time` s), then
##              fire a heavy shot down it. At most `lock_cap` paints at once
##              (bosses ignore the cap). A shooter killed, frozen or staggered
##              while painting loses its lock (counted "broken").
## The look: EmpireLayer (the painted lines and their reticles, drawing only)
## and EmpireDial (the HUD cue in the top-left corner: shots stopped of shots
## fired, paints live), both null headless.
extends MapRule

## Paints live: {e: TdEnemy, gen: int (its generation), t: Tower, at: game s the
## shot fires, born: game s painted, args: Dictionary (HostileFire.fire args)}.
var locks: Array[Dictionary] = []
## Counters for the summary.
var counts: Dictionary = {"painted": 0, "fired": 0, "broken": 0, "capped": 0}
## The drawing layer and the HUD dial (null headless).
var layer: Node2D = null
## See layer.
var dial: Control = null


## The RULE numbers.
static func r() -> Dictionary:
	return Acts.data("empire")["RULE"]


## Line of Fire of this run, or null on another act's map.
static func of(game: TdGame) -> MapRule:
	return game.act_rule if game.act_rule != null and game.act_rule.has_method("paint") else null


func setup() -> void:
	if DisplayServer.get_name() == "headless":
		return
	layer = (load("res://scripts/maps/rules/empire/empire_layer.gd") as GDScript).new() as Node2D
	layer.set("rule", self)
	game.world.add_child(layer)
	dial = (load("res://scripts/maps/rules/empire/empire_dial.gd") as GDScript).new() as Control
	dial.set("rule", self)
	game.hud.root.add_child(dial)


func on_wave_start(n: int) -> void:
	if n == 1:
		game.banner(String(r()["banner"]))


## Paints tower `t` from enemy `e`; `args` fire down the line `lock_time` s
## later. `boss` ignores the cap. Returns false when the cap refused it.
func paint(e: TdEnemy, t: Tower, args: Dictionary, boss: bool = false) -> bool:
	if not boss and locks.size() >= int(r()["lock_cap"]):
		counts["capped"] = int(counts["capped"]) + 1
		return false
	locks.append({"e": e, "gen": e.generation, "t": t, "at": game.time + float(r()["lock_time"]), "born": game.time, "args": args})
	counts["painted"] = int(counts["painted"]) + 1
	Sfx.play("lock_on")
	return true


func step(_dt: float) -> void:
	for i in range(locks.size() - 1, -1, -1):
		var lk: Dictionary = locks[i]
		var e: TdEnemy = lk["e"]
		var t: Tower = lk["t"]
		var ok := TdEnemy.valid(e, int(lk["gen"])) and game.time >= e.freeze_until and game.time >= e.staggered_until
		if not (is_instance_valid(t) and game.towers.has(t)):
			locks.remove_at(i)
			continue
		if not ok:
			counts["broken"] = int(counts["broken"]) + 1
			locks.remove_at(i)
			continue
		if game.time < float(lk["at"]):
			continue
		locks.remove_at(i)
		if game.hostile.fire(e.position + Vector2(0, -14), t, lk["args"]):
			counts["fired"] = int(counts["fired"]) + 1
			e.vis_strike_at = game.time
			e.vis_strike_dir = (t.position - e.position).normalized()
			Sfx.play("rail_shot")


func summary() -> String:
	var keys := counts.keys()  # Sorted for a stable line.
	keys.sort()
	var parts: Array[String] = []
	for k: Variant in keys:
		parts.append("lock_%s:%d" % [k, int(counts[k])])
	var hc: Dictionary = game.hostile.counts
	var shots := int(hc["blocked"]) + int(hc["hit_tower"]) + int(hc["hit_body"])  # Shots that landed somewhere.
	parts.append("stopped_share:%.2f" % (float(hc["blocked"]) / float(maxi(shots, 1))))
	return ",".join(parts)
