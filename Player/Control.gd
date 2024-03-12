extends CharacterBody3D


const speed = 2.0

var gravity = ProjectSettings.get_setting('physics/3d/default_gravity')
@onready var camera: = $'%Camera3D' as Camera3D
@onready var arms: = $'Viewport/Arms' as Node3D
@onready var animator: = $'AnimationTree' as PlayerAnimator
@onready var stats := $Stats as PlayerStats
@onready var viewport := $Viewport as Node3D
@export var respawn_point: Node3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_window().mode = Window.MODE_MAXIMIZED
	stats.died.connect(handle_death)


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir := Input.get_vector('move_left', 'move_right', 'move_forward', 'move_back')
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

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
	if Input.is_action_just_pressed('attack'):
		animator.request_attack()
	if Input.is_action_just_pressed('block'):
		animator.request_block()


func handle_death():
	var fall_tween := create_tween()
	var viewport_position := viewport.position
	fall_tween.tween_property(viewport, 'position', viewport_position + Vector3(0, -1.5, 0), 3.5)
	fall_tween.tween_property(viewport, 'position', viewport_position, 0.1)
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

signal respawned()
