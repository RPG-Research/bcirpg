extends Control
#charFilePath will hold the file path for the character file, fileText will hold the text in the file
var charFilePath = ""
var fileText

func _ready() -> void:
	#grab focus will make it so tab can be used to move between options
	$VBoxContainer2/Title/But_ChangeScene.grab_focus()
	
	var save_game = File.new()
	if save_game.file_exists("user://savegame.save"):
		save_game.open("user://savegame.save", File.READ)
		var tempPath = save_game.get_as_text()
		displayInfo(tempPath)
	
	save_game.close()

func displayInfo(path):
	var file = File.new()
	#read the text in the file, save it in the variable fileText, display in textBox
	file.open(path, File.READ)
	
	fileText = file.get_as_text()
	
	$VBoxContainer2/VBoxContainer/VBoxContainer3/textBox.visible = true
	$VBoxContainer2/VBoxContainer/VBoxContainer3/textBox.text = fileText
#	
	
	#save the file path in the global var to use it in the other function
	charFilePath = path
	file.close()
	

func _on_Button_pressed():
	$VBoxContainer2/VBoxContainer/FileDialog.popup()

func _on_FileDialog_file_selected(path):
	displayInfo(path)
	
#when they've made the changes and pressed save:
func _on_Save_Button_pressed():
	#open the same file so that changes can be written to it
	var file = File.new()
	file.open(charFilePath, File.WRITE)
	
	#store the text from the textbox back into the file
	var content = ""
	var currentWord = $VBoxContainer2/VBoxContainer/VBoxContainer3/textBox.text
		
	content = currentWord
	file.store_string(content)
	file.close()


func _on_But_Remember_pressed():
	#save the path of the file so that it can be automatically opened next time
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_string(charFilePath)
	save_game.close()
