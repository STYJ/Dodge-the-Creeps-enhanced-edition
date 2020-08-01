extends CanvasLayer

signal start_game

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
	$VBoxContainer/Body/Buttons/Start/Button.hide()
	$VBoxContainer/Body/Buttons/Settings/Button.hide()

func show_buttons():
	$VBoxContainer/Body/Buttons/Start/Button.show()
	$VBoxContainer/Body/Buttons/Settings/Button.show()

func _on_MessageTimer_timeout():
	$VBoxContainer/Body/MessageLabel.hide()
