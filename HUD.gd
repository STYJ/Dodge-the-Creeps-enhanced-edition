extends CanvasLayer

signal start_game
signal single_life
signal increased_spawn

func show_message(text):
	$VBoxContainer/Body/MessageLabel.text = text
	$VBoxContainer/Body/MessageLabel.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# yield is like pausing the processing the next part of the code until it 
	# receives a certain signal from a certain node.
	yield($MessageTimer, "timeout")

	$VBoxContainer/Body/MessageLabel.text = "Dodge the\nCreeps!"
	$VBoxContainer/Body/MessageLabel.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	show_buttons()
	$VBoxContainer/Footer/Version.show()
	
func update_highscore(highscore): 
	$VBoxContainer/Header/ScoreLabel.text = "High score: %s" % highscore
	yield(get_tree().create_timer(1), "timeout")
	$VBoxContainer/Header/ScoreLabel.hide()

func update_score(score):
	$VBoxContainer/Header/ScoreLabel.text = str(score)

func _on_StartButton_pressed():
	$VBoxContainer/Header/ScoreLabel.show()
	hide_buttons()
	$VBoxContainer/Footer/Version.hide()
	emit_signal("start_game")

func hide_buttons():
	# You don't want to do $VBoxContainer/Body/Buttons.hide() because it removes
	# the entire element from the screen. This causes the message label to be 
	# out of alignment
	$VBoxContainer/Body/Buttons/Start/StartButton.hide()
	$VBoxContainer/Body/Buttons/Settings/SettingsButton.hide()

func show_buttons():
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
		new_modifier = curr_modifier * 3
		emit_signal("single_life", true)
	else:
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
