extends CanvasLayer
class_name HUD


@onready var blur_effect := $Blur as BlurEffect
@onready var stats_display := $Stats

func _ready():
	var hitbox := $'../Hitbox' as Hitbox
	hitbox.notify_hurt.connect(register_damage)
	var stats := $'../Stats' as PlayerStats
	stats.health_changed.connect(($'Stats/HealthBar' as TextureProgressBar).set_value_no_signal)
	stats.health_regain_changed.connect(($'Stats/HealthRegainBar' as TextureProgressBar).set_value_no_signal)
	stats.stamina_changed.connect(($'Stats/StaminaBar' as TextureProgressBar).set_value_no_signal)
	stats.stamina_regain_changed.connect(($'Stats/StaminaRegainBar' as TextureProgressBar).set_value_no_signal)
	get_tree().get_root().connect('size_changed', reposition_stats)
	reposition_stats()


func register_damage(_damage: float):
	blur_effect.play_damage_feedback()


func reposition_stats():
	var screen_size: = get_viewport().get_visible_rect().size
	stats_display.position = Vector2(0, screen_size.y)
	var stats_scale := screen_size.x * 0.0004
	print(stats_scale)
	stats_display.scale = Vector2(stats_scale, stats_scale)
	
