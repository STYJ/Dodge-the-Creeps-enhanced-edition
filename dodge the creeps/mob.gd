extends RigidBody2D

export var min_speed = 150  # Minimum speed range.
export var max_speed = 250  # Maximum speed range.

func _ready():
	# get_animation_names() returns ["walk", "swim", "fly"]
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	# randi() is not the same as randomize(). 
	# you should use randomize() if you want your sequence of random numbers 
	# to be different each time you run the scene. 
	# we are not using it here because we will be using it in the main scene
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]


func _on_VisibilityNotifier2D_screen_exited():
	# this queues the mob instance to be freed. 
	# Mobs will delete themselves when they leave the screen
	queue_free()
