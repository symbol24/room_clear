class_name PlayUi extends RidControl


const SECOND := 1.0


@onready var room_timer: Label = %room_timer

var _current_time := 3


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"cancel") and visible:
		_pause()
		get_viewport().set_input_as_handled()


func _ready() -> void:
	Signals.start_room_timer.connect(_run_room_timer)


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


func _run_room_timer() -> void:
	room_timer.text = "3"
	room_timer.show()
	while _current_time >= 0:
		room_timer.scale = Vector2.ONE
		var tween:Tween = create_tween()
		tween.tween_property(room_timer, "scale", Vector2.ZERO, SECOND)
		await tween.finished
		_current_time -= 1
		room_timer.text = str(_current_time) if _current_time > 0 else "GO!"
	room_timer.hide()
	Signals.room_start.emit()
