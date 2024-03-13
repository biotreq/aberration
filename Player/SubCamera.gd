extends Camera3D


@onready var main_cam := $%Camera3D as Node3D


func _process(_delta):
	transform = main_cam.global_transform
