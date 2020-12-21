extends Node2D


onready var on = $StaticBody2D/on
onready var off = $StaticBody2D/off
onready var conveyor = $StaticBody2D/conveyor
var is_on = false
var can_put_egg = false

var last_time = 0
var hack_time = 0.01
var current_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if can_put_egg:
		on.visible = false
		off.visible = false
		conveyor.visible = true
	else:
		
		on.visible = false	
		off.visible = true
		conveyor.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_time +=delta

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
	if Input.is_mouse_button_pressed(1) or Input.is_action_just_pressed("click"):
		if can_put_egg:
			Events.emit_signal("right_click_table",position)
	if Input.is_action_just_pressed("click"):
		if not can_put_egg:
			if current_time - last_time>hack_time:
				
				Events.emit_signal("turn_on")
				#print("hmm")
				flip()
			last_time = current_time
		
		

func _on_StaticBody2D_mouse_entered():
	if Util.game_end:
		return
		
	if can_put_egg :
		return
	if Input.is_mouse_button_pressed(1):  # Left mouse button.
		flip()
	
