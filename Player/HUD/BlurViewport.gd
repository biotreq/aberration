extends SubViewport


func _ready():
	get_tree().get_root().connect('size_changed', resize)
	resize()


func resize():
	var screen_size: = get_viewport().get_visible_rect().size
	if screen_size.x and screen_size.y:
		size.x = size.y * (screen_size.x / screen_size.y)
