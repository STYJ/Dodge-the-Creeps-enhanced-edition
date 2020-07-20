extends Panel

func _ready():
	var _status = get_node("Click Button").connect("pressed", self, "_on_Button_pressed")

func _on_Button_pressed():
	get_node("Label").text = "HELLO!"
