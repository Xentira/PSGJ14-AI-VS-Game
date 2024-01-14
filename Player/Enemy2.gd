extends CharacterBody3D

@onready var player: CharacterBody3D = $"../Player" # Getting the player
var speed = 5 # Set the speed value

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") # Gravity value

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
func _process(delta) -> void:
	var movement_position = player.transform.origin # Set the position to look at
	var transform_val = self.transform.looking_at(movement_position, Vector3.UP) # Set the transform value
	self.transform  = self.transform.interpolate_with(transform_val, speed * delta) # making the object look at the player
