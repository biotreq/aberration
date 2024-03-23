extends Area3D
class_name Weapon


@export var damage := 10.0
@export var random_damage := 5.0
@export var holder: Node3D
@onready var block_effect := $BlockEffect as GPUParticles3D
@onready var parry_effect := $ParryEffect as GPUParticles3D
@onready var flare := $Flare as Node3D
@onready var sfx := $SwordSFX as SwordSFX

func _ready():
	area_entered.connect(attack)
	monitoring = false


func attack(hitbox: Area3D):
	if hitbox is Hitbox:
		var attack_effect = hitbox.attack(damage + randf_range(0, random_damage), holder)
		notify_attack_effect.emit(attack_effect)
		deactivate()


func activate():
	monitoring = true
	sfx.play_swish()


func deactivate():
	set_deferred('monitoring', false)


func spark():
	block_effect.restart()
	sfx.play_clash()


func big_spark():
	block_effect.restart()
	parry_effect.restart()
	flare.scale = Vector3.ONE * 0.3
	var tween := create_tween()
	tween.tween_property(flare, 'scale', Vector3.ZERO, 0.1)
	sfx.play_strong_clash()


signal notify_attack_effect(effect: Hitbox.AttackEffect)
