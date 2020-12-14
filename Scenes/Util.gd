extends Node



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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
