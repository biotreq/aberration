extends AnimationIntelligence

func _ready():
	super._ready()
	active_attack_states = {
		&'Combo1_2a': null,
		&'Combo1_4a': null,
		&'Combo2_2a': null,
		&'Combo2_4a': null,
		&'Combo3_2a': null,
		&'Combo3_4a': null,
	}
	parry_tendency = -1.0
	attack_states = [&'Combo1', &'Combo2', &'Combo3']


func roll_attack_state():
	playback.travel(attack_states.pick_random())


func receive_attack(_damage: float):
	poise -= attack_poise_loss
