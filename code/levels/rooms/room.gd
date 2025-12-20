class_name Room extends Node2D


const DOOR_CLOSED := Vector2i(4,1)
const DOOR_OPEN := Vector2i(0,1)


var data:RoomData

@onready var outline: TileMapLayer = %outline
@onready var spawn_point: Marker2D = %spawn_point
@onready var transfer_area: Area2D = %transfer_area
@onready var transfer_collider: CollisionShape2D = %transfer_collider


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	Signals.room_start.connect(_room_start)


func setup_room(new_data:RoomData) -> void:
	data = new_data
	_set_outline()
	outline.set_cell(Vector2i(21,0), 0, DOOR_CLOSED) # Door


func _set_outline() -> void:
	var x := 0
	var y := 0
	while x <= 23:
		outline.set_cell(Vector2i(x+10, 0), 0, data.get_outline_coord())
		x += 1
	while y <= 23:
		outline.set_cell(Vector2i(10, y), 0, data.get_outline_coord())
		y += 1
	x = 0
	y = 0
	while x <= 23:
		outline.set_cell(Vector2i(x+10, 23), 0, data.get_outline_coord())
		x += 1
	while y <= 23:
		outline.set_cell(Vector2i(33, y), 0, data.get_outline_coord())
		y += 1


func _room_clear() -> void:
	outline.set_cell(Vector2i(21,0), 0, DOOR_CLOSED) # open door
	transfer_collider.disabled = false


func _transfer_area_entered(_area:Area2D) -> void:
	Signals.toggle_character_active.emit(false)
	Signals.load_next_room.emit()


func _room_start() -> void:
	Signals.start_spawning_enemies.emit(data)
