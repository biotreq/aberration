extends Area3D
class_name Weapon


@export var damage := 10.0

func _ready():
	area_entered.connect(hurt)
	monitoring = false


func hurt(hitbox: Area3D):
	if hitbox is Hitbox:
		hitbox.hurt(damage)
		deactivate()


func activate():
	monitoring = true


func deactivate():
	monitoring = false
