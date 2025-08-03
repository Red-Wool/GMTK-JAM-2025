class_name GameManager extends Node

@export var level_data : LevelResource

var aim_box : int
# 0 is grid
# 1 is For Loop's Commands
# 2 is While Loop's Attacks
var aim_position : Vector2i
var is_placing : bool
var selected_command : CommandResource

@onready var for_loop : ForLoop = %ForLoop
@onready var while_loop : WhileLoop = %WhileLoop
@onready var grid_manager : GridManager = %GridManager

@onready var test_label : Label = $TestLabel
@onready var aim_reticle : Sprite2D = $Reticle
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(.1).timeout
	_start_level()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#ugly as hell solution
	match (aim_box):
		0: #Grid
			if Input.is_action_just_pressed("left"):
				aim_position.x = max(aim_position.x - 1, 0)
			if Input.is_action_just_pressed("right"):
				aim_position.x = min(aim_position.x + 1, grid_manager.grid.grid.size()-1)
			if Input.is_action_just_pressed("up"):
				aim_position.y = aim_position.y - 1
				if aim_position.y < 0:
					aim_box = 2
					aim_position.x = min(aim_position.x, while_loop.attacks.size()-1)
			if Input.is_action_just_pressed("down"):
				aim_position.y = aim_position.y + 1
				if aim_position.y > grid_manager.grid.grid[0].grid_column.size()-1:
					aim_box = 1
		1: #For Loop Command section
			if Input.is_action_just_pressed("left"):
				aim_position.x = max(aim_position.x - 1, 0)
			if Input.is_action_just_pressed("right"):
				aim_position.x = min(aim_position.x + 1, max(0, for_loop.max_item_count-1))
			if Input.is_action_just_pressed("up"):
				aim_box = 0
				aim_position = Vector2i(grid_manager.grid.grid.size()/2,grid_manager.grid.grid[0].grid_column.size()-1)
			if Input.is_action_just_pressed("down"):
				pass
		2: #While Loop Attack Section
			if Input.is_action_just_pressed("left"):
				aim_position.x = max(aim_position.x - 1, 0)
			if Input.is_action_just_pressed("right"):
				aim_position.x = min(aim_position.x + 1, max(0, while_loop.attacks.size()-1))
			if Input.is_action_just_pressed("up"):
				pass
			if Input.is_action_just_pressed("down"):
				aim_box = 0
				while_loop._preview(while_loop.attack_index)
				aim_position = Vector2i(grid_manager.grid.grid.size()/2,0)
	
	match (aim_box):
		0:
			aim_reticle.position = lerp(aim_reticle.position,grid_manager._grid_to_world_position(aim_position), delta * 20.)
		1:
			aim_reticle.position = lerp(aim_reticle.position,for_loop.command_display.sprites[aim_position.x].global_position, delta * 20.)
		2:
			aim_reticle.position = lerp(aim_reticle.position,while_loop.attack_display.sprites[aim_position.x].global_position, delta * 20.)
			while_loop._preview(aim_position.x)
	
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
