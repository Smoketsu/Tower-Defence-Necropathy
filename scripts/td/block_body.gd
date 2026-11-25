## BlockBody: one undead body standing on a road post (or one Bone Wall),
## holding up to `capacity` enemies. Damage reaches it only through
## TdCombat.damage_body(); a fallen body returns for free after its respawn
## time (GDD §4.3), driven by the Blocker behaviour.
class_name BlockBody
extends RefCounted

## The RoadBlock it belongs to.
var block: RoadBlock = null
## Map px where the body stands.
var pos: Vector2 = Vector2.ZERO
## Current HP (0 .. max_hp).
var hp: float = 1.0
## Max HP (from the tower's stats).
var max_hp: float = 1.0
## Enemies it holds at once (before the block's hold_bonus).
var capacity: int = 1
## Enemies currently held.
var held: Array[TdEnemy] = []
## False while fallen (waiting for its respawn).
var alive: bool = true
## Seconds a fallen body waits before it returns (from the tower's stats).
var respawn_time: float = 8.0
## Game time (s) at which a fallen body returns.
var respawn_at: float = 0.0
## Game time (s) of its next attack.
var next_attack: float = 0.0
## True for a temporary body (a Lich's Risen): its fall is not counted as a blocker lost.
var temporary: bool = false
## A Bone Colossus body that takes the hits meant for this body (its taunt), or null.
var taunt_by: BlockBody = null
## Game time (s) the taunt lasts (refreshed by the Colossus every step).
var taunt_until: float = 0.0
## Barrier HP absorbed before its own HP (Crypt Warder, Sovereign's Decree;
## TdCombat.barrier_body / damage_body), and the game s it fades (gw2-kit).
var barrier: float = 0.0
## See barrier.
var barrier_until: float = 0.0
## Fraction (0..1) of each hit it ignores (Bone Golem planted; 0 = none).
var damage_cut: float = 0.0
## Game time (s) until which it draws a hit flash (visual only).
var flash_until: float = 0.0
## Drawing only (TdVfx): game s of its last strike and the lunge direction (unit vector).
var vis_strike_at: float = -INF
## See vis_strike_at.
var vis_dir: Vector2 = Vector2.ZERO
## Drawing only: game s it was last hit by a held enemy and the blow's direction (unit vector).
var vis_flinch_at: float = -INF
## See vis_flinch_at.
var vis_flinch_dir: Vector2 = Vector2.ZERO
## Drawing only: game s it last respawned (it climbs out of its bone pile).
var vis_rise_at: float = -INF


## Lets go of every held enemy (they walk on).
func release_all() -> void:
	for e: TdEnemy in held:
		e.holder = null
	held.clear()
