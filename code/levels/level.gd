class_name Level extends Node2D


const ROOM := preload("uid://73vsmr7y8pbp")
const Y_OFFSET := 528.0


var active_room:Room
var level_data:LevelData
var _character_ready := false
var _gm:GameManager = null:
	get:
		if _gm == null: _gm = get_tree().get_first_node_in_group(&"game_manager")
		return _gm
var _previous_room:Room


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	Signals.load_next_room.connect(_spawn_next_room)
	Signals.ready_checklist.connect(_check_is_all_ready)
	Signals.toggle_display.emit(&"play_ui", true)
	level_data = _gm.active_level
	_spawn_next_room()
	await get_tree().create_timer(0.2).timeout
	Signals.spawn_character.emit(_gm.active_character)


func _check_is_all_ready(_id:StringName) -> void:
	if _id == &"character": _character_ready = true

	if _character_ready: 
		Signals.toggle_display.emit(&"loading_screen", false)
		Signals.toggle_pause.emit(false)
		Signals.toggle_character_active.emit(true)
		Signals.start_room_timer.emit()


func _spawn_next_room() -> void:
	if active_room != null:
		if _previous_room != null: 
			var temp = _previous_room
			_previous_room = null
			temp.queue_free.call_deferred()
		
		_previous_room = active_room
		active_room = null

	active_room = ROOM.instantiate()
	active_room.global_position.y = _previous_room.y - Y_OFFSET if _previous_room != null else 0.0
	add_child(active_room)
	if not active_room.is_node_ready(): await active_room.ready
	active_room.setup_room(level_data.get_next_room())
