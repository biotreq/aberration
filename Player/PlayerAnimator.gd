extends AnimationTree
class_name PlayerAnimator


@onready var playback := self.get("parameters/playback") as AnimationNodeStateMachinePlayback
@onready var weapon := $'%Weapon' as Weapon

func _ready():
	current_state = playback.get_current_node()


var current_state: StringName

func _process(_delta):
	var new_state := playback.get_current_node()
	if new_state != current_state:
		is_attack_queued = false
		is_block_queued = false
		current_state = new_state


var is_attack_queued = false
var is_block_queued = false

func request_attack():
	if current_state in action_request_states:
		if current_state == &'Attack1_3a' or current_state == &'Attack2_2a':
			is_attack_queued = true
		elif current_state == &'Attack1_4':
			playback.travel(&'Attack2')
		else:
			playback.travel(&'Attack1')


func request_block():
	if current_state in action_request_states:
		if current_state == &'Attack1_3a' or current_state == &'Attack2_2a':
			is_block_queued = true
		elif current_state in reblock_states:
			playback.travel(&'ReBlock')
		else:
			playback.travel(&'Block')


const action_request_states := {
	&'Idle': null,
	&'Block_release': null,
	&'Attack1_4': null,
	&'Attack1_3a': null,
	&'Attack2_3': null,
	&'Attack2_2a': null,
	&'Deflect': null,
}

const reblock_states := {
	&'Block_release': null,
	&'Attack1_4': null,
	&'Attack2_3': null,
	&'Deflect': null,
	&'Attack1': null,
	&'Attack2': null,
}
