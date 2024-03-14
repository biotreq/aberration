extends Area3D


@onready var player := get_tree().current_scene.get_node('Player') as PlayerControl

func _ready():
	body_entered.connect(exit_level)


func exit_level(body: Node3D):
	if !(body is PlayerControl):
		return
	player.end()
	var tween := create_tween()
	tween.tween_interval(3.0)
	tween.tween_callback(end_game)


func end_game():
	get_tree().change_scene_to_file("res://Opening/Opening.tscn")
