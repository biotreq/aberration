extends CanvasLayer
class_name HUD


@onready var blur_effect := $Blur as BlurEffect
@onready var stats_display := $Stats as Control
@onready var black_fade := $Black as BlackFade
@onready var tooltips_element := $Tooltips as Node2D

func _ready():
	var hitbox := $'../Hitbox' as Hitbox
	hitbox.notify_hurt.connect(register_damage)
	var stats := $'../Stats' as PlayerStats
	stats.health_changed.connect(($'Stats/HealthBar' as TextureProgressBar).set_value_no_signal)
	stats.health_regain_changed.connect(($'Stats/HealthRegainBar' as TextureProgressBar).set_value_no_signal)
	stats.stamina_changed.connect(($'Stats/StaminaBar' as TextureProgressBar).set_value_no_signal)
	stats.stamina_changed.connect(($'Stats/NegativeStaminaBar' as TextureProgressBar).set_value_no_signal)
	get_tree().get_root().connect('size_changed', reposition_hud)
	var tween := create_tween()
	tween.tween_interval(0.1)
	tween.tween_callback(reposition_hud)
	stats.died.connect(black_fade.fade_out)


func register_damage(_damage: float):
	blur_effect.play_damage_feedback()


func reposition_hud():
	var screen_size: = get_viewport().get_visible_rect().size
	stats_display.position = Vector2(0, screen_size.y)
	var stats_scale := screen_size.x * 0.0004
	stats_display.scale = Vector2(stats_scale, stats_scale)
	tooltips_element.position = Vector2(screen_size.x, screen_size.y)
	tooltips_element.scale = Vector2(stats_scale * 2, stats_scale * 2)


func fade_in():
	black_fade.fade_in()

func fade_out():
	black_fade.fade_out()

func play_respawn_blur():
	blur_effect.play_respawn_blur()


@onready var tooltips := {
	&'Open': $'Tooltips/OpenTooltip' as Node2D,
	&'PickUp': $'Tooltips/PickUpTooltip' as Node2D,
	&'HealTip': $'Tooltips/HealTipReadable' as Node2D,
	&'ParryTip': $'Tooltips/ParryTipReadable' as Node2D,
	&'PerfectParryTip': $'Tooltips/PerfectParryTipReadable' as Node2D,
}

func display_tooltip(id: StringName):
	tooltips[id].visible = true

func hide_tooltip(id: StringName):
	tooltips[id].visible = false
