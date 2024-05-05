extends Control

onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance
onready var pSingleton = get_node("/root/PlayerCharacter").pc
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	theme=load(settings.themeFile)
	#$Title/But_ChangeScene.grab_focus()
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed():
	$FileDialog.popup()


#this is going to take information from the file the player chose and put the individual parts into textboxes so it can be edited and then saved
func _on_FileDialog_file_selected(path):
	var file = File.new()
	#read the text in the file, save it in the variable a
	file.open(path, File.READ)

	#split by the spaces so the individual pieces can be separated into textboxes
	while file.eof_reached() == false:
		var csvStrArray = file.get_csv_line()
		var i = 0
		var isLabel = true
		while i < csvStrArray.size():	
			var csvStr = csvStrArray[i]
			if(isLabel):
				#make a new textbox for each piece of information
				var textLine = Label.new()
				$ScrollContainer/VBoxContainer.add_child(textLine)
				textLine.text = csvStr.to_upper()
				isLabel = false
				#DKM TEMP: save this unformatted to the singleton text string
				pSingleton.pcText += csvStr.to_upper() + ": "
			else:
				isLabel = true
				var textBox = LineEdit.new()
				$ScrollContainer/VBoxContainer.add_child(textBox)
				textBox.text = csvStr
				#DKM TEMP: save this unformatted to the singleton text string
				pSingleton.pcText += csvStr + "\n"
			i += 1
	file.close()


