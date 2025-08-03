class_name LevelResource extends Resource

@export var level_name : String

@export var grid_data : GridLevelResource

@export var commands : Array[CommandResource]

@export var while_loop_hp : int
@export var attack_data : Array[WhileAttackResource]

#put more data later

func _duplicate_commands() -> Array[CommandResource]:
	var c : Array[CommandResource]
	for command : CommandResource in commands:
		c.append(command.duplicate(true))
	
	return c
