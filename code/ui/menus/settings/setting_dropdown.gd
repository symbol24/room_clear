class_name SettingDropdown extends SettingHbox


@onready var drop_down: OptionButton = %drop_down


func _ready() -> void:
	super()
	drop_down.item_selected.connect(_selection_updated)
	Signals.generate_dropdown_items.connect(_generate_dropdown_values)


func _selection_updated(i:int) -> void:
	Signals.settings_dropdown_changed.emit(setting_id, i)


func _update_value(id:StringName, value:Variant) -> void:
	if id == setting_id and value is int:
		drop_down.select(value)


func _generate_dropdown_values(id:StringName, values:Array[String]) -> void:
	if setting_id == id:
		drop_down.clear()
		for item in values:
			drop_down.add_item(item)
