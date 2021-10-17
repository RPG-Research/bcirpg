extends Label

func _ready():
	pass # Replace with function body.

func _on_NewGame_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().change_scene("res://NewGame.tscn")
