class_name SettingSlider extends SettingHbox


@onready var hslider: HSlider = %hslider


func _ready() -> void:
	super()
	hslider.value_changed.connect(_value_changed)


func _value_changed(value:float) -> void:
	Signals.setting_slider_updated.emit(setting_id, value)


func _update_value(id:StringName, value:Variant) -> void:
	if id == setting_id and value is float:
		hslider.value = value
