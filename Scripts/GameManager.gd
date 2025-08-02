class_name GameManager extends Node

@export var level_data : LevelResource

var aim_position : Vector2i
@onready var aim_reticle : Sprite2D

@onready var for_loop : ForLoop = %ForLoop
@onready var while_loop : WhileLoop = %WhileLoop
@onready var grid_manager : GridManager = %GridManager

@onready var test_label : Label = $TestLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(.1).timeout
	_start_level()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	test_label.text = str(while_loop.health)
	if Input.is_key_pressed(KEY_SPACE) and !while_loop.is_attacking:
		_start_turn()

func _start_level():
	grid_manager._create_level(level_data.grid_data)
	for_loop._setup(level_data.commands)
	while_loop._setup(level_data.while_loop_hp, level_data.attack_data)
	

func _start_turn():
	while_loop._start_attack()

func _end_turn():
	if for_loop.is_dead:
		lose_level()
	elif while_loop.is_dead:
		win_level()

func lose_level():
	pass

func win_level():
	pass
