extends Area2D

# Creating a custom signal called hit
# the signal "hit" will be emitted when an enemy hits the player
# you can see this custom signal when you click on the Player node on the left
# side and click on "Node" on the right side.
signal hit

# How fast the player will move (pixels/sec).
# "export" lets you create? a new variable called speed and sets it to 400
# You can open the inspector to see a new "script variable"
export var speed = 300
var velocity = Vector2()
var screen_size  # Size of the game window.

# _ready is called when the node enters the SceneTree
func _ready():
	screen_size = get_viewport_rect().size
	# Hide the player scene when it is loaded.
	hide()

func get_input():
	var diff = sqrt(pow(get_global_mouse_position().x - position.x, 2) + pow(get_global_mouse_position().y - position.y, 2))

	if Input.is_action_pressed('mouse_down'):
		# Determine if velocity and rotation should change depending on distance
		# between mouse and player
		if diff > 50:
			look_at(get_global_mouse_position())
			velocity = Vector2(speed, 0).rotated(rotation)
		else:
			# This is to prevent the player from rotation like crazy if the player
			# is on top of the mouse
			velocity = Vector2(0, 0).rotated(0)
		$AnimatedSprite.play()
	else:
		# If mouse is not pressed, don't do anything
		velocity = Vector2(0, 0).rotated(0)
		$AnimatedSprite.stop()
		

func _process(delta):
	get_input()

	position += velocity * delta
	# Clamping a value means restricting it to a given range
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

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
