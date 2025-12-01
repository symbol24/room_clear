class_name AudioManager extends Node


const MIN_DB := -60.0
const MAX_DB := 0.0
const MUSIC_FADE_TIME := 2.0
const BTN_SOUND := preload("uid://ghdpasia543e")


var _music:RidAudioStreamPlayer = null
var _unique_audio:RidAudioStreamPlayer = null
var _all_audio:Array[RidAudioStreamPlayer] = []
var _to_remove:Array[RidAudioStreamPlayer] = []
var _removing := false


func _init() -> void:
	add_to_group(&"audio_manager")
	name = &"audio_manager"
	process_mode = Node.PROCESS_MODE_ALWAYS


func _ready() -> void:
	Signals.play_audio.connect(_play_audio)
	Signals.update_bus_volume.connect(_update_bus_volume)


func _process(_delta: float) -> void:
	if not _removing and not _to_remove.is_empty(): _remove_audio_stream(_to_remove.pop_front())


func _play_audio(audio:AudioFile = null) -> void:
	if audio == null:
		push_warning("Audio manager received no audio file.")
		return

	if audio.is_unique and _unique_audio != null and _unique_audio.playing:
		push_warning("Unique audio already playing.")
		return

	var new_audio := RidAudioStreamPlayer.new(audio)
	add_child(new_audio)
	if not new_audio.is_node_ready(): await new_audio.ready
	new_audio.set_stream(audio.audio)
	new_audio.set_volume_db(audio.db)
	new_audio.set_pitch_scale(audio.pitch)
	new_audio.bus = &"SFX"
	_all_audio.append(new_audio)

	var old:RidAudioStreamPlayer
	var fade := audio.is_music and _music != null and _music.playing
	if audio.is_music:
		if fade:
			old = _music
			new_audio.volume_db = MIN_DB
		new_audio.bus = &"Music"
		_music = new_audio
	elif audio.is_unique:
		_unique_audio = new_audio

	new_audio.play()
	if fade: _fade_music(old, new_audio)


func _add_to_removal(audio_stream:RidAudioStreamPlayer) -> void:
	_to_remove.append(audio_stream)


func _remove_audio_stream(audio_stream:RidAudioStreamPlayer) -> void:
	if _all_audio.has(audio_stream):
		_removing = true
		var i = _all_audio.find(audio_stream)
		var temp = _all_audio.pop_at(i)
		temp.queue_free.call_deferred()
		_removing = true


func _clean_audios() -> void:
	for each in _all_audio:
		if not each.playing:
			each.queue_free()

	while _all_audio.find(null) != -1:
		var i = _all_audio.find(null)
		var _temp = _all_audio.pop_at(i)


func _fade_music(_out:RidAudioStreamPlayer, _in:RidAudioStreamPlayer) -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(_out, "volume_db", MIN_DB, MUSIC_FADE_TIME)
	tween.parallel().tween_property(_in, "volume_db", _in.audio_file.db, MUSIC_FADE_TIME)


func _update_bus_volume(bus:StringName, value:float) -> void:
	var index := AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(index, linear_to_db(value))
