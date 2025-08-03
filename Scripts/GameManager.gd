class_name GameManager extends Node

@export var level_data : LevelResource

var aim_box : int
# 0 is grid
# 1 is For Loop's Commands
# 2 is While Loop's Attacks
var aim_position : Vector2i
var is_placing : bool
var can_select_direction : bool = false
var selected_command : CommandResource
var selected_index : int

var initiate_start : bool
var is_gameover : bool

@onready var for_loop : ForLoop = %ForLoop
@onready var while_loop : WhileLoop = %WhileLoop
@onready var grid_manager : GridManager = %GridManager

@onready var test_label : Label = $TestLabel
@onready var aim_reticle : Sprite2D = $Reticle
@onready var aim_reticle_preview : Sprite2D = $Preview

@onready var choose_dir_sprite : Texture2D = preload("res://Art/chooseDir.png")
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
					is_placing = false
				aim_position.y = max(aim_position.y, 0)
			if Input.is_action_just_pressed("down"):
				aim_position.y = aim_position.y + 1
				if aim_position.y > grid_manager.grid.grid[0].grid_column.size()-1:
					aim_box = 1
					is_placing = false
				aim_position.y = min(aim_position.y, grid_manager.grid.grid[0].grid_column.size()-1)
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
		3: #Selecting new direction
			if Input.is_action_just_pressed("left"):
				selected_command._do_action(grid_manager, aim_position, Vector2i.LEFT)
				_end_place_item()
			if Input.is_action_just_pressed("right"):
				selected_command._do_action(grid_manager, aim_position, Vector2i.RIGHT)
				_end_place_item()
			if Input.is_action_just_pressed("up"):
				selected_command._do_action(grid_manager, aim_position, Vector2i.UP)
				_end_place_item()
			if Input.is_action_just_pressed("down"):
				selected_command._do_action(grid_manager, aim_position, Vector2i.DOWN)
				_end_place_item()
	
	match (aim_box):
		0:
			aim_reticle.position = lerp(aim_reticle.position,grid_manager._grid_to_world_position(aim_position), delta * 20.)
		1:
			aim_reticle.position = lerp(aim_reticle.position,for_loop.command_display.sprites[aim_position.x].global_position, delta * 20.)
		2:
			aim_reticle.position = lerp(aim_reticle.position,while_loop.attack_display.sprites[aim_position.x].global_position, delta * 20.)
			while_loop._preview(aim_position.x)
		3:
			aim_reticle.position = lerp(aim_reticle.position,grid_manager._grid_to_world_position(aim_position), delta * 20.)
	
	if is_placing:
		
		aim_reticle_preview.modulate.a = .5
		aim_reticle.modulate.a = 0.
		aim_reticle_preview.global_position = aim_reticle.global_position
	else:
		aim_reticle_preview.modulate.a = 0.
		aim_reticle.modulate.a = 1.
	
	test_label.text = str(while_loop.health)
	if Input.is_action_just_pressed("action") and !while_loop.is_attacking and !initiate_start:
		if !is_placing and for_loop._try_select(aim_position.x) and aim_box == 1:
			selected_command = for_loop.commands[aim_position.x]
			selected_index = aim_position.x
			is_placing = true
			aim_box = 0
			aim_reticle_preview.texture = selected_command.sprite
			aim_position = Vector2i(grid_manager.grid.grid.size()/2,grid_manager.grid.grid[0].grid_column.size()-1)
		elif is_placing and !can_select_direction:
			print("check")
			if selected_command.can_choose_direction:
				can_select_direction = true
				aim_box = 3
				aim_reticle_preview.texture = choose_dir_sprite
			else:
				selected_command._do_action(grid_manager, aim_position)
				_end_place_item()
	
	if Input.is_key_pressed(KEY_SPACE) and !while_loop.is_attacking and !is_placing and !initiate_start:
		initiate_start = true
		_start_turn()

func _start_level():
	grid_manager._create_level(level_data.grid_data)
	for_loop._setup(level_data._duplicate_commands())
	while_loop._setup(level_data.while_loop_hp, level_data.attack_data)

func _end_place_item():
	if initiate_start:
		return
	
	aim_box = 0
	can_select_direction = false
	is_placing = false
	
	initiate_start = true
	
	for_loop._use_command(selected_index)
	
	await get_tree().create_timer(.5).timeout
	_start_turn()

func _start_turn():
	if !is_gameover:
		while_loop._start_attack()

func _end_turn():
	initiate_start = false
	if for_loop.is_dead:
		lose_level()
	elif while_loop.is_dead:
		win_level()
	
	

func lose_level():
	is_gameover = true
	print("lose")
	pass

func win_level():
	is_gameover = true
	print("win")
	pass
