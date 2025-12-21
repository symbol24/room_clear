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

var current_hp := 1
var max_hp := 1
var current_armor := 1
var max_armor := 1
var current_lives := 1


func setup_entity() -> void:
	max_hp = get_stat(&"hp")
	current_hp = max_hp
	max_armor = get_stat(&"armor")
	current_armor = max_armor
	current_lives = get_stat(&"lives")


func update_hp(value := 0) -> int:
	var remainder := clampi(-value - current_hp, 0, value)
	current_hp = clampi(current_hp + value, 0, max_hp)
	return remainder


func update_armor(value := 0) -> int:
	var remainder := clampi(-value - current_armor, 0, value)
	current_armor = clampi(current_armor + value, 0, max_armor)
	return remainder


func update_lives(value := 0) -> void:
	current_lives += value


func get_stat(stat:StringName) -> Variant:
	if get(&"_"+stat) != null: return get(&"_"+stat)
	return 0
