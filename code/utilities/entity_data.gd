class_name EntityData extends Resource


@export var id := &""
@export var display_name := ""
@export var description := ""

@export var _speed := 100.0

@export var _hp := 3
@export var _armor := 0
@export var _lives := 1

@export var _attack_power := 1.0
@export var _attack_speed := 1.0


func get_stat(stat:StringName) -> Variant:
	if get(&"_"+stat) != null: return get(&"_"+stat)
	return 0
