extends Control
var charFilePath
var a
#GRAB FOCUS: simple script for temp files to grab focus


func _ready() -> void:
	$VBoxContainer2/Title/But_ChangeScene.grab_focus()


func _on_Button_pressed():
	$VBoxContainer2/VBoxContainer/FileDialog.popup()

#this is going to take information from the file the player chose and put the individul parts into textboxes so it can be edited and then saved
func _on_FileDialog_file_selected(path):
	var file = File.new()
	#read the text in the file, save it in the variable a
	file.open(path, File.READ)
#	a = int(file.get_line())
	a = file.get_as_text()
	#split by the spaces so the individual pieces can be separated into textboxes
	var b = a.split(" ")
#	for i in b.size():
	var i = 0
	while i < b.size():	
		#make a new textbox for each piece of information
		var textLine = Label.new()
		$VBoxContainer2/VBoxContainer.add_child(textLine)
		textLine.text = b[i]
		i += 1
		var textBox = LineEdit.new()
		$VBoxContainer2/VBoxContainer.add_child(textBox)
		textBox.text = b[i]
		i += 1
	file.close()
