extends Node2D

onready var table_path = $whole_table/Path2D
onready var table_generator = $whole_table/Path2D/table_generator
onready var tables = $whole_table/Path2D/tables
onready var eaters = $eaters

var egg_wholes = []

var table_scene = preload("res://Scenes/table.tscn")
var eater_scene = preload("res://Scenes/eater.tscn")
var egg_whole_scene = preload("res://Scenes/egg_whole.tscn")

var chicken_scene = preload("res://Scenes/chicken.tscn")

var egg_scene = preload("res://Scenes/egg.tscn")

var current_time = 0
var generate_time = 0
var generate_range = [3,6]

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
		if i >=16 and i<=23:
			table_instance.can_put_egg = true
		tables.add_child(table_instance)
		table_instance.position = table_generator.position
		

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_table()
	egg_generation()
	generate_time = Util.rng.randf_range(generate_range[0],generate_range[1])
	#Util.eaters = eaters
	Events.connect("fully_left",self,"on_eater_fully_left")
	Events.connect("right_click_table",self,"on_right_click_table")
	pass

func generate_eater():
	
	var random_request = Util.rng.randi_range(1,3)
	
	var top_count = top_position_x_range[1] - top_position_x_range[0] +1
	var right_count = top_position_y_range[1] - top_position_y_range[0] +1
	var total_count = top_count + right_count*2-1
	var random_position = Util.randomi_size_with_invalid_positions(total_count,eater_invalid_position)
#	if (eater_invalid_position.get(random_position,false)):
#		return
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
#	elif random_position < top_count+right_count+top_count:
#		var random_value = random_position - top_count-right_count
#
#		var random_x =top_position_x_range[0] + random_value
#		var y = top_position_y_range[1]+1
#
#		d_position = Vector2(random_x,y)
#		degree = 180
	elif random_position < top_count+right_count+right_count:
		var random_value = random_position - top_count-right_count
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
	
func egg_generation():
	
	var should_generate_chicken = true
	var chicken_position = Util.rng.randi()%7
	
	var egg_position = $table/egg_start.position
	for i in range(7):
		var egg_whole_instance = egg_whole_scene.instance()
		egg_whole_instance.position = egg_position
		if chicken_position == i:
			egg_whole_instance.is_chicken = true
		$table.add_child(egg_whole_instance)
		egg_wholes.append(egg_whole_instance)
		egg_position+=Vector2(32,0)
	
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
	
func on_right_click_table():
	var mouse_position = get_viewport().get_mouse_position()
	var offset = table_path.curve.get_closest_offset(mouse_position)
	
	
	if egg_wholes.size()>0:
		
		var egg_whole = egg_wholes.pop_front()
		
		if egg_whole.is_chicken:
			var chicken_instance = chicken_scene.instance()
			$chickens.add_child(chicken_instance)
		else:
			for i in table_path.get_children():
				if i.is_in_group("egg"):
					if abs(offset - i.offset)<32:
						return
			var egg_instance = egg_scene.instance()
			egg_instance.offset = offset
			table_path.add_child(egg_instance)
		
		egg_whole.queue_free()
		
		if egg_wholes.empty():
			egg_generation()
	else:
		return
	
	
	
	print("create egg")
	
	
	

func _on_Button_pressed():
	Util.game_end = false
	get_tree().reload_current_scene()
