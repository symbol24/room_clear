class_name Ability extends Node2D


var data:AbilityData
var _delay_on := false
var _ability_triggered := false
var _timer:float = 0.0:
	set(value):
		_timer = value
		if _timer <= 0.0:
			_delay_on = false
			_ability_triggered = false
			_timer = data.starting_delay
		Signals.ability_timer.emit(data.id, _timer)


func _process(delta: float) -> void:
	if _delay_on: _timer -= delta


func trigger_ability(_option:Variant) -> void:
	if not _ability_triggered:
		_ability_triggered = true
		_delay_on = true
