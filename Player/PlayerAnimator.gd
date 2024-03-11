extends StateAnimator
class_name PlayerAnimator


@onready var playback := self.get("parameters/playback") as AnimationNodeStateMachinePlayback
@onready var weapon := $'%Weapon' as Weapon
@onready var stats := $'../Stats' as PlayerStats

func _ready():
	current_state = playback.get_current_node()


var current_state: StringName

func _process(_delta):
	var new_state := playback.get_current_node()
	if new_state != current_state:
		if new_state in attack_states:
			weapon.activate()
			stats.spend_stamina(40)
		if current_state in attack_states:
			weapon.deactivate()
		if new_state in block_up_states:
			stats.spend_stamina(20)
		is_attack_queued = false
		is_block_queued = false
		current_state = new_state


var is_attack_queued = false
var is_block_queued = false

func request_attack():
	if !stats.can_use_stamina():
		return
	if current_state in action_request_states:
		if current_state == &'Attack1_3a' or current_state == &'Attack2_2a':
			is_attack_queued = true
		elif current_state == &'Attack1_4':
			playback.travel(&'Attack2')
		elif current_state == &'Deflect':
			playback.travel(&'Attack1_2')
		else:
			playback.travel(&'Attack1')


func request_block():
	if current_state in action_request_states:
		if current_state == &'Attack1_3a' or current_state == &'Attack2_2a':
			is_block_queued = true
		else:
			playback.travel(&'Block')
	if current_state in reblock_states:
		playback.start(&'ReBlock')


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

func get_block_state() -> BlockState:
	if current_state == &'Block_a':
		return BlockState.PerfectBlocking
	if current_state == &'Block_b' or current_state == &'Block':
		return BlockState.Blocking
	return BlockState.None


func commit_block(state: BlockState):
	stats.regain_stamina(12 if state == BlockState.Blocking else 30)
	playback.travel(&'Deflect')


const attack_states := {
	&'Attack1_3a': null,
	&'Attack2_2a': null,
}

const block_up_states := {
	&'Block': null,
	&'ReBlock': null,
}
