## Demon Brute (Necropathy DemonBruteKit: "four arms, a ground slam, flat
## armour"): every `slam_every`-th blow on the post holding it is the SLAM:
## all four fists come down on every living body of that post within
## `slam_radius` px of it for `slam_damage` (TdCombat.damage_body).
## Args: slam_every (blows), slam_damage, slam_radius (px). vars: "blows".
extends EnemyTrait

const Kit := preload("res://scripts/enemies/traits/inferno/inferno_kit.gd")


func on_attack(e: TdEnemy, game: TdGame, _body: BlockBody) -> void:
	var a: Dictionary = e.row["args"]  # Its numbers.
	e.vars["blows"] = int(e.vars.get("blows", 0)) + 1
	if int(e.vars["blows"]) % int(a["slam_every"]) != 0:
		return
	var rad := float(a["slam_radius"])  # Px.
	for b: BlockBody in Kit.post_bodies(e):
		if b.pos.distance_to(e.position) <= rad + e.radius:
			TdCombat.damage_body(game, b, float(a["slam_damage"]) * e.damage_mult(), e)
	EnemyTrait.note(game, "brute_slams")
	Sfx.play("brute_slam")
	if game.vfx.on:
		game.vfx.add(TdVfx.Kind.ANIM, e.position, float(Acts.data("inferno")["LOOK"]["slam_d"]), 0.45, Color(1.0, 0.6, 0.4), "golem_slam")
		game.vfx.add(TdVfx.Kind.CRACK, e.position, 1.2, TdVfxData.CRACK_TIME, Color.WHITE)
