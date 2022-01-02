extends Node

const date = preload("res://Date.gd")

var isPaused = false
var isGameOver = false

var Scene = SceneTree 
# var players = Array or Similar for Actors
# var history = Array or Similar for Nodes
# var decisions = Array or Similar for ints
var DateTime = date.new()

func _ready():
	var TimeTest = OS.get_datetime()
	print(TimeTest)
