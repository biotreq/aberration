extends Node3D

func _ready():
	($Blood as GPUParticles3D).restart()
	($BlockEffect as GPUParticles3D).restart()
	($ParryEffect as GPUParticles3D).restart()
