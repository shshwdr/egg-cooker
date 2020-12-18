extends Node2D

export var request_level = 1
onready var sprite = $request/Sprite
onready var progress_bar = $request/ProgressBar
onready var request = $request
onready var tween = $Tween
onready var human = $human
var move_time = 2
var got_food = false
var is_leaving

var is_angry
var is_happy

var patient_max = 100
var patient
var patient_speed = 0.04

var is_moving = true
var target_position
var origin_position
var position_index

func init(_request_level, _origin_position,_target_position,_position_index):
	request_level = _request_level
	origin_position = _origin_position*32
	position_index = _position_index
	position = _target_position*32
	target_position = Vector2(0,0)

func move():
	is_moving = true
	tween.interpolate_property(
				human, 
				"position", 
				origin_position,target_position, move_time,
				Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween,"tween_completed")
	is_moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.update_cooked_level(request_level)
	patient = patient_max
	request.visible = false
	if origin_position:
		human.position = origin_position
		yield(move(),"completed")
	request.visible = true
	
	pass # Replace with function body.

func can_eat():
	return not got_food and not is_leaving and not is_moving

func angry():
	Events.emit_signal("left")
	is_leaving = true
	angry_anim()
	leave()

func _process(delta):
	if Util.game_end:
		return
	if got_food:
		return
	if is_moving:
		return
	patient-=patient_speed
	progress_bar.value = patient/float(patient_max)*100
	if patient<=0:
		angry()

func leave():
	request.visible = false
	target_position = origin_position
	origin_position = Vector2(0,0)
	yield(move(),"completed")
	Events.emit_signal("fully_left",position_index)
	queue_free()
	
func pay():
	Events.emit_signal("pay",10)
		
func angry_anim():
	sprite.visible = false
	$request/happy.visible = true
	$AnimationPlayer.play("happy")
	yield($AnimationPlayer,"animation_finished")
	
	sprite.visible = true
		
func happy():
	sprite.visible = false
	progress_bar.value = 100
	$request/happy.visible = true
	$AnimationPlayer.play("happy")
	yield($AnimationPlayer,"animation_finished")
	
	sprite.visible = true
		
func eat(egg):
	
	
	got_food = true
	egg.is_eaten = true
	#egg.position = position
	
	happy()
	tween.interpolate_property(
				egg, 
				"position", 
				egg.position,position, 0.5,
				Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween,"tween_completed")
	
	egg.queue_free()
	pay()
	leave()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
