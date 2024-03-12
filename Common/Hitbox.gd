extends Area3D
class_name Hitbox

enum AttackEffect {
	Hurt,
	Parried,
	PerfectParried,
}

@export var state_animator: StateAnimator
@onready var parent := $'..' as Node3D
@onready var weapon := $'%Weapon' as Weapon
const block_threshold := 0.9
@onready var blood_splatter := $Blood as GPUParticles3D
@onready var stats := $'../Stats' as Stats


func _ready():
	stats.died.connect(disable)
	stats.respawned.connect(enable)


func attack(damage: float, attacker: Node3D) -> AttackEffect:
	var block_state = state_animator.get_block_state()
	if block_state != StateAnimator.BlockState.None:
		state_animator.commit_block(block_state)
		if get_dot_to(attacker) >= block_threshold:
			if block_state == StateAnimator.BlockState.PerfectBlocking:
				weapon.big_spark()
				return AttackEffect.PerfectParried
			if block_state == StateAnimator.BlockState.Blocking:
				weapon.spark()
				return AttackEffect.Parried
	stats.lose_health(damage)
	notify_hurt.emit(damage)
	blood_splatter.emitting = true
	return AttackEffect.Hurt

func get_dot_to(target: Node3D) -> float:
	var forward_position: = parent.basis * Vector3.FORWARD
	forward_position.y = 0
	var target_position: = target.global_position - global_position
	target_position.y = 0
	return forward_position.dot(target_position.normalized())


signal notify_hurt(damage: float)


func disable():
	set_deferred('monitorable', false)


func enable():
	monitorable = true
