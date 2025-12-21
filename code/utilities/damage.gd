class_name Damage extends Resource


enum Type {PHYSICAL, FIRE, COLD, LIGHTNING}


@export var value := 0
@export var crit_chance := 0.0
@export var crit_damage := 0.0
@export var is_crit := false
@export var type:Type
@export var damage_owner:EntityData


func setup_damage(new_owner:EntityData) -> void:
	damage_owner = new_owner
	value += damage_owner.get_stat(&"attack_power")
	crit_chance += damage_owner.get_stat(&"crit_chance")
	crit_damage += damage_owner.get_stat(&"crit_damage")


func get_final_damage() -> int:
	var result:float = value
	if _get_if_crit():
		result += value * crit_damage
		if crit_chance > 1.0:
			result += value * (0.1 * (crit_chance - 1.0))
	return roundi(result)


func _get_if_crit() -> bool:
	if randf() <= crit_chance: is_crit = true
	return is_crit
