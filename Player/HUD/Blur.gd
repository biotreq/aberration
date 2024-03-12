extends CanvasLayer
class_name BlurEffect


@onready var heavy_blur := $HeavyBlur as Sprite2D
@onready var light_blur := $LightBlur as Sprite2D

const light_blur_high_radius := 3.12
const light_blur_low_radius := 1.0
const heavy_blur_high_radius := 2.93
const heavy_blur_low_radius := 1.5

const light_blur_inner_radius := 0.125
const heavy_blur_inner_radius := 0.2

var damage_tween: Tween

func _ready():
	get_tree().get_root().connect('size_changed', resize)
	resize()


func resize():
	var screen_size: = get_viewport().get_visible_rect().size

	heavy_blur.position = Vector2(screen_size.x / 2, screen_size.y / 2)
	light_blur.position = Vector2(screen_size.x / 2, screen_size.y / 2)

	var heavy_scale := float(screen_size.y) / float(heavy_blur.texture.get_height())
	heavy_blur.scale = Vector2(heavy_scale, heavy_scale)
	var light_scale := float(screen_size.y) / float(light_blur.texture.get_height())
	light_blur.scale = Vector2(light_scale, light_scale)


func play_damage_feedback():
	if damage_tween:
		damage_tween.kill()
	set_heavy_blur_amount(heavy_blur_high_radius)
	set_light_blur_amount(light_blur_high_radius)
	color_heavy_blur(0.0)
	damage_tween = create_tween()
	damage_tween.set_parallel()
	damage_tween.tween_method(color_light_blur, 0.8, 1.0, 0.5)
	damage_tween.tween_method(color_heavy_blur, 0.0, 1.0, 1.0)
	damage_tween.tween_method(set_light_blur_amount, light_blur_high_radius, light_blur_low_radius, 6.0)
	damage_tween.tween_method(set_heavy_blur_amount, heavy_blur_high_radius, heavy_blur_low_radius, 4.0)


func play_respawn_blur():
	damage_tween = create_tween()
	damage_tween.set_parallel()
	damage_tween.tween_method(set_light_blur_amount, light_blur_high_radius, light_blur_low_radius, 8.0)
	damage_tween.tween_method(set_heavy_blur_amount, heavy_blur_high_radius, heavy_blur_low_radius, 6.0)
	damage_tween.tween_method(set_light_inner, -1.0, light_blur_inner_radius, 8.0)
	damage_tween.tween_method(set_heavy_inner, -1.0, heavy_blur_inner_radius, 6.0)


func color_light_blur(amount: float):
	light_blur.material.set('shader_parameter/green_blue', amount)


func color_heavy_blur(amount: float):
	heavy_blur.material.set('shader_parameter/green_blue', amount)


func set_light_blur_amount(amount: float):
	light_blur.material.set('shader_parameter/outer_radius', amount)


func set_heavy_blur_amount(amount: float):
	heavy_blur.material.set('shader_parameter/outer_radius', amount)


func set_light_inner(amount: float):
	light_blur.material.set('shader_parameter/inner_radius', amount)


func set_heavy_inner(amount: float):
	heavy_blur.material.set('shader_parameter/inner_radius', amount)
