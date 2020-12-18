extends KinematicBody2D


var dragging = false
var origin_position 

var is_chicken = false

# Called when the node enters the scene tree for the first time.
func _ready():
	origin_position = global_position
	
	if is_chicken:
		$AnimationPlayer.play("shaking")
	pass # Replace with function body.


func _process(delta):
	#print(self.position)
	if dragging:
		var mousepos = get_global_mouse_position()
		#print(self.position)
		self.global_position = Vector2(mousepos.x, mousepos.y)
		#print(self.position)

	

func try_put_egg():
	
	
	global_position = origin_position


func _on_egg_whole_input_event(viewport, event, shape_idx):
	return
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
