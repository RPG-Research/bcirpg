#GRAB FOCUS: simple script for temp files to grab focus
#	Expanded for Import Character option

#DKM TEMP: TO DO: As with the character add, we need this to read what's 
#	handed to it and generate the output from that, rather than have this be hard-coded. 

extends Control

onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance
onready var pSingleton = get_node("/root/PlayerCharacter").pc

var charFilePath
var a


func _ready() -> void:
	theme=load(settings.themeFile)

func _on_Button_pressed():
	$FileDialog.popup()

#FUNCTION populate preset character format
#Params: file we have opened and are reading
#Returns: Nothing; all work done in function
#Notes: This adjusts  output using what we know, that is: set character sheet format, and a csv that 
#	has all headers in the top line, and all values in the next line
#	NOTE: this assumes we have matching lines, and our csv matches
#TODO: Next step  here is run the GSP converted to also update the percentile/singleton
func _populate_preset_character_format(file:File):
	while file.eof_reached() == false:
		var csvStrHeaderArray = file.get_csv_line()
		var csvStrContentsArray = file.get_csv_line()
		for i in csvStrHeaderArray.size():
			#make a new textbox for each header piece
			var textLine = Label.new()
			$ScrollContainer/VBoxContainer.add_child(textLine)
			textLine.text = csvStrHeaderArray[i].to_upper()
			
			#match to content, assuming it exists and aligns
			if(csvStrContentsArray.size()>= i):
				var textBox = LineEdit.new()
				$ScrollContainer/VBoxContainer.add_child(textBox)
				textBox.text = csvStrContentsArray[i]
				


#this is going to take information from the file the player chose and put the individul parts into textboxes so it can be edited and then saved
func _on_FileDialog_file_selected(path):
	var file = File.new()
	#read the text in the file, save it in the variable a
	file.open(path, File.READ)
	_populate_preset_character_format(file)
	
	file.close()
