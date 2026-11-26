## The Barrow-Wight (Barrow Fields miniboss; Necropathy's BarrowWightKit: "a
## draugr chieftain whose howl stuns the ring for 1 s; the howl cracks open
## barrows"). Every `howl_every` s (first after `howl_first`) he throws back his
## head for `windup` s (he stands, a frost ring grows: the telegraph, his cast
## pose) and howls: every tower within `radius` px is stunned `stun` s
## (TdCombat.disable_tower, cause "frozen"), every blocker body there loses its
## next strike for `stun` s (BlockBody.next_attack), and the howl cracks open
## the barrows behind him: `call_count` draugr of `call_kind` rise on his road,
## `call_gap` px apart behind him (WaveDirector.spawn_extra()). His blows chill
## like a draugr's. Args in his row. vars: "next_howl", "howl_at", "pose_until".
extends EnemyTrait


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	e.vars["next_howl"] = game.time + float(e.row["args"]["howl_first"])
	e.vars["pose_until"] = 0.0


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # His numbers.
	if e.pose != 0 and game.time >= float(e.vars["pose_until"]) and not e.vars.has("howl_at"):
		e.pose = 0
		e.body.queue_redraw()
	if e.vars.has("howl_at"):
		e.freeze_until = maxf(e.freeze_until, game.time + 0.05)  # He stands while he draws breath.
		if game.time < float(e.vars["howl_at"]):
			return
		e.vars.erase("howl_at")
		howl(e, game, float(a["radius"]), float(a["stun"]))
		var lk: Dictionary = Acts.data("norse")["LOOK"]
		for i in int(a["call_count"]):
			var d := maxf(e.follower.dist - float(a["call_gap"]) * float(i + 1), 0.0)  # Px along his road.
			var c := game.waves.spawn_extra(String(a["call_kind"]), e.follower.road.id, d, e.follower.lane + float(i % 2 * 2 - 1) * 8.0)
			game.fx.spawn("summon_rise", c.position, 60.0, 0.5, lk["barrow_tint"])
		EnemyTrait.note(game, "wight_howls")
		return
	if game.time < float(e.vars["next_howl"]) or game.time < e.freeze_until:
		return
	e.vars["next_howl"] = game.time + float(a["howl_every"])
	e.vars["howl_at"] = game.time + float(a["windup"])
	e.pose = 1
	e.vars["pose_until"] = game.time + float(a["windup"]) + float(a["pose_time"])
	e.body.queue_redraw()
	if game.vfx.on:
		var ring := game.vfx.add(TdVfx.Kind.RING, e.position, float(a["radius"]), float(a["windup"]), Acts.data("norse")["LOOK"]["howl_tint"])
		if ring != null:
			ring.size0 = float(a["radius"]) * 0.2
	Sfx.play("boss_telegraph")


## The howl at `e`: towers within `radius` px stunned `stun` s (cause "frozen"),
## bodies there lose their next strike for `stun` s. Hrimgar reuses it.
static func howl(e: TdEnemy, game: TdGame, radius: float, stun: float) -> void:
	for t: Tower in game.towers.duplicate():
		if t.position.distance_to(e.position) <= radius:
			TdCombat.disable_tower(game, t, stun, "frozen")
	for b: BlockBody in game.bodies_near(e.position, radius):
		b.next_attack = maxf(b.next_attack, game.time + stun)
	Sfx.play("banshee_wail")
	if game.vfx.on:
		game.fx.spawn("frost_nova", e.position, radius * 2.0, 0.7, Acts.data("norse")["LOOK"]["howl_tint"])
		game.vfx.shake(3.0)


func on_attack(e: TdEnemy, game: TdGame, body: BlockBody) -> void:
	if body != null and body.alive:
		body.next_attack = maxf(body.next_attack, game.time) + 0.6
