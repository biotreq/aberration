extends CanvasLayer
class_name BlurEffect


@onready var blur := $ColorRect as ColorRect

var damage_tween: Tween


func play_damage_feedback():
	if damage_tween:
		damage_tween.kill()
	set_blur_inner(0.0)
	set_blur_magnitude(20.0)
	damage_tween = create_tween()
	damage_tween.set_parallel()
	damage_tween.tween_method(color_red_border, 1.5, 0.0, 1.0)
	damage_tween.tween_method(set_blur_inner, 0.0, 0.3, 3.0)


func play_respawn_blur():
	damage_tween = create_tween()
	damage_tween.tween_method(set_blur_inner, -1.0, 0.3, 12.0)


func color_red_border(amount: float):
	blur.material.set('shader_parameter/red', amount)


func set_blur_magnitude(amount: float):
	blur.material.set('shader_parameter/magnitude', amount)


func set_blur_inner(amount: float):
	blur.material.set('shader_parameter/inner_radius', amount)
