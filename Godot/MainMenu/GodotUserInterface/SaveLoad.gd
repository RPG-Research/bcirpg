extends Label

func _ready():
	pass # Replace with function body.

func _on_SaveLoad_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().change_scene("res://SaveLoad.tscn")
