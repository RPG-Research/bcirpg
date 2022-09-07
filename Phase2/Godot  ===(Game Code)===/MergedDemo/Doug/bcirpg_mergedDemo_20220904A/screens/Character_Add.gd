#CHARACTER_ADD:
#	Script for adding a new character and both saving it to file and loading 
#		it into the character object

extends Control

onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance

func _ready() -> void:
	theme=load(settings.themeFile)
	$Title/But_SaveChar.grab_focus()


func _on_But_SaveChar_pressed() -> void:
	$Title/FileDialog.popup()

#DKM TEMP: just text for now from text edit
func _on_FileDialog_file_selected(path: String) -> void:
	var pc = get_node("/root/PlayerCharacter")
	var newCharFile = File.new()
	newCharFile.open(path, 2)
	newCharFile.store_string($TextEdit.text)
	pc.playerCharacterSingleton.pcText = $TextEdit.text
