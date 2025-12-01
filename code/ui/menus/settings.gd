class_name Settings extends RidControl


const CONFIRM_TITLE := "confirm_popup_title"
const CONFIRM_DESCRIPTION := "confirm_popup_description"
const TIMED_CHANGE_TITLE := "timed_change_popup_title"
const TIMED_CHANGE_DESC := "timed_change_popup_desc"


var _data:DataManager = null:
	get:
		if _data == null: _data = get_tree().get_first_node_in_group(&"data_manager")
		return _data
var _gm:GameManager = null:
	get:
		if _gm == null: _gm = get_tree().get_first_node_in_group(&"game_manager")
		return _gm
var _master := 1.0
var _music := 1.0
var _sfx := 1.0
var _dyslexic := false
var _locale := "en"
var _window_mode := GameManager.Window_Mode.FULLSCREEN
var _resolution := 2

@onready var btn_back: Button = %btn_back


func _ready() -> void:
	Signals.setting_slider_updated.connect(_slider_updated)
	Signals.settings_button_pressed.connect(_button_pressed)
	Signals.settings_dropdown_changed.connect(_dropdown_updated)
	Signals.popup_result.connect(_check_popup_results)
	btn_back.pressed.connect(_btn_back_pressed)


func toggle_ridcontrol(_id:StringName = id, display := false) -> void:
	if _id == id:
		# do something here
		if display:
			print("displaying setting")
			_update_settings()
			show()
		else:
			hide()


func _update_settings() -> void:
	_master = _data.loaded_save_file.master_volume
	_music = _data.loaded_save_file.music_volume
	_sfx = _data.loaded_save_file.sfx_volume
	_dyslexic = _data.loaded_save_file.dyslexic_font
	_locale = _data.loaded_save_file.language
	_window_mode = _data.loaded_save_file.window_mode
	_resolution = _data.loaded_save_file.resolution
	Signals.update_setting_from_data.emit(&"Master", _master)
	Signals.update_setting_from_data.emit(&"Music", _music)
	Signals.update_setting_from_data.emit(&"SFX", _sfx)
	Signals.update_setting_from_data.emit(&"dyslexic_friendly", _dyslexic)
	Signals.generate_dropdown_items.emit(&"language", _gm.LOCALES)
	Signals.update_setting_from_data.emit(&"language", _gm.LOCALES.find(_locale))
	Signals.generate_dropdown_items.emit(&"window_mode", _generate_window_modes())
	Signals.update_setting_from_data.emit(&"window_mode", _window_mode)
	Signals.generate_dropdown_items.emit(&"resolution", _generate_resolutions())
	Signals.update_setting_from_data.emit(&"resolution", _resolution)


func _generate_window_modes() -> Array[String]:
	var result:Array[String] = []
	for item in _gm.Window_Mode.keys():
		result.append(item)
	return result


func _generate_resolutions() -> Array[String]:
	var result:Array[String] = []
	for item in _gm.WINDOW_SIZES:
		var text:String = str(item.x) + "x" + str(item.y)
		result.append(text)
	return result


func _btn_back_pressed() -> void:
	if _check_changes():
		Signals.display_large_popup.emit(&"confirm_changes", tr(CONFIRM_TITLE), tr(CONFIRM_DESCRIPTION), false)
	else:
		Signals.toggle_display.emit(previous, true)
		Signals.toggle_display.emit(id, false)


func _check_changes() -> bool:
	var result := false
	if _master != _data.loaded_save_file.master_volume: result = true
	if _music != _data.loaded_save_file.music_volume: result = true
	if _sfx != _data.loaded_save_file.sfx_volume: result = true
	if _dyslexic != _data.loaded_save_file.dyslexic_font: result = true
	return result


func _slider_updated(slider_id:StringName, value:float) -> void:
	match slider_id:
		&"Master", &"Music", &"SFX":
			Signals.update_bus_volume.emit(slider_id, value)
			if slider_id == &"Master": _master = value
			if slider_id == &"Music": _music = value
			if slider_id == &"SFX": _sfx = value
		_:
			pass


func _button_pressed(btn_id:StringName, is_on:bool) -> void:
	match btn_id:
		&"dyslexic_friendly":
			_dyslexic = is_on
			Signals.update_font.emit(is_on)
		_:
			pass


func _dropdown_updated(dd_id:StringName, value:int) -> void:
	match dd_id:
		&"language":
			_locale = _gm.LOCALES[value]
			Signals.update_language.emit(_gm.LOCALES[value])
			Signals.display_large_popup.emit(&"language", TIMED_CHANGE_TITLE, TIMED_CHANGE_DESC, true)
		&"window_mode":
			_window_mode = value as GameManager.Window_Mode
			Signals.update_window_mode.emit(_window_mode, _resolution)
			Signals.display_large_popup.emit(&"window_mode", TIMED_CHANGE_TITLE, TIMED_CHANGE_DESC, true)
		&"resolution":
			_resolution = value
			Signals.update_resolution.emit(_resolution)
			Signals.display_large_popup.emit(&"resolution", TIMED_CHANGE_TITLE, TIMED_CHANGE_DESC, true)
		_:
			pass


func _check_popup_results(_id:StringName, result:bool) -> void:
	match _id:
		&"confirm_changes":
			if result:
				_save_changes()
				_btn_back_pressed()
		&"language":
			if result:
				_data.loaded_save_file.language = _locale
				Signals.save.emit()
			else:
				_locale = _data.loaded_save_file.language
				Signals.update_language.emit(_locale)
				Signals.update_setting_from_data.emit(&"language", _gm.LOCALES.find(_locale))
		&"window_mode":
			if result:
				_data.loaded_save_file.window_mode = _window_mode
				Signals.save.emit()
			else:
				_window_mode = _data.loaded_save_file.window_mode
				Signals.update_window_mode.emit(_window_mode, _resolution)
				Signals.update_setting_from_data.emit(&"window_mode", _window_mode)
		&"resolution":
			if result:
				_data.loaded_save_file.resolution = _resolution
				Signals.save.emit()
			else:
				_resolution = _data.loaded_save_file.resolution
				Signals.update_resolution.emit(_resolution)
				Signals.update_setting_from_data.emit(&"resolution", _resolution)
		_:
			pass


func _save_changes() -> void:
	if _data.loaded_save_file.master_volume != _master: _data.loaded_save_file.master_volume = _master
	if _data.loaded_save_file.music_volume != _music: _data.loaded_save_file.music_volume = _music
	if _data.loaded_save_file.sfx_volume != _music: _data.loaded_save_file.sfx_volume = _sfx
	if _data.loaded_save_file.dyslexic_font != _dyslexic: _data.loaded_save_file.dyslexic_font = _dyslexic
	Signals.save.emit()
