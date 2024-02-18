#CHARACTER_ADD:
#	Script for adding a new character and both saving it to file and loading 
#		it into the character object

extends Control

onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance
onready var pSingleton = get_node("/root/PlayerCharacter").pc

func _ready() -> void:
	theme=load(settings.themeFile)
	$Title/But_SaveChar.grab_focus()

func _on_But_SaveChar_pressed() -> void:
	$Title/FileDialog.popup()

#DKM TEMP: this code was inherited and it needs pretty substantial
#	overhaul for use in the module, depending on toolset use. 
#	For now all the labels are individual lineEdits we need to grab.
func _on_FileDialog_file_selected(path: String) -> void:
	var pc = get_node("/root/PlayerCharacter")
	var newCharFile = File.new()
	newCharFile.open(path, 2)
	
	#DKM TEMP: getting something to work with as text	
	var newCharStr = $Title/VBoxContainer/LabelName/LE_Name.text
	newCharFile.store_string(newCharStr)
	pSingleton.pcText = "Name: " + newCharStr
	print("PC text: " + pSingleton.pcText )
