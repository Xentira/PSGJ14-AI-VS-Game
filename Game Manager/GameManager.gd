extends Node3D

const ANTI_VIRUS = preload("res://Enemies/anti_virus.tscn")
const FLY = preload("res://Enemies/fly.tscn")	

var antiVirus

var spawnListener

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	#spawnListener = get_parent().get_node("fly")
	#spawnListener.connect("spawnAntiVirus", self, "spawnAntiVirusGroup")
	#await  get_tree().create_timer(2).timeout
	#spawnAntiVirusGroup(100, Vector3(0,0,0), 30)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawnAntiVirusGroup(amount: int, center: Vector3, radius: float) -> void:
	#Calculate the positions of the enemies to place
	var count = amount
	while count >= 0:
		print("Enemy: " + str(count+1)+ " of " + str(amount))
		antiVirus = ANTI_VIRUS.instantiate()
		var spawnPos = Vector3(randf_range(center.x - radius/2,center.x + radius/2),
					   1,
					   randf_range(center.z - radius/2, center.z + radius/2))
		antiVirus.position = spawnPos
		get_parent_node_3d().add_child(antiVirus)
		count -= 1
		await get_tree().create_timer(.1).timeout
