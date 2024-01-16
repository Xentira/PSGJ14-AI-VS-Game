extends GridMap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.clear()
	buildLevel()
	pass # Replace with function body.

func buildLevel() -> void:
	set_cell_item(Vector3(1,1,0), 0, 0)
	pass
