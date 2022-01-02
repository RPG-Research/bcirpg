extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var isPaused = false

func isPausedFunc():
	print("Status is " + isPaused)
	return isPaused

# Called when the node enters the scene tree for the first time.
func _ready():
	isPausedFunc()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
