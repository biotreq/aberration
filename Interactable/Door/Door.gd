extends AnimatableBody3D
class_name Door


var is_opening := false
@export var target_rotation: float
@export var turn_rate: float
@onready var initial_rotation := rotation.y
@onready var current_roation_factor := turn_rate
@onready var locked_sound := $LockedSound as AudioStreamPlayer3D
@onready var open_sound := $OpenSound as AudioStreamPlayer3D


func open():
	is_opening = true
	open_sound.play(1.0)


func fail_open():
	locked_sound.play()


func _physics_process(_delta):
	if is_opening:
		rotation.y = lerp_angle(initial_rotation, target_rotation, current_roation_factor)
		current_roation_factor = current_roation_factor + turn_rate
		if abs(rotation.y - target_rotation) < 0.1:
			is_opening = false
