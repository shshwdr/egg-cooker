extends Control

var money
var lifeleft

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
	money+=m
	money_label.text = String(money)
	
func end_game():
	failed_sound.play()
	Util.game_end = true
	result.text = "You've earned "+String(money)+". Good luck next time!"
	game_end.visible = true
	ingame.visible = false
	
func on_left():
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
	
	Events.connect("pay",self,"on_pay")
	
	Events.connect("left",self,"on_left")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
