#GRAB FOCUS: simple script for temp files to grab focus
#	Expanded for Import Character option

extends Control
var charFilePath
var a


func _ready() -> void:
	#DKM TEMP TODO: replace with settings Singleton theme value
	#theme=load("res://assets/ui_controlNode_dark_theme.tres")
	$But_ChangeScene.grab_focus()


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
	var b = a.split(";")
#	for i in b.size():
	var i = 0
	while i < b.size():	
		var c = b[i]
		var d = c.split(":")
		#make a new textbox for each piece of information
		var textLine = Label.new()
		$VBoxContainer2/VBoxContainer.add_child(textLine)
		var lineLabel = d[0]
		textLine.text = lineLabel
		var textBox = LineEdit.new()
		$VBoxContainer2/VBoxContainer.add_child(textBox)
		if(d.size() > 1):
			textBox.text = d[1]
		i += 1
	file.close()
