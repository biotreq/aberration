extends Sprite2D
class_name BlackFade


func _ready():
	var tween := create_tween()
	tween.tween_method(set_fade, 1.0, 0.0, 2.0)


func set_fade(amount: float):
	material.set('shader_parameter/magnitude', amount)


func fade_out():
	var tween := create_tween()
	tween.tween_method(set_fade, 0.0, 1.0, 3.0)


func fade_in():
	var tween := create_tween()
	tween.tween_method(set_fade, 1.0, 0.0, 4.0)
