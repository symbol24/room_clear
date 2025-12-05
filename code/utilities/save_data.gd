class_name SaveData extends Resource


@export var id:int = 0
@export var file_name:String = ""
@export var save_time_and_date:float = 0.0

@export var master_volume := 0.8
@export var music_volume := 0.8
@export var sfx_volume := 0.8
var default_master_volume := 0.8
var default_music_volume := 0.8
var default_sfx_volume := 0.8

@export var language := "en"
@export var dyslexic_font := false
var default_language := "en"
var default_dyslexic_font := false

@export var resolution := 2
@export var window_mode:GameManager.Window_Mode = GameManager.Window_Mode.FULLSCREEN
var default_resolution := 2
var default_windowmod:GameManager.Window_Mode = GameManager.Window_Mode.FULLSCREEN


@export var player_unlocked_characters:Array[StringName] = []
var default_unlocked_characters:Array[StringName] = []
var unlocked_characters:Array[StringName]:
	get:
		unlocked_characters.clear()
		unlocked_characters.append_array(default_unlocked_characters)
		unlocked_characters.append_array(player_unlocked_characters)
		return unlocked_characters
