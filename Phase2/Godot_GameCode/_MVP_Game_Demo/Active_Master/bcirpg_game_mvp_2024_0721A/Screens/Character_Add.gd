#CHARACTER_ADD:
#	Script for adding a new character and both saving it to file and loading 
#		it into the character object

#DKM TEMP: TODO: we shouldn't be writing all this stuff manually. 
#	That way we can send this whatever we have and have it write the boxes. 
#	This one requires a conversion, which is trickier. 

extends Control

onready var settings = get_node("/root/GlobalSaveInstance").settingsInstance
onready var pSingleton = get_node("/root/PlayerCharacter").pc

#GSP is to hold instantiated GSP_Layer; needed for calling necessary conversion functionality
const Game_Layer := preload("res://globalScripts/GSP_Lookups.gd")
onready var GSP = Game_Layer.new()


func _ready() -> void:
	theme=load(settings.themeFile)
	$Title/But_SaveChar.grab_focus()
	_populate_output_character_format()
	
func _populate_output_character_format():
	var i = 0
	#make a new textbox for each header piece
	for label in pSingleton.output_labels:
		var textLine = Label.new()
		$Title/VBoxContainer.add_child(textLine)
		textLine.text = label.to_upper()
		i = i+1
		#match to content, assuming it exists and aligns
		if(pSingleton.output_scores_A.size()>= i):
			var textBox = LineEdit.new()
			$Title/VBoxContainer.add_child(textBox)
			var ability_text = str(pSingleton.output_scores_A[i-1])
			if(pSingleton.output_A_label.length() > 0):
				ability_text = ability_text + pSingleton.output_A_label
				if(pSingleton.is_output_B && pSingleton.output_scores_B.size()>= i):
					if(pSingleton.output_B_label.length() > 0):
						ability_text = ability_text + pSingleton.output_B_label
					ability_text = ability_text + str(pSingleton.output_scores_B[i-1])
			textBox.text = ability_text
				
				
func save_data_to_csv(data: Array, file_path: String):
	var file = File.new()
	
	if file.open(file_path, File.WRITE) == OK:
		for row in data:
			file.store_string(format_row(row))
		file.close()
		print("Data saved to ", file_path)
		print(OS.get_data_dir())
	else:
		print("Failed to open", file_path, "for writing.")

func format_row(row_data: Array) -> String:
	# Convert the array of data to a comma-separated string
	var formatted_row = ""
	for i in range(row_data.size()):
		formatted_row += str(row_data[i])
		if i < row_data.size() - 1:
			formatted_row += ","
	formatted_row += "\n"
	return formatted_row


func _on_But_SaveChar_pressed(): 
	
	var file_path = ""
	
	if pSingleton.name != "":
		file_path = "user://" + pSingleton.name + "_data.csv"
	
	else: 
		 file_path = "user://character_data.csv"

#	To Do. Format data into the correct table.
	
	var input_data = [
	["Name", "Profession", "Strength", "Intellect", "Willpower", "Charm",  "Weapon", "Armor", "Quote"],
	[pSingleton.name, pSingleton.profession, pSingleton.strength, pSingleton.intellect, pSingleton.willpower, pSingleton.charm, pSingleton.weapon, pSingleton.armor, pSingleton.quote],
]

	save_data_to_csv(input_data, file_path)
