class_name SceneManager extends Node


const EXTRA_TIME := 1.0
const SCENES := preload("uid://cyyxj7gx442mu")


var active_scene:Node = null
var _to_load := ""
var _loading := false
var _progress := []
var _load_complete := false
var _extra_time := false
var _loading_status:ResourceLoader.ThreadLoadStatus


func _init() -> void:
	add_to_group(&"scene_manager")
	name = &"scene_manager"
	process_mode = Node.PROCESS_MODE_ALWAYS


func _ready() -> void:
	Signals.load_scene.connect(_load_scene)


func _process(_delta: float) -> void:
	if _loading:
		_loading_status = ResourceLoader.load_threaded_get_status(_to_load, _progress)
		#print("loading ", _to_load , ": ", _progress[0]*100, "%")
		if _loading_status == ResourceLoader.THREAD_LOAD_LOADED:
			if not _load_complete:
				_load_complete = true
				_complete_load()


func _load_scene(id:StringName, display_loading:bool, extra_time:bool = false) -> void:
	if id == &"":
		push_warning("id to load string is empty, nothing to load.")
		return

	if not SCENES.list.has(id):
		push_warning("id to load string is missing from scenes ressource, nothing to load.")
		return

	if display_loading: Signals.toggle_display.emit(&"loading_screen", true)

	if active_scene != null:
		var temp = active_scene
		active_scene = null
		get_tree().root.remove_child(temp)
		temp.queue_free.call_deferred()

	_to_load = SCENES.list[id]
	_loading = true
	_extra_time = extra_time
	_load_complete = false
	ResourceLoader.load_threaded_request(_to_load)
	_loading_status = ResourceLoader.load_threaded_get_status(_to_load)
	_loading_status = ResourceLoader.load_threaded_get_status(_to_load, _progress)


func _complete_load() -> void:
	_loading = false
	active_scene = ResourceLoader.load_threaded_get(_to_load).instantiate()
	get_tree().root.add_child.call_deferred(active_scene)
	if not active_scene.is_node_ready(): await active_scene.ready
	if _extra_time: await get_tree().create_timer(EXTRA_TIME).timeout
	if not active_scene is Level:
		Signals.toggle_pause.emit(false)
		Signals.toggle_display.emit(&"loading_screen", false)
