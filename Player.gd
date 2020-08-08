extends Area2D

# Creating a custom signal called hit
# the signal "hit" will be emitted when an enemy hits the player
# you can see this custom signal when you click on the Player node on the left
# side and click on "Node" on the right side.
signal hit

# How fast the player will move (pixels/sec).
# "export" lets you create? a new variable called speed and sets it to 300
# You can open the inspector to see a new "script variable"
export var speed = 300
var velocity = Vector2()
var screen_size  # Size of the game window.
var last_pos = Vector2()
var clicked = false

# _ready is called when the node enters the SceneTree
func _ready():
	screen_size = get_viewport_rect().size
	# Hide the player scene when it is loaded.
	hide()

func _calc_velocity(global_pos, player_pos):
	var diff = sqrt(pow(global_pos.x - player_pos.x, 2) + pow(global_pos.y - player_pos.y, 2))
	if diff > 50:
		look_at(global_pos)
		velocity = Vector2(speed, 0).rotated(rotation)
	else:
		# This is to prevent the player from rotation like crazy if the player
		# is on top of the mouse
		velocity = Vector2(0, 0).rotated(0)

# Get touch input
func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.is_pressed():
			clicked = true
			last_pos = event.position
			$AnimatedSprite.play()
		else:
			clicked = false
			velocity = Vector2(0, 0).rotated(0)
			$AnimatedSprite.stop()
	
	if event is InputEventScreenDrag:
		last_pos = event.position
		$AnimatedSprite.play()
		
	if event is InputEventMouseMotion and clicked:
		last_pos = event.position
		$AnimatedSprite.play()

func _process(delta):
	_calc_velocity(last_pos, position)
	position += velocity * delta
	# Clamping a value means restricting it to a given range
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _on_Player_body_entered(_body):
	emit_signal("hit")

# This function is to be called when the game is started or to reset the game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
