extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var time_start = 0
var time_now = 0

class_name WorldObject
	var Players: String = ''
	var Scene: Scene
	var History: = Array()
	var decisions:
	var totalTime: 

# Called when the node enters the scene tree for the first time.
func _ready():
	time_start = OS.get_unix_time()
	set_process(true)

# Should we tie time to the save files or the application? 
# I would think the save files.

func _process(delta):
	time_now = OS.get_unix_time()
	var elapsed = time_now - time_start
	var minutes = elapsed / 60
	var seconds = elapsed % 60
	var str_elapsed = "%02d : %02d" % [minutes, seconds]
	print("elapsed : ", str_elapsed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
