class_name LoadingScreen extends RidControl


const DELAY := 0.25


var _timer := 0.0
var _current := 0:
	set(value):
		_current = value
		if _current > loading_text.text.length(): _current = 0
		elif _current < 0: _current = loading_text.text.length()
		loading_text.visible_characters = _current
@onready var loading_text: Label = %loading_text


func _ready() -> void:
	visibility_changed.connect(_visibility_changed)


func _process(delta: float) -> void:
	if visible: 
		_timer += delta
		if _timer >= DELAY: 
			_current += 1
			_timer = 0.0
		

func _visibility_changed() -> void:
	_current = loading_text.text.length()
