extends Stats
class_name PlayerStats

@export var max_stamina := 100.0
@onready var stamina := max_stamina
var health_regain := max_health
@onready var stamina_regain := stamina
@export var initial_health := 80.0

const stamina_regen_rate := 20.0
const stamina_regain_tickdown_rate := 5.0
const health_regain_tickdown_rate := 7.5
const min_stamina := -20.0

var stamina_regain_tween: Tween
var health_regain_tween: Tween
var stamina_regen_tween: Tween

func _ready():
	health = initial_health
	health_regain = health
	var weapon := $'%Weapon' as Weapon
	# disgusting control handovers all around
	weapon.notify_attack_effect.connect(on_attacked_enemy)


func lose_health(amount: float):
	super.lose_health(amount)
	if (
		!is_ticking_down_health_regain
		and (!health_regain_tween or !health_regain_tween.is_running())
	):
		var tween = create_tween()
		tween.tween_interval(5.0)
		tween.tween_callback(start_health_regain_tickdown)
		health_regain_tween = tween
	health_changed.emit(health)


func spend_stamina(amount: float):
	assert(amount > 0)
	stamina = max(stamina - amount, min_stamina)
	if (
		!is_ticking_down_stamina_regain
		and (!stamina_regain_tween or !stamina_regain_tween.is_running())
	):
		var tween = create_tween()
		tween.tween_interval(1.0)
		tween.tween_callback(start_stamina_regain_tickdown)
		health_regain_tween = tween
	if stamina_regen_tween:
		stamina_regen_tween.kill()
	is_regenerating_stamina = false
	var regen = create_tween()
	regen.tween_interval(1.0)
	regen.tween_callback(start_stamina_regen)
	stamina_regen_tween = regen
	stamina_changed.emit(stamina)


func can_use_stamina() -> bool:
	return stamina > 0


func regain_stamina(amount: float):
	stamina = min(stamina + amount, stamina_regain)
	stamina_changed.emit(stamina)


func regain_health(amount: float):
	if health + amount <= health_regain:
		health += amount
	elif health >= health_regain:
		health = min(health + amount * 0.3, max_health)
		health_regain = health
	else:
		amount -= health_regain - health
		health = min(health_regain + amount * 0.3, max_health)
		health_regain = health
	health_changed.emit(health)
	health_regain_changed.emit(health_regain)


func on_attacked_enemy(effect: Hitbox.AttackEffect):
	if effect == Hitbox.AttackEffect.Hurt:
		regain_health(10)
	var second_wind_amount := -5.0 if effect == Hitbox.AttackEffect.Hurt else 0.001
	if stamina < second_wind_amount:
		stamina = second_wind_amount
		if stamina_regain < second_wind_amount:
			stamina_regain = second_wind_amount


var is_ticking_down_health_regain := false
var is_ticking_down_stamina_regain := false
var is_regenerating_stamina := true

func start_health_regain_tickdown():
	is_ticking_down_health_regain = true


func start_stamina_regain_tickdown():
	is_ticking_down_stamina_regain = true


func start_stamina_regen():
	is_regenerating_stamina = true


func _process(delta):
	if is_ticking_down_health_regain:
		health_regain = move_toward(health_regain, health, delta * health_regain_tickdown_rate)
		health_regain_changed.emit(health_regain)
		if health_regain == health:
			is_ticking_down_health_regain = false
	if is_ticking_down_stamina_regain:
		stamina_regain = move_toward(stamina_regain, min(stamina, 0.0), delta * stamina_regain_tickdown_rate)
		stamina_regain_changed.emit(stamina_regain)
		if stamina_regain == stamina:
			is_ticking_down_stamina_regain = false
	if is_regenerating_stamina:
		stamina = move_toward(stamina, max_stamina, delta * stamina_regen_rate)
		stamina_changed.emit(stamina)
		if stamina_regain < stamina:
			stamina_regain = stamina
			stamina_regain_changed.emit(stamina_regain)
		if stamina == max_stamina:
			is_regenerating_stamina = false


signal health_changed(amount: float)
signal health_regain_changed(amount: float)
signal stamina_changed(amount: float)
signal stamina_regain_changed(amount: float)


func respawn():
	if stamina_regain_tween:
		stamina_regain_tween.kill()
	if health_regain_tween:
		health_regain_tween.kill()
	if stamina_regen_tween:
		stamina_regen_tween.kill()
	is_ticking_down_health_regain = false
	is_ticking_down_stamina_regain = false
	is_regenerating_stamina = false
	health = max_health
	health_regain = max_health
	stamina = max_stamina
	stamina_regain = max_stamina
	health_changed.emit(health)
	health_regain_changed.emit(health_regain)
	stamina_changed.emit(stamina)
	stamina_regain_changed.emit(stamina_regain)
	respawned.emit()
