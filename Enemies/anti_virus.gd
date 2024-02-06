class_name Virus
extends CharacterBody3D

enum States {IDLE = 0, MOVING = 1, DEAD = 2, MELEE = 3}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var waiting: bool = false
var cam: Camera3D
var rayLength = 10
var target

@export var state: States = States.MOVING 
@export var speedMove = 3.5 # The moving speed.
@export var gravSpeed = 5 # Set the speed value.
@export var isGrounded = true
@export var active: bool = true #used to handle on death and inactive states
@export var health: int = 100
@export var shield: int = 0
@export var damage: int = 10

@onready var health_bar: ProgressBar = $HealthBar/SubViewport2/HealthBar
@onready var shield_bar: ProgressBar = $HealthBar/SubViewport2/ShieldBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody3D = $"../Player" # Getting the player
@onready var ray: RayCast3D = $RayCast3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var agent: NavigationAgent3D = $NavigationAgent3D
@onready var firewallParticle: Node3D = $"Firewall Particle"

func _ready()-> void:
	target = player.global_transform.origin
	updateTargetLocation(target)
	health_bar.max_value = health
	health_bar.value = health
	shield_bar.max_value = shield
	shield_bar.value = shield
	if shield <= 0:
		shield_bar.visible = false
	player.WormAttack.connect(changeHealth)
	if health_bar != null:
		health_bar.value = health
	else:
		print("healthbar error , " + str(health_bar))
	
func _physics_process(delta: float) -> void:
	#scale = Vector3(size, size, size)
	cam = player.get_node("../Player/Camera")
	var space_state = get_world_3d().direct_space_state
	#ray.target_position = player.position * -1
	#ray.cast_to = ray.cast_to.normalized() * 3
	# Add the gravity.
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	if isGrounded:
		rotation.x = 0
		
	match state:
		States.MOVING:
			#rint(self.transform.origin)
			if not waiting:
				target = player.global_transform.origin
				updateTargetLocation(target)
				animation_player.speed_scale = speedMove / 1.5
				animation_player.play("Walk Cycle") # play the animation
				#var movement_position = player.transform.origin # Set the position to look at
				#var transform_val = self.transform.looking_at(movement_position, Vector3.UP) # Set the transform value
				#self.transform  = self.transform.interpolate_with(transform_val, gravSpeed * delta) # making the object look at the player
				#var direction = (player.position - self.position).normalized()
				#velocity.x = direction.x * speedMove
				#velocity.z = direction.z * speedMove
				
				var currentLocation = global_transform.origin
				var nextLocation = agent.get_next_path_position()
				var transform_val = self.transform.looking_at(nextLocation, Vector3.UP)
				self.transform  = self.transform.interpolate_with(transform_val, gravSpeed * delta)
				var direction = (nextLocation - currentLocation).normalized()
				velocity = direction * speedMove
							
				if ray.get_collider() == player:
					state = States.MELEE
					
				move_and_slide()
		States.MELEE:
			if not waiting:
				#reset to default speed for animation
				animation_player.speed_scale = 1
				animation_player.play("Melee") # play the animation
				waiting = true
			
			if animation_player.is_playing() == false:
				if ray.get_collider() != player:
					state = States.MOVING
					waiting = false
				else:
					if ray.get_collider() == player:
						waiting = false
					else:
						waiting = true
		States.DEAD:
			if active:
				#reset to default speed for animation
				animation_player.speed_scale = 1
				animation_player.play("Dying") # play the animation
				active = false
				health_bar.visible = false
				collision_shape_3d.disabled = true
				await get_tree().create_timer(2.5).timeout
				queue_free()
		States.IDLE:
			#reset to default speed for animation
			animation_player.speed_scale = 1
			animation_player.play("Idle") # play the animation
		_:
			print("Error Invalid State")	

func changeHealth(amount: int) -> void:
	if shield_bar.visible == true:
		shield += amount
		#print("Amount to change shield = " + str(shield) + "Shield current value: " + str(shield_bar.value) + "Shield max value: " +str(shield_bar.max_value))
		shield_bar.value = shield
		if shield <= 0:
			shield_bar.visible = false
			firewallParticle.enabled = false
	else:
		health += amount
		health_bar.value = health
		if health <= 0:
			state = States.DEAD

func updateTargetLocation(target):
	agent.set_target_position(target)
	
func enableShield(amount: int) -> void:
	shield_bar.value = amount
	shield_bar.max_value = amount
	shield_bar.visible = true
	firewallParticle.enabled = true
	changeHealth(amount)
