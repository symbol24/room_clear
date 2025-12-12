class_name RidCamera extends Camera2D


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group(&"rid_camera")
