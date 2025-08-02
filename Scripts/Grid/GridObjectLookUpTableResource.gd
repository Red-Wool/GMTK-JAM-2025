class_name GridObjectLookUpTableResource extends Resource

@export var object_table : Dictionary

func _has(object_name : String):
	return object_table.has(object_name)

func _get_object(object_name : String) -> String:
	return object_table[object_name]
