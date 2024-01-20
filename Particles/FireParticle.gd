class_name Particle
extends GPUParticles3D

@export var enabledAll = false

@onready var gpu_particles_3d_2: GPUParticles3D = $GPUParticles3D2
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var omni_light_3d: OmniLight3D = $OmniLight3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	emitting = enabledAll
	gpu_particles_3d.emitting = enabledAll
	gpu_particles_3d_2.emitting = enabledAll
	if enabledAll == false:
		omni_light_3d.omni_range = 0
	else:
		omni_light_3d.omni_range = 5
