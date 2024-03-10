extends AnimationTree
class_name AnimationIntelligence


@onready var playback := self.get("parameters/playback") as AnimationNodeStateMachinePlayback
@onready var navigation := $'..' as EnemyNavigation
@onready var weapon := $'%Weapon' as Weapon

func _ready():
	current_state = playback.get_current_node()
	navigation.reached_player.connect(start_fighting)


var current_state: StringName
var active_attack_states := {
	&'Combo1_2a': null,
	&'Combo1_4a': null,
	&'Combo2_2a': null,
	&'Combo2_4a': null,
	&'Counter_2a': null,
}

func _process(_delta):
	var new_state := playback.get_current_node()
	if new_state != current_state:
		if new_state == &'Think':
			if navigation.can_reach_player():
				roll_attack_state()
			else:
				playback.travel(&'WalkForward')
				navigation.chase_player()
		if new_state in active_attack_states:
			weapon.activate()
		if current_state in active_attack_states:
			weapon.deactivate()
		current_state = new_state


func start():
	active = true


func activate():
	playback.travel(&'Activate')


func start_fighting():
	roll_attack_state()


var attack_states := [&'Combo1', &'Combo2']

func roll_attack_state():
	if randf() > 0.8:
		playback.travel(&'FightIdle')
	else:
		playback.travel(attack_states.pick_random())
