extends Label

var flag : bool = false
@onready var trans : Restart = %Transition

@export var gotoscene : String = "res://test_grid_system.tscn"

func _process(delta):
	if flag and Input.is_action_just_pressed("space"):
		trans._gottoscene(gotoscene)

func _on_chatbox_finished_dialogue():
	
	flag = true
	visible = true
	pass # Replace with function body.
