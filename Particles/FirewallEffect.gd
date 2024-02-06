extends Node3D

@export var enabled = false
@export var rotationSpeed = 5

var rotationAmmount = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not enabled:
		visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enabled:
		visible = true
		rotationAmmount += rotationSpeed * delta
		rotation.y = rotationAmmount
	else:
		visible = false
