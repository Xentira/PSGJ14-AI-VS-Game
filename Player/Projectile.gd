extends Node3D

@onready var area_3d: Area3D = $Area3D

var BULLET_SPEED = 70
var BULLET_DAMAGE = 15

const KILL_TIMER = 4
var timer = 0

var hit_something = false

func _ready():
	#area_3d.connect("body_entered", self, "collided") old
	area_3d.body_entered.connect(collided)
func _physics_process(delta):
	var forward_dir = global_transform.basis.z.normalized()
	
	global_translate(forward_dir * BULLET_SPEED * delta)

	timer += delta
	if timer >= KILL_TIMER:
		queue_free()


func collided(body):
	if hit_something == false:
		if body.has_method("bullet_hit"):
			body.bullet_hit(BULLET_DAMAGE, global_transform)

	hit_something = true
	queue_free()
