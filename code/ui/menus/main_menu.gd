class_name MainMenu extends RidControl


const QUIT_TITLE := "quit_title"
const QUIT_DESC := "quit_desc"


@export var btn_pressed_audio:AudioFile
@export var play_target := &""

@onready var btn_play: Button = %btn_play
@onready var btn_settings: Button = %btn_settings
@onready var btn_how_to: Button = %btn_how_to
@onready var btn_credits: Button = %btn_credits
@onready var btn_quit: Button = %btn_quit


func _ready() -> void:
	Signals.popup_result.connect(_popup_result)
	btn_play.pressed.connect(_btn_play_pressed)
	btn_settings.pressed.connect(_btn_settings_pressed)
	btn_how_to.pressed.connect(_btn_howto_pressed)
	btn_credits.pressed.connect(_btn_credits_pressed)
	btn_quit.pressed.connect(_btn_quit_pressed)


func _btn_play_pressed() -> void:
	if play_target != &"": Signals.load_scene.emit(play_target, true, true)


func _btn_settings_pressed() -> void:
	Signals.toggle_display.emit(&"settings", true)
	toggle_ridcontrol(id, false)


func _btn_howto_pressed() -> void:
	Signals.toggle_display.emit(&"how_to", true)
	toggle_ridcontrol(id, false)


func _btn_credits_pressed() -> void:
	Signals.toggle_display.emit(&"credits", true)
	toggle_ridcontrol(id, false)


func _btn_quit_pressed() -> void:
	Signals.display_large_popup.emit(&"quit_popup", QUIT_TITLE, QUIT_DESC, false)


func _popup_result(_id:StringName, _result:bool) -> void:
	if _id == &"quit_popup" and _result:
		get_tree().quit()
