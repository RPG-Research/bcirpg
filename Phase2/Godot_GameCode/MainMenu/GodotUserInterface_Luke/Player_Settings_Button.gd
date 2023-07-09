extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"	
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_Settings_gui_input(event):
		if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
			print("Clicked Player Settings")
