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

var is_finishing

var patient_max = 100
var patient
var patient_speed =0.04


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
	
	Events.connect("found_chicken",self,"on_found_chicken")
	
	pass # Replace with function body.

func can_eat():
	return not got_food and not is_leaving and not is_moving

func angry():
	
	Events.emit_signal("left")
	is_leaving = true
	
	yield(angry_anim(),"completed")
	leave()

func update_patient_bar():
	
	progress_bar.value = patient/float(patient_max)*100

func _process(delta):
	if Util.game_end:
		return
	if got_food:
		return
	if is_moving:
		return
	if is_leaving:
		return
	patient-=patient_speed
	update_patient_bar()
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
	$AudioStreamPlayer2D.stream = load("res://sound/209578__zott820__cash-register-purchase.wav")
	$AudioStreamPlayer2D.play()
	Events.emit_signal("pay",10)
		
func angry_anim():
	Util.camera.start_shake(0.4,0.02,4)
	$AudioStreamPlayer2D.stream = load("res://sound/wrong.wav")
	$AudioStreamPlayer2D.volume_db = 0
	$AudioStreamPlayer2D.play()
	sprite.visible = false
	$request/angry.visible = true
	$AnimationPlayer.play("angry")
	yield($AnimationPlayer,"animation_finished")
	
	sprite.visible = true
		
func happy():
	sprite.visible = false
	progress_bar.value = 100
	$request/happy.visible = true
	$AnimationPlayer.play("happy")
	yield($AnimationPlayer,"animation_finished")
	
	sprite.visible = true
	
func on_found_chicken():
	if not can_eat():
		return
	else:
		$AudioStreamPlayer2D.stream = load("res://sound/aww.wav")
		$AudioStreamPlayer2D.volume_db = -6
		$AudioStreamPlayer2D.play()
		patient = patient_max
		update_patient_bar()
		happy()
		
func eat(egg):
	
	
	got_food = true
	egg.is_eaten = true
	#egg.position = position
	$AudioStreamPlayer2D.stream = load("res://sound/yummy.wav")
	$AudioStreamPlayer2D.volume_db = 18
	$AudioStreamPlayer2D.play()
	#happy()
	tween.interpolate_property(
				egg, 
				"position", 
				egg.position,position, 0.5,
				Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(happy(),"completed")
	
	egg.queue_free()
	pay()
	leave()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
