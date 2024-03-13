extends AudioStreamPlayer3D
class_name PitchShiftSound

@onready var default_pitch := pitch_scale

func play_pitched(from = 0.0):
	pitch_scale = default_pitch + randf_range(-0.1, 0.1)
	play(from)
