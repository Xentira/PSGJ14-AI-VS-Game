extends CharacterBody3D
#
#enum _States {IDLE = 0, MOVING = 1, DEAD = 2}
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
#
#@export var state: _States = _States.IDLE 
#@export var speedMove = 3.5 # The moving speed.
#@export var gravSpeed = 5 # Set the speed value.
#@export var isGrounded = true
#
#@onready var animation_player: AnimationPlayer = $AnimationPlayer
#@onready var player: CharacterBody3D = $"../Player" # Getting the player
	#
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
	#if isGrounded:
		#rotation.x = 0
	#
	#match state:
		#_States.MOVING:
			#animation_player.speed_scale = speedMove / 2
			#var movement_position = player.transform.origin # Set the position to look at
			#var transform_val = self.transform.looking_at(movement_position, Vector3.UP) # Set the transform value
			#self.transform  = self.transform.interpolate_with(transform_val, gravSpeed * delta) # making the object look at the player
			#var direction = (player.position - self.position).normalized()
			#velocity.x = direction.x * speedMove
			#velocity.z = direction.z * speedMove
		#_States.DEAD:
			##reset to default speed for animation
			#animation_player.speed_scale = 1
			#animation_player.play("Dead") # play the animation
		#_States.IDLE:
			##reset to default speed for animation
#s			animation_player.speed_scale = 1
			#animation_player.play("Idle") # play the animation
		#_:
			#print("Error Invalid State")
			#
	#move_and_slide()
