extends PathFollow2D

onready var rigidbody = $RigidBody2D
onready var sprite = $RigidBody2D/Sprite
onready var progress_bar = $ProgressBar
var speed = 70
#rare, medium_rare, medium, medium_well, well_done, overcooked
var cooked_level_upgrade_number = [25,50,100,50]
var cooked_level = 0
var cooked_number = 0
var cook_speed = 10

var is_eaten = false

var is_cooking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar.value = 0
	
	progress_bar.visible = false
	pass # Replace with function body.

func _physics_process(delta):
	if Util.game_end:
		return
	if is_eaten:
		progress_bar.visible = false
		return
	offset+=delta*speed
	var current_cooking = false
	var collidings = rigidbody.get_colliding_bodies()
	for i in collidings:
		if i.is_in_group("table"):
			if i.get_parent().is_on:
				cooking(delta)
				current_cooking = true
		elif i.is_in_group("eater"):
			var eater = i.get_parent()
			if eater.request_level == cooked_level and eater.can_eat():
				eater.eat(self)
	
	if is_cooking and not current_cooking:
		is_cooking = false
		$AudioStreamPlayer2D.stop()
			
func cooking(delta):
	if not is_cooking:
		is_cooking = true
		$AudioStreamPlayer2D.play()
	if cooked_level == cooked_level_upgrade_number.size():
		#burned
		return
	cooked_number+=delta*cook_speed
	if cooked_number>=cooked_level_upgrade_number[cooked_level]:
		cooked_number = 0
		cooked_level+=1
		sprite.update_cooked_level(cooked_level)
	if cooked_level == cooked_level_upgrade_number.size():
		#burned
		progress_bar.visible = false
		$burned.play()
		
		Util.camera.start_shake(0.2,0.02,2)
	else:
		progress_bar.visible = true
		progress_bar.value = cooked_number/float(cooked_level_upgrade_number[cooked_level])*100
	#sprite.modulate = Color(cooked_level,0,0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
