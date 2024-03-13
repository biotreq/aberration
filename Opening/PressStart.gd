extends Sprite2D


func _ready():
	get_tree().get_root().connect('size_changed', reposition)
	reposition()


func reposition():
	var screen_size: = get_viewport().get_visible_rect().size
	position.x = screen_size.x / 2
	position.y = screen_size.y - 64
