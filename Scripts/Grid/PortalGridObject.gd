class_name PortalGridObject extends GridObject

@onready var anim : AnimationPlayer = $AnimationPlayer

func _ready():
	PortalManager.portalArray.append(self)
	pass

func _action(proj : AttackProjectile, dir : Vector2i) -> bool:
	var other_portal : PortalGridObject = PortalManager._find_portal(self)
	
	_anim(proj, other_portal.grid_position)
	proj.grid_position = other_portal.grid_position
	
	return true

func _anim(proj : AttackProjectile, pos : Vector2i):
	
	await get_tree().create_timer(.2).timeout
	anim.play("flash")
	position = proj.grid_manager._grid_to_world_position(pos)
	await get_tree().create_timer(.2).timeout
	anim.play("idle")
