class_name PlayUi extends RidControl


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"cancel") and visible:
		_pause()
		get_viewport().set_input_as_handled()


func toggle_ridcontrol(_id:StringName = id, display := false) -> void:
	if _id == id:
		if display:
			if Input.get_mouse_mode() != Input.MOUSE_MODE_HIDDEN:
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			show()
		else:
			hide()


func _pause() -> void:
	Signals.toggle_pause.emit(true)
	toggle_ridcontrol(id, false)
	Signals.toggle_display.emit(&"pause_menu", true)
