extends Node2D

onready var table_path = $whole_table/Path2D
onready var table_generator = $whole_table/Path2D/table_generator
onready var tables = $whole_table/Path2D/tables
var table_scene = preload("res://Scenes/table.tscn")
func generate_table():
	var length = table_path.curve.get_baked_length()
	print("length ",length)
	for i in range(0,30):
		table_generator.offset=i*32
		#yield(get_tree(), 'idle_frame')

		var table_instance = table_scene.instance()
		
		tables.add_child(table_instance)
		table_instance.position = table_generator.position
		

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_table()
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
