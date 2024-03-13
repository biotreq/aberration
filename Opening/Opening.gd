extends Node3D


var is_starting := false
@onready var fake_player_animation := $fakeplayer/AnimationPlayer
@onready var black_out := $CanvasLayer/Black as BlackFade

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	fake_player_animation.play("LieDown")

func _process(_delta):
	if Input.is_key_pressed(KEY_ENTER) and !is_starting:
		is_starting = true
		fake_player_animation.play("GetUp")
		var tween := create_tween()
		tween.tween_interval(3.0)
		tween.tween_callback(fade_out)
		tween.tween_interval(2.0)
		tween.tween_callback(start_game)


func start_game():
	get_tree().change_scene_to_file("res://Terrain/Level.tscn")

func fade_out():
	black_out.fade_out(2.0)
