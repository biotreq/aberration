extends Interactable


@export var key_name: StringName
@export var door: Door


func interact(player: PlayerControl):
	if key_name in player.keys:
		door.open()
		queue_free()
	else:
		door.fail_open()
