extends Control

var money
var lifeleft

var money_add = preload("res://Scenes/money_add.tscn")
var life_decrease = preload("res://Scenes/life_decrease.tscn")

onready var money_label = $in_game/money
onready var lifeleft_label = $in_game/life_left

onready var ingame = $in_game
onready var game_end = $game_ending
onready var result = $game_ending/result

onready var failed_sound = $failedSound

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func on_pay(m):
	var money_add_instance = money_add.instance()
	ingame.add_child(money_add_instance)
	money_add_instance.rect_position = money_label.rect_position
	money+=m
	money_label.text = String(money)
	
func end_game():
	failed_sound.play()
	Util.game_end = true
	result.text = "You've earned "+String(money)+". Good luck next time!"
	game_end.visible = true
	ingame.visible = false
	
func on_left():
	
	var life_decrease_instance = life_decrease.instance()
	ingame.add_child(life_decrease_instance)
	
	life_decrease_instance.rect_position = lifeleft_label.rect_position
	
	lifeleft-=1
	lifeleft_label.text = String(lifeleft)
	if lifeleft == 0:
		end_game()
# Called when the node enters the scene tree for the first time.
func _ready():
	lifeleft = 3
	money = 0
	money_label.text = String(money)
	lifeleft_label.text = String(lifeleft)
	
	$in_game/hint_stove/AnimationPlayer.play("hint")
	$in_game/hint_table/AnimationPlayer.play("hint")
	
	Events.connect("pay",self,"on_pay")
	
	Events.connect("left",self,"on_left")
	
	Events.connect("turn_on",self,"on_turn_on")
	
	Events.connect("right_click_table",self,"on_crack_egg")
	pass # Replace with function body.

func on_turn_on():
	$in_game/hint_stove.visible = false
	
func on_crack_egg():
	$in_game/hint_table.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
