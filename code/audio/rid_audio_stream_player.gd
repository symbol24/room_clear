class_name RidAudioStreamPlayer extends AudioStreamPlayer


var audio_file:AudioFile


func _init(new_file:AudioFile) -> void:
	audio_file = new_file


func _ready() -> void:
	finished.connect(remove_audio)
	name = audio_file.audio_name if audio_file.audio_name != &"" else &"new_audio_0"
	process_mode = PROCESS_MODE_ALWAYS if audio_file.is_music else PROCESS_MODE_PAUSABLE


func remove_audio() -> void:
	Signals.audio_finished.emit(self)
