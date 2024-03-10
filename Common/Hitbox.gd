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

func attack(damage: float, attacker: Node3D) -> AttackEffect:
	var block_state = state_animator.get_block_state()
	if block_state != StateAnimator.BlockState.None:
		state_animator.commit_block()
		if get_dot_to(attacker) >= block_threshold:
			if block_state == StateAnimator.BlockState.PerfectBlocking:
				weapon.big_spark()
				return AttackEffect.PerfectParried
			if block_state == StateAnimator.BlockState.Blocking:
				weapon.spark()
				return AttackEffect.Parried
	print('hurt for ', damage)
	notify_hurt.emit()
	blood_splatter.emitting = true
	return AttackEffect.Hurt

func get_dot_to(target: Node3D) -> float:
	var forward_position: = parent.basis * Vector3.FORWARD
	forward_position.y = 0
	var target_position: = target.global_position - global_position
	target_position.y = 0
	return forward_position.dot(target_position.normalized())


signal notify_hurt()
