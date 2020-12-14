extends Node2D

onready var table_path = $whole_table/Path2D
onready var table_generator = $whole_table/Path2D/table_generator
onready var tables = $whole_table/Path2D/tables
onready var eggs = $whole_table/Path2D/eggs
onready var eaters = $eaters
var table_scene = preload("res://Scenes/table.tscn")
var eater_scene = preload("res://Scenes/eater.tscn")

var current_time = 0
var generate_time = 0
var generate_range = [0,0.5]

var top_position_x_range = [3,12]
var border = 2
var top_position_y_range = [3,9]

var top_origin_position_y = -1
var eater_invalid_position = {}

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
	
	generate_time = Util.rng.randf_range(generate_range[0],generate_range[1])
	#Util.eaters = eaters
	Events.connect("fully_left",self,"on_eater_fully_left")
	pass

func generate_eater():
	
	var random_request = Util.rng.randi_range(1,4)
	
	var top_count = top_position_x_range[1] - top_position_x_range[0] +1
	var right_count = top_position_y_range[1] - top_position_y_range[0] +1
	var total_count = top_count*2 + right_count*2-1
	var random_position = Util.randomi_size_with_invalid_positions(total_count,eater_invalid_position)
	if random_position <0:
		return
	var d_position
	var d_origin =Vector2(0,-(border+1))
	var degree =0
	if random_position < top_count:
		var random_x =top_position_x_range[0] + random_position
		d_position = Vector2(random_x,border)
	elif random_position < top_count+right_count:
		var random_value = random_position - top_count
		var random_y =top_position_y_range[0] + random_value
		var x = top_position_x_range[1]+1
		d_position = Vector2(x,random_y)
		degree = 90
	elif random_position < top_count+right_count+top_count:
		var random_value = random_position - top_count-right_count
		
		var random_x =top_position_x_range[0] + random_value
		var y = top_position_y_range[1]+1
		
		d_position = Vector2(random_x,y)
		degree = 180
	elif random_position < top_count+right_count+top_count+right_count:
		var random_value = random_position - top_count*2-right_count
		var random_y =top_position_y_range[0] + random_value
		#var x = top_position_x_range[1]+1
		d_position = Vector2(border,random_y)
		degree = 270
	else:
		return
	
	eater_invalid_position[random_position] = true
	var eater_instance = eater_scene.instance()
	eater_instance.init(random_request,d_origin,d_position,random_position)
	
	eaters.add_child(eater_instance)
	eater_instance.rotation_degrees = degree
	pass
	
func on_eater_fully_left(position_index):
	eater_invalid_position.erase(position_index)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Util.game_end:
		return
	if current_time>=generate_time:
		generate_eater()
		current_time = 0
		generate_time = Util.rng.randf_range(generate_range[0],generate_range[1])
	current_time+=delta
	


func _on_Button_pressed():
	Util.game_end = false
	get_tree().reload_current_scene()
