class_name Boot extends Node


const DELAY := 0.3
const MUSIC := preload("res://data/audio/music.tres")


var _current := &""
var _next := &"godot"
var _can_skip := false
var _can_click := true
var _data:DataManager
@onready var animator: AnimationPlayer = %animator


func _input(_event: InputEvent) -> void:
	if Input.is_anything_pressed() and _can_skip and _can_click:
		_can_click = false
		animator.play(&"RESET")
		await get_tree().create_timer(DELAY).timeout
		_can_click = true


func _ready() -> void:
	animator.animation_finished.connect(_play_next)
	await _load_managers()
	_load_settings()
	await get_tree().create_timer(0.4).timeout
	Signals.play_audio.emit(MUSIC)
	_play_next()
	_can_skip = true


func _play_next(anim_name := &"") -> void:
	match _current:
		&"godot":
			_next = &"rid"
		&"rid":
			_next = &""
		_:
			pass

	match anim_name:
		&"godot":
			_current = &"RESET"
		&"rid":
			_current = &"RESET"
		_:
			_current = _next

	if _current != &"":
		animator.play(_current)
	else:
		_load_next()


func _load_next() -> void:
	Signals.toggle_display.emit(&"main_menu", true)
	queue_free.call_deferred()
	

func _load_managers() -> void:
	var ui := Ui.new()
	get_tree().root.add_child.call_deferred(ui)
	if not ui.is_node_ready(): await ui.ready
	_data = DataManager.new()
	get_tree().root.add_child.call_deferred(_data)
	if not _data.is_node_ready(): await _data.ready
	var sm := SceneManager.new()
	get_tree().root.add_child.call_deferred(sm)
	if not sm.is_node_ready(): await sm.ready
	var am := AudioManager.new()
	get_tree().root.add_child.call_deferred(am)
	if not am.is_node_ready(): await am.ready
	var gm := GameManager.new()
	get_tree().root.add_child.call_deferred(gm)
	if not gm.is_node_ready(): await gm.ready


func _load_settings() -> void:
	Signals.update_window_mode.emit(_data.loaded_save_file.window_mode, _data.loaded_save_file.resolution)
	Signals.update_bus_volume.emit(&"Master", _data.loaded_save_file.master_volume)
	Signals.update_bus_volume.emit(&"Music", _data.loaded_save_file.music_volume)
	Signals.update_bus_volume.emit(&"SFX", _data.loaded_save_file.sfx_volume)
	Signals.update_font.emit(_data.loaded_save_file.dyslexic_font)
	Signals.update_language.emit(_data.loaded_save_file.language)
