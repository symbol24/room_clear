class_name SpawnManager extends Node2D


const CHARACTER := preload("uid://jby7lgv0mata")
const ENEMY := preload("uid://05ieltwx82n6")
const DELAY_BETWEEN_SPAWNS := 1.0
const DELAY_BETWEEN_WAVES := 15.0


var character:Character = null
var _level:Level = null:
	get:
		if _level == null: _level = get_parent() as Level
		return _level
var _enemy_pool:Array[Enemy]
var _active_room:RoomData = null
var _active_wave:EnemyWave
var _wave_count := 0:
	set(value):
		_wave_count = value
		if _wave_count < _active_room.enemy_waves.size():
			_active_wave = _active_room.enemy_waves[_wave_count]
		else:
			_active_wave = null
			_spawning_active = false
var _spawning_active := false
var _wave_spawning := false
var _wave_delay := 0.0:
	set(value):
		_wave_delay = value
		if _wave_delay <= 0.0:
			_spawn_wave(_active_wave)
			_wave_delay = DELAY_BETWEEN_WAVES


func _ready() -> void:
	Signals.spawn_character.connect(_spawn_character)
	Signals.start_spawning_enemies.connect(_start_room_spawning)


func _process(delta: float) -> void:
	if _spawning_active:
		if not _wave_spawning: _wave_delay -= delta


func _spawn_character(data:CharacterData) -> void:
	character = CHARACTER.instantiate()
	_level.add_child(character)
	if not character.is_node_ready(): await character.ready
	character.name = data.id
	character.setup_character(data)
	for ability:AbilityData in data.abilities:
		if ability.uid != "":
			var new = load(ability.uid).instantiate()
			character.add_child(new)
			if not new.is_node_ready(): await new.ready
			new.name = ability.id
	character.global_position = _level.active_room.spawn_point.global_position
	await get_tree().create_timer(1.5).timeout
	Signals.ready_checklist.emit(&"character")


func _spawn_one_enemy(data:EnemyData, pos:Vector2) -> void:
	var new_enemy:Enemy = _get_enemy()
	_level.add_child(new_enemy)
	if not new_enemy.is_node_ready(): await new_enemy.ready
	new_enemy.global_position = pos
	new_enemy.setup_enemy(data)


func _get_enemy() -> Enemy:
	if _enemy_pool.is_empty(): return ENEMY.instantiate()
	return _enemy_pool.pop_front()


func _get_enemy_spawn_position() -> Vector2:
	return Vector2(randf_range(200, 328), randf_range(100, 188))


func _spawn_enemies(data:EntityData, amount:int) -> void:
	for x in amount:
		#print("Spawning enemy: ", x)
		await _spawn_one_enemy(data, _get_enemy_spawn_position())
		await get_tree().create_timer(DELAY_BETWEEN_SPAWNS).timeout


func _spawn_wave(wave:EnemyWave) -> void:
	_wave_spawning = true
	#print("Spawning main wave: ", _wave_count)
	for x in wave.wave_count:
		#print("Spawning sub wave: ", x)
		await _spawn_enemies(wave.get_enemy_to_spawn(), wave.enemies_per_wave)
		await get_tree().create_timer(wave.delay_between_waves).timeout
	_wave_count += 1
	_wave_spawning = false


func _start_room_spawning(new_room_data:RoomData) -> void:
	if new_room_data != null:
		_active_room = new_room_data
		_wave_count = 0
		_wave_delay = 0.1
		_active_wave = _active_room.enemy_waves[_wave_count]
		_spawning_active = true
		_wave_spawning = false
