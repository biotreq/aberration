extends CharacterBody3D


const speed = 2.0

var gravity = ProjectSettings.get_setting('physics/3d/default_gravity')
@onready var camera: = $Camera3D as Camera3D


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


func _input(event):
	const turn_rate: = 0.002
	if event is InputEventMouseMotion:
		camera.rotate_x(-event.relative.y * turn_rate)
		rotate_y(-event.relative.x * turn_rate)
