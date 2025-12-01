class_name SettingButton extends SettingHbox


@export var btn_on := ""
@export var btn_off := ""

var _is_on := false

@onready var btn_setting: Button = %btn_setting


func _ready() -> void:
	super()
	btn_setting.text = btn_on if _is_on else btn_off
	btn_setting.pressed.connect(_button_pressed)


func _button_pressed() -> void:
	_is_on = false if _is_on else true
	btn_setting.text = btn_on if _is_on else btn_off
	Signals.settings_button_pressed.emit(setting_id, _is_on)


func _update_value(id:StringName, value:Variant) -> void:
	if id == setting_id and value is bool:
		_is_on = value
		btn_setting.text = btn_on if _is_on else btn_off
