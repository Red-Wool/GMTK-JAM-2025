class_name AttackProjectile extends Node2D

var grid_position : Vector2i
var velocity : Vector2i 

var is_dead : bool
var is_paused : bool
var special_trigger : bool

var grid_manager : GridManager

var move_time : float

@onready var sprite : Sprite2D = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _set_up(grid : GridManager, pos : Vector2i):
	grid_manager = grid
	grid_position = pos
	global_position =  grid_manager._grid_to_world_position(grid_position)
	velocity = Vector2i.LEFT
	is_dead = false

func _start():
	is_paused = false

func _step(t : float):
	if is_dead or is_paused:
		return
	special_trigger = false
	
	move_time = t
	
	var new_pos = grid_position + velocity
	special_trigger = grid_manager._move_projectile(self, new_pos, move_time)

func _change_velocity(new_velocity : Vector2i):
	velocity = new_velocity
	_align()

func _align():
	
	get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)\
	.tween_property(sprite, "rotation_degrees", Alignment._align(velocity), move_time)

func _destroy():
	is_dead = true
	

func _disappear():
	get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)\
	.tween_property(sprite, "global_scale", Vector2.ZERO, move_time*4.)
