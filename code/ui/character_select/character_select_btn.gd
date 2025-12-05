class_name CharacterSelectBtn extends Control


@export var character_data:CharacterData

var is_locked := false
var is_disabled:bool:
	get:
		return character_data == null
var _hovered := false

@onready var selected: Panel = %selected
@onready var character_visual: TileMapLayer = %character_visual
@onready var normal: Panel = %normal
@onready var hover: Panel = %hover
@onready var disabled: Panel = %disabled


func _input(event: InputEvent) -> void:
	if _hovered and not is_disabled:
		if event.is_action_pressed(&"confirm") or event.is_action_pressed(&"mouse_left"):
			Signals.character_select_press_select_button.emit(character_data.id)


func _ready() -> void:
	Signals.character_select_press_select_button.connect(_select)
	mouse_entered.connect(_mouse_enter)
	mouse_exited.connect(_mouse_exit)
	_setup_btn()


func _mouse_enter() -> void:
	if not is_locked and not is_disabled:
		Signals.update_displayed_character.emit(character_data)
		normal.hide()
		hover.show()
		_hovered = true


func _mouse_exit() -> void:
	if not is_locked and not is_disabled:
		normal.show()
		hover.hide()
		_hovered = false


func _setup_btn() -> void:
	if is_disabled:
		character_visual.hide()
		normal.hide()
		hover.hide()
		disabled.show()
	else:
		character_visual.set_cell(Vector2i.ZERO, 0, character_data.image_coords)
		normal.show()
		hover.hide()
		disabled.hide()


func _select(_id:StringName) -> void:
	if character_data != null and character_data.id == _id:
		selected.show()
		Signals.character_select_select_character.emit(character_data)
	else:
		selected.hide()
