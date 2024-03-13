extends Node3D
class_name SwordSFX

@onready var clashes := [
	$Clash1 as PitchShiftSound,
	$Clash2 as PitchShiftSound,
]
@onready var strong_clashes := [
	$StrongClash1 as PitchShiftSound,
	$StrongClash2 as PitchShiftSound,
]
@onready var swish := $Swish as PitchShiftSound


func play_clash():
	clashes.pick_random().play_pitched()

func play_strong_clash():
	strong_clashes.pick_random().play_pitched()

func play_swish():
	swish.play_pitched(0.2)
