class_name CommandDisplay extends Sprite2D


@export var sprites : Array[Sprite2D]
@onready var default_sprite = preload("res://Art/empty_ass_inventory_lmaopng.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _update_sprites(resource : Array[CommandResource]):
	
	for i in range(sprites.size()):
		if i < resource.size() and resource[i] != null:
			sprites[i].texture = resource[i].sprite
		else:
			sprites[i].texture = null
