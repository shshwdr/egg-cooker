extends Node2D


var off_texture = preload("res://art/UI/checkmark.png")
var on_texture = preload("res://art/UI/cancel.png")
var is_on = false


onready var sprite = $StaticBody2D/sprite
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func flip():
	is_on = not is_on
	if is_on:
		sprite.texture = on_texture
	else:
		sprite.texture = off_texture

#func _on_Control_mouse_entered():
#	print("enter table")
#	if Input.is_mouse_button_pressed(1):  # Left mouse button.
#		flip()


func _on_StaticBody2D_input_event(viewport, event, shape_idx):
	if Util.game_end:
		return
	#print("well")
	if event.is_action_pressed("click"):
		print("hmm")
		flip()


func _on_StaticBody2D_mouse_entered():
	if Util.game_end:
		return
	if Input.is_mouse_button_pressed(1):  # Left mouse button.
		flip()
