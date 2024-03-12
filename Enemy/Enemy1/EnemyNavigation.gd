extends CharacterBody3D
class_name EnemyNavigation


enum State {
	Idle,
	Traversing,
	Fighting,
}

const speed = 0.7
const turn_rate = 0.05
const max_range = 1.7
const optimum_range = 1.4

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var navigation_agent := $NavigationAgent3D as NavigationAgent3D
@onready var ai := $AnimationTree as AnimationIntelligence
@onready var player: = get_tree().current_scene.get_node('Player') as CharacterBody3D


func _ready():
	navigation_agent.path_desired_distance = optimum_range
	var start_stagger := create_tween()
	start_stagger.tween_interval(randf() * 2.0)
	start_stagger.tween_callback(ai.start)

var state := State.Idle
var navigation_tween: Tween


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if state == State.Idle:
		look_for_player()

	if state == State.Traversing:
		if navigation_agent.is_navigation_finished():
			state = State.Fighting
			navigation_tween.kill()
			reached_player.emit()
		else:
			var next_path_position := navigation_agent.get_next_path_position()
			turn_to_target(next_path_position)
			velocity = transform.basis * Vector3.FORWARD * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * 0.1)
		velocity.z = move_toward(velocity.z, 0, speed * 0.1)

	if state == State.Fighting:
		turn_to_target(player.global_position)

	move_and_slide()


func wake_up():
	ai.activate()


func look_for_player():
	wake_up()


func chase_player():
	if navigation_tween:
		navigation_tween.kill()
	state = State.Traversing
	target_player_position()
	navigation_tween = create_tween()
	navigation_tween.tween_interval(0.5)
	navigation_tween.tween_callback(target_player_position)
	navigation_tween.set_loops()


func turn_to_target(target: Vector3):
	var look_target := transform.looking_at(target).basis.get_euler()
	rotation.y = lerp_angle(rotation.y, look_target.y, turn_rate)


func target_player_position():
	navigation_agent.target_position = player.global_position


func can_reach_player() -> bool:
	return global_position.distance_to(player.global_position) < max_range


signal reached_player()
