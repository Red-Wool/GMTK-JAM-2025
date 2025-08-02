extends Node

func _align(direction : Vector2i) -> float:
	match direction:
		Vector2i.RIGHT:
			return 0
		Vector2i.LEFT:
			return 180
		Vector2i.UP:
			return -90
		Vector2i.DOWN:
			return 90
	
	return 0

func _rotate(direction : Vector2i, rotations_counter_clockwise : int) -> Vector2i:
	var list : Array[Vector2i] = [Vector2i.RIGHT,Vector2i.DOWN,Vector2i.LEFT,Vector2i.UP]
	
	var index : int = list.find(direction)
	if index == -1:
		return direction
	
	return list[(index + rotations_counter_clockwise) % 4]
