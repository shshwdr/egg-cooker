extends Control

var money
var lifeleft

onready var money_label = $money
onready var lifeleft_label = $life_left

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func on_pay(m):
	money+=m
	money_label.text = String(money)
	
func on_left():
	lifeleft-=1
	lifeleft_label.text = String(lifeleft)
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
