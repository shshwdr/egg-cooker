extends PathFollow2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 500

var table_scene = preload("res://Scenes/table.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _physics_process(delta):
	offset+=delta*speed
	#var table_instance = table_scene.instance()
		
	#get_parent().get_parent().add_child(table_instance)
	#table_instance.position = position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
