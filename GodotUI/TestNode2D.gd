extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var isPaused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Make this function return a boolean.
func _isPaused():
	if isPaused == true:
		print("Unpaused")
	if isPaused == false:
		print("Paused")
	return isPaused

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
