#MENUSCREEN:
#	Script purely to grab focus for tabbing control

extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/But_NewGame.grab_focus()
