extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
	

func show_game_over():
	show_message("Game Over")
	# yield is like pausing the processing the next part of the code until it 
	# receives a certain signal from a certain node.
	yield($MessageTimer, "timeout")

	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	
func update_highscore(highscore): 
	$ScoreLabel.text = "High score: %s" % highscore
	yield(get_tree().create_timer(1), "timeout")
	$ScoreLabel.hide()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_StartButton_pressed():
	$StartButton.hide()
	$ScoreLabel.show()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Message.hide()
