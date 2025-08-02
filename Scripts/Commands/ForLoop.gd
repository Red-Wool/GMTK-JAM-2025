class_name ForLoop extends Node2D

var is_dead : bool

var commands : Array[CommandResource]

@onready var sprite : Sprite2D = $CharacterSprite

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
