extends Node3D

const ANTI_VIRUS = preload("res://Enemies/anti_virus.tscn")

var antiVirus

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawnAntiVirusGroup(amount: int) -> void:
	antiVirus = ANTI_VIRUS.instantiate()
	antiVirus.position.y = 0.5
	await get_tree().create_timer(2.5).timeout
	get_parent_node_3d().add_child(antiVirus)
