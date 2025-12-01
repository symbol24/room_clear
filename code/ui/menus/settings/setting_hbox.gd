class_name SettingHbox extends HBoxContainer

@export var display_text := ""
@export var setting_id := &""

@onready var setting_label: Label = %setting_label


func _ready() -> void:
	setting_label.text = tr(display_text)
	Signals.update_setting_from_data.connect(_update_value)


func _update_value(_id:StringName, _value:Variant) -> void:
	pass
