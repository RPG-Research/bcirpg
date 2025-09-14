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
#Notes: This adjusts both output and singleton using what 
#	we know, that is: set character sheet format, and a csv that 
#	has all headers in the top line, and all values in the next line
#	NOTE: this assumes we have matching lines, and our csv matches

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
				match csvStrHeaderArray[i].strip_edges(true,true).to_upper():
					"NAME":
						pSingleton.name = str(csvStrContentsArray[i])
					"PROFESSION":
						pSingleton.profession = str(csvStrContentsArray[i])
					"AGILITY":
						pSingleton.AG = int(csvStrContentsArray[i])
					"APPEARANCE":
						pSingleton.APP = int(csvStrContentsArray[i])
					"CONSTITUTION":
						pSingleton.CO = int(csvStrContentsArray[i])
					"QUICKNESS":
						pSingleton.QU = int(csvStrContentsArray[i])
					"STRENGTH":
						pSingleton.ST = int(csvStrContentsArray[i])
					"CHUTZPAH":
						pSingleton.CH = int(csvStrContentsArray[i])
					"EMPATHY":
						pSingleton.EM = int(csvStrContentsArray[i])
					"INTUITION":
						pSingleton.IN = int(csvStrContentsArray[i])
					"WEAPON":
						pSingleton.weapon = str(csvStrContentsArray[i])
					"ARMOR":
						pSingleton.armor = str(csvStrContentsArray[i])
					"QUOTE":
						pSingleton.quote = str(csvStrContentsArray[i])
		


#this is going to take information from the file the player chose and put the individul parts into textboxes so it can be edited and then saved
func _on_FileDialog_file_selected(path):
	var file = File.new()
	#read the text in the file, save it in the variable a
	file.open(path, File.READ)
	_populate_preset_character_format(file)
	#DKM TEMP: replacing this with our set character creation from 
	#	Luke's player csv code
	#split by the spaces so the individual pieces can be separated into textboxes
#	while file.eof_reached() == false:
#		var csvStrArray = file.get_csv_line()
#		var i = 0

#		var isLabel = true
#		while i < csvStrArray.size():	
#			var csvStr = csvStrArray[i]
#			if(isLabel):
#				#make a new textbox for each piece of information
#				var textLine = Label.new()
#				$ScrollContainer/VBoxContainer.add_child(textLine)
#				textLine.text = csvStr.to_upper()
#				isLabel = false
#				#DKM TEMP: save this unformatted to the singleton text string
#				pSingleton.pcText += csvStr.to_upper() + ": "
#			else:
#				isLabel = true
#				var textBox = LineEdit.new()
#				$ScrollContainer/VBoxContainer.add_child(textBox)
#				textBox.text = csvStr
#				#DKM TEMP: save this unformatted to the singleton text string
#				pSingleton.pcText += csvStr + "\n"
#			i += 1
	file.close()
