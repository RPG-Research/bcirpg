#CHARACTER_LOAD:
#	Script for loading a character file into the character object from file

extends Control


func _ready() -> void:
	$Title/But_loadCharacter.grab_focus()


func _on_But_loadCharacter_pressed() -> void:
	$LoadCharacter_FileDialog.popup()


#DKM TEMP: we need to load the character item, not display to field
func _on_LoadCharacter_FileDialog_file_selected(path: String) -> void:
	print(path)
	var charFile = File.new()
	charFile.open(path, 1)
	$TextEdit.text = charFile.get_as_text()
