extends ItemList


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_selected(0):
			get_tree().change_scene("res://newGame.tscn")
	if is_selected(1):
			get_tree().change_scene("res://loadGame.tscn")
	if is_selected(2):
			get_tree().change_scene("res://multiplayer.tscn")
	if is_selected(3):
			get_tree().change_scene("res://addCharacter.tscn")
	if is_selected(4):
			get_tree().change_scene("res://settings.tscn")
