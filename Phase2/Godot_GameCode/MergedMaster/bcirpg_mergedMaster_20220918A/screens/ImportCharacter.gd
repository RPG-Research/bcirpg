#GRAB FOCUS: simple script for temp files to grab focus
#	Expanded for Import Character option

extends Control

onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance
onready var pSingleton = get_node("/root/PlayerCharacter").pc

var charFilePath
var a


func _ready() -> void:
	theme=load(settings.themeFile)

func _on_Button_pressed():
	$FileDialog.popup()
	
#Import character file 
func _charSetStat(statname: String, statvalue: int) -> void:
	if statname in pSingleton.viableCharStats:
		match statname:
			"AG":
				pSingleton.agility = statvalue
			"APP":
				pSingleton.appearance = statvalue
			"CO":
				pSingleton.constitution = statvalue
			"QU":
				pSingleton.quickness = statvalue
			"MD":
				pSingleton.manual_dexterity = statvalue
			"ST":
				pSingleton.strength = statvalue
			"CH":
				pSingleton.chutzpah = statvalue
			"EM":
				pSingleton.empathy = statvalue
			"IN":
				pSingleton.intuition = statvalue
			"ME":
				pSingleton.memory = statvalue
			"MX":
				pSingleton.moxie = statvalue
			"PR":
				pSingleton.presence = statvalue
			"RE":
				pSingleton.reasoning = statvalue
			"SD":
				pSingleton.self_discipline = statvalue
	else:
		return	

#this is going to take information from the file the player chose and put the individul parts into textboxes so it can be edited and then saved
func _on_FileDialog_file_selected(path):
	var file = File.new()
	#read the text in the file, save it in the variable a
	file.open(path, File.READ)

	#split by the spaces so the individual pieces can be separated into textboxes
	while file.eof_reached() == false:
		var csvStrArray = file.get_csv_line()
		var i = 0
		var isLabel = true
		var row_label = ""
		var row_value = ""
		while i < csvStrArray.size():	
			var csvStr = csvStrArray[i]
			if(isLabel):
				#make a new textbox for each piece of information
				var textLine = Label.new()
				$ScrollContainer/VBoxContainer.add_child(textLine)
				textLine.text = csvStr.to_upper()
				row_label = csvStr.to_upper()
				isLabel = false
				#DKM TEMP: save this unformatted to the singleton text string
				pSingleton.pcText += csvStr.to_upper() + ": "
			else:
				row_value = csvStr
				if(typeof(int(row_value)) == TYPE_INT):
					_charSetStat(row_label, int(row_value))
				isLabel = true
				var textBox = LineEdit.new()
				$ScrollContainer/VBoxContainer.add_child(textBox)
				textBox.text = csvStr
				#DKM TEMP: save this unformatted to the singleton text string
				pSingleton.pcText += csvStr + "\n"
			i += 1
	file.close()
	#DKM TEMP:
	print("PRINTING set char tostring: ")
	print(pSingleton.toString())