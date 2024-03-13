extends Interactable


@export var key_name: StringName


func interact(player: PlayerControl):
	player.keys.append(key_name)
	queue_free()
