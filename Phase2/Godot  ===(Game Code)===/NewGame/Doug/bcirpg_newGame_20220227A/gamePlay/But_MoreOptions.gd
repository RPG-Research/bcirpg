#But_MoreOptions:
#	For these options, we leave the game object active and manually add and remove
#		the scenes as needed. 

tool
extends Button

#Creates param usable in the UI; and the params next to export make it string and file browser
export(String, FILE) var next_scene_path: = ""

func _on_But_MoreOptions_button_up():
	var root = get_node("/root")
	var gameCurrent = get_node("/root/Game")
	var gameSingleton = get_node("/root/GameCurrent")
	var nextScene = load(next_scene_path)
	
	gameSingleton.gameCurrent_scene = gameCurrent
	root.remove_child(gameCurrent)
	nextScene = nextScene.instance()
	root.add_child(nextScene)


func _get_configuration_warning() -> String:
		return "next_scene_path must be set for this button to work" if next_scene_path == "" else ""

