class_name CommandResource extends Resource

@export var command_name : String
@export var can_choose_direction : bool

@export var sprite : Texture2D

func _do_action (grid : GridManager, pos : Vector2i, dir : Vector2i = Vector2i.ZERO):
	pass 
