extends Area2D

# Creating a custom signal called hit
# the signal "hit" will be emitted when an enemy hits the player
# you can see this custom signal when you click on the Player node on the left
# side and click on "Node" on the right side.
signal hit

# How fast the player will move (pixels/sec).
# "export" lets you create? a new variable called speed and sets it to 400
# You can open the inspector to see a new "script variable"
export var speed = 400
var screen_size  # Size of the game window.

# _ready is called when the node enters the SceneTree
func _ready():
	screen_size = get_viewport_rect().size
	# Hide the player scene when it is loaded.
	hide()

# _process is called every frame
# For the player, we want to do the following:
# 1. check for input
# 2. move in the given direction
# 3. play the correct animation
# You can find the default keyboard mapping under project settings
func _process(delta):
	# 1. Check for input
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		# The reason why we normalise is because if you press 2 keys at the
		# same time like down and right, it means you move faster diagonally
		# than horizontally!
		# Normalizing means set the length to 1 i.e. by dividing by itself
		# That means you can't normalise a vector with length 0. Doing so will
		# Throw an error
		velocity = velocity.normalized() * speed
		# $ is shorthand for get_node so $AnimatedSprite.play() is equivalent
		# to get_node("AnimatedSprite").play()
		# 3a. Play the correct animation
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	# 2. Move in the given direction
	# delta refers to the time difference between the previous frame that
	# was drawn and the current frame. This ensures that your movement is
	# smooth even if your frame rate changes
	# https://medium.com/@dr3wc/understanding-delta-time-b53bf4781a03
	position += velocity * delta
	# Clamping a value means restricting it to a given range
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	# 3b. Play the correct animation cont.
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		# GDscripts version of a 1 liner if statement
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0



func _on_Player_body_entered(_body):
	hide()  # Player disappears after being hit.
	emit_signal("hit")
	# After the first time the body is hit, you need to set the "Disabled" 
	# property on the CollisionShape2D child node to true. 
	# set_deferred() is used so we dont accidentally disable it when the engine
	# collision is processing. It tells Godot engine to disable it when it is 
	# safe to do so.  
	$CollisionShape2D.set_deferred("disabled", true)

# This function is to be called when the game is started or to reset the game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
