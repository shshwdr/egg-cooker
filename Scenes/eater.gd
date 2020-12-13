extends Node2D

var request_level = 1
onready var sprite = $request/Sprite
onready var progress_bar = $request/ProgressBar
var got_food = false
var is_leaving

var patient_max = 100
var patient
var patient_speed = 0.1

func init(_request_level):
	request_level = _request_level

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.update_cooked_level(request_level)
	patient = patient_max
	pass # Replace with function body.

func can_eat():
	return not got_food and not is_leaving

func angry():
	Events.emit_signal("left")
	is_leaving = true
	leave()

func _process(delta):
	if got_food:
		return
	patient-=patient_speed
	progress_bar.value = patient/float(patient_max)*100
	if patient<=0:
		angry()

func leave():
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
	
func pay():
	Events.emit_signal("pay",10)
		
func eat(egg):
	got_food = true
	egg.is_eaten = true
	egg.position = position
	
	yield(get_tree().create_timer(1), "timeout")
	egg.queue_free()
	pay()
	leave()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
