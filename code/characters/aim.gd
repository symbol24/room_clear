class_name Aim extends Node2D


@onready var aim_line: Line2D = %aim_line
@onready var marker: Node2D = %marker

var _parent:Character = null:
	get:
		if _parent == null: _parent = get_parent() as Character
		return _parent


func _process(_delta: float) -> void:
	if _parent != null and _parent.get_active():
		var pos:Vector2 = get_global_mouse_position()
		marker.global_position = pos
		aim_line.look_at(pos)
