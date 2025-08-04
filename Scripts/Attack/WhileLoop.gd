class_name WhileLoop extends Node2D
#so gamer

@onready var game_manager = %GameManager

var health : int

var is_dead : bool

var is_attacking : bool
var attack_timer : float

var attack_step_time : float = .3
var default_attack_step_time : float = .3

signal attack_step(time : float)

var attack_index : int
var attacks : Array[WhileAttackResource]

var attack_projectile_array : Array[AttackProjectile]
var attack_previews : Array[Node2D]

var current_step_count : int = 0
var infinite_loop_step_count : int = 128

var stop : bool

@onready var sprite : Sprite2D = $CharacterSprite
@onready var attack_display : AttackDisplay = $AttackDisplay

@onready var attack_container_prefab = preload("res://Prefab/attack_holder.tscn")
@onready var attack_preview_prefab = preload("res://Prefab/attack_preview.tscn")
@onready var attack_projectile_prefab = preload("res://Prefab/attack_projectile.tscn")

@onready var move_sfx : AudioStreamPlayer = $AudioStreamPlayer
@onready var hurt : AudioStreamPlayer = $Hurt

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.material.set_shader_parameter("isOn", false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if is_dead:
		sprite.skew = (randf_range(-2,2))
	
	attack_timer -= delta
	if is_attacking and attack_timer <= 0. and !stop:
		attack_step.emit(attack_step_time)
		current_step_count += 1
		
		move_sfx.pitch_scale = default_attack_step_time / attack_step_time
		move_sfx.play()
		
		
		if infinite_loop_step_count <= current_step_count:
			_infinite_state()
			current_step_count = 0
			stop = true
		
		var dead_check : bool = true
		var speed_up : bool = false
		for proj : AttackProjectile in attack_projectile_array:
			if !speed_up and proj.special_trigger:
				attack_step_time *= .9
				speed_up = true
			
			if !proj.is_dead:
				dead_check = false
		
		attack_timer = attack_step_time
		
		if dead_check:
			stop = true
			_end_turn()
	
	pass

func _setup(hp : int, a : Array[WhileAttackResource]):
	health = hp
	attacks = a
	current_step_count = 0
	
	
	for i : int in range(attacks.size()):
		var attack_data : WhileAttackResource = attacks[i]
		var container_prefab = attack_container_prefab.instantiate()
		add_child(container_prefab)
		attack_previews.append(container_prefab)
		
		for row : int in range(attack_data.attack_lanes.size()):
			var attack_preview = attack_preview_prefab.instantiate()
			container_prefab.add_child(attack_preview)
			
			attack_preview.position = \
			Vector2(game_manager.grid_manager.grid.grid.size(),
			attack_data.attack_lanes[row])*game_manager.grid_manager.grid_size+ \
			game_manager.level_data.grid_data.offset
	
	_preview(0)
	_update_display()

func _start_attack():
	current_step_count = 0
	is_attacking = true
	var while_attack : WhileAttackResource = attacks[attack_index]
	attack_timer = .5
	attack_step_time = default_attack_step_time
	
	for r : int in while_attack.attack_lanes:
		var attack_projectile : AttackProjectile = attack_projectile_prefab.instantiate()
		attack_projectile_array.append(attack_projectile)
		add_child(attack_projectile)
		
		var grid_pos : Vector2i = Vector2i(game_manager.grid_manager.grid.grid.size()-1, r)
		attack_projectile._set_up(game_manager.grid_manager,
			grid_pos)
		attack_step.connect(attack_projectile._step)
	
	attack_index = (attack_index + 1) % attacks.size()

func _preview(index : int):
	for i : int in range(attack_previews.size()):
		var preview : Node2D = attack_previews[i]
		if i == attack_index:
			preview.modulate.a = 1.
			preview.position = Vector2.ZERO
		elif i == index:
			preview.modulate.a = .5
			preview.position = Vector2.RIGHT * 30
		else:
			preview.modulate.a = 0.
		

func _infinite_state():
	for proj : AttackProjectile in attack_projectile_array:
		if !proj.is_dead:
			health -= 1
			game_manager.grid_manager._move_hit_character(proj, false, .2)
			
			await get_tree().create_timer(.4).timeout
			
			hurt.play()
			sprite.skew = -.1
			create_tween().set_ease(Tween.EASE_OUT).tween_property(sprite, "skew", 0, .2)
			if health <= 0:
				sprite.material.set_shader_parameter("isOn", true)
				is_dead = true
			
			
			await get_tree().create_timer(.3).timeout
	
	_end_turn()

func _end_turn():
	
	await get_tree().create_timer(1.).timeout
	
	game_manager._end_turn()
	_update_display()
	_preview(attack_index)
	
	for p in attack_projectile_array:
		if !p.is_paused:
			p.queue_free()
	attack_projectile_array.clear()
	
	await get_tree().create_timer(.5).timeout
	
	stop = false
	is_attacking = false

func _update_display():
	attack_display._update_display(attacks, attack_index)
