extends AnimationTree
class_name AnimationIntelligence


@onready var playback := self.get("parameters/playback") as AnimationNodeStateMachinePlayback
@onready var navigation := $'..' as EnemyNavigation

func _ready():
	current_state = playback.get_current_node()
	navigation.reached_player.connect(start_fighting)


var current_state: StringName

func _process(_delta):
	var state := playback.get_current_node()
	if state != current_state:
		if state == &'Think':
			if navigation.can_reach_player():
				roll_attack_state()
			else:
				playback.travel(&'WalkForward')
				navigation.chase_player()
		current_state = state


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
