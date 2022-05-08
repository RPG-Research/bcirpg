tool
extends Button


func _on_But_ResumeGame_button_up():
	var root = get_node("/root")
	var thisScene = get_node("/root/MoreOptions")
	var gameSingleton = get_node("/root/GameCurrent")
	var gameScene = gameSingleton.gameCurrent_scene 
	root.remove_child(thisScene)
	thisScene.queue_free()
	root.add_child(gameScene)

