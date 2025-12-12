class_name SpawnManager extends Node2D


const CHARACTER := preload("uid://jby7lgv0mata")


var character:Character = null
var level:Level = null:
	get:
		if level == null: level = get_parent() as Level
		return level


func _ready() -> void:
	Signals.spawn_character.connect(_spawn_character)


func _spawn_character(data:CharacterData) -> void:
	character = CHARACTER.instantiate()
	get_parent().add_child(character)
	if not character.is_node_ready(): await character.ready
	character.name = data.id
	character.setup_character(data)
	for ability:AbilityData in data.abilities:
		if ability.uid != "":
			var new = load(ability.uid).instantiate()
			character.add_child(new)
			if not new.is_node_ready(): await new.ready
			new.name = ability.id
	character.global_position = level.active_room.spawn_point.global_position
	await get_tree().create_timer(1.5).timeout
	Signals.ready_checklist.emit(&"character")
