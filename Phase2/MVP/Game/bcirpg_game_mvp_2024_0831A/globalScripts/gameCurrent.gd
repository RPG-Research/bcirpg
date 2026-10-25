#gameCurrent: 
#	Simple singleton script for storing persistent game cene paths. 
#	These must then not be destroyed, but manually removed as a child of the 
#	node and they can always be re-added as needed. 

extends Node

var gameCurrent_scene 

	
#If the game quits while the game scene is set aside (e.g. from MoreOptions),
#	nothing else will free it.
func _exit_tree() -> void:
	if is_instance_valid(gameCurrent_scene) && !gameCurrent_scene.is_inside_tree():
		gameCurrent_scene.free()
