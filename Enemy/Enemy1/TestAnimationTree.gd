extends AnimationTree


@onready var playback := self.get("parameters/playback") as AnimationNodeStateMachinePlayback

func _ready():
#	var animation_player := $'../badguy/AnimationPlayer' as AnimationPlayer
	current_state = playback.get_current_node()


var current_state: StringName

func _process(_delta):
	var state := playback.get_current_node()
	if state != current_state:
		current_state = state
		print(state)
		if state == &'Combo1':
			print('AAAAAA')
