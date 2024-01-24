extends CharacterBody3D

enum States {IDLE = 0, MOVING = 1, DEAD = 2, SPOTTED = 3}

signal spawnAntiVirus(amount: int, center: Vector3, radius: float)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var state: States = States.DEAD
@export var speedMove = 3.5 # The moving speed.
@export var gravSpeed = 5 # Set the speed value.
@export var isGrounded = false

#@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody3D = $"../Player" # Getting the player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spotting_area: Area3D = $SpottingArea
@onready var gameManager = $"../GameManager"

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if isGrounded:
		velocity.y -= gravity * delta
	
	match state:
		States.MOVING:
			animation_player.speed_scale = speedMove / 2
			animation_player.play("Walk Cycle") # play the animation
			var movement_position = player.transform.origin # Set the position to look at
			var transform_val = self.transform.looking_at(movement_position, Vector3.UP) # Set the transform value
			self.transform  = self.transform.interpolate_with(transform_val, gravSpeed * delta) # making the object look at the player
			var direction = (player.position - self.position).normalized()
			velocity = direction * speedMove
		States.DEAD:
			if not isGrounded:
				animation_player.play("Dying") # play the animation
			isGrounded = true
			#reset to default speed for animation
			#animation_player.speed_scale = 1
			animation_player.play("Dying") # play the animation
			if not is_on_floor():
				velocity.y -= gravity * delta
		States.IDLE:
			#reset to default speed for animation
			animation_player.speed_scale = 1
			animation_player.play("Idle") # play the animation
			pass
		_:
			print("Error Invalid State")
			
	move_and_slide()

func _on_spotting_area_body_entered(body: Node3D) -> void:
	if(body == player):
		gameManager.spawnAntiVirusGroup(5, self.position, 30)
	#spawnAntiVirus.emit(5, self.position, 30)
