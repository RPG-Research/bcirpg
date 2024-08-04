#CHARACTER_ADD:
#	Script for adding a new character and both saving it to file and loading 
#		it into the character object


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

#FUNCTION populate preset character format
#Params: file we have opened and are reading
#Returns: Nothing; all work done in function
#Notes: This adjusts  output using what we know, that is: set character sheet format, and a csv that 
#	has all headers in the top line, and all values in the next line
#	NOTE: this assumes we have matching lines, and our csv matches
#TODO: Next step  here is run the GSP converted to also update the percentile/singleton
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

#FUNCTION save data to character singleton
#Params: None
#Returns: Nothing; all work done in function
#Notes: Reads the input fields, breaking headers out, then parsing lines to look 
#	for the relevant fields for the system. It saves to the singleton output fields. 
#TODO: This should poll the game system in use first, for validing what output fields
#	to save; it should also call the GSP conversion once done to update the percentile values, too.
func save_data_to_singleton() -> void:
	var char_labels = []
	var char_scores_A = []
	var char_A_label = "D"
	var is_char_B = true
	var char_B_label = "+"
	var char_scores_B = []
	
	var is_label = true
	for child_box in $Title/VBoxContainer.get_children():
		if is_label:
			#if child_box.text.strip_edges(true,true).to_upper() == "NAME":
				#TODO(7/28/24): Stopped here. We need to:
				#	Check between TextLines (labels) and TextBoxes values. Not sure how to
				#		verify this type, but it must be doable. In this case, get the next 
				#		TextBox after Name and store that value, ala
				#		pSingleton.name = child_box.text.strip_edges(true,true).to_upper()
			#else:
			char_labels.append(child_box.text.strip_edges(true,true).to_upper())
			is_label = false
		else:
			var input_value = child_box.text
			
			is_label = true
	pSingleton.output_labels = char_labels
				
#FUNCTION save character csv
#Params: none
#Returns: Nothing; all work done in function
#Notes: This saves the character output fields to a csv.
#	TO DO: this is not safe at all; we can't just take a player entered name
#		for a file name, we need to validate it. 
func save_data_to_csv() -> void:
	var file_path = ""
	if pSingleton.name != "":
		file_path = "user://" + pSingleton.name + "_data.csv"
	else: 
		 file_path = "user://character_data.csv"
	var file = File.new()
	if file.open(file_path, File.WRITE) == OK:
		var csv_labels = ""
		for name in pSingleton.output_labels:
			csv_labels = csv_labels + name + ","
		csv_labels = csv_labels + "\n"
		#TO DO:add the values, too.
		file.store_string(csv_labels)
		file.close()
		print("Data saved to ", file_path)
		print(OS.get_data_dir())
	else:
		print("Failed to open", file_path, "for writing.")


func _on_But_SaveChar_pressed(): 
	save_data_to_singleton()
	save_data_to_csv()

