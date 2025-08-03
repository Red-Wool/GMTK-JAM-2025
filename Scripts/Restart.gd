class_name Restart extends Sprite2D

@onready var anim : AnimationPlayer = $AnimationPlayer

@export var can_transition : bool = true
var is_transitioning

func _ready():
	is_transitioning = true
	await get_tree().create_timer(1.6).timeout
	is_transitioning = false

func _process(delta):
	if Input.is_action_just_pressed("restart") and !is_transitioning and can_transition:
		_restart()
		is_transitioning = true

func _restart():
	
	anim.play("closing")
	await get_tree().create_timer(1.6).timeout
	get_tree().reload_current_scene()

func _gottoscene(scene : String):
	anim.play("closing")
	await get_tree().create_timer(1.6).timeout
	get_tree().change_scene_to_file(scene)
