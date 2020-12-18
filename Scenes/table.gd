extends Node2D


onready var on = $StaticBody2D/on
onready var off = $StaticBody2D/off
var is_on = false
var can_put_egg = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func flip():
	is_on = not is_on
	if is_on:
		on.visible = true
		off.visible = false
	else:
		on.visible = false
		off.visible = true

#func _on_Control_mouse_entered():
#	print("enter table")
#	if Input.is_mouse_button_pressed(1):  # Left mouse button.
#		flip()


func _on_StaticBody2D_input_event(viewport, event, shape_idx):
	if Util.game_end:
		return
	if Util.hold_egg :
		return
	#print("well")
	if event.is_action_pressed("click"):
		if can_put_egg:
			Events.emit_signal("right_click_table")
		else:
		#print("hmm")
			flip()
#	if can_put_egg  and event.is_action_pressed("right_click"):
#		Events.emit_signal("right_click_table")

func _on_StaticBody2D_mouse_entered():
	if Util.game_end:
		return
		
	if can_put_egg :
		return
	if Input.is_mouse_button_pressed(1):  # Left mouse button.
		flip()
