extends Button

signal option_pressed(destinationLabel)

var destinationLabel

#DKM TEMP: test
func _on_Option_button_up() -> void:
	print("Button pushed!")
	emit_signal("option_pressed", destinationLabel)
