extends Node

var game_end=false
var hold_egg = false
var camera
var money = 0

var rng:RandomNumberGenerator = RandomNumberGenerator.new()
func _ready():
	rng.randomize()

func randomi_size_with_invalid_positions(size,invalid_position, loop_count = 100):
	for i in range(loop_count):
		var res = Util.rng.randi_range(0,size)
		if not (invalid_position.get(res,false)):
			return res
		else:
			pass
			#print("duplicated")
	return -1
	
func random_vector2(x,y):
	return Vector2(rng.randi()%x, rng.randi()%y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
