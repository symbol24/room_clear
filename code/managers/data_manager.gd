class_name DataManager extends Node


const FOLDER = "user://save/"
const EXTENSION = "tres"


var loaded_save_file:SaveData
var all_save_data:Array[SaveData] = []


func _init() -> void:
	add_to_group(&"data_manager")
	name = &"data_manager"
	process_mode = PROCESS_MODE_ALWAYS


func _ready() -> void:
	Signals.save.connect(_save_file)
	Signals.load.connect(_load_file)
	_check_for_first_save()
	all_save_data = _get_all_saves()
	loaded_save_file = _get_last_saved_save()


func _save_file() -> void:
	if loaded_save_file == null:
		loaded_save_file = SaveData.new()
		loaded_save_file.id = all_save_data.size()
		loaded_save_file.file_name = str(hash(loaded_save_file.id))
	
	# TODO: Place whatever information you want in the SaveData
	# or retrieve the data you want and add it to the save
	
	loaded_save_file.save_time_and_date = Time.get_unix_time_from_system()
	ResourceSaver.save(loaded_save_file, FOLDER + loaded_save_file.file_name + "." + EXTENSION)
	Signals.save_result.emit(0)
	Signals.display_save_icon.emit()


func _load_file(id:int = 0) -> void:
	loaded_save_file = _get_save_from_id(id)
	Signals.load_result.emit(0)


func _get_all_saves() -> Array[SaveData]:
	var saves:Array[SaveData] = []
	var dir:DirAccess = _check_folder()
	if dir != null:
		var files:PackedStringArray = dir.get_files()
		for file in files:
			if file.get_extension() == EXTENSION:
				saves.append(load(FOLDER + file))
	return saves


func _check_folder() -> DirAccess:
	var dir:DirAccess = DirAccess.open(FOLDER)
	if dir == null:
		var result = DirAccess.make_dir_absolute(FOLDER)
		if result != OK:
			print_debug("Error creating save folder: ", result)
			return null
	return dir


func _get_save_from_id(id:int) -> SaveData:
	for each in all_save_data:
		if each.id == id: return each
	return null


func _get_last_saved_save() -> SaveData:
	var _save:SaveData = null
	for each in all_save_data:
		if _save == null:
			_save = each
		elif each.save_time_and_date > _save.save_time_and_date:
			_save = each
	return _save


func _check_for_first_save() -> void:
	if _get_all_saves().is_empty():
		_save_file()
