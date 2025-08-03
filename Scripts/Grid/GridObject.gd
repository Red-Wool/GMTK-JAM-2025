class_name GridObject extends Node2D

@export var direction : Vector2i 
var grid_position : Vector2i

var is_dead : bool

func _action(proj : AttackProjectile, dir : Vector2i) -> bool:
	return false
