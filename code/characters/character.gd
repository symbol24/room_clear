class_name Character extends CharacterBody2D


const SPEED := 100.0
const ACCELERATION := 700.0
const FRICTION := 1100.0


var active := false
var _direction := Vector2.ZERO


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE


func _process(delta: float) -> void:
	if active:
		_direction = Input.get_vector("left", "right","up", "down")
		velocity = _move(delta, velocity, _direction)
		move_and_slide()


func _move(delta:float, current:Vector2, direction:Vector2) -> Vector2:
	var x := current.x
	var y := current.y
	if direction == Vector2.ZERO:
		x = move_toward(x, 0, delta * FRICTION)
		y = move_toward(y, 0, delta * FRICTION)
	else:
		x = move_toward(x, direction.x * SPEED, delta * ACCELERATION)
		y = move_toward(y, direction.y * SPEED, delta * ACCELERATION)
	var result := Vector2(x,y)
	result.clampf(-70, 70)
	return result


func _open_pause_menu() -> void:
	Signals.toggle_pause.emit(true)
	Signals.toggle_display.emit(&"pause_menu", true)
