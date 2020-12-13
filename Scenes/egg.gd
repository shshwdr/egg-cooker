extends PathFollow2D

onready var rigidbody = $RigidBody2D
onready var sprite = $RigidBody2D/Sprite
var speed = 100

var cooked_level = 0
var cook_speed = 0.04

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	offset+=delta*speed
	
	var collidings = rigidbody.get_colliding_bodies()
	for i in collidings:
		if i.get_parent().is_on:
			cooking(delta)
			
func cooking(delta):
	cooked_level+=delta*cook_speed
	sprite.modulate = Color(cooked_level,1,1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
