#CHARACTER_LOAD:
#	Script for loading a character file into the character object from file

extends Control

onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance
onready var pSingleton = get_node("/root/PlayerCharacter").pc

func _ready() -> void:
	theme=load(settings.themeFile)
	$Title/But_loadCharacter.grab_focus()


func _on_But_loadCharacter_pressed() -> void:
	$LoadCharacter_FileDialog.popup()


func _prep_PlayerCharacter_Template(loadedCSVData):

	print(loadedCSVData)

	pSingleton.name = loadedCSVData[0]
	pSingleton.profession = loadedCSVData[1]
	pSingleton.strength = loadedCSVData[2]
	pSingleton.intellect = loadedCSVData[3]
	pSingleton.willpower = loadedCSVData[4]
	pSingleton.charm = loadedCSVData[5]
	pSingleton.armor = loadedCSVData[6]
	pSingleton.quote = loadedCSVData[7]



func load_csv_data(path):
  var file = File.new()
  var error = file.open(path, File.READ)  # Open the file for reading

  if error != OK:
	  print("Error opening CSV file:", error)
	  return

  var data = []
  while !file.eof_reached():
	  var line = file.get_csv_line()
	  data.append(line)

  file.close()
  return data


#DKM TEMP: we need to load the character item, not display to field
func _on_LoadCharacter_FileDialog_file_selected(path: String) -> void:
	print(path)
	var charFile = File.new()
	charFile.open(path, 1)
	var pc = get_node("/root/PlayerCharacter")
	
	var csv_data = load_csv_data(path)
	print(csv_data)
	_prep_PlayerCharacter_Template(csv_data[1])

