extends CanvasLayer


@onready var heavy_blur := $HeavyBlur as Sprite2D
@onready var light_blur := $LightBlur as Sprite2D

func _ready():
	get_tree().get_root().connect('size_changed', resize)
	resize()


func resize():
	var screen_size: = get_viewport().get_visible_rect().size

	heavy_blur.position = Vector2(screen_size.x / 2, screen_size.y / 2)
	light_blur.position = Vector2(screen_size.x / 2, screen_size.y / 2)

	var heavy_scale := float(screen_size.x) / float(heavy_blur.texture.get_width())
	heavy_blur.scale = Vector2(heavy_scale, heavy_scale)
	var light_scale := float(screen_size.x) / float(light_blur.texture.get_width())
	light_blur.scale = Vector2(light_scale, light_scale)
