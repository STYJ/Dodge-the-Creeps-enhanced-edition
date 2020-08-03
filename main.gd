extends Node

# exposes a variable called Mob on the inspector 
export (PackedScene) var Mob

var score
var highscore = 0
var spawn_multiplier = 1
var single_life = false
var lives = 3
var score_multiplier = 1
const MOB_TIMER_DEFAULT_WAIT_TIME = 0.428
const PITCH_SCALE_DEFAULT_TIME = 1

func _ready():
	randomize()

# when main detects the "died" signal
func game_over():
	# Hide player
	$Player.hide()
	# After the player dies, you need to set the "Disabled" 
	# property on the CollisionShape2D child node to true. 
	# set_deferred() is used so we dont accidentally disable it when the engine
	# collision is processing. It tells Godot engine to disable it when it is 
	# safe to do so.
	$Player/CollisionShape2D.set_deferred("disabled", true)
	
	# Stop creeps from spawning and scores from increasing
	_stop_timers()
	
	# Play gameover music
	$Music.stop()
	$DeathSound.play()
	
	# Set highscore
	if(score > highscore):
		highscore = score
		
	# Update HUD to show gameover
	$HUD.show_game_over(highscore)
	
	# Cleanup mobs
	get_tree().call_group("mobs", "queue_free")

func new_game():
	# Reset state
	score = 0
	$MobTimer.wait_time = MOB_TIMER_DEFAULT_WAIT_TIME
	$Music.pitch_scale = PITCH_SCALE_DEFAULT_TIME
	lives = 1 if single_life else 3
	
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()

# When the MobTimer counts down to 0, spawn a mob.
func _on_MobTimer_timeout():
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.offset = randi()
	
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	add_child(mob)
	
	# Set the mob's direction perpendicular to the path direction. 
	# We use Pi because GDScript uses radians, not degrees
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)

# When ScoreTimer counts down to 0, add a score.
func _on_ScoreTimer_timeout():
	# Todo: add spawn multipler here
	score += 1 * score_multiplier
	$HUD.update_score(round(score))

# When StartTimer counts down to 0, start! 
func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$MultiplierTimer.start()

# Reduce MobTimer every time MultiplierTimer times out
func _on_MultiplierTimer_timeout():
	$MobTimer.wait_time = $MobTimer.wait_time * spawn_multiplier
	$Music.pitch_scale = $Music.pitch_scale * (1 / spawn_multiplier)

# Stop all timers
func _stop_timers():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$MultiplierTimer.stop()

func _on_HUD_single_life(is_true):
	# I need this global variable to detect how much life to restart the game with
	single_life = is_true
	if is_true:
		lives = 1
		score_multiplier *= 2
	else:
		lives = 3
		score_multiplier /= 2

func _on_HUD_increased_spawn(is_true):
	if is_true:
		spawn_multiplier = 0.990
		score_multiplier *= 1.5
	else:
		spawn_multiplier = 1
		score_multiplier /= 1.5

func _on_Player_hit():
#	can't seem to do game_over() if lives == 0 else lives--
#	also can't do like -- lives
	lives -= 1
	# Todo: Play hit sound
	
	# clear mobs, spawn again after 2 seconds of blinking
	if(lives == 0):
		game_over()
	else:
		$CollisionSound.play()
