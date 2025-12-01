class_name RidControl extends Control


@export var id := &""

var previous := &""


func toggle_ridcontrol(_id:StringName = id, display := false) -> void:
	if _id == id:
		# do something here
		if display:
			show()
		else:
			hide()
