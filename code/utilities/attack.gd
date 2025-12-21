class_name Attack extends Area2D


@export var damage:Damage


func setup_attack(_owner:EntityData) -> void:
	if _owner != null:
		damage.setup_damage(_owner)
	else:
		push_warning("No owner sent to attack ", name)


func get_damage() -> Damage:
	return damage.duplicate(true)
