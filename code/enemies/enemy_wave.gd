class_name EnemyWave extends Resource


@export var enemy_datas:Array[EnemyData]
@export var wave_count := 1
@export var enemies_per_wave := 1
@export var delay_between_waves := 0.5


func get_enemy_to_spawn() -> EnemyData:
	return enemy_datas.pick_random() if not enemy_datas.is_empty() else null
