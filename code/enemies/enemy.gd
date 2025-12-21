class_name Enemy extends Entity


var _target:Character = null:
	get:
		if _target == null: _target = get_tree().get_first_node_in_group(&"player")
		return _target


func _process(delta: float) -> void:
	if _active:
		_direction = global_position.direction_to(_target.global_position)
		velocity = _move(delta, velocity, _direction)
		move_and_slide()


func setup_enemy(new_data:EnemyData) -> void:
	if new_data != null:
		_data = new_data
		_data.setup_entity()
		name = _data.id
		sprite.set_cell(Vector2i.ZERO, 0, _data.image_coord)
		_activate_attack_children()
		_active = true


func _activate_attack_children() -> void:
	for each in get_children():
		if each is Attack:
			each.setup_attack(_data)
