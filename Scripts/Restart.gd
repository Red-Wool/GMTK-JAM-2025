class_name Restart extends Sprite2D

@onready var anim : AnimationPlayer = $AnimationPlayer

var is_transitioning

func _ready():
	is_transitioning = true
	await get_tree().create_timer(1.6).timeout
	is_transitioning = false

func _process(delta):
	if Input.is_action_just_pressed("restart") and !is_transitioning:
		_restart()
		is_transitioning = true

func _restart():
	
	anim.play("closing")
	await get_tree().create_timer(1.6).timeout
	get_tree().reload_current_scene()
	
