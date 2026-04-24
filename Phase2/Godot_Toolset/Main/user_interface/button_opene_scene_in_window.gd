extends Button


export(String, FILE) var scene_path: = "Scene Path"
export(String) var window_title = "New Window"

var persistent_window_path = "res://user_interface/PersistentWindow.tscn"

func _ready():
	connect("button_up", self, "_on_button_up")

func _on_button_up():
	# see if our scene path exists. if so, load it and add it to a new panel in the main scene
	# godot 4 has resizeable non-popup-style windows we could use here, but we're in 3.x, so we'll have to make our own instead
	if ResourceLoader.exists(scene_path):
		var new_scene = ResourceLoader.load(scene_path).instance()
		var new_panel = ResourceLoader.load(persistent_window_path).instance()
		new_panel.add_child(new_scene)
		get_tree().current_scene.add_child(new_panel)
		
	else:
		print("oh no")
