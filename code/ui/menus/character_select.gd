class_name CharacterSelect extends RidControl


const TEST_LEVEL := preload("uid://7cnc0xtl5mpd")


@export var play_target := &""

var _selected_character:CharacterData = null

@onready var character_image: TileMapLayer = %character_image
@onready var character_name: Label = %character_name
@onready var ability_1: Label = %ability_1
@onready var ability_2: Label = %ability_2
@onready var ability_3: Label = %ability_3
@onready var ability_4: Label = %ability_4
@onready var btn_back: RidButton = %btn_back
@onready var btn_confirm: RidButton = %btn_confirm


func _ready() -> void:
	Signals.update_displayed_character.connect(_update_character_data)
	Signals.character_select_select_character.connect(_select_character)
	btn_back.pressed.connect(_btn_back_pressed)
	btn_confirm.pressed.connect(_btn_confirm_pressed)


func _update_character_data(data:CharacterData) -> void:
	character_image.set_cell(Vector2i.ZERO, 0, data.image_coords)
	character_name.text = data.display_name
	ability_1.text = data.primary.display_name if data.primary != null else ""
	ability_2.text = data.secondary.display_name if data.secondary != null else ""
	ability_3.text = data.special.display_name if data.special != null else ""
	ability_4.text = data.movement.display_name if data.movement != null else ""


func _btn_confirm_pressed() -> void:
	if _selected_character != null and play_target != &"":
		Signals.select_character.emit(_selected_character)
		Signals.select_level.emit(TEST_LEVEL)
		Signals.load_scene.emit(play_target, true, true)
		toggle_ridcontrol(id, false)


func _btn_back_pressed() -> void:
	Signals.toggle_display.emit(&"main_menu", true)
	toggle_ridcontrol(id, false)
	_clear_selected()


func _clear_selected() -> void:
	_selected_character = null
	character_image.clear()
	character_name.text = ""
	ability_1.text = ""
	ability_2.text = ""
	ability_3.text = ""
	ability_4.text = ""


func _select_character(data:CharacterData) -> void:
	_selected_character = data
