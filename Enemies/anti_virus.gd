extends CharacterBody3D


const speedMove = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

#@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var player: CharacterBody3D = $"../Player" # Getting the player
var speed = 5 # Set the speed value
var state = 0 # 0 is idle 1 is moving

func _process(delta) -> void:
	var movement_position = player.transform.origin # Set the position to look at
	var transform_val = self.transform.looking_at(movement_position, Vector3.UP) # Set the transform value
	self.transform  = self.transform.interpolate_with(transform_val, speed * delta) # making the object look at the player
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	rotation.x = 0
	if state == 0:
		var direction = (player.position - self.position).normalized()
		velocity.x = direction.x * speedMove
		velocity.z = direction.z * speedMove	
		#pass
	move_and_slide()
	#animation_player.play("Walk Cycle")
