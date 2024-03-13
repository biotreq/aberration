extends CharacterBody3D
class_name PlayerControl


const speed = 2.0

var gravity = ProjectSettings.get_setting('physics/3d/default_gravity')
@onready var camera: = $'%Camera3D' as Camera3D
@onready var arms: = $'Viewport/Arms' as Node3D
@onready var animator: = $'AnimationTree' as PlayerAnimator
@onready var stats := $Stats as PlayerStats
@onready var viewport := $Viewport as Node3D
@onready var viewport_position := viewport.position
@export var respawn_point: Node3D
var can_move := true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_window().mode = Window.MODE_MAXIMIZED
	stats.died.connect(handle_death)


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir := Input.get_vector('move_left', 'move_right', 'move_forward', 'move_back')
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and can_move:
		var is_running := Input.is_action_pressed('run')
		var move_speed = speed * 1.8 if is_running else speed
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
		if is_running:
			stats.spend_stamina(1)
			viewport.position.y = move_toward(viewport.position.y, viewport_position.y + 0.02 + sin(Time.get_ticks_msec() * 0.015) * 0.1, 0.01)
		else:
			viewport.position.y = move_toward(viewport.position.y, viewport_position.y + 0.03 + sin(Time.get_ticks_msec() * 0.01) * 0.075, 0.01)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * 0.1)
		velocity.z = move_toward(velocity.z, 0, speed * 0.1)
		viewport.position.y = move_toward(viewport.position.y, viewport_position.y, 0.01)

	move_and_slide()
	process_action_input()

const camera_clamp := deg_to_rad(50)

func _input(event):
	const turn_rate: = 0.002
	if event is InputEventMouseMotion:
		camera.rotate_x(-event.relative.y * turn_rate)
		camera.rotation.x = clampf(camera.rotation.x, -camera_clamp, camera_clamp)
		arms.rotation.x = camera.rotation.x / 2
		rotate_y(-event.relative.x * turn_rate)


func process_action_input():
	if !can_move:
		return
	if Input.is_action_just_pressed('attack'):
		animator.request_attack()
	if Input.is_action_just_pressed('block'):
		animator.request_block()


func handle_death():
	can_move = false
	create_tween().tween_property(viewport, 'position', viewport_position + Vector3(0, -1.2, 0), 2.0)
	var respawn_tween := create_tween()
	respawn_tween.tween_interval(4.0)
	respawn_tween.tween_callback(respawn)


func respawn():
	stats.respawn()
	global_position = respawn_point.global_position
	rotation.y = respawn_point.rotation.y
	respawned.emit()
	var hud = $HUD as HUD
	hud.fade_in()
	hud.play_respawn_blur()
	var stand_up := create_tween()
	stand_up.tween_property(viewport, 'position', viewport_position, 6.0)
	stand_up.tween_property(self, 'can_move', true, 0.0)

signal respawned()

var keys := []
