class_name LevelData extends Resource


@export var rooms:Array[RoomData]

var _current_room := -1


func get_next_room() -> RoomData:
	_current_room += 1
	return rooms[_current_room] if _current_room < rooms.size() else null
