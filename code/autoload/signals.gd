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
signal update_displayed_character(data:CharacterData)
signal character_select_press_select_button(id:StringName)
signal character_select_select_character(data:CharacterData)
signal ability_timer(id:StringName, value:float)
signal start_room_timer
signal display_damage_number(value:int, type:Damage.Type, is_crit:bool, pos:Vector2)
signal armor_updated(current_value:int, max_value:int)
signal hp_uipdated(current_value:int, max_value:int)

# Scene Manager
signal load_scene(id:StringName, display_loading:bool, extra_time:bool)
signal scene_manager_load_complete

# Game Manager
signal toggle_pause(value:bool)
signal update_window_mode(mode:GameManager.Window_Mode, resolution_choice:int)
signal update_resolution(choice:int)
signal update_font(is_dyslexia_friendly:bool)
signal update_language(locale:String)
signal select_character(data:CharacterData)
signal select_level(data:LevelData)

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

# Spawn Manager
signal spawn_character(data:CharacterData)
signal spawn_enemies(data:EntityData, amount:int)
signal start_spawning_enemies(data:RoomData)

# Utilities
signal assigne_remote_path_to_camera(new_path:NodePath)
signal ready_checklist(id:StringName)

# Level
signal room_start
signal load_next_room

# Character
signal toggle_character_active(value:bool)
