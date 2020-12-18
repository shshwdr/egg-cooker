extends Node2D

var is_moving = true
var target_p 
var speed = 0.5
var dragging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	fly_to_target()
	pass # Replace with function body.

func wander():
	pass
	
func pick_position():
	is_moving = true
	var start_position = Vector2(128,128)
	var vec_index = Util.random_vector2(8,5)
	var pos =  start_position+vec_index*32
	
	target_p = pos

func fly_to_target():
	pick_position()
	$AnimationPlayer.play("fly")
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if dragging:
		var mousepos = get_global_mouse_position()
		#print(self.position)
		self.global_position = Vector2(mousepos.x, mousepos.y)
		#print(self.position)
		return
	if Util.game_end:
		$AnimationPlayer.play("jump")
		return
	if is_moving:
		position+=(target_p - position).normalized()*speed
		if position.distance_to (target_p)<=1:
			is_moving = false
	if not is_moving:
		pick_position()
		$AnimationPlayer.play("walk")
	pass






	

func try_put_egg():
	fly_to_target()


func _on_Node2D_input_event(viewport, event, shape_idx):
	if Util.game_end:
		return
	#print("well")
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			dragging = true
			Util.hold_egg = true
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			dragging = false
			Util.hold_egg = false
			try_put_egg()


