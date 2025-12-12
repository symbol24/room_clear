class_name Character extends CharacterBody2D


const ACCELERATION := 700.0
const FRICTION := 1100.0


@onready var sprite: TileMapLayer = %sprite
@onready var remote_transform: RemoteTransform2D = %remote_transform

var active := false
var data:CharacterData
var _direction := Vector2.ZERO


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	Signals.assigne_remote_path_to_camera.emit(get_path())
	Signals.toggle_character_active.connect(_toggle_active)


func _process(delta: float) -> void:
	if active:
		_direction = Input.get_vector("left", "right","up", "down")
		velocity = _move(delta, velocity, _direction)
		move_and_slide()


func setup_character(new_data:CharacterData) -> void:
	data = new_data
	sprite.set_cell(Vector2i.ZERO, 0, data.image_coords)
	remote_transform.remote_path = get_tree().get_first_node_in_group(&"rid_camera").get_path()


func _move(delta:float, current:Vector2, direction:Vector2) -> Vector2:
	var x := current.x
	var y := current.y
	if direction == Vector2.ZERO:
		x = move_toward(x, 0, delta * FRICTION)
		y = move_toward(y, 0, delta * FRICTION)
	else:
		x = move_toward(x, direction.x * data.get_stat(&"speed"), delta * ACCELERATION)
		y = move_toward(y, direction.y * data.get_stat(&"speed"), delta * ACCELERATION)
	var result := Vector2(x,y)
	result.clampf(-70, 70)
	return result


func _open_pause_menu() -> void:
	Signals.toggle_pause.emit(true)
	Signals.toggle_display.emit(&"pause_menu", true)


func _toggle_active(value:bool) -> void:
	active = value
