class_name PointerGridObject extends GridObject

@onready var anim : AnimationPlayer = $AnimationPlayer

func _action(proj : AttackProjectile, dir : Vector2i) -> bool:
	var flag = proj.velocity != direction
	proj._change_velocity(direction)
	
	_anim()
	
	return flag

func _anim():
	anim.play("flash")
	await get_tree().create_timer(.2).timeout
	anim.play("idle")
