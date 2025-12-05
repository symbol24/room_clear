class_name CharacterData extends EntityData


@export var abilities:Array[AbilityData] = []
var primary:AbilityData = null:
	get:
		if primary == null: primary = _get_ability(&"primary")
		return primary
var secondary:AbilityData = null:
	get:
		if secondary == null: secondary = _get_ability(&"secondary")
		return secondary
var special:AbilityData = null:
	get:
		if special == null: special = _get_ability(&"special")
		return special
var movement:AbilityData = null:
	get:
		if movement == null: movement = _get_ability(&"movement")
		return movement
@export var image_coords:Vector2i

var items:Array = []
var game_manager:GameManager = null


func get_stat(stat:StringName) -> Variant:
	var result
	if get(stat) != null:
		result = get(stat)

		if not items.is_empty(): pass
		if game_manager != null: pass

	return result


func _get_ability(_id:StringName) -> AbilityData:
	for each in abilities:
		if each.id == _id: return each
	return null
