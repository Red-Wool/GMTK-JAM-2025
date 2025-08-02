class_name GridManager extends Node2D


@export var grid : GridLevelResource
#@export var offset : Vector2

var grid_size : int = 64

@onready var grid_tile_prefab = preload("res://Prefab/grid_tile.tscn")
@onready var game_manager : GameManager = %GameManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _create_level(data : GridLevelResource):
	grid = data
	
	var x : int = 0
	
	
	for x_point : GridColumnResource in grid.grid:
		for y : int in range(x_point.grid_column.size()):
			var point : GridPointResource = x_point.grid_column[y]
			if point == null:
				continue
			
			var tile : GridTile = grid_tile_prefab.instantiate()
			
			add_child(tile)
			point.grid_tile = tile
			
			tile.global_position = Vector2(x, y) * grid_size + grid.offset
			
			if grid.look_up_table._has(point.grid_prefab_name):
				var grid_object : GridObject = load(grid.look_up_table._get_object(point.grid_prefab_name)).instantiate()
				tile._set_object(grid_object)
			
		x += 1

func _move_projectile(proj : AttackProjectile, pos : Vector2i, t : float = .5) -> bool:
	
	_move_object(proj, _grid_to_world_position(pos), t)
	proj.grid_position = pos
	
	if !_outer_bounds(pos):
		if pos.x <= -1:
			game_manager.for_loop._hurt()
			_move_hit_character(proj, true, t)
		else:
			proj._disappear()
		proj._destroy()
		return false
	
	var tile : GridTile = _get_tile(pos)
	if tile == null or tile.grid_object == null:
		return false
	
	return tile.grid_object._action(proj, proj.velocity)

func _move_hit_character(proj : AttackProjectile, attack_for : bool, t : float = .5):
	get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)\
		.tween_property(proj, "global_position:x", game_manager.for_loop.sprite.global_position.x if attack_for else game_manager.while_loop.sprite.global_position.x, t*2.)
	var tween : Tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(proj, "global_position:y", proj.global_position.y - 50, t)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(proj, "global_position:y", game_manager.for_loop.sprite.global_position.y, t)
	
	get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)\
		.tween_property(proj, "rotation_degrees", -1500 if attack_for else 1500, t*2.)
	
	await get_tree().create_timer(t*2.)

func _outer_bounds(pos : Vector2i) -> bool:
	if pos.x < 0 or pos.y < 0:
		return false
	if pos.x >= grid.grid.size() or pos.y >= grid.grid[pos.x].grid_column.size():
		return false
	return true

func _bounds(pos : Vector2i) -> bool:
	if _get_tile(pos) == null:
		return false
	return _outer_bounds(pos)

func _grid_to_world_position(pos : Vector2i) -> Vector2:
	return Vector2(pos) * grid_size + grid.offset

func _get_tile(pos : Vector2i) -> GridTile:
	return grid.grid[pos.x].grid_column[pos.y].grid_tile

func _set_tile_item(pos : Vector2i, obj : GridObject):
	grid.grid[pos.x].grid_column[pos.y].grid_tile.grid_object = obj

func _push_object(pos : Vector2i, dir : Vector2i):
	
	if dir == Vector2i.ZERO:
		return
	
	var push_stack : Array[Vector2i]
	
	var off_screen_flag : bool = true
	while _bounds(pos):
		push_stack.append(pos)
		pos += dir
		
		var grid_tile : GridTile = _get_tile(pos)
		if grid_tile != null and grid_tile.grid_object == null: 
			off_screen_flag = false
			break
	
	push_stack.reverse()
	
	if off_screen_flag:
		var v : Vector2i = push_stack.pop_front()
		var obj = _get_tile(v).grid_object
		_death_object(obj,_grid_to_world_position(v+dir))
	
	for v : Vector2i in push_stack:
		_set_tile_item(v+dir,_get_tile(v).grid_object)
	_set_tile_item(push_stack[push_stack.size()-1], null)

func _move_object(obj : Node2D, pos : Vector2, t : float = .5):
	get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)\
		.tween_property(obj, "position", pos, t)

func _death_object(obj : Node2D, pos : Vector2):
	_move_object(obj,_grid_to_world_position(pos))
	get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)\
		.tween_property(obj, "global_scale", Vector2.ZERO, 1.)
	
	await get_tree().create_timer(1.).timeout
	
	obj.queue_free()
