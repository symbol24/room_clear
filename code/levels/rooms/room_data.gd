class_name RoomData extends Resource


@export var outline_coords:Array[Vector2i]

@export var enemy_waves:Array[EnemyWave]


func get_outline_coord() -> Vector2i:
	return outline_coords.pick_random()
