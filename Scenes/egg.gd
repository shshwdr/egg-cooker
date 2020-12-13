extends PathFollow2D


var speed = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	offset+=delta*speed
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
