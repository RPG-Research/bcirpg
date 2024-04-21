#gameCurrent: 
#	Simple singleton script for storing persistent game cene paths. 
#	These must then not be destroyed, but manually removed as a child of the 
#	node and they can always be re-added as needed. 

extends Node

var gameCurrent_scene 

	
