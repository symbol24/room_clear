class_name GameManager extends Node


const DEFAULT_FONT := preload("uid://cloau38b4wikc")
const DYSLEXIA_FONT := preload("uid://jkiaci5nw4q1")
const DEFAULT_THEME:Theme = preload("uid://bv127b8g6qnhn")
const WINDOW_SIZES:Array[Vector2i] = [
	Vector2i(3840, 2160), 
	Vector2i(2560, 1440), 
	Vector2i(1920, 1080), 
	Vector2i(1366, 768), 
	Vector2i(1280, 720), 
	Vector2i(1920, 1200), 
	Vector2i(1680, 1050), 
	Vector2i(1440, 900), 
	Vector2i(1280, 800), 
	Vector2i(1024, 768), 
	Vector2i(800, 600), 
	Vector2i(640, 480), 
	]
const LOCALES:Array[String] = [
	"en",
	"fr",
	"fr-CA"
]


enum Window_Mode {
	FULLSCREEN = 0,
	WINDOWED = 1,
	BORDERLESS_WINDOWED = 2,
}


var theme:Theme
var active_character:CharacterData = null
var _data:DataManager = null:
	get:
		if _data == null: _data = get_tree().get_first_node_in_group(&"data_manager")
		return _data


func _init() -> void:
	add_to_group(&"game_manager")
	name = &"game_manager"
	process_mode = PROCESS_MODE_ALWAYS
	theme = DEFAULT_THEME


func _ready() -> void:
	Signals.update_resolution.connect(_update_resolution)
	Signals.update_window_mode.connect(_update_window_mode)
	Signals.update_font.connect(_update_font)
	Signals.update_language.connect(_update_display_language)
	Signals.toggle_pause.connect(_toggle_pause)
	Signals.select_character.connect(_select_character)


func _toggle_pause(value:bool) -> void:
	get_tree().paused = value


func _update_window_mode(_mode:Window_Mode, resolution_choice:int) -> void:
	match _mode:
		Window_Mode.BORDERLESS_WINDOWED:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			get_window().set_size(WINDOW_SIZES[resolution_choice])
		Window_Mode.WINDOWED:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			get_window().set_size(WINDOW_SIZES[resolution_choice])
		_:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _update_resolution(resolution_choice:int) -> void:
	get_window().size = WINDOW_SIZES[resolution_choice]


func _update_font(is_dyslexia_friendly := false) -> void:
	if is_dyslexia_friendly:
		theme.set_default_font(DYSLEXIA_FONT)
	else:
		theme.set_default_font(DEFAULT_FONT)


func _update_display_language(locale := "en") -> void:
	locale = locale if locale in LOCALES else LOCALES[0]
	TranslationServer.set_locale(locale)


func _select_character(data:CharacterData) -> void:
	active_character = data.duplicate(true)
