class_name AudioFile extends Resource


@export var audio_name := &""
@export var _file:Array[AudioStream]
@export var _pitch:Vector2 = Vector2(0.9, 1.1)
@export var db:float = -10.0
@export var is_unique:bool = false
@export var is_music:bool = false


var audio:AudioStream:
	get:
		return _file.pick_random()
var pitch:float:
	get:
		return randf_range(_pitch.x, _pitch.y)
