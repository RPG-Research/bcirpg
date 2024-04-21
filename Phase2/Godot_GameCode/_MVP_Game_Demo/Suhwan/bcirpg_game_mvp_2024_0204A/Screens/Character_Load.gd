#CHARACTER_LOAD:
#	Script for loading a character file into the character object from file

extends Control

onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance

func _ready() -> void:
	theme=load(settings.themeFile)
	$Title/But_loadCharacter.grab_focus()


func _on_But_loadCharacter_pressed() -> void:
	$LoadCharacter_FileDialog.popup()


#DKM TEMP: we need to load the character item, not display to field
func _on_LoadCharacter_FileDialog_file_selected(path: String) -> void:
	print(path)
	var charFile = File.new()
	charFile.open(path, 1)
	var pc = get_node("/root/PlayerCharacter")
	pc.playerCharacterSingleton.pcText = charFile.get_as_text()
	$TextEdit.text = pc.playerCharacterSingleton.pcText 
