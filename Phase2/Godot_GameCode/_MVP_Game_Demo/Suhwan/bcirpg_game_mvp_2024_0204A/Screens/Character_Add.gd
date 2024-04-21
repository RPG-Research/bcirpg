#CHARACTER_ADD:
#	Script for adding a new character and both saving it to file and loading 
#		it into the character object

extends Control

onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance
onready var pSingleton = get_node("/root/PlayerCharacter").pc

onready var Name = get_node("Title/VBoxContainer/LabelName/LE_Name")

onready var Profession = get_node("Title/VBoxContainer/LabelProfession/LE_Pro")

onready var Strength = get_node("Title/VBoxContainer/LabelStrength/LE_Str")

onready var Intellect = get_node("Title/VBoxContainer/LabelIntellect/LE_Intl")

onready var Willpower = get_node("Title/VBoxContainer/LabelWillpower/LE_Will")

onready var Charm = get_node("Title/VBoxContainer/LabelCharm/LE_Charm")

onready var Weapon = get_node("Title/VBoxContainer/LabelWeapon/LE_Weapon")

onready var Armor = get_node("Title/VBoxContainer/LabelArmor/LE_Armor")

onready var Quote = get_node("Title/VBoxContainer/LabelQuote/LE_Quote")

func _ready() -> void:
	theme=load(settings.themeFile)
	$Title/But_SaveChar.grab_focus()


func save_data_to_csv(data: Array, file_path : String) ->void:
	var file = File.new()
	
	if file.open(file_path, File.WRITE) == OK:
		for row in data:
			file.store_string(format_row(row))
		file.close()
		print("Data saved to ", file_path)
	else:
		print("Failed to open ", file_path, " for writing.")


func format_row(row_data: Array) -> String:
	# Convert the array of data to a comma-separated string
	var formatted_row = ""
	for i in range(row_data.size()):
		formatted_row += str(row_data[i])
		if i < row_data.size() - 1:
			formatted_row += ","
			
	formatted_row += "\n"
		
	return formatted_row
	


func _prep_PlayerCharacter_Template():
#	This function prepares the data for the player character in two ways.
#	Way 1: By loading all of this data into the singleton for easy reads during gameplay
#	Way 2: To prepare the data to be pulled from the singleton, when writing a file.
	pSingleton.name = Name.text
	pSingleton.profession = Profession.text
	pSingleton.strength = Strength.text
	pSingleton.intellect = Intellect.text
	pSingleton.willpower = Willpower.text
	pSingleton.charm = Charm.text
	pSingleton.armor = Armor.text
	pSingleton.quote = Quote.text

func _on_But_SaveChar_pressed() -> void:
	_prep_PlayerCharacter_Template()
	var file_path = ""
	
	if pSingleton.name != "":
		file_path = "user://" + pSingleton.name + "_data.csv"
	else:
		file_path = "user//character_data.csv"
		
	var input_data = [
	["Name", "Profession", "Strength", "Intellect", "Willpower", "Charm",  "Weapon", "Armor", "Quote"],
	[pSingleton.name, pSingleton.profession, pSingleton.strength, pSingleton.intellect, pSingleton.willpower, pSingleton.charm, pSingleton.weapon, pSingleton.armor, pSingleton.quote],
	]

	save_data_to_csv(input_data, file_path)


