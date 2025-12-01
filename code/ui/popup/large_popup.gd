class_name LargePopup extends Control


const DELAY := 15


var _id := &""
var _current := 15:
	set(value):
		_current = value
		timer_label.text = str(_current)
		if _current <= 0:
			_cancel()
var _timer := 0.0:
	set(value):
		_timer = value
		if _timer >= 1.0:
			_timer = 0.0
			_current -= 1
var _timer_active := false

@onready var title: Label = %title
@onready var description: Label = %description
@onready var timer_label: Label = %timer_label
@onready var btn_confirm: Button = %btn_confirm
@onready var btn_cancel: Button = %btn_cancel


func _ready() -> void:
	btn_confirm.pressed.connect(_confirm)
	btn_cancel.pressed.connect(_cancel)


func _process(delta: float) -> void:
	if visible and _timer_active: _timer += delta


func display_popup(new_id:StringName, new_title:String, new_description:String, use_timer:bool) -> void:
	_id = new_id
	title.text = new_title
	description.text = new_description
	if use_timer:
		_timer_active = true
		_current = DELAY
		timer_label.show()
	else:
		_timer_active = false
		timer_label.hide()
	
	show()


func _cancel() -> void:
	hide()
	Signals.popup_result.emit(_id, false)
	_id = &""


func _confirm() -> void:
	hide()
	Signals.popup_result.emit(_id, true)
	_id = &""
