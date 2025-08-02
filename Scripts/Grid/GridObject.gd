class_name GridObject extends Node2D

@export var direction : Vector2i 

func _action(proj : AttackProjectile, dir : Vector2i) -> bool:
	return false
