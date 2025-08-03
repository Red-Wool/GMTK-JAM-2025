class_name AttackDisplay extends Sprite2D

@export var sprites : Array[Sprite2D]

@onready var pointer : Sprite2D = $Pointer
@onready var pointer_target : Sprite2D = $CommandDisplay
var timer : float 

@onready var attack_sprite : Texture2D = preload("res://Art/BasicAngryPixelBlocks.png")
@onready var waiting_sprite : Texture2D = preload("res://Art/Metronome-1.png.png")

func _process(delta):
	timer += delta * .75
	pointer.position.y = 75 - (roundf(fmod(timer, 1.))*5)

func _update_display(attacks : Array[WhileAttackResource], index : int):
	for i in range(sprites.size()):
		if i < attacks.size():
			sprites[i].visible = true
			sprites[i].texture = waiting_sprite if attacks[i].attack_lanes.size() == 0 else attack_sprite
		else:
			sprites[i].visible = false
		if index == i:
			pointer_target = sprites[i]
			create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).tween_property(pointer, "position:x", sprites[i].position.x, .5)
