extends Node
class_name Stats

@export var max_health := 100.0
@onready var health := max_health


func lose_health(amount: float):
	assert(amount > 0)
	health -= amount
	if health <= 0:
		died.emit()


func is_dead():
	return health <= 0


func reset():
	health = max_health


signal died()
signal respawned()
