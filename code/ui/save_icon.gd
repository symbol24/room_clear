class_name SaveIcon extends Control


const FLASH_COUNT := 3
const FLASH_TIME := 1.0


@onready var icon: TextureRect = %icon


func _ready() -> void:
	icon.modulate = Color.TRANSPARENT


func display_icon() -> void:
	var tween := create_tween()
	for i in FLASH_COUNT:
		tween.tween_property(icon, "modulate", Color.WHITE, FLASH_TIME)
		tween.tween_property(icon, "modulate", Color.TRANSPARENT, FLASH_TIME)
