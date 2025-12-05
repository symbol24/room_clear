class_name PauseMenu extends RidControl


@onready var btn_back: RidButton = %btn_back


func _ready() -> void:
	btn_back.pressed.connect(_back_btn_pressed)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"cancel") and visible:
		_back_btn_pressed()
		get_viewport().set_input_as_handled()


func _back_btn_pressed() -> void:
	toggle_ridcontrol(id, false)
	Signals.toggle_display.emit(&"play_ui", true)


func toggle_ridcontrol(_id:StringName = id, display := false) -> void:
	if _id == id:
		# do something here
		if display:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_HIDDEN:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			show()
		else:
			Signals.toggle_pause.emit(false)
			hide()
