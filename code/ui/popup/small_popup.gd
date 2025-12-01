class_name SmallPopup extends Control


const DELAY := 5.0
const TRANSITION := 0.6


var _timer := 0.0:
	set(value):
		_timer = value
		if _timer <= 0.0:
			_close()

@onready var description: Label = %description


func _process(delta: float) -> void:
	if visible and modulate == Color.WHITE: _timer -= delta


func display_popup(new_description:String) -> void:
	description.text = new_description
	_timer = DELAY
	modulate = Color.TRANSPARENT
	show()
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, TRANSITION)


func _close() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, TRANSITION)
	await tween.finished
	hide()
