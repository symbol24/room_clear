class_name Character extends Entity


@onready var remote_transform: RemoteTransform2D = %remote_transform


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	add_to_group(&"player")
	Signals.assigne_remote_path_to_camera.emit(get_path())
	Signals.toggle_character_active.connect(_toggle_active)


func _process(delta: float) -> void:
	if _active:
		_direction = Input.get_vector("left", "right","up", "down")
		velocity = _move(delta, velocity, _direction)
		move_and_slide()


func setup_character(new_data:CharacterData) -> void:
	_data = new_data
	_data.setup_entity()
	name = _data.id
	sprite.set_cell(Vector2i.ZERO, 0, _data.image_coords)
	remote_transform.remote_path = get_tree().get_first_node_in_group(&"rid_camera").get_path()
	_hurt_box = _get_hurtbox()


func apply_damage(_damage:Damage) -> void:
	pass


func _open_pause_menu() -> void:
	Signals.toggle_pause.emit(true)
	Signals.toggle_display.emit(&"pause_menu", true)


func _toggle_active(value:bool) -> void:
	_active = value
