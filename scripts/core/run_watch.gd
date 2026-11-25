## RunWatch: watches a map run for the permanent records (GDD §8.2, §8.3):
## the Codex entries it meets (the spells brought, every tower raised, every
## enemy kind and boss whose wave starts, every evolution reached) and the
## Masteries it opens (a class at MetaData.MASTERY_LEVEL). It only reads the
## run through its signals and writes Meta (saved with the run's record);
## never added under the autotest unless --meta-save.
class_name RunWatch
extends Node

## The run watched.
var game: TdGame = null


func _ready() -> void:
	for id: String in game.caster.loadout:
		Meta.see("spells", id)
	game.changed.connect(_on_changed)
	game.wave_started.connect(_on_wave)


## Towers, evolutions and masteries after any change.
func _on_changed() -> void:
	for t: Tower in game.towers:
		Meta.see("towers", t.tower_id)
		if t.evolution != "":
			Meta.see("evolutions", t.evolution)
		if t.level >= MetaData.MASTERY_LEVEL and Meta.open_mastery(t.tower_id):
			game.banner("Mastery: %s" % String(t.row["name"]))


## Wave `n` (1-based) started: its enemy kinds are met.
func _on_wave(n: int) -> void:
	if n - 1 >= (game.map["waves"] as Array).size():
		return
	for g: Dictionary in game.map["waves"][n - 1]["groups"]:
		var kind := String(g["kind"])  # The group's kind.
		var rank := String(TdEnemyData.KINDS[kind]["rank"]) if TdEnemyData.KINDS.has(kind) else "fodder"
		Meta.see("bosses" if rank == "boss" else "enemies", kind)
