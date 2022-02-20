#BUT_CHANGESCENE:
#	Generic template script allowing GUI linking of scenes by button press.

tool
extends Button

#Creates param usable in the UI; and the params next to export make it string and file browser
export(String, FILE) var next_scene_path: = ""


func _on_But_NewGame_button_up():
	get_tree().change_scene(next_scene_path)


func _get_configuration_warning() -> String:
		return "next_scene_path must be set for this button to work" if next_scene_path == "" else ""

