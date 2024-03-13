extends RayCast3D


@onready var hud := $%HUD as HUD
var last_tooltip_id := &'HealTip'


func _process(_delta):
	var collider = get_collider()
	if collider is Readable:
		last_tooltip_id = collider.tooltip_id
		hud.display_tooltip(last_tooltip_id)
	else:
		hud.hide_tooltip(last_tooltip_id)
