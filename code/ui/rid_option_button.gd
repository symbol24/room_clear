class_name RidOptionButton extends OptionButton


func _ready() -> void:
	item_selected.connect(_item_selected)


func _item_selected(_value:int) -> void:
	Signals.play_audio.emit(AudioManager.BTN_SOUND)
