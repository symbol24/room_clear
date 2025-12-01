extends Node


# UI
signal toggle_display(id:StringName, display:bool)
signal display_save_icon
signal update_setting_from_data(id:StringName, value:Variant)
signal setting_slider_updated(id:StringName, value:float)
signal settings_button_pressed(id:StringName, is_on:bool)
signal settings_dropdown_changed(id:StringName, value:bool)
signal generate_dropdown_items(id:StringName, values:Array[String])
signal display_large_popup(id:StringName, title:String, description:String, use_timer:bool)
signal display_small_popup(description:String)
signal popup_result(id:StringName, is_confirmed:bool)

# Scene Manager
signal load_scene(id:StringName, display_loading:bool, extra_time:bool)
signal scene_manager_load_complete

# Game Manager
signal toggle_pause(value:bool)
signal update_window_mode(mode:GameManager.Window_Mode, resolution_choice:int)
signal update_resolution(choice:int)
signal update_font(is_dyslexia_friendly:bool)
signal update_language(locale:String)

# Audio Manager
signal volumes_updated()
signal update_bus_volume(bus:StringName, value:float)
signal play_audio(audio_file:AudioFile)
signal audio_finished(audio_stream_player:RidAudioStreamPlayer)

# Data Manager
signal save
signal load
signal save_result(code:int)
signal load_result(code:int)
