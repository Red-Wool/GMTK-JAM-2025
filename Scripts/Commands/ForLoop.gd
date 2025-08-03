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

func _hurt():
	pass
