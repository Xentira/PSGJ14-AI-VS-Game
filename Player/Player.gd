extends CharacterBody3D

enum States {IDLE = 0, MOVING = 1, DEAD = 2}

var state = States.IDLE

@export var speed = 10.0
@export var attackDamage = 10
signal WormAttack(damage:int)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var bullet = load("res://Player/Projectile.tscn")

@onready var root = $".."
@onready var camera: Camera3D = $Camera
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var armature: Node3D = $Armature
@onready var ray_cast_3d: RayCast3D = $Camera/RayCast3D
@onready var projectile_spawn: Node3D = $ProjectileSpawn

func _ready():
	pass

func _physics_process(delta: float) -> void:

	var point = ScreenPointToRay()
	point += Vector3(0,0.5, 0)
	armature.look_at(point, Vector3.UP)
	DrawLine3d.DrawLine(position, point, Color.PURPLE)

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		state = States.MOVING
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		state = States.IDLE
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	if Input.is_action_just_pressed("fire"):
		fireProjectile()

	match state:
		States.IDLE:
			#animation_player.speed_scale = 1
			animation_player.play("Idle")
		States.MOVING:
			#animation_player.speed_scale = speed / 2
			animation_player.play("Walk Cycle")
		States.DEAD:
			animation_player.play("Dying")
		_:
			print("Error invalid state ")

	move_and_slide()

func ScreenPointToRay():
	var spaceState = get_world_3d().direct_space_state
	var mousePosition = get_viewport().get_mouse_position()
	var rayOrigin = camera.project_ray_origin(mousePosition)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePosition) * camera.far
	var rayQuery = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	var rayDict = spaceState.intersect_ray(rayQuery)
	if rayDict.has("position"):
		return rayDict["position"]
	return Vector3()
	
func fireProjectile():
	var bulletObj = bullet.instantiate()
	bulletObj.transform = projectile_spawn.global_transform
	bulletObj.rotation = armature.global_rotation
	bulletObj.rotation.x = 0
	root.add_child(bulletObj)
	#WormAttack.emit(attackDamage)
