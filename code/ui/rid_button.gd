class_name RidButton extends Button


func _pressed() -> void:
	Signals.play_audio.emit(AudioManager.BTN_SOUND)
