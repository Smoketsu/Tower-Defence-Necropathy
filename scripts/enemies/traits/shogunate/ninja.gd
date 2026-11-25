## From the Shadows (Ninja; Necropathy's ShadowAmbush, GDD §7.3 Act V): from
## dusk on a ninja does not walk in from the entrance; it appears mid-road at
## the Sun's Course's next ambush point (map key "ambush") after a smoke puff.
## While it walks it douses the first lit stone lantern it passes within
## `douse_radius` px (the act rule's douse_near(); one per ninja). By day it
## walks in like any soldier. vars: "doused" (true once it put one out).
## Args: douse_radius (px). The kunoichi extends it.
extends EnemyTrait


## The Sun's Course of this run, or null on another act's map.
static func sun(game: TdGame) -> MapRule:
	return game.act_rule if game.act_rule != null and game.act_rule.has_method("douse_near") else null


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var s := sun(game)  # The act rule.
	if s == null:
		return
	var pt: Array = s.call("ambush_point")  # [road id, px] or [].
	if pt.is_empty() or not game.roads.has(String(pt[0])):
		return
	var r: Road = game.roads[String(pt[0])]
	e.follower.setup(game.roads, r, minf(float(pt[1]), r.length - 1.0), e.follower.lane)
	e.position = e.follower.position()
	e.last_dist = e.follower.dist
	EnemyTrait.note(game, "ninja_ambushes")
	game.fx.spawn("spore_cloud", e.position, float(Acts.data("shogunate")["LOOK"]["smoke_puff"]), 0.6, Acts.data("shogunate")["LOOK"]["smoke_tint"])
	Sfx.play("smoke_puff")


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var s := sun(game)  # The act rule.
	if s != null and not e.vars.has("doused") and int(s.call("douse_near", e.position, float(e.row["args"]["douse_radius"]))) > 0:
		e.vars["doused"] = true
