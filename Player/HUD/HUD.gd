extends CanvasLayer
class_name HUD


@onready var blur_effect := $Blur as BlurEffect
@onready var hitbox := $'../Hitbox' as Hitbox

func _ready():
	hitbox.notify_hurt.connect(register_damage)


func register_damage(_damage: float):
	blur_effect.play_damage_feedback()
