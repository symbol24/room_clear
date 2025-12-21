class_name HurtBox extends Area2D


var _parent:Entity = null:
	get:
		if _parent == null: _parent = get_parent() as Entity
		return _parent
var _collider:CollisionShape2D = null:
	get:
		if _collider == null: _collider = get_child(0) as CollisionShape2D
		return _collider


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(_area:Area2D) -> void:
	if _area is Attack and _area.damage.damage_owner != _parent.get_data():
		print(_area.get_damage().value)
		_parent.apply_damage(_area.get_damage())
		_collider.set_disabled.call_deferred(true)
