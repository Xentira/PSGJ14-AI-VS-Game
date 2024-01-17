extends CharacterBody3D

enum States {IDLE = 0, MOVING = 1, DEAD = 2, MELEE = 3}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var waiting: bool = false

@export var state: States = States.IDLE 
@export var speedMove = 3.5 # The moving speed.
@export var gravSpeed = 5 # Set the speed value.
@export var isGrounded = true
@export_range(0.0, 1.0) var size = 1.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody3D = $"../Player" # Getting the player
@onready var ray: RayCast3D = $RayCast3D

func _onready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	scale = Vector3(size, size, size)
	#ray.target_position = player.position * -1
	#ray.cast_to = ray.cast_to.normalized() * 3
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	if isGrounded:
		rotation.x = 0
	
	match state:
		States.MOVING:
			if not waiting:
				animation_player.speed_scale = speedMove / 2
				animation_player.play("Walk Cycle") # play the animation
				var movement_position = player.transform.origin # Set the position to look at
				var transform_val = self.transform.looking_at(movement_position, Vector3.UP) # Set the transform value
				self.transform  = self.transform.interpolate_with(transform_val, gravSpeed * delta) # making the object look at the player
				var direction = (player.position - self.position).normalized()
				velocity.x = direction.x * speedMove
				velocity.z = direction.z * speedMove
				if ray.get_collider() == player:
					state = States.MELEE
		States.MELEE:
			print("entering melee")
			if not waiting:
				print("playing melee")
				#reset to default speed for animation
				animation_player.speed_scale = 1
				animation_player.play("Melee") # play the animation
				waiting = true
			print("checking if done")
			if animation_player.is_playing() == false:
				if ray.get_collider() != player:
					state = States.MOVING
					waiting = false
				else:
					if ray.get_collider() == player:
						print("reset melee")
						waiting = false
					waiting = true
		States.DEAD:
			#reset to default speed for animation
			animation_player.speed_scale = 1
			animation_player.play("Dead") # play the animation
		States.IDLE:
			#reset to default speed for animation
			animation_player.speed_scale = 1
			animation_player.play("Idle") # play the animation
		_:
			print("Error Invalid State")
			
	move_and_slide()
