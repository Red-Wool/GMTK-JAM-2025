class_name PointerGridObject extends GridObject

func _action(proj : AttackProjectile, dir : Vector2i) -> bool:
	var flag = proj.velocity != direction
	proj._change_velocity(direction)
	
	return flag
