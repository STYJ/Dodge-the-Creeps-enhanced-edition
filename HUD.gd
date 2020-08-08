extends CanvasLayer

signal start_game
signal single_life
signal increased_spawn
const MAX_HEALTH = 99

func show_message(text):
	$VBoxContainer/Body/MessageLabel.text = text
	$VBoxContainer/Body/MessageLabel.show()
	$MessageTimer.start()

func show_game_over(highscore):
	show_message("Game Over")
	# yield is like pausing the processing the next part of the code until it 
	# receives a certain signal from a certain node.
	yield($MessageTimer, "timeout")

	$VBoxContainer/Body/MessageLabel.text = "Dodge the\nCreeps!"
	$VBoxContainer/Body/MessageLabel.show()
	
	_hide_lives()
	_update_highscore(highscore)
	
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	_show_buttons()
	$VBoxContainer/Footer/Version.show()
	
	
func _update_highscore(highscore): 
	$VBoxContainer/Header/ScoreLabel.text = "High score: %s" % highscore
	yield(get_tree().create_timer(1), "timeout")
	$VBoxContainer/Header/ScoreLabel.hide()

func update_score(score):
	$VBoxContainer/Header/ScoreLabel.text = str(score)

func _on_StartButton_pressed():
	_show_lives()
	$VBoxContainer/Header/ScoreLabel.show()
	_hide_buttons()
	$VBoxContainer/Footer/Version.hide()
	update_health(MAX_HEALTH)
	emit_signal("start_game")

func _show_lives():
	if $Settings/SettingsValues/Hardcore/HardcoreCheckbox.pressed:
		$VBoxContainer/Header/Lives/OneLife.show()
	else:
		$VBoxContainer/Header/Lives/ThreeLives.show()

func _hide_lives():
	if $Settings/SettingsValues/Hardcore/HardcoreCheckbox.pressed:
		$VBoxContainer/Header/Lives/OneLife.hide()
	else:
		$VBoxContainer/Header/Lives/ThreeLives.hide()

func _hide_buttons():
	# You don't want to do $VBoxContainer/Body/Buttons.hide() because it removes
	# the entire element from the screen. This causes the message label to be 
	# out of alignment
	$VBoxContainer/Body/Buttons/Start/StartButton.hide()
	$VBoxContainer/Body/Buttons/Settings/SettingsButton.hide()

func _show_buttons():
	$VBoxContainer/Body/Buttons/Start/StartButton.show()
	$VBoxContainer/Body/Buttons/Settings/SettingsButton.show()

func _on_MessageTimer_timeout():
	$VBoxContainer/Body/MessageLabel.hide()


func _on_SettingsButton_pressed():
	$Settings.show()


func _on_CloseButton_pressed():
	$Settings.hide()


func _on_HardcoreCheckbox_pressed():
	var curr_modifier = int($Settings/DifficultyValue.text)
	var new_modifier = 0
	if $Settings/SettingsValues/Hardcore/HardcoreCheckbox.pressed:
		heart = $VBoxContainer/Header/Lives/OneLife
		new_modifier = curr_modifier * 3
		emit_signal("single_life", true)
	else:
		heart = $VBoxContainer/Header/Lives/ThreeLives
		new_modifier = curr_modifier / 3
		emit_signal("single_life", false)
	_set_difficulty_value(new_modifier)

func _on_SpawnCheckbox_pressed():
	var curr_modifier = int($Settings/DifficultyValue.text)
	var new_modifier = 0
	if $Settings/SettingsValues/Spawn/SpawnCheckbox.pressed:
		new_modifier = curr_modifier * 2
		emit_signal("increased_spawn", true)
	else:
		new_modifier = curr_modifier / 2
		emit_signal("increased_spawn", false)
	_set_difficulty_value(new_modifier)

func _set_difficulty_value(modifier):
	$Settings/DifficultyValue.text = " %dx" % modifier if modifier < 10 else "%dx" % modifier

### Lives related stuff on HUD
onready var heart = $VBoxContainer/Header/Lives/ThreeLives
onready var tween = $Tween
var animated_health = 0

func _process(_delta):
	var round_value = round(animated_health)
	heart.value = round_value

func update_health(new_value):
	if not tween.is_active():
		tween.start()
	tween.interpolate_property(self, "animated_health", animated_health, new_value, 0.3)

func _on_Player_hit():
	var damage = MAX_HEALTH if $Settings/SettingsValues/Hardcore/HardcoreCheckbox.pressed else MAX_HEALTH/3
	update_health(animated_health - damage)
