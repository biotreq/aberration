extends StateAnimator
class_name AnimationIntelligence


@onready var playback := self.get("parameters/playback") as AnimationNodeStateMachinePlayback
@onready var navigation := $'..' as EnemyNavigation
@onready var weapon := $'%Weapon' as Weapon
@onready var hitbox := $'../Hitbox' as Hitbox
@onready var stats := $'../Stats' as Stats
const parry_tendency := 0.25

func _ready():
	current_state = playback.get_current_node()
	navigation.reached_player.connect(start_fighting)
	weapon.notify_attack_effect.connect(complete_attack)
	hitbox.notify_hurt.connect(receive_attack)
	stats.died.connect(die)


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
				if current_state in hurt_states and randf() <= parry_tendency:
					playback.start(&'Block')
				else:
					roll_attack_state()
			else:
				playback.travel(&'WalkForward')
				navigation.chase_player()
		if new_state in active_attack_states:
			weapon.activate()
		if current_state in active_attack_states:
			weapon.deactivate()
		if new_state == &'Dead':
			navigation.queue_free()
		current_state = new_state


func start():
	active = true


func activate():
	playback.travel(&'Activate')


func start_fighting():
	roll_attack_state()


var attack_states := [&'Combo1', &'Combo2']

func roll_attack_state():
	if randf() > 0.9:
		playback.travel(&'FightIdle')
	else:
		playback.travel(attack_states.pick_random())

func get_block_state() -> BlockState:
	if current_state == &'Block_2a':
		return BlockState.Blocking
	return BlockState.None


func complete_attack(effect: Hitbox.AttackEffect):
	if effect == Hitbox.AttackEffect.Parried:
		poise -= block_poise_loss
		# only poisebreak on perfect parry
	if effect == Hitbox.AttackEffect.PerfectParried:
		poise -= parry_poise_loss
		if poise <= 0:
			poise = max_poise
			playback.start(&'ParryStun')


func receive_attack(_damage: float):
	poise -= attack_poise_loss
	if poise <= 0:
		poise = max_poise
		playback.start(&'HitStun')
		return
	if (
		current_state in hurt_states
		or current_state in active_attack_states
	):
		return
	if !is_in_hurt_grace_period():
		playback.start(&'Hurt')
		last_staggered_at = Time.get_ticks_msec()


func commit_block():
	playback.start(&'Counter')


var last_staggered_at := 0

func is_in_hurt_grace_period():
	return Time.get_ticks_msec() <= last_staggered_at + 1500


const hurt_states := {
	&'Hurt': null,
	&'HitStun': null,
	&'ParryStun': null,
}


const max_poise := 15
var poise := max_poise
const attack_poise_loss := 2
const parry_poise_loss := 3
const block_poise_loss := 1


func die():
	playback.start(&'Die')
	hitbox.notify_hurt.disconnect(receive_attack)
	stats.died.disconnect(die)
