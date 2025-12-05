class_name Level extends Node2D


func _ready() -> void:
	Signals.toggle_display.emit(&"play_ui", true)
