extends PathFollow2D

onready var rigidbody = $RigidBody2D
onready var sprite = $RigidBody2D/Sprite
onready var progress_bar = $ProgressBar
var speed = 100
#rare, medium_rare, medium, medium_well, well_done, overcooked
var cooked_level_upgrade_number = [25,50,50,100,50]
var cooked_level = 0
var cooked_number = 0
var cook_speed = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar.value = 0
	
	progress_bar.visible = false
	pass # Replace with function body.

func _physics_process(delta):
	offset+=delta*speed
	
	var collidings = rigidbody.get_colliding_bodies()
	for i in collidings:
		if i.get_parent().is_on:
			cooking(delta)
			
func cooking(delta):
	
	if cooked_level == cooked_level_upgrade_number.size():
		#burned
		return
	cooked_number+=delta*cook_speed
	if cooked_number>=cooked_level_upgrade_number[cooked_level]:
		cooked_number = 0
		cooked_level+=1
		sprite.frame = cooked_level
	if cooked_level == cooked_level_upgrade_number.size():
		#burned
		pass
		progress_bar.visible = false
	else:
		progress_bar.visible = true
		progress_bar.value = cooked_number/float(cooked_level_upgrade_number[cooked_level])*100
	#sprite.modulate = Color(cooked_level,0,0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
