extends Label
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var option = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Start_Game_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
			print("Clicked Start Game")
			get_tree().change_scene("res://TestNode2D.tscn")
	# Start Game button opens a new node for that purpose
