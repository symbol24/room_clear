class_name Entity extends CharacterBody2D


const ACCELERATION := 700.0
const FRICTION := 1100.0


@onready var sprite: TileMapLayer = %sprite

var _gm:GameManager = null:
	get:
		if _gm == null: _gm = get_tree().get_first_node_in_group(&"game_manager")
		return _gm
var _active := false: get = get_active
var _data:EntityData
var _hurt_box:HurtBox
var _direction := Vector2.ZERO


func apply_damage(_damage:Damage) -> void:
	print("Damage received")
	var dmg:int = _damage.get_final_damage()
	dmg = _data.update_armor(-dmg)
	
	if dmg < _damage.get_final_damage() and not _gm.debug_damage_roll_over: 
		return
	else:
		_data.update_hp(-dmg)


func get_data() -> EntityData:
	return _data


func get_active() -> bool:
	return _active


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


func _get_hurtbox() -> HurtBox:
	var found := false
	for each in get_children():
		if each is HurtBox:
			return each
	assert(found, "No Hurtbox found on " + name)
	return null
