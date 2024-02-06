extends Node3D

@onready var area_3d: Area3D = $Area3D

var BULLET_SPEED = 35
var BULLET_DAMAGE = 25

const KILL_TIMER = 1
var timer = 0

var hit_something = false
var start_pos : Vector3
var end_pos : Vector3

func _ready():
	#area_3d.connect("body_entered", self, "collided") old
	area_3d.body_entered.connect(collided)
	start_pos = self.global_transform.origin
	
func _physics_process(delta):
	var forward_dir = global_transform.basis.z.normalized()
	global_translate(forward_dir * (BULLET_SPEED * -1) * delta)

	timer += delta
	if timer >= KILL_TIMER:
		queue_free()


func collided(body):
	if hit_something == false:
		if body.has_method("changeHealth"):
			body.changeHealth(BULLET_DAMAGE * -1)

	hit_something = true
	end_pos = global_transform.origin
	#print(start_pos.distance_to(end_pos))
	queue_free()
