#MENUSCREEN:
#	Script purely to grab focus for tabbing control

extends Control

#onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#theme=load(settings.themeFile)
	$VBoxContainer/But_NewGame.grab_focus()
