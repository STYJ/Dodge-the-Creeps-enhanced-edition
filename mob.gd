extends RigidBody2D

export var min_speed = 150  # Minimum speed range.
export var max_speed = 250  # Maximum speed range.

const ANIMATED_SPRITE_DEFAULT_SCALE = 0.75
const COLLISION_SHAPE_2D_DEFAULT_SCALE = 1
const MIN_SCALE_MULTIPLIER = 0.5
const MAX_SCALE_MULTIPLIER = 1

func _ready():
	# get_animation_names() returns ["walk", "swim", "fly"]
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	# randi() is not the same as randomize(). 
	# you should use randomize() if you want your sequence of random numbers 
	# to be different each time you run the scene. 
	# we are not using it here because we will be using it in the main scene
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	var scale_multiplier = rand_range(
		MIN_SCALE_MULTIPLIER,
		MAX_SCALE_MULTIPLIER
	)
	
	# Setting scale of AnimatedSprite and CollisionShape2D nodes
	var sprite_scale = scale_multiplier * ANIMATED_SPRITE_DEFAULT_SCALE
	var collision_shape_2d_scale = scale_multiplier * COLLISION_SHAPE_2D_DEFAULT_SCALE
	_set_scale($AnimatedSprite, sprite_scale)
	_set_scale($CollisionShape2D, collision_shape_2d_scale)

func _on_VisibilityNotifier2D_screen_exited():
	# Queues the mob instance to be freed. 
	# Mobs will delete themselves when they leave the screen.
	queue_free()

func _set_scale(node, value):
	node.scale.x = value
	node.scale.y = value
