class_name Credits extends RidControl


@onready var btn_back: Button = %btn_back


func _ready() -> void:
	btn_back.pressed.connect(_btn_back_pressed)


func _btn_back_pressed() -> void:
	Signals.toggle_display.emit(previous, true)
	Signals.toggle_display.emit(id, false)
