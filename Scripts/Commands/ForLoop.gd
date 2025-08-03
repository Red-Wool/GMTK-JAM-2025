class_name ForLoop extends Node2D

var is_dead : bool

var commands : Array[CommandResource]

@onready var sprite : Sprite2D = $CharacterSprite
@onready var command_display : CommandDisplay = $CommandArea

var max_item_count : int = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.material.set_shader_parameter("isOn", false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_dead:
		sprite.skew = (randf_range(-2,2))

func _setup(c : Array[CommandResource]):
	commands = c
	_display()

func _try_select(index : int) -> bool:
	if index >= commands.size():
		return false
	return true

func _use_command(index : int):
	commands.pop_at(index)
	_display()
	

func _hurt(delay : float):
	await get_tree().create_timer(delay * 2.).timeout
	if commands.pop_back() == null:
		is_dead = true
		sprite.material.set_shader_parameter("isOn", true)
	_display()
	

func _display():
	command_display._update_sprites(commands)
