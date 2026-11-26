## The Voice (Empyrean boss, the end of Part Two; Necropathy's BossVoice, a
## six-winged seraph of light). It NEVER MOVES: it stands `stand_dist` px down
## its road (row speed 0) at the heart of the rose, and the map ends when it
## falls.
##   the Holy        — while it lives the Light is at its strongest: shafts x
##                     `holy_width` wide and `holy_live` more at once (the act
##                     rule's boss_width / boss_live).
##   Be Not Afraid   — every `fear_every` s (first after `fear_first`) it lowers
##                     the wings from its face (pose 1) for `fear_warn` s, then
##                     every tower NOT in shade (a cloud bank, a Warder's or a
##                     Bound Ophan's) is stunned `fear_stun` s
##                     (TdCombat.disable_tower, cause "blinded").
##   the Last Word   — every `word_every` s (first after `word_first`) the
##                     scales read the run's sins back: the act rule sends
##                     judges_due(`word_cap`) Judges (at least `word_min`), for
##                     at most `word_waves` waves.
##   the choir       — every `choir_every` s it calls `choir` ([kind, count]
##                     rows) behind it on its road, `choir_gap` px apart.
## Args in its row. vars: "next_fear", "fear_at", "next_word", "words",
## "next_choir", "pose_until" (game s).
extends EnemyTrait

const Light := preload("res://scripts/maps/rules/host/hallowed_light.gd")


func on_spawn(e: TdEnemy, game: TdGame) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.follower.advance(minf(float(a["stand_dist"]), e.follower.road.length - 1.0))
	e.position = e.follower.position()
	e.last_dist = e.follower.dist
	e.vars["next_fear"] = game.time + float(a["fear_first"])
	e.vars["fear_at"] = 0.0
	e.vars["next_word"] = game.time + float(a["word_first"])
	e.vars["words"] = 0
	e.vars["next_choir"] = game.time + float(a["choir_every"])
	var rule := Light.of(game)  # The Hallowed Light (null off-act).
	if rule != null:
		rule.set("boss_width", float(a["holy_width"]))
		rule.set("boss_live", int(a["holy_live"]))
	game.banner("The Voice: the Holy floods the rose with light")


func step(e: TdEnemy, game: TdGame, _dt: float) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	var rule := Light.of(game)  # The Hallowed Light (null off-act).
	var at := float(e.vars["fear_at"])
	if at > 0.0:
		if game.time >= at:
			e.vars["fear_at"] = 0.0
			_fear(e, game, a, rule)
		return
	if game.time >= float(e.vars["next_fear"]):
		e.vars["next_fear"] = game.time + float(a["fear_every"])
		e.vars["fear_at"] = game.time + float(a["fear_warn"])
		e.pose = 1
		e.body.queue_redraw()
		game.banner("Be Not Afraid: the Voice unveils! Only towers in shade will stand")
	if rule != null and int(e.vars["words"]) < int(a["word_waves"]) and game.time >= float(e.vars["next_word"]):
		e.vars["next_word"] = game.time + float(a["word_every"])
		e.vars["words"] = int(e.vars["words"]) + 1
		var n := maxi(int(rule.call("judges_due", int(a["word_cap"]))), int(a["word_min"]))  # Judges this word.
		rule.call("send_judges", n)
		game.banner("The Last Word: %d Judges descend" % n)
		EnemyTrait.note(game, "voice_words")
	if game.time >= float(e.vars["next_choir"]):
		e.vars["next_choir"] = game.time + float(a["choir_every"])
		var k := 0  # Units placed.
		for g: Array in a["choir"]:
			for j in int(g[1]):
				k += 1
				game.waves.spawn_extra(String(g[0]), e.follower.road.id, maxf(e.follower.dist - float(a["choir_gap"]) * float(k), 0.0), float(k % 3 - 1) * 8.0)
		EnemyTrait.note(game, "voice_choirs")


## Be Not Afraid lands: every tower out of the shade is stunned.
func _fear(e: TdEnemy, game: TdGame, a: Dictionary, rule: MapRule) -> void:
	e.pose = 0
	e.body.queue_redraw()
	var n := 0  # Towers stunned.
	for t: Tower in game.towers.duplicate():
		if rule != null and bool(rule.call("shaded", t.position)):
			continue
		TdCombat.disable_tower(game, t, float(a["fear_stun"]), "blinded")
		n += 1
	game.fx.spawn("holy_impact", e.position, 260.0, 0.7, Acts.data("host")["LOOK"]["fear_tint"])
	game.vfx.shake(3.0)
	EnemyTrait.note(game, "voice_fears")
	EnemyTrait.note(game, "voice_fear_stuns", float(n))
	Sfx.play("verdict")


func on_death(_e: TdEnemy, game: TdGame) -> void:
	var rule := Light.of(game)
	if rule != null:
		rule.set("boss_width", 1.0)
		rule.set("boss_live", 0)
	game.banner("The Voice falls silent. Heaven, earth and hell answer to the necromancer")
