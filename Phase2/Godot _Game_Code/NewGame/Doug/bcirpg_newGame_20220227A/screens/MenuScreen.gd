#MENUSCREEN:
#	Script purely to grab focus for tabbing control

extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#DKM TEMP: for testing only -- this will be set for all scenes in settings
	theme=load("res://assets/ui_controlNode_dark_theme.tres")
	$VBoxContainer/But_NewGame.grab_focus()
