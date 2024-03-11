extends Camera3D


@onready var main_cam := $'../..' as Node3D


func _process(_delta):
	transform = main_cam.global_transform
