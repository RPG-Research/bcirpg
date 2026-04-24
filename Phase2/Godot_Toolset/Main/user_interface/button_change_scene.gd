extends Button


export(String, FILE) var next_scene_path: = ""

func _ready():
	connect("button_up", self, "_on_button_up")

func _on_button_up():
	var _next_scene_load = get_tree().change_scene(next_scene_path)
