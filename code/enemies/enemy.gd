class_name Enemy extends CharacterBody2D


const ACCELERATION := 700.0
const FRICTION := 1100.0


@onready var sprite: TileMapLayer = %sprite

var _active := false
var _data:EnemyData
var _target:Character = null:
	get:
		if _target == null: _target = get_tree().get_first_node_in_group(&"player")
		return _target


func _process(delta: float) -> void:
	if _active:
		velocity = _move(delta, velocity, global_position.direction_to(_target.global_position))
		move_and_slide()


func setup_enemy(new_data:EnemyData) -> void:
	if new_data != null:
		_data = new_data
		name = _data.id
		sprite.set_cell(Vector2i.ZERO, 0, _data.image_coord)
		_active = true
		print(_data.get_stat(&"speed"))


func _move(delta:float, current:Vector2, direction:Vector2) -> Vector2:
	var x := current.x
	var y := current.y
	if direction == Vector2.ZERO:
		x = move_toward(x, 0, delta * FRICTION)
		y = move_toward(y, 0, delta * FRICTION)
	else:
		x = move_toward(x, direction.x * _data.get_stat(&"speed"), delta * ACCELERATION)
		y = move_toward(y, direction.y * _data.get_stat(&"speed"), delta * ACCELERATION)
	var result := Vector2(x,y)
	result.clampf(-70, 70)
	return result
