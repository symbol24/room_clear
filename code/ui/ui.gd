class_name Ui extends CanvasLayer


const UIS := preload("uid://ia2rys7jnt44")
const LARGE_POPUP := preload("res://scenes/ui/popup/large_popup.tscn")
const SMALL_POPUP := preload("res://scenes/ui/popup/small_popup.tscn")
const SAVE_ICON := preload("res://scenes/ui/save_icon.tscn")


var _active_ui:RidControl = null
var _all_uis:Array[RidControl] = []
var _large_popup:LargePopup = null
var _small_popup:SmallPopup = null
var _save_icon:SaveIcon = null


func _init() -> void:
	add_to_group(&"ui")
	name = &"ui"
	process_mode = Node.PROCESS_MODE_ALWAYS


func _ready() -> void:
	Signals.toggle_display.connect(_toggle_display)
	Signals.display_large_popup.connect(_display_large_popup)
	Signals.display_small_popup.connect(_display_small_popup)
	Signals.display_save_icon.connect(_display_save_icon)


func _toggle_display(id:StringName, display:bool) -> void:
	if id == &"":
		push_error("No id sent to UI.")
		return
	var temp:RidControl = _get_ridcontrol(id)
	if not temp.is_node_ready(): await temp.ready
	if temp == null: 
		push_error(id, " not found in uis.")
		return
	temp.toggle_ridcontrol(id, display)
	if display:
		move_child(temp, get_child_count())
		if _active_ui != null: temp.previous = _active_ui.id
		_active_ui = temp


func _get_ridcontrol(id:StringName) -> RidControl:
	for each in _all_uis:
		if each.id == id:
			return each

	if id in UIS.list:
		var new:RidControl = load(UIS.list[id]).instantiate()
		add_child.call_deferred(new)
		new.name = id
		_all_uis.append(new)
		return new

	return null


func _display_large_popup(id:StringName, title:String, description:String, use_timer:bool) -> void:
	if _large_popup == null: 
		_large_popup = LARGE_POPUP.instantiate()
		add_child(_large_popup)
		_large_popup.name = &"large_popup"
		if not _large_popup.is_node_ready(): await _large_popup.ready

	move_child(_large_popup, get_child_count())
	_large_popup.display_popup(id, title, description, use_timer)


func _display_small_popup(description:String) -> void:
	if _small_popup == null:
		_small_popup = SMALL_POPUP.instantiate()
		add_child(_small_popup)
		_small_popup.name = &"small_popup"
		if not _small_popup.is_node_ready(): await _small_popup.ready

	move_child(_small_popup, get_child_count())
	_small_popup.display_popup(description)


func _display_save_icon() -> void:
	print("Lets display save icon")
	if _save_icon == null:
		_save_icon = SAVE_ICON.instantiate()
		add_child(_save_icon)
		_save_icon.name = &"save_icon"
		if not _save_icon.is_node_ready(): await _save_icon.ready

	move_child(_save_icon, get_child_count())
	_save_icon.display_icon()
