extends Area3D
class_name Weapon


@export var damage := 10.0
@export var holder: Node3D

func _ready():
	area_entered.connect(attack)
	monitoring = false


func attack(hitbox: Area3D):
	if hitbox is Hitbox:
		var attack_effect = hitbox.attack(damage, holder)
		notify_attack_effect.emit(attack_effect)
		deactivate()


func activate():
	monitoring = true


func deactivate():
	set_deferred('monitoring', false)

signal notify_attack_effect(effect: Hitbox.AttackEffect)
