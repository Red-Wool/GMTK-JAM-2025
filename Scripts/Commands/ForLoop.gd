class_name ForLoop extends Node2D

var is_dead : bool

var commands : Array[CommandResource]

@onready var sprite : Sprite2D = $CharacterSprite
@onready var command_display : CommandDisplay = $CommandArea

var max_item_count : int = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _setup(c : Array[CommandResource]):
	commands = c
	_display()

func _try_select(index : int) -> bool:
	if index >= commands.size():
		return false
	return true

func _use_command(index : int):
	

func _hurt():
	commands.

func _display():
	command_display._update_sprites(commands)
